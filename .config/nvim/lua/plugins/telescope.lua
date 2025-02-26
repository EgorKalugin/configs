-- exclude folders in telescope
return {
  {
    "nvim-telescope/telescope.nvim", -- Specify the Telescope plugin
    opts = {
      defaults = {
        file_ignore_patterns = {
          "%.lock",
          "%.target", -- Rust `.target` directory
          "%target", -- Rust `target` directory
          "%.venv", -- Python virtual environment
          "node_modules", -- Node.js modules
          "%.parquet", -- Analytics shit
          "%.csv", -- Analytics shit
          "%.xlsx", -- Analytics shit
          "%.txt", -- Analytics shit
          "%.tpl", -- Analytics shit
          "%.json", -- Analytics shit
          "%.onnx", -- Analytics shit
          "%.cbm", -- Analytics shit
          "%.pdf", -- Analytics shit
          ".ruff_cache", -- Ruff cache
        },
      },
    },
  },
}
