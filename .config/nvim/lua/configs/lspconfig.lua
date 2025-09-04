-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local util = require "lspconfig.util"

-- EXAMPLE
local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- Enable inlay hints
if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end

-- json
do
  local has_schemastore, schemastore = pcall(require, "schemastore")
  lspconfig.jsonls.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    settings = {
      json = {
        schemas = has_schemastore and schemastore.json.schemas() or nil,
        validate = { enable = true },
      },
    },
  }
end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Unified Python project root detection
local python_root = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "ruff.toml", ".ruff.toml", ".git")

local function custom_on_attach(client, bufnr)
  nvlsp.on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- Disable formatting in pyright if using ruff for formatting
  if client.name == "pyright" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

-- python
lspconfig.pyright.setup {
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, {
    offsetEncoding = { "utf-16" },
    general = { positionEncodings = { "utf-16" } },
  }),
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "strict",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
  filetypes = { "python" },
  root_dir = python_root,
}
lspconfig.ruff.setup {
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, {
    general = {
      positionEncodings = { "utf-16", "utf-8" },
    },
  }),
  settings = {
    ruff = {
      organizeImports = true,
      fixAll = true,
    },
  },
  filetypes = { "python" },
  root_dir = python_root,
}
-- for using ruff with pyright
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

--rust
-- Не включай второй lsp для раста, ты используешь rustaceanvim
-- lspconfig.rust_analyzer.setup {
--   on_attach = nvlsp.on_attach, -- Set up common on_attach functionality
--   on_init = nvlsp.on_init,     -- Set up common on_init functionality
--   capabilities = nvlsp.capabilities, -- Set up common LSP capabilities
--
--   -- Rust-specific settings (optional)
--   settings = {
--     ["rust-analyzer"] = {
--       assist = {
--         importMergeBehavior = "last",
--         importPrefix = "by_self",
--       },
--       cargo = {
--         runBuildScripts = true,
--       },
--       procMacro = {
--         enable = true,
--       },
--       checkOnSave = {
--         command = "clippy", -- Use `clippy` for more detailed linting
--       },
--     },
--   },
-- }

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
