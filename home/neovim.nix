{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Helper to build a vim plugin from nixpkgs
  p = pkgs.vimPlugins;

  # LSP servers available as nix packages
  lspServers = with pkgs; [
    lua-language-server
    nixd
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # html/css/json/eslint
    rust-analyzer
    gopls
    pyright
    clang-tools
    marksman
    coqPackages.coq-lsp
  ];

  # Formatters/linters
  formatters = with pkgs; [
    stylua
    nixfmt
    prettierd
    black
    isort
    shfmt
    gofumpt
    rustfmt
  ];

  # Tools needed at runtime
  runtimeDeps =
    with pkgs;
    [
      ripgrep
      fd
      fzf
      git
      tree-sitter
      gcc
      gnumake
      curl
      lazygit
      coq
    ]
    ++ lspServers
    ++ formatters;

  python3Env = pkgs.python3.withPackages (ps: [ ps.pynvim ]);

  latex-unicoder = pkgs.vimUtils.buildVimPlugin {
    name = "latex-unicoder";
    src = pkgs.fetchFromGitHub {
      owner = "joom";
      repo = "latex-unicoder.vim";
      rev = "705d9e5705f2612df7220d3650e287b97c0e996a";
      sha256 = "1w49riywnwr67kgaafx07pmfw9hqgpf69kf1aw2ygncfai3c4462";
    };
  };

in
{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;

    extraPackages = runtimeDeps;
    extraPython3Packages = ps: with ps; [ pynvim ];
    extraLuaPackages = ps: [ ps.jsregexp ];

    extraConfig = ''
      let g:python3_host_prog = '${python3Env}/bin/python3'
    '';

    plugins = with p; [
      # ─── Core / UI ────────────────────────────────────────────────
      {
        plugin = cyberdream-nvim;
        type = "lua";
        config = ''
          require("cyberdream").setup({
            transparent        = false,
            italic_comments    = true,
            hide_fillchars     = false,
            borderless_telescope = true,
            terminal_colors    = true,
          })
          vim.cmd("colorscheme cyberdream")
        '';
      }

      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require("lualine").setup({
            options = {
              theme = "cyberdream",
              globalstatus = true,
              disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
            },
            sections = {
              lualine_a = { "mode" },
              lualine_b = { "branch" },
              lualine_c = {
                { "diagnostics" },
                { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
              },
              lualine_x = {
                { "diff", symbols = { added = " ", modified = " ", removed = " " } },
              },
              lualine_y = { "progress" },
              lualine_z = { "location" },
            },
          })
        '';
      }

      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require("bufferline").setup({
            options = {
              diagnostics = "nvim_lsp",
              always_show_bufferline = false,
              diagnostics_indicator = function(_, _, diag)
                local icons = { error = " ", warning = " " }
                local ret = (diag.error and icons.error .. diag.error .. " " or "")
                  .. (diag.warning and icons.warning .. diag.warning or "")
                return vim.trim(ret)
              end,
              offsets = {
                {
                  filetype = "neo-tree",
                  text = "Neo-tree",
                  highlight = "Directory",
                  text_align = "left",
                },
              },
            },
          })
        '';
      }

      nvim-web-devicons

      {
        plugin = noice-nvim;
        type = "lua";
        config = ''
          require("noice").setup({
            lsp = {
              override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
              },
            },
            routes = {
              {
                filter = {
                  event = "msg_show",
                  any = {
                    { find = "%d+L, %d+B" },
                    { find = "; after #%d+" },
                    { find = "; before #%d+" },
                  },
                },
                view = "mini",
              },
            },
            presets = {
              bottom_search = true,
              command_palette = true,
              long_message_to_split = true,
              inc_rename = true,
            },
          })
        '';
      }

      nui-nvim

      {
        plugin = nvim-notify;
        type = "lua";
        config = ''
          require("notify").setup({
            stages = "static",
            timeout = 3000,
            max_height = function() return math.floor(vim.o.lines * 0.75) end,
            max_width = function() return math.floor(vim.o.columns * 0.75) end,
            on_open = function(win)
              vim.api.nvim_win_set_config(win, { zindex = 100 })
            end,
          })
          vim.notify = require("notify")
        '';
      }

      {
        plugin = alpha-nvim;
        type = "lua";
        config = ''
          local dashboard = require("alpha.themes.dashboard")
          dashboard.section.header.val = {
            "                                                                  ",
            "  ███╗   ███╗ █████╗ ████████╗████████╗███████╗    ██████╗  ██╗  ",
            "  ████╗ ████║██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝    ██╔══██╗███║  ",
            "  ██╔████╔██║███████║   ██║      ██║   █████╗      ██████╔╝╚██║  ",
            "  ██║╚██╔╝██║██╔══██║   ██║      ██║   ██╔══╝      ██╔═══╝  ██║  ",
            "  ██║ ╚═╝ ██║██║  ██║   ██║      ██║   ███████╗    ██║      ██║  ",
            "  ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝    ╚═╝      ╚═╝  ",
            "                                                                  ",
          }
          dashboard.section.buttons.val = {
            dashboard.button("f", " " .. " Find file",          ":Telescope find_files <CR>"),
            dashboard.button("n", " " .. " New file",           ":ene <BAR> startinsert <CR>"),
            dashboard.button("r", " " .. " Recent files",       ":Telescope oldfiles <CR>"),
            dashboard.button("g", " " .. " Find text",          ":Telescope live_grep <CR>"),
            dashboard.button("c", " " .. " Config",             ":e ~/nixos-config/home/neovim.nix <CR>"),
            dashboard.button("C", " " .. " Config (generated)", ":e $MYVIMRC <CR>"),
            dashboard.button("q", " " .. " Quit",               ":qa<CR>"),
          }
          require("alpha").setup(dashboard.opts)
        '';
      }

      which-key-nvim

      Coqtail

      # ─── latex-unicoder ────────────────────────────────────────────
      {
        plugin = latex-unicoder;
        type = "lua";
        config = ''
          vim.g.unicode_map = {
            ["\\fun"]     = "λ",
            ["\\mult"]    = "⋅",
            ["\\ent"]     = "⊢",
            ["\\valid"]   = "✓",
            ["\\diamond"] = "◇",
            ["\\box"]     = "□",
            ["\\bbox"]    = "■",
            ["\\later"]   = "▷",
            ["\\pred"]    = "φ",
            ["\\and"]     = "∧",
            ["\\or"]      = "∨",
            ["\\comp"]    = "∘",
            ["\\ccomp"]   = "◎",
            ["\\all"]     = "∀",
            ["\\ex"]      = "∃",
            ["\\to"]      = "→",
            ["\\sep"]     = "∗",
            ["\\lc"]      = "⌜",
            ["\\rc"]      = "⌝",
            ["\\Lc"]      = "⎡",
            ["\\Rc"]      = "⎤",
            ["\\lam"]     = "λ",
            ["\\empty"]   = "∅",
            ["\\Lam"]     = "Λ",
            ["\\Sig"]     = "Σ",
            ["\\-"]       = "∖",
            ["\\aa"]      = "●",
            ["\\af"]      = "◯",
            ["\\auth"]    = "●",
            ["\\frag"]    = "◯",
            ["\\iff"]     = "↔",
            ["\\gname"]   = "γ",
            ["\\incl"]    = "≼",
            ["\\latert"]  = "▶",
            ["\\update"]  = "⇝",
            ['\\"o']      = "ö",
            ["_a"]        = "ₐ",
            ["_e"]        = "ₑ",
            ["_h"]        = "ₕ",
            ["_i"]        = "ᵢ",
            ["_k"]        = "ₖ",
            ["_l"]        = "ₗ",
            ["_m"]        = "ₘ",
            ["_n"]        = "ₙ",
            ["_o"]        = "ₒ",
            ["_p"]        = "ₚ",
            ["_r"]        = "ᵣ",
            ["_s"]        = "ₛ",
            ["_t"]        = "ₜ",
            ["_u"]        = "ᵤ",
            ["_v"]        = "ᵥ",
            ["_x"]        = "ₓ",
          }
        '';
      }

      # ─── File Explorer ─────────────────────────────────────────────
      {
        plugin = neo-tree-nvim;
        type = "lua";
        config = ''
          require("neo-tree").setup({
            filesystem = {
              bind_to_cwd = false,
              follow_current_file = { enabled = true },
              use_libuv_file_watcher = true,
            },
            window = {
              width = 30,
              mappings = {
                ["<space>"] = "none",
              },
            },
            default_component_configs = {
              indent = {
                with_expanders = true,
                expander_collapsed = "",
                expander_expanded = "",
              },
            },
          })
        '';
      }

      plenary-nvim

      # ─── Fuzzy Finding ─────────────────────────────────────────────
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require("telescope")
          local actions = require("telescope.actions")
          telescope.setup({
            defaults = {
              prompt_prefix = " ",
              selection_caret = " ",
              get_selection_window = function()
                local wins = vim.api.nvim_list_wins()
                table.insert(wins, 1, vim.api.nvim_get_current_win())
                for _, win in ipairs(wins) do
                  local buf = vim.api.nvim_win_get_buf(win)
                  if vim.bo[buf].buftype == "" then
                    return win
                  end
                end
                return 0
              end,
              mappings = {
                i = {
                  ["<c-t>"] = function(...) return require("trouble.providers.telescope").open_with_trouble(...) end,
                  ["<a-t>"] = function(...) return require("trouble.providers.telescope").open_selected_with_trouble(...) end,
                  ["<a-i>"] = function()
                    local action_state = require("telescope.actions.state")
                    local line = action_state.get_current_line()
                    telescope.extensions.find_files({ no_ignore = true, default_text = line })()
                  end,
                  ["<a-h>"] = function()
                    local action_state = require("telescope.actions.state")
                    local line = action_state.get_current_line()
                    telescope.extensions.find_files({ hidden = true, default_text = line })()
                  end,
                  ["<C-Down>"] = actions.cycle_history_next,
                  ["<C-Up>"] = actions.cycle_history_prev,
                  ["<C-f>"] = actions.preview_scrolling_down,
                  ["<C-b>"] = actions.preview_scrolling_up,
                },
                n = { ["q"] = actions.close },
              },
            },
          })
        '';
      }

      telescope-fzf-native-nvim

      {
        plugin = snacks-nvim;
        type = "lua";
        config = ''
          require("snacks").setup({
            dashboard = {
              enabled = false,
              sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
              },
              preset = {
                header = table.concat({
                  "███╗   ███╗ █████╗ ████████╗████████╗███████╗    ██████╗  ██╗",
                  "████╗ ████║██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝    ██╔══██╗███║",
                  "██╔████╔██║███████║   ██║      ██║   █████╗      ██████╔╝╚██║",
                  "██║╚██╔╝██║██╔══██║   ██║      ██║   ██╔══╝      ██╔═══╝  ██║",
                  "██║ ╚═╝ ██║██║  ██║   ██║      ██║   ███████╗    ██║      ██║",
                  "╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝    ╚═╝      ╚═╝",
                }, "\n"),
                keys = {
                  { icon = " ", key = "f", desc = "Find File",          action = function() Snacks.picker.files() end },
                  { icon = " ", key = "n", desc = "New File",           action = ":ene | startinsert" },
                  { icon = " ", key = "r", desc = "Recent Files",       action = function() Snacks.picker.recent() end },
                  { icon = " ", key = "g", desc = "Find Text",          action = function() Snacks.picker.grep() end },
                  { icon = " ", key = "c", desc = "Config",             action = ":e ~/nixos-config/home/neovim.nix" },
                  { icon = " ", key = "C", desc = "Config (generated)", action = ":e $MYVIMRC" },
                  { icon = " ", key = "q", desc = "Quit",               action = ":qa" },
                },
              },
            },

            notifier = {
              enabled = false,
              timeout = 3000,
              style   = "compact",
            },

            picker   = { enabled = false },
            explorer = { enabled = false },
            lazygit  = { enabled = true },
            image    = { enabled = true },

            indent = {
              enabled = true,
              char  = "│",
              blank = " ",
              scope = { enabled = true, char = "│" },
              exclude = {
                filetypes = {
                  "help", "dashboard", "snacks_dashboard", "Trouble",
                  "trouble", "notify", "toggleterm",
                  "alpha", "neo-tree", "lazy", "mason", "lazyterm",
                },
              },
            },

            bigfile      = { enabled = true },
            bufdelete    = { enabled = true },
            gitbrowse    = { enabled = true },
            input        = { enabled = true },
            quickfile    = { enabled = true },
            scratch      = { enabled = true },
            scroll       = { enabled = true },
            scope        = { enabled = true },
            statuscolumn = { enabled = true },
            toggle       = { enabled = true },
            words        = { enabled = true },

            zen = {
              enabled = true,
              toggles = { dim = true, git_signs = false },
            },
          })

          local map = vim.keymap.set

          -- Scratch
          map("n", "<leader>.", function() Snacks.scratch() end,        { desc = "Toggle Scratch Buffer" })
          map("n", "<leader>S", function() Snacks.scratch.select() end, { desc = "Select Scratch Buffer" })

          -- Git
          map("n", "<leader>gg", function() Snacks.lazygit() end,      { desc = "Lazygit" })
          map("n", "<leader>gb", function() Snacks.gitbrowse() end,     { desc = "Git Browse" })
          map("n", "<leader>gl", function() Snacks.lazygit.log() end,   { desc = "Lazygit Log" })

          -- Notifications
          map("n", "<leader>un", function() Snacks.notifier.hide() end,            { desc = "Dismiss Notifications" })
          map("n", "<leader>sn", function() Snacks.notifier.show_history() end,    { desc = "Notification History" })

          -- Zen
          map("n", "<leader>z", function() Snacks.zen() end,      { desc = "Zen Mode" })
          map("n", "<leader>Z", function() Snacks.zen.zoom() end, { desc = "Zoom" })

          -- Explorer
          map("n", "<leader>e",  function() Snacks.explorer() end, { desc = "Explorer (root dir)" })
          map("n", "<leader>E",  function() Snacks.explorer({ cwd = vim.fn.expand("%:p:h") }) end, { desc = "Explorer (cwd)" })
          map("n", "<leader>fe", function() Snacks.explorer() end, { desc = "Explorer (root dir)" })
          map("n", "<leader>fE", function() Snacks.explorer({ cwd = vim.fn.expand("%:p:h") }) end, { desc = "Explorer (cwd)" })

          -- Picker
          map("n", "<leader><space>", function() Snacks.picker.files() end,           { desc = "Find Files" })
          map("n", "<leader>,",       function() Snacks.picker.buffers() end,         { desc = "Switch Buffer" })
          map("n", "<leader>/",       function() Snacks.picker.grep() end,            { desc = "Grep" })
          map("n", "<leader>:",       function() Snacks.picker.command_history() end, { desc = "Command History" })
          map("n", "<leader>ff",      function() Snacks.picker.files() end,           { desc = "Find Files" })
          map("n", "<leader>fF",      function() Snacks.picker.files({ cwd = "~" }) end, { desc = "Find Files (home)" })
          map("n", "<leader>fr",      function() Snacks.picker.recent() end,          { desc = "Recent Files" })
          map("n", "<leader>fg",      function() Snacks.picker.git_files() end,       { desc = "Git Files" })
          map("n", "<leader>gc",      function() Snacks.picker.git_log() end,         { desc = "Git Log" })
          map("n", "<leader>gs",      function() Snacks.picker.git_status() end,      { desc = "Git Status" })
          map("n", "<leader>sb",      function() Snacks.picker.lines() end,           { desc = "Buffer Lines" })
          map("n", "<leader>sd",      function() Snacks.picker.diagnostics() end,     { desc = "Diagnostics" })
          map("n", "<leader>sD",      function() Snacks.picker.diagnostics({ filter = { buf = 0 } }) end, { desc = "Buffer Diagnostics" })
          map("n", "<leader>sg",      function() Snacks.picker.grep() end,            { desc = "Grep" })
          map("n", "<leader>sh",      function() Snacks.picker.help() end,            { desc = "Help Pages" })
          map("n", "<leader>sH",      function() Snacks.picker.highlights() end,      { desc = "Highlights" })
          map("n", "<leader>sk",      function() Snacks.picker.keymaps() end,         { desc = "Keymaps" })
          map("n", "<leader>sm",      function() Snacks.picker.marks() end,           { desc = "Marks" })
          map("n", "<leader>so",      function() Snacks.picker.vim_options() end,     { desc = "Vim Options" })
          map("n", "<leader>sw",      function() Snacks.picker.grep_word() end,       { desc = "Grep Word" })
          map("n", "<leader>ss",      function() Snacks.picker.lsp_symbols() end,     { desc = "LSP Symbols" })
          map("n", "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
          map("n", "<leader>st",      function() Snacks.picker.todo_comments() end,   { desc = "Todo" })
          map("n", "<leader>sT",      function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, { desc = "Todo/Fix/Fixme" })

          -- LSP pickers
          map("n", "gr", function() Snacks.picker.lsp_references() end,       { desc = "LSP References" })
          map("n", "gI", function() Snacks.picker.lsp_implementations() end,  { desc = "LSP Implementations" })
          map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "LSP Type Definitions" })

          -- Word reference jumping
          map("n", "]]", function() Snacks.words.jump(1) end,  { desc = "Next Reference" })
          map("n", "[[", function() Snacks.words.jump(-1) end, { desc = "Prev Reference" })
        '';
      }

      # ─── Treesitter ────────────────────────────────────────────────
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      # nvim-treesitter-context

      # ─── LSP ───────────────────────────────────────────────────────
      nvim-lspconfig

      # ─── Completion ────────────────────────────────────────────────
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require("cmp")
          local luasnip = require("luasnip")

          cmp.setup({
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
            completion = { completeopt = "menu,menuone,noinsert" },
            mapping = cmp.mapping.preset.insert({
              ["<C-n>"]   = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
              ["<C-p>"]   = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
              ["<C-b>"]   = cmp.mapping.scroll_docs(-4),
              ["<C-f>"]   = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"]   = cmp.mapping.abort(),
              ["<CR>"]    = cmp.mapping.confirm({ select = true }),
              ["<S-CR>"]  = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
              ["<C-CR>"]  = function(fallback)
                cmp.abort()
                fallback()
              end,
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "luasnip" },
              { name = "buffer" },
              { name = "path" },
            }),
            formatting = {
              format = function(_, item)
                local icons = {
                  Text          = "󰉿",  Method        = "󰊕", Function    = "󰊕",
                  Constructor   = "󰒓",  Field         = "󰜢", Variable    = "󰆦",
                  Class         = "󰠱",  Interface     = " ", Module      = "󰅩",
                  Property      = "󰖷",  Unit          = "󰑭", Value       = "󰎠",
                  Enum          = "󰦤",  Keyword       = "󰻾", Snippet     = "󱄽",
                  Color         = "󰏘",  File          = "󰈔", Reference   = "󰬲",
                  Folder        = "󰉋",  EnumMember    = "󰦤", Constant    = "󰏿",
                  Struct        = "󰠱",  Event         = "󱐋", Operator    = "󰪚",
                  TypeParameter = "󰬛",
                }
                if icons[item.kind] then
                  item.kind = icons[item.kind] .. " " .. item.kind
                end
                return item
              end,
            },
            experimental = { ghost_text = { hl_group = "CmpGhostText" } },
          })
        '';
      }

      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip

      {
        plugin = luasnip;
        type = "lua";
        config = ''
          require("luasnip.loaders.from_vscode").lazy_load()
        '';
      }

      friendly-snippets

      # ─── Formatting ────────────────────────────────────────────────
      {
        plugin = conform-nvim;
        type = "lua";
        config = ''
          require("conform").setup({
            formatters_by_ft = {
              lua        = { "stylua" },
              nix        = { "nixfmt" },
              javascript      = { "prettierd" },
              typescript      = { "prettierd" },
              javascriptreact = { "prettierd" },
              typescriptreact = { "prettierd" },
              json            = { "prettierd" },
              html            = { "prettierd" },
              css             = { "prettierd" },
              markdown        = { "prettierd" },
              python     = { "isort", "black" },
              sh         = { "shfmt" },
              go         = { "gofumpt" },
              rust       = { "rustfmt" },
            },
            format_on_save = {
              timeout_ms = 500,
              lsp_fallback = true,
            },
          })
          vim.keymap.set({ "n", "v" }, "<leader>cf", function()
            require("conform").format({ async = true, lsp_fallback = true })
          end, { desc = "Format" })
        '';
      }

      # ─── Linting ───────────────────────────────────────────────────
      {
        plugin = nvim-lint;
        type = "lua";
        config = ''
          require("lint").linters_by_ft = {
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            python     = { "mypy" },
          }
          vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
              require("lint").try_lint()
            end,
          })
        '';
      }

      # ─── Git ───────────────────────────────────────────────────────
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require("gitsigns").setup({
            signs = {
              add          = { text = "▎" },
              change       = { text = "▎" },
              delete       = { text = "" },
              topdelete    = { text = "" },
              changedelete = { text = "▎" },
              untracked    = { text = "▎" },
            },
            on_attach = function(buffer)
              local gs = package.loaded.gitsigns
              local map = function(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
              end
              map("n", "]h", gs.next_hunk,          "Next Hunk")
              map("n", "[h", gs.prev_hunk,          "Prev Hunk")
              map("n", "<leader>ghs", gs.stage_hunk,   "Stage Hunk")
              map("n", "<leader>ghr", gs.reset_hunk,   "Reset Hunk")
              map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
              map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
              map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
              map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
              map("n", "<leader>ghd", gs.diffthis,     "Diff This")
              map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
            end,
          })
        '';
      }

      {
        plugin = vim-fugitive;
        type = "lua";
        config = ''
          vim.keymap.set("n", "<leader>gf", "<cmd>Git<cr>", { desc = "Fugitive" })
        '';
      }

      # ─── Editor Enhancements ───────────────────────────────────────
      {
        plugin = mini-nvim;
        type = "lua";
        config = ''
          -- mini.pairs: auto pairs
          require("mini.pairs").setup()

          -- mini.surround
          require("mini.surround").setup({
            mappings = {
              add            = "gsa",
              delete         = "gsd",
              find           = "gsf",
              find_left      = "gsF",
              highlight      = "gsh",
              replace        = "gsr",
              update_n_lines = "gsn",
            },
          })

          -- mini.comment (commenting)
          require("mini.comment").setup({
            options = {
              custom_commentstring = function()
                return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
              end,
            },
          })

          -- mini.ai: better text objects
          local ai = require("mini.ai")
          ai.setup({
            n_lines = 500,
            custom_textobjects = {
              o = ai.gen_spec.treesitter({
                a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                i = { "@block.inner", "@conditional.inner", "@loop.inner" },
              }, {}),
              f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
              c = ai.gen_spec.treesitter({ a = "@class.outer",    i = "@class.inner" }, {}),
              t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
            },
          })

          -- mini.move: move selections
          require("mini.move").setup({
            mappings = {
              left        = "<M-h>",
              right       = "<M-l>",
              down        = "<M-j>",
              up          = "<M-k>",
              line_left   = "<M-h>",
              line_right  = "<M-l>",
              line_down   = "<M-j>",
              line_up     = "<M-k>",
            },
          })

          -- mini.bufremove
          require("mini.bufremove").setup()
          vim.keymap.set("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end, { desc = "Delete Buffer" })
          vim.keymap.set("n", "<leader>bD", function() require("mini.bufremove").delete(0, true)  end, { desc = "Delete Buffer (Force)" })
        '';
      }

      nvim-ts-context-commentstring

      {
        plugin = flash-nvim;
        type = "lua";
        config = ''
          require("flash").setup()
          vim.keymap.set({ "n", "x", "o" }, "s",     function() require("flash").jump() end,              { desc = "Flash" })
          vim.keymap.set({ "n", "x", "o" }, "S",     function() require("flash").treesitter() end,        { desc = "Flash Treesitter" })
          vim.keymap.set("o",               "r",     function() require("flash").remote() end,             { desc = "Remote Flash" })
          vim.keymap.set({ "o", "x" },      "R",     function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
          vim.keymap.set({ "c" },           "<c-s>", function() require("flash").toggle() end,             { desc = "Toggle Flash Search" })
        '';
      }

      {
        plugin = trouble-nvim;
        type = "lua";
        config = ''
          require("trouble").setup({ use_diagnostic_signs = true })
          vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  { desc = "Document Diagnostics" })
          vim.keymap.set("n", "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" })
          vim.keymap.set("n", "<leader>xL", "<cmd>TroubleToggle loclist<cr>",               { desc = "Location List" })
          vim.keymap.set("n", "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>",              { desc = "Quickfix List" })
          vim.keymap.set("n", "[q", function()
            if require("trouble").is_open() then require("trouble").previous({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cprev)
              if not ok then vim.notify(err, vim.log.levels.ERROR) end
            end
          end, { desc = "Previous Trouble/Quickfix" })
          vim.keymap.set("n", "]q", function()
            if require("trouble").is_open() then require("trouble").next({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cnext)
              if not ok then vim.notify(err, vim.log.levels.ERROR) end
            end
          end, { desc = "Next Trouble/Quickfix" })
        '';
      }

      {
        plugin = todo-comments-nvim;
        type = "lua";
        config = ''
          require("todo-comments").setup()
          vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next Todo Comment" })
          vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev Todo Comment" })
          vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<cr>",               { desc = "Todo (Trouble)" })
          vim.keymap.set("n", "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme (Trouble)" })
          vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>",             { desc = "Todo" })
          vim.keymap.set("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme" })
        '';
      }

      {
        plugin = nvim-spectre;
        type = "lua";
        config = ''
          vim.keymap.set("n", "<leader>sr", function() require("spectre").open() end, { desc = "Replace in Files (Spectre)" })
        '';
      }

      {
        plugin = toggleterm-nvim;
        type = "lua";
        config = ''
          require("toggleterm").setup({
            size = 20,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = { border = "curved" },
          })
        '';
      }

      {
        plugin = persistence-nvim;
        type = "lua";
        config = ''
          require("persistence").setup()
          vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end,                { desc = "Restore Session" })
          vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore Last Session" })
          vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end,               { desc = "Don't Save Current Session" })
        '';
      }

      # ─── Extras ────────────────────────────────────────────────────
      {
        plugin = nvim-ufo;
        type = "lua";
        config = ''
          vim.o.foldcolumn = "1"
          vim.o.foldlevel = 99
          vim.o.foldlevelstart = 99
          vim.o.foldenable = true
          require("ufo").setup({
            provider_selector = function()
              return { "treesitter", "indent" }
            end,
          })
          vim.keymap.set("n", "zR", require("ufo").openAllFolds,  { desc = "Open All Folds" })
          vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close All Folds" })
        '';
      }

      promise-async # nvim-ufo dependency

      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = ''
          require("colorizer").setup()
        '';
      }

      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text

    ]; # end plugins

    initLua = ''
      -- ─── LSP (Neovim 0.11+ native API) ───────────────────────────────
      vim.diagnostic.config({
        underline        = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source  = "if_many",
          prefix  = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
      })

      -- Rounded borders for hover / signature help
      local orig = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig(contents, syntax, opts, ...)
      end

      -- Extend capabilities for nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
        callback = function(ev)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("n", "gd",         vim.lsp.buf.definition,                    "Goto Definition")
          map("n", "gD",         vim.lsp.buf.declaration,                   "Goto Declaration")
          map("n", "gr",         "<cmd>Telescope lsp_references<cr>",       "References")
          map("n", "gI",         "<cmd>Telescope lsp_implementations<cr>",  "Goto Implementation")
          map("n", "gy",         "<cmd>Telescope lsp_type_definitions<cr>", "Goto T[y]pe Definition")
          map("n", "K",          vim.lsp.buf.hover,                         "Hover")
          map("n", "gK",         vim.lsp.buf.signature_help,                "Signature Help")
          map("i", "<c-k>",      vim.lsp.buf.signature_help,                "Signature Help")
          map("n", "<leader>ca", vim.lsp.buf.code_action,                   "Code Action")
          map("v", "<leader>ca", vim.lsp.buf.code_action,                   "Code Action")
          map("n", "<leader>cr", vim.lsp.buf.rename,                        "Rename")
          map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        end,
      })

      -- Apply capabilities to all servers
      vim.lsp.config("*", { capabilities = capabilities })

      -- lua_ls needs extra settings
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace  = { checkThirdParty = false },
            codeLens   = { enable = true },
            completion = { callSnippet = "Replace" },
          },
        },
      })

      -- Enable all servers (binaries are on PATH via extraPackages)
      vim.lsp.enable({
        "lua_ls", "nixd", "ts_ls", "html", "cssls",
        "jsonls", "eslint", "rust_analyzer", "gopls",
        "pyright", "clangd", "marksman",
      })




      -- ─── Options ─────────────────────────────────────────────────────
      local opt = vim.opt

      -- Netrw
      vim.cmd("let g:netrw_banner = 0")

      -- Cursor & line numbers
      opt.guicursor      = ""           -- block cursor always
      opt.nu             = true
      opt.number         = true
      opt.relativenumber = true

      -- Indentation
      opt.autoindent     = true
      opt.smartindent    = true
      opt.expandtab      = true
      opt.shiftwidth     = 2
      opt.tabstop        = 2

      -- Search
      opt.incsearch      = true
      opt.hlsearch       = true
      opt.ignorecase     = true
      opt.smartcase      = true
      opt.inccommand     = "split"      -- show substitution preview in split

      -- Files
      opt.swapfile       = false
      opt.undofile       = true
      opt.undolevels     = 10000
      opt.autowrite      = true

      -- UI
      opt.wrap           = true
      opt.termguicolors  = true
      opt.cursorline     = true
      opt.scrolloff      = 4
      opt.sidescrolloff  = 8
      opt.signcolumn     = "yes"
      opt.showmode       = false
      opt.laststatus     = 3
      opt.pumheight      = 10
      opt.pumblend       = 10
      opt.winminwidth    = 5
      opt.splitright     = true
      opt.splitbelow     = true
      opt.splitkeep      = "screen"
      opt.conceallevel   = 2
      opt.list           = true

      -- Editing
      opt.backspace      = { "start", "eol", "indent" }
      opt.isfname:append("@-@")
      opt.clipboard      = "unnamedplus"
      opt.mouse          = "a"
      opt.completeopt    = "menu,menuone,noselect"
      opt.formatoptions  = "jcroqlnt"

      -- Performance
      opt.updatetime     = 50           -- your preference (was 200)
      opt.timeoutlen     = 300

      -- Misc
      opt.confirm        = true
      opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
      opt.shortmess:append({ W = true, I = true, c = true, C = true })
      opt.spelllang      = { "en" }
      opt.virtualedit    = "block"
      opt.wildmode       = "longest:full,full"
      opt.grepformat     = "%f:%l:%c:%m"
      opt.grepprg        = "rg --vimgrep"
      vim.g.editorconfig = true

      -- Float border transparent background
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })

      -- ─── Keymaps ─────────────────────────────────────────────────────
      local map = vim.keymap.set

      vim.g.mapleader      = " "
      vim.g.maplocalleader = "\\"

      -- Better up/down
      map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
      map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
      map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
      map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

      -- Window navigation
      map("n", "<C-h>", "<C-w>h", { desc = "Go to left window",  remap = true })
      map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
      map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
      map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

      -- Resize with arrows
      map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase window height" })
      map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease window height" })
      map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Decrease window width"  })
      map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width"  })

      -- Buffers
      map("n", "<S-h>",     "<cmd>bprevious<cr>",          { desc = "Prev buffer" })
      map("n", "<S-l>",     "<cmd>bnext<cr>",              { desc = "Next buffer" })
      map("n", "[b",        "<cmd>bprevious<cr>",          { desc = "Prev buffer" })
      map("n", "]b",        "<cmd>bnext<cr>",              { desc = "Next buffer" })
      map("n", "<leader>`", "<cmd>e #<cr>",                { desc = "Switch to Other Buffer" })

      -- Clear search
      map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
      map("n", "<leader>ur", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>", { desc = "Redraw / clear hlsearch / diff update" })

      -- Save
      map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

      -- Quit
      map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

      -- Better indenting in visual
      map("v", "<", "<gv")
      map("v", ">", ">gv")

      -- Lazy / package management (no-op since we use nix)
      -- Commenting out <leader>l which lazyvim uses for lazy UI

      -- File explorer
      map("n", "<leader>e",  "<cmd>Neotree toggle<cr>",         { desc = "Explorer NeoTree (root dir)" })
      map("n", "<leader>E",  "<cmd>Neotree toggle dir=%:p:h<cr>", { desc = "Explorer NeoTree (cwd)" })
      map("n", "<leader>fe", "<cmd>Neotree toggle<cr>",         { desc = "Explorer NeoTree (root dir)" })
      map("n", "<leader>fE", "<cmd>Neotree toggle dir=%:p:h<cr>", { desc = "Explorer NeoTree (cwd)" })

      -- Telescope
      map("n", "<leader>,",  "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", { desc = "Switch Buffer" })
      map("n", "<leader>/",  "<cmd>Telescope live_grep<cr>",         { desc = "Grep (root dir)" })
      map("n", "<leader>:",  "<cmd>Telescope command_history<cr>",   { desc = "Command History" })
      map("n", "<leader><space>", "<cmd>Telescope find_files<cr>",   { desc = "Find Files (root dir)" })
      map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",        { desc = "Find Files (root dir)" })
      map("n", "<leader>fF", "<cmd>Telescope find_files cwd=~<cr>",  { desc = "Find Files (cwd)" })
      map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",          { desc = "Recent" })
      map("n", "<leader>fR", "<cmd>Telescope oldfiles cwd=vim.loop.cwd()<cr>", { desc = "Recent (cwd)" })
      map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>",       { desc = "Commits" })
      map("n", "<leader>gs", "<cmd>Telescope git_status<cr>",        { desc = "Status" })
      map("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer" })
      map("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document diagnostics" })
      map("n", "<leader>sD", "<cmd>Telescope diagnostics<cr>",       { desc = "Workspace diagnostics" })
      map("n", "<leader>sg", "<cmd>Telescope live_grep<cr>",         { desc = "Grep (root dir)" })
      map("n", "<leader>sh", "<cmd>Telescope help_tags<cr>",         { desc = "Help Pages" })
      map("n", "<leader>sH", "<cmd>Telescope highlights<cr>",        { desc = "Search Highlight Groups" })
      map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>",           { desc = "Key Maps" })
      map("n", "<leader>sm", "<cmd>Telescope marks<cr>",             { desc = "Jump to Mark" })
      map("n", "<leader>so", "<cmd>Telescope vim_options<cr>",       { desc = "Options" })
      map("n", "<leader>sw", "<cmd>Telescope grep_string<cr>",       { desc = "Word (root dir)" })
      map("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Goto Symbol" })
      map("n", "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Goto Symbol (Workspace)" })

      -- UI toggles
      map("n", "<leader>uf", function()
        vim.b.autoformat = not vim.b.autoformat
        vim.notify("Autoformat " .. (vim.b.autoformat and "enabled" or "disabled"), vim.log.levels.INFO)
      end, { desc = "Toggle auto format (buffer)" })
      map("n", "<leader>us", "<cmd>set spell!<cr>",               { desc = "Toggle Spelling" })
      map("n", "<leader>uw", "<cmd>set wrap!<cr>",                { desc = "Toggle Word Wrap" })
      map("n", "<leader>uL", "<cmd>set relativenumber!<cr>",      { desc = "Toggle Relative Line Numbers" })
      map("n", "<leader>ul", "<cmd>set number!<cr>",              { desc = "Toggle Line Numbers" })
      map("n", "<leader>ud", function()
        local enabled = vim.diagnostic.is_disabled and not vim.diagnostic.is_disabled(0)
          or (not vim.diagnostic.is_disabled and true)
        if enabled then vim.diagnostic.disable(0) else vim.diagnostic.enable(0) end
      end, { desc = "Toggle Diagnostics" })
      map("n", "<leader>uc", function()
        vim.opt.conceallevel = vim.o.conceallevel > 0 and 0 or 2
      end, { desc = "Toggle Conceal" })

      -- Diagnostics
      map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
      map("n", "]d", vim.diagnostic.goto_next,          { desc = "Next Diagnostic" })
      map("n", "[d", vim.diagnostic.goto_prev,          { desc = "Prev Diagnostic" })
      map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next Error" })
      map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error" })
      map("n", "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end,  { desc = "Next Warning" })
      map("n", "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end,  { desc = "Prev Warning" })

      -- ─── Autocmds ─────────────────────────────────────────────────────
      local function augroup(name)
        return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
      end

      -- Highlight on yank
      vim.api.nvim_create_autocmd("TextYankPost", {
        group = augroup("highlight_yank"),
        callback = function() vim.hl.on_yank() end,
      })

      -- Resize splits if window got resized
      vim.api.nvim_create_autocmd("VimResized", {
        group = augroup("resize_splits"),
        callback = function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd("tabdo wincmd =")
          vim.cmd("tabnext " .. current_tab)
        end,
      })

      -- Go to last loc when opening a buffer
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = augroup("last_loc"),
        callback = function(event)
          local exclude = { "gitcommit" }
          local buf = event.buf
          if vim.tbl_contains(exclude, vim.bo[buf].filetype) then return end
          if vim.b[buf].lazyvim_last_loc then return end
          vim.b[buf].lazyvim_last_loc = true
          local mark = vim.api.nvim_buf_get_mark(buf, '"')
          local lcount = vim.api.nvim_buf_line_count(buf)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end,
      })

      -- Close some filetypes with <q>
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup("close_with_q"),
        pattern = {
          "PlenaryTestPopup", "help", "lspinfo", "man", "notify", "qf",
          "query", "spectre_panel", "startuptime", "tsplayground",
          "neotest-output", "checkhealth", "neotest-summary", "neotest-output-panel",
        },
        callback = function(event)
          vim.bo[event.buf].buflisted = false
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end,
      })

      -- Wrap and spell in text filetypes
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup("wrap_spell"),
        pattern = { "gitcommit", "markdown" },
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.spell = true
        end,
      })

      -- Fix conceallevel for json
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup("json_conceal"),
        pattern = { "json", "jsonc", "json5" },
        callback = function()
          vim.opt_local.conceallevel = 0
        end,
      })

      -- Auto create dir when saving a file
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup("auto_create_dir"),
        callback = function(event)
          if event.match:match("^%w%w+://") then return end
          local file = vim.loop.fs_realpath(event.match) or event.match
          vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end,
      })
    '';
  };
}
