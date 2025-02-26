--sticky scroll
-- install and setup treesitter

return {
  {
    "nvim-treesitter/nvim-treesitter", -- Tree-sitter plugin
    build = ":TSUpdate", -- Ensure parsers are updated
    opts = {
      highlight = {
        enable = true, -- Enables syntax highlighting
      },
      indent = {
        enable = true, -- Enables indentation
      },
      ensure_installed = { -- List of languages to install parsers for
        "python",
        "rust",
        "javascript",
        "html",
        "css",
        "lua",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Enable sticky scrolling with Treesitter context
      require("treesitter-context").setup {
        enable = true, -- Enable sticky scrolling
        throttle = true, -- Improve performance
        max_lines = 3, -- No limit on the number of context lines
        patterns = { -- Patterns for context
          default = {
            "class",
            "function",
            "method",
          },
        },
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context", -- Sticky scrolling plugin
    },
  },
}

