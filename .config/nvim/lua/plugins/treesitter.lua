return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, {
        "python",
        "rust",
        "javascript",
        "html",
        "css",
        "lua",
        "json",
        "jsonc",
      })

      opts.highlight = { enable = true }
      opts.indent = { enable = true }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true,
      throttle = true,
      max_lines = 3,
      patterns = {
        default = { "class", "function", "method" },
      },
    },
  },
}
