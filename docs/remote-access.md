# Remote Access

This machine runs OpenSSH and Tailscale.

## SSH server

The SSH server allows public-key authentication and disables password login and
root login.

From another device in the same Tailnet:

```bash
ssh qrbao@100.80.42.117
ssh qrbao@nixos.tail028e21.ts.net
ssh qrbao@nixos
```

The short hostname works when MagicDNS is enabled on the client device.
Otherwise use the full MagicDNS name or the Tailscale IPv4 address shown by:

```bash
tailscale ip -4
```

The firewall trusts `tailscale0`, so SSH is reachable from the Tailnet. Port 22
is not opened on ordinary LAN or public interfaces.

## Authorize a MacBook

On the MacBook, generate a key if needed:

```bash
ssh-keygen -t ed25519 -C "macbook"
```

Copy the MacBook public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Add that public key to this machine:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
printf '%s\n' '<macbook-public-key>' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

Then connect from the MacBook:

```bash
ssh qrbao@100.80.42.117
ssh qrbao@nixos.tail028e21.ts.net
```

## Tailscale login

If this machine is not yet in the Tailnet:

```bash
sudo tailscale up --ssh=false
```

Follow the login URL, then check:

```bash
tailscale status
tailscale ip -4
```

This setup uses normal OpenSSH over the Tailscale network. Tailscale SSH is not
required.

## Mac mini

The Mac mini is visible in the Tailnet as:

```text
mac-mini.tail028e21.ts.net
100.66.1.87
```

Network reachability and TCP port 22 have been verified from this machine.
