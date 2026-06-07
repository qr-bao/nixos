#!/usr/bin/env node
import { spawn } from "node:child_process";
import { mkdir, writeFile } from "node:fs/promises";
import { dirname } from "node:path";

const port = Number(process.env.CODEX_BROWSER_CDP_PORT || "9223");
const profileDir =
  process.env.CODEX_BROWSER_CDP_PROFILE_DIR ||
  `${process.env.HOME}/.local/share/codex-browser/cdp-profile`;
const logDir =
  process.env.CODEX_BROWSER_LOG_DIR ||
  `${process.env.HOME}/.local/share/codex-browser`;
const endpoint = `http://127.0.0.1:${port}`;

const usage = `Usage:
  browser-cdp.mjs status
  browser-cdp.mjs list
  browser-cdp.mjs open <url>
  browser-cdp.mjs title [url]
  browser-cdp.mjs text [url]
  browser-cdp.mjs screenshot <output.png> [url]
`;

async function sleep(ms) {
  await new Promise((resolve) => setTimeout(resolve, ms));
}

async function fetchJson(url, options = {}) {
  const response = await fetch(url, options);
  if (!response.ok) {
    throw new Error(`${options.method || "GET"} ${url} failed: ${response.status}`);
  }
  return response.json();
}

async function isRunning() {
  try {
    await fetchJson(`${endpoint}/json/version`);
    return true;
  } catch {
    return false;
  }
}

async function ensureChrome() {
  if (await isRunning()) return;

  await mkdir(profileDir, { recursive: true });
  await mkdir(logDir, { recursive: true });

  const chrome = spawn(
    "google-chrome",
    [
      `--user-data-dir=${profileDir}`,
      "--remote-debugging-address=127.0.0.1",
      `--remote-debugging-port=${port}`,
      "--no-first-run",
      "--no-default-browser-check",
      "--new-window",
      "about:blank",
    ],
    {
      detached: true,
      stdio: ["ignore", "ignore", "ignore"],
    },
  );
  chrome.unref();

  for (let i = 0; i < 30; i += 1) {
    if (await isRunning()) return;
    await sleep(500);
  }

  throw new Error(`Chrome DevTools did not answer on ${endpoint}`);
}

async function newPage(url = "about:blank") {
  await ensureChrome();
  const encoded = encodeURIComponent(url);
  try {
    return await fetchJson(`${endpoint}/json/new?${encoded}`, { method: "PUT" });
  } catch {
    return await fetchJson(`${endpoint}/json/new?${encoded}`);
  }
}

async function pages() {
  await ensureChrome();
  return (await fetchJson(`${endpoint}/json/list`)).filter(
    (page) => page.type === "page",
  );
}

async function firstPage() {
  const allPages = await pages();
  if (allPages.length === 0) return newPage("about:blank");
  return allPages[0];
}

async function targetFor(url) {
  if (url) return openUrl(url);
  return firstPage();
}

function connect(page) {
  if (!page.webSocketDebuggerUrl) {
    throw new Error("Target does not expose a WebSocket debugger URL");
  }

  const ws = new WebSocket(page.webSocketDebuggerUrl);
  let nextId = 1;
  const pending = new Map();

  ws.addEventListener("message", (event) => {
    const message = JSON.parse(event.data);
    if (!message.id || !pending.has(message.id)) return;
    const { resolve, reject } = pending.get(message.id);
    pending.delete(message.id);
    if (message.error) reject(new Error(message.error.message));
    else resolve(message.result);
  });

  const ready = new Promise((resolve, reject) => {
    ws.addEventListener("open", resolve, { once: true });
    ws.addEventListener("error", reject, { once: true });
  });

  async function send(method, params = {}) {
    await ready;
    const id = nextId;
    nextId += 1;
    ws.send(JSON.stringify({ id, method, params }));
    return new Promise((resolve, reject) => {
      pending.set(id, { resolve, reject });
    });
  }

  return {
    send,
    close() {
      ws.close();
    },
  };
}

async function waitForReady(cdp) {
  for (let i = 0; i < 40; i += 1) {
    const result = await cdp.send("Runtime.evaluate", {
      expression: "document.readyState",
      returnByValue: true,
    });
    if (result.result?.value === "complete") return;
    await sleep(250);
  }
}

async function openUrl(url) {
  const page = await newPage("about:blank");
  const cdp = connect(page);
  try {
    await cdp.send("Page.enable");
    await cdp.send("Runtime.enable");
    await cdp.send("Page.bringToFront");
    await cdp.send("Page.navigate", { url });
    await waitForReady(cdp);
    return page;
  } finally {
    cdp.close();
  }
}

async function evaluate(page, expression) {
  const cdp = connect(page);
  try {
    await cdp.send("Page.enable");
    await cdp.send("Runtime.enable");
    await cdp.send("Page.bringToFront");
    await waitForReady(cdp);
    const result = await cdp.send("Runtime.evaluate", {
      expression,
      returnByValue: true,
    });
    return result.result?.value ?? "";
  } finally {
    cdp.close();
  }
}

async function capture(page, outputPath) {
  const cdp = connect(page);
  try {
    await cdp.send("Page.enable");
    await cdp.send("Emulation.setDeviceMetricsOverride", {
      width: 1365,
      height: 900,
      deviceScaleFactor: 1,
      mobile: false,
    });
    await cdp.send("Page.bringToFront");
    await waitForReady(cdp);
    const result = await cdp.send("Page.captureScreenshot", {
      format: "png",
      captureBeyondViewport: true,
    });
    await mkdir(dirname(outputPath), { recursive: true });
    await writeFile(outputPath, Buffer.from(result.data, "base64"));
  } finally {
    cdp.close();
  }
}

function requireUrl(raw) {
  if (!raw) throw new Error("Missing URL");
  return new URL(raw).toString();
}

async function main() {
  const [command, ...args] = process.argv.slice(2);

  if (!command || command === "help" || command === "--help") {
    process.stdout.write(usage);
    return;
  }

  if (command === "status") {
    await ensureChrome();
    const version = await fetchJson(`${endpoint}/json/version`);
    console.log(`${version.Browser} ${version.webSocketDebuggerUrl}`);
    return;
  }

  if (command === "list") {
    const allPages = await pages();
    for (const page of allPages) {
      console.log(`${page.id}\t${page.title}\t${page.url}`);
    }
    return;
  }

  if (command === "open") {
    const page = await openUrl(requireUrl(args[0]));
    console.log(`${await evaluate(page, "document.title")}\t${args[0]}`);
    return;
  }

  if (command === "title") {
    const page = await targetFor(args[0] ? requireUrl(args[0]) : undefined);
    console.log(await evaluate(page, "document.title"));
    return;
  }

  if (command === "text") {
    const page = await targetFor(args[0] ? requireUrl(args[0]) : undefined);
    console.log(
      await evaluate(
        page,
        "document.body ? document.body.innerText.slice(0, 12000) : ''",
      ),
    );
    return;
  }

  if (command === "screenshot") {
    const [outputPath, url] = args;
    if (!outputPath) throw new Error("Missing screenshot output path");
    const page = await targetFor(url ? requireUrl(url) : undefined);
    await capture(page, outputPath);
    console.log(outputPath);
    return;
  }

  throw new Error(`Unknown command: ${command}\n${usage}`);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
