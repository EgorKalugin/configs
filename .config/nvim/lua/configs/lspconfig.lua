-- Enable inlay hints
if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end

-- Global LSP settings and attach handlers
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
          resolveSupport = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          },
        },
      },
    },
  },
})

-- Set up global LSP attach behavior
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_config", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    -- Set buffer-local options
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Set up buffer-local keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    -- Server-specific settings
    if client.name == "pyright" then
      -- Disable formatting in favor of ruff
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    elseif client.name == "ruff" then
      -- Disable hover in favor of pyright
      client.server_capabilities.hoverProvider = false
    elseif client.name == "tsserver" then
      -- Disable formatting in favor of prettier
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
})

-- JSON LSP configuration
do
  local has_schemastore, schemastore = pcall(require, "schemastore")
  vim.lsp.config["jsonls"] = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git" },
    settings = {
      json = {
        schemas = has_schemastore and schemastore.json.schemas() or nil,
        validate = { enable = true },
      },
    },
  }
  vim.lsp.enable "jsonls"
end

-- HTML and CSS LSP configurations
vim.lsp.config["html"] = {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { ".git" },
}
vim.lsp.enable "html"

vim.lsp.config["cssls"] = {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { ".git" },
}
vim.lsp.enable "cssls"

-- Python LSP configurations
vim.lsp.config["pyright"] = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "ruff.toml",
    ".ruff.toml",
    ".git",
  },
  capabilities = {
    offsetEncoding = { "utf-16" },
    general = { positionEncodings = { "utf-16" } },
  },
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
}
vim.lsp.enable "pyright"

vim.lsp.config["ruff"] = {
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "ruff.toml",
    ".ruff.toml",
    ".git",
  },
  capabilities = {
    general = { positionEncodings = { "utf-16" } },
  },
  settings = {
    ruff = {
      organizeImports = true,
      fixAll = true,
    },
  },
}
vim.lsp.enable "ruff"

-- TypeScript/JavaScript LSP configuration
vim.lsp.config["tsserver"] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayVariableTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
      },
      preferences = {
        includeCompletionsForModuleExports = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayVariableTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
      },
      preferences = {
        includeCompletionsForModuleExports = true,
      },
    },
  },
}
vim.lsp.enable "tsserver"
