{ config, lib, pkgs, ... }:

{
  home.username = "qrbao";
  home.homeDirectory = "/home/qrbao";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  dconf.enable = true;

  home.packages = with pkgs; [
    copyq
  ];

  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Control><Shift>t" ];
      toggle-message-tray = [ "<Super>m" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Clipboard History";
      command = "/run/current-system/sw/bin/copyq show";
      binding = "<Super>V";
    };
  };

  home.activation.installMutableDesktopConfig =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      install -Dm0644 ${./files/fcitx5/profile} "$HOME/.config/fcitx5/profile"
      install -Dm0644 ${./files/fcitx5/conf/chttrans.conf} "$HOME/.config/fcitx5/conf/chttrans.conf"
      install -Dm0644 ${./files/fcitx5/conf/notifications.conf} "$HOME/.config/fcitx5/conf/notifications.conf"
      install -Dm0644 ${./files/fcitx5/conf/pinyin.conf} "$HOME/.config/fcitx5/conf/pinyin.conf"
      install -Dm0644 ${./files/fcitx5/conf/punctuation.conf} "$HOME/.config/fcitx5/conf/punctuation.conf"

      install -Dm0644 ${./files/autostart/copyq.desktop} "$HOME/.config/autostart/copyq.desktop"
      install -Dm0644 ${./files/copyq/copyq.conf} "$HOME/.config/copyq/copyq.conf"
      install -Dm0644 ${./files/copyq/copyq-commands.ini} "$HOME/.config/copyq/copyq-commands.ini"
      install -Dm0644 ${./files/copyq/copyq-filter.ini} "$HOME/.config/copyq/copyq-filter.ini"
      install -Dm0644 ${./files/copyq/copyq-monitor.ini} "$HOME/.config/copyq/copyq-monitor.ini"
      install -Dm0644 ${./files/copyq/copyq_tabs.ini} "$HOME/.config/copyq/copyq_tabs.ini"

      install -Dm0644 ${./files/codex/skills/browser-control/SKILL.md} "$HOME/.codex/skills/browser-control/SKILL.md"

      mkdir -p "$HOME/.codex"
      touch "$HOME/.codex/config.toml"
      tmp_config="$(mktemp)"
      ${pkgs.gawk}/bin/awk '
        /^\[mcp_servers\.chrome_devtools\]$/ { skip = 1; next }
        /^\[/ && skip { skip = 0 }
        !skip { print }
      ' "$HOME/.codex/config.toml" > "$tmp_config"
      mv "$tmp_config" "$HOME/.codex/config.toml"

      cat >> "$HOME/.codex/config.toml" <<'EOF'

[mcp_servers.chrome_devtools]
command = "npx"
args = [
  "-y",
  "chrome-devtools-mcp@latest",
  "--channel=stable",
  "--userDataDir=/home/qrbao/.local/share/codex-browser/mcp-profile",
  "--headless=false",
  "--redactNetworkHeaders=true",
  "--no-usage-statistics",
  "--no-performance-crux",
]
startup_timeout_sec = 20
tool_timeout_sec = 60
enabled = true
required = false
default_tools_approval_mode = "prompt"
EOF
    '';
}
