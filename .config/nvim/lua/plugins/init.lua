return {
  -- easily add new plugins to your config
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
    opts = {
      inlay_hints = { enabled = true },
    },
  },

  -- Mason: manage LSP/DAP/linters/formatters
  -- Deliberately no config/opts: NvChad's own spec supplies mason's opts, and
  -- nvchad/options.lua already puts mason's bin dir on vim.env.PATH at startup.
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- VeryLazy fires on UIEnter, the first moment a UI exists; mason-lspconfig
    -- skips ensure_installed while headless, so nothing earlier would help.
    event = "VeryLazy",
    -- v2 requires nvim-lspconfig in rtp before setup(), and automatic_enable must
    -- see the server configs from configs/lspconfig.lua, so load that plugin first.
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "ruff",
          "jsonls",
          "ts_ls",
          "gopls",
          "lua_ls",
        },
        -- v2 auto-enables every installed server via vim.lsp.enable(). Mason's
        -- registry maps the stylua package to a "stylua" LSP, which would attach
        -- `stylua --lsp` to every lua buffer alongside conform's stylua formatter.
        automatic_enable = { exclude = { "stylua" } },
      })
    end,
  },
  -- Auto install formatters/linters used by conform & tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local mti = require "mason-tool-installer"
      mti.setup({
        ensure_installed = {
          -- formatters/linters used by conform & tools
          "prettier",
          "jq",
          "stylua",
          "isort",
          "ruff",
          -- go formatters
          "gofumpt",
          "goimports",
          -- ensure ts language server binary exists even outside lspconfig
          "typescript-language-server",
        },
        auto_update = false,
        run_on_start = true,
      })
      -- run_on_start is wired to a VimEnter autocmd in the plugin's plugin/ dir,
      -- which never fires when we load after VimEnter, so kick it off ourselves
      mti.run_on_start()
    end,
  },

  -- JSON schema catalog for jsonls
  {
    "b0o/schemastore.nvim",
    event = "BufReadPre",
  },

  -- rustaceanvim
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",

    config = function()
      require "configs.rustacean"
    end,
  },
  -- {
  --   "rust-lang/rust.vim",
  --   ft = "rust",
  --   init = function()
  --     vim.g.rustfmt_autosave = 1
  --   end,
  -- },
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true,
          },
        },
      }
      require("cmp").setup.buffer {
        sources = { { name = "crates" } },
      }
    end,
  },

  -- DAP debugger
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").test_runner = "pytest"
    end,
  },
}
