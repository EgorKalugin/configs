-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- Enable inlay hints
if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- python
lspconfig.pyright.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "standart", -- Optional: Enable strict type checking
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
  filetypes = { "python" },
}
lspconfig.ruff.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    ruff = {
      organizeImports = true, -- Enable Ruff's import organization
      fixAll = true, -- Enable auto-fix on save
    },
  },
  filetypes = { "python" }, -- Ensure Ruff runs only for Python files
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
