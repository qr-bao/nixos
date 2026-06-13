{
  config,
  lib,
  pkgs,
  userName,
  homeDirectory,
  ...
}:

let
  wwwBrowser = pkgs.writeShellScriptBin "www-browser" ''
    exec ${pkgs.chawan}/bin/cha "$@"
  '';

  pcha = pkgs.writeShellScriptBin "pcha" ''
    exec ${pkgs.chawan}/bin/cha -T text/x-ansi "$@"
  '';

  codex = pkgs.writeShellScriptBin "codex" ''
    exec ${homeDirectory}/.codex/packages/standalone/current/bin/codex "$@"
  '';

  codex1 = pkgs.writeShellScriptBin "codex1" ''
    exec ${homeDirectory}/.local/bin/codex1 "$@"
  '';

  codex2 = pkgs.writeShellScriptBin "codex2" ''
    exec ${homeDirectory}/.local/bin/codex2 "$@"
  '';

  term = pkgs.writeShellScriptBin "term" ''
    exec ${pkgs.wezterm}/bin/wezterm start --cwd="''${PWD:-$HOME}" -- ${pkgs.bashInteractive}/bin/bash -l
  '';

  nvimTerm = pkgs.writeShellScriptBin "nvim-term" ''
    exec ${pkgs.wezterm}/bin/wezterm start --cwd="''${PWD:-$HOME}" -- ${pkgs.neovim}/bin/nvim "$@"
  '';
in
{
  home.username = userName;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  dconf.enable = true;

  home.packages = with pkgs; [
    copyq
    chawan
    ddgr
    black
    bash-language-server
    clang-tools
    fd
    fzf
    feishu
    gnome-terminal
    gopls
    bat
    btop
    delta
    dust
    eza
    lazygit
    isort
    lua-language-server
    marksman
    nixd
    nixfmt
    prettier
    pyright
    ripgrep
    rust-analyzer
    rdrview
    shellcheck
    sqlfluff
    shfmt
    stylua
    taplo
    tree-sitter
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
    wl-clipboard
    xclip
    xsel
    starship
    ffmpegthumbnailer
    imagemagick
    jq
    poppler-utils
    unar
    wezterm
    yazi
    zellij
    zoxide
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    codex
    codex1
    codex2
    wwwBrowser
    nvimTerm
    pcha
    term
  ];

  home.sessionVariables = {
    BROWSER = "www-browser";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "term";
    MANPAGER = "mancha";
    PAGER = "pcha";
    COLORTERM = "truecolor";
  };

  home.sessionPath = [
    "$HOME/.local/state/nix/profiles/home-manager/home-path/bin"
    "$HOME/.local/bin"
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      c = "clear";
      g = "git";
      cat = "bat -p";
      dust = "dust -r";
      lg = "lazygit";
      ll = "eza -lah --git --icons=auto";
      ls = "eza --icons=auto";
      t = "zellij attach main -c";
      top = "btop";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      y = "yazi";
      zj = "zellij";
      zz = "zellij attach main -c";
    };

    initExtra = ''
      export PATH="$HOME/.local/state/nix/profiles/home-manager/home-path/bin:$HOME/.local/bin:$PATH"
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  home.file.".wezterm.lua".text = ''
    local wezterm = require("wezterm")
    local config = wezterm.config_builder()

    config.default_prog = { "${pkgs.bashInteractive}/bin/bash", "-l" }
    config.font = wezterm.font_with_fallback({
      "JetBrainsMono Nerd Font",
      "Symbols Nerd Font Mono",
      "monospace",
    })
    config.font_size = 12.5
    config.color_scheme = "Catppuccin Mocha"
    config.enable_wayland = true
    config.window_decorations = "RESIZE"
    config.window_background_opacity = 0.96
    config.hide_tab_bar_if_only_one_tab = true
    config.use_fancy_tab_bar = false
    config.scrollback_lines = 100000
    config.adjust_window_size_when_changing_font_size = false
    config.audible_bell = "Disabled"
    config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

    config.keys = {
      { key = "u", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
      { key = "n", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
      { key = "\\", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
      { key = "-", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
      { key = "x", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
      { key = "w", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
      { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
      { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
      { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
      { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
      { key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
      { key = "DownArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
      { key = "UpArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
      { key = "RightArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
      { key = "Tab", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Next") },
      { key = "t", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
      { key = "1", mods = "ALT", action = wezterm.action.ActivateTab(0) },
      { key = "2", mods = "ALT", action = wezterm.action.ActivateTab(1) },
      { key = "3", mods = "ALT", action = wezterm.action.ActivateTab(2) },
      { key = "4", mods = "ALT", action = wezterm.action.ActivateTab(3) },
      { key = "5", mods = "ALT", action = wezterm.action.ActivateTab(4) },
      { key = "Enter", mods = "ALT", action = wezterm.action.ToggleFullScreen },
      { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
      { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
    }

    return config
  '';

  home.file.".local/bin/term" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      exec ${pkgs.wezterm}/bin/wezterm start --cwd="''${PWD:-$HOME}" -- ${pkgs.bashInteractive}/bin/bash -l
    '';
  };

  home.file.".local/bin/nvim-term" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      exec ${pkgs.wezterm}/bin/wezterm start --cwd="''${PWD:-$HOME}" -- ${pkgs.neovim}/bin/nvim "$@"
    '';
  };

  home.file.".config/yazi/yazi.toml".text = ''
    [mgr]
    ratio = [1, 3, 4]
    sort_by = "natural"
    sort_sensitive = false
    sort_dir_first = true
    show_hidden = true
    show_symlink = true

    [preview]
    tab_size = 2
    max_width = 1600
    max_height = 1600
    image_filter = "triangle"
    image_quality = 75
  '';

  home.file.".config/zellij/config.kdl" = {
    force = true;
    text = ''
      default_mode "normal"
      default_layout "compact"
      pane_frames true
      mouse_mode true
      scroll_buffer_size 50000
      copy_command "wl-copy"
      copy_clipboard "system"
      copy_on_select true
      scrollback_editor "nvim"
      show_release_notes false
      simplified_ui true
      theme "catppuccin-mocha"

      themes {
          catppuccin-mocha {
              fg 205 214 244
              bg 30 30 46
              black 69 71 90
              red 243 139 168
              green 166 227 161
              yellow 249 226 175
              blue 137 180 250
              magenta 203 166 247
              cyan 137 220 235
              white 205 214 244
              orange 250 179 135
          }
      }

      keybinds {
          normal {
              bind "Alt h" { MoveFocus "Left"; }
              bind "Alt j" { MoveFocus "Down"; }
              bind "Alt k" { MoveFocus "Up"; }
              bind "Alt l" { MoveFocus "Right"; }
              bind "Alt \\" { NewPane "Right"; }
              bind "Alt -" { NewPane "Down"; }
              bind "Alt u" { NewPane "Right"; }
              bind "Alt n" { NewPane "Down"; }
              bind "Alt Tab" { SwitchFocus; }
              bind "Alt x" { CloseFocus; }
              bind "Alt w" { CloseFocus; }
              bind "Alt f" { ToggleFocusFullscreen; }
              bind "Alt y" { ToggleActiveSyncTab; }
              bind "Alt t" { NewTab; }
              bind "Alt 1" { GoToTab 1; }
              bind "Alt 2" { GoToTab 2; }
              bind "Alt 3" { GoToTab 3; }
              bind "Alt 4" { GoToTab 4; }
              bind "Alt 5" { GoToTab 5; }
              bind "Alt s" {
                  LaunchOrFocusPlugin "session-manager" {
                      floating true
                      move_to_focused_tab true
                  };
              }
          }
      }
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-web-devicons
      mini-icons
      plenary-nvim
      which-key-nvim
      lualine-nvim
      bufferline-nvim
      gitsigns-nvim
      oil-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip
      friendly-snippets
      nvim-lspconfig
      conform-nvim
      nvim-autopairs
      comment-nvim
      nvim-surround
      indent-blankline-nvim
      trouble-nvim
      todo-comments-nvim
      dressing-nvim
      nvim-ts-autotag
      (nvim-treesitter.withAllGrammars)
    ];

    initLua = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.g.loaded_node_provider = 0
      vim.g.loaded_python3_provider = 0

      local opt = vim.opt
      -- Use the system clipboard for unnamed yanks and pastes.
      opt.clipboard = "unnamedplus"
      opt.completeopt = { "menu", "menuone", "noselect" }
      opt.confirm = true
      opt.cursorline = true
      opt.fillchars = { eob = " " }
      opt.expandtab = true
      opt.ignorecase = true
      opt.inccommand = "split"
      opt.laststatus = 3
      opt.mouse = "a"
      opt.number = true
      opt.relativenumber = true
      opt.scrolloff = 8
      opt.sidescrolloff = 8
      opt.shiftwidth = 2
      opt.signcolumn = "yes"
      opt.smartcase = true
      opt.smartindent = true
      opt.splitbelow = true
      opt.splitright = true
      opt.tabstop = 2
      opt.termguicolors = true
      opt.timeoutlen = 400
      opt.undofile = true
      opt.updatetime = 200
      opt.virtualedit = "block"
      opt.wrap = false

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end

      map("n", "<leader>w", "<cmd>write<cr>", "Save file")
      map("n", "<leader>q", "<cmd>quit<cr>", "Quit window")
      map("n", "<leader>Q", "<cmd>qall!<cr>", "Quit all")
      map("n", "<leader>h", "<cmd>nohlsearch<cr>", "Clear search highlight")
      map("n", "<leader>bd", "<cmd>bdelete<cr>", "Close buffer")
      map("n", "<S-h>", "<cmd>bprevious<cr>", "Previous buffer")
      map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
      map("n", "<C-h>", "<C-w>h", "Window left")
      map("n", "<C-j>", "<C-w>j", "Window down")
      map("n", "<C-k>", "<C-w>k", "Window up")
      map("n", "<C-l>", "<C-w>l", "Window right")
      map("n", "<leader>sv", "<cmd>vsplit<cr>", "Vertical split")
      map("n", "<leader>sh", "<cmd>split<cr>", "Horizontal split")
      map("n", "<leader>se", "<C-w>=", "Equalize windows")
      map("n", "<leader>sx", "<cmd>close<cr>", "Close window")
      map("n", "<leader>e", vim.diagnostic.open_float, "Line diagnostics")
      map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
      map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
      map("n", "[q", "<cmd>cprevious<cr>", "Previous quickfix")
      map("n", "]q", "<cmd>cnext<cr>", "Next quickfix")
      map("n", "<leader>tt", "<cmd>split | terminal<cr>", "Terminal split")
      map("n", "<leader>tv", "<cmd>vsplit | terminal<cr>", "Terminal vertical split")
      map("n", "<leader>tb", function()
        vim.ui.input({ prompt = "Browse URL: ", default = "https://" }, function(input)
          if input and input ~= "" then
            vim.cmd("vsplit | terminal cha " .. vim.fn.shellescape(input))
          end
        end)
      end, "Text browser split")
      map("t", "<Esc><Esc>", "<C-\\><C-n>", "Terminal normal mode")
      map("t", "<C-h>", "<C-\\><C-n><C-w>h", "Terminal left")
      map("t", "<C-j>", "<C-\\><C-n><C-w>j", "Terminal down")
      map("t", "<C-k>", "<C-\\><C-n><C-w>k", "Terminal up")
      map("t", "<C-l>", "<C-\\><C-n><C-w>l", "Terminal right")

      local telescope = require("telescope.builtin")
      map("n", "<leader>ff", telescope.find_files, "Find files")
      map("n", "<leader>fg", telescope.live_grep, "Live grep")
      map("n", "<leader>fb", telescope.buffers, "Buffers")
      map("n", "<leader>fh", telescope.help_tags, "Help tags")
      map("n", "<leader>fr", telescope.oldfiles, "Recent files")
      map("n", "<leader>fd", telescope.diagnostics, "Diagnostics")
      map("n", "<leader>fs", telescope.git_status, "Git status")
      map("n", "<leader>fc", telescope.git_commits, "Git commits")
      map("n", "<leader>fw", telescope.grep_string, "Search word")
      map("n", "<leader>pv", "<cmd>Oil<cr>", "Project files")
      map("n", "<leader>gg", "<cmd>tabnew | terminal lazygit<cr>", "LazyGit")
      map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics list")
      map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", "Quickfix list")
      map("n", "<leader>xt", "<cmd>TodoTrouble<cr>", "Todo list")
      map("n", "gd", vim.lsp.buf.definition, "Go to definition")
      map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
      map("n", "gr", vim.lsp.buf.references, "Go to references")
      map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
      map("n", "K", vim.lsp.buf.hover, "Hover docs")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      map({ "n", "x" }, "<leader>f", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, "Format buffer")

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded" },
        virtual_text = { spacing = 4, source = "if_many" },
      })

      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank({ higroup = "IncSearch", timeout = 120 })
        end,
      })

      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          local mark = vim.api.nvim_buf_get_mark(0, '"')
          local line_count = vim.api.nvim_buf_line_count(0)
          if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end,
      })

      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          cmp = true,
          gitsigns = true,
          treesitter = true,
          telescope = true,
          which_key = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")

      require("which-key").setup({
        preset = "modern",
        delay = 250,
      })
      require("lualine").setup({
        options = {
          globalstatus = true,
          theme = "catppuccin",
          component_separators = "",
          section_separators = "",
        },
      })
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "oil",
              text = "Project",
              text_align = "left",
            },
          },
        },
      })
      require("gitsigns").setup()
      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon", "permissions", "size" },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
        },
        view_options = {
          show_hidden = true,
        },
      })
      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
      require("nvim-autopairs").setup({})
      require("Comment").setup({})
      require("nvim-surround").setup({})
      require("ibl").setup({})
      require("trouble").setup({})
      require("todo-comments").setup({})
      require("dressing").setup({})
      require("nvim-ts-autotag").setup({})

      require("nvim-treesitter").setup({})

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        "bashls",
        "clangd",
        "cssls",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "nixd",
        "pyright",
        "rust_analyzer",
        "taplo",
        "ts_ls",
        "yamlls",
      }

      for _, server in ipairs(servers) do
        local settings = {}
        if server == "lua_ls" then
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          }
        elseif server == "yamlls" then
          settings = {
            yaml = {
              keyOrdering = false,
            },
          }
        elseif server == "nixd" then
          settings = {
            nixd = {
              formatting = {
                command = { "nixfmt" },
              },
            },
          }
        end

        vim.lsp.config(server, {
          capabilities = capabilities,
          settings = settings,
        })
        vim.lsp.enable(server)
      end

      require("conform").setup({
        format_on_save = {
          lsp_fallback = true,
          timeout_ms = 1000,
        },
        formatters_by_ft = {
          bash = { "shfmt" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          css = { "prettier" },
          html = { "prettier" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          lua = { "stylua" },
          markdown = { "prettier" },
          nix = { "nixfmt" },
          python = { "isort", "black" },
          sh = { "shfmt" },
          sql = { "sqlfluff" },
          toml = { "taplo" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          yaml = { "prettier" },
        },
      })
    '';
  };

  home.file.".config/chawan/config.toml".text = ''
    [start]
    visual-home = "about:chawan"

    [buffer]
    images = false
    mark-links = true

    [input]
    bracketed-paste = true

    [display]
    image-mode = "none"

    [page]
    'SPC r' = "pager.externFilterSource('rdrview -Hu \"$CHA_URL\"')"
  '';

  dconf.settings = {
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Control><Shift>t" ];
      toggle-message-tray = [ "<Super>m" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Clipboard History";
      command = "/run/current-system/sw/bin/copyq show";
      binding = "<Super>V";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Terminal";
      command = "${term}/bin/term";
      binding = "<Super><Shift>Return";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Neovim";
      command = "${nvimTerm}/bin/nvim-term";
      binding = "<Super>Return";
    };
  };

  home.activation.installMutableDesktopConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
      "--userDataDir=${homeDirectory}/.local/share/codex-browser/mcp-profile",
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
