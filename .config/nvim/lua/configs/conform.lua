local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    python = { "ruff_format", "isort", "ruff" },
    -- Prefer prettier for JSON; jq second (strict JSON only)
    json = { "prettier", "jq" },
    jsonc = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" }, -- JSX
    typescript = { "prettier" },
    typescriptreact = { "prettier" }, -- TSX
  },

  format_on_save = nil,
}

return options
