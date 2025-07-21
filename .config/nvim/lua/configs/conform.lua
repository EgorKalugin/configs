local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    python = { "ruff_format", "isort", "ruff" },
  },

  format_on_save = nil,
}

return options
