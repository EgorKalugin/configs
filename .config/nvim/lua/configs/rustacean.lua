local nvlsp = require "nvchad.configs.lspconfig"
local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb"

local this_os = vim.uv.os_uname().sysname
if this_os:find "Windows" then
  codelldb_path = extension_path .. "adapter\\codelldb.exe"
  liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
else
  -- The liblldb extension is .so for Linux and .dylib for MacOS
  liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

local cfg = require "rustaceanvim.config"

-- Set memory limit for rust-analyzer
vim.env.RUST_ANALYZER_MEMORY_LIMIT = "8192" -- 8GB limit

-- Configure rust-analyzer
local rust_analyzer_config = {
  assist = {
    importPrefix = "by_self",
  },
  cargo = {
    loadOutDirsFromCheck = true,
    runBuildScripts = true,
    buildScripts = true,
    allFeatures = true,
    targetDir = "target/rust-analyzer",
  },
  check = {
    command = "clippy",
    allFeatures = true,
    extraArgs = { "--target-dir", "target/rust-analyzer" },
  },
  procMacro = {
    enable = true,
  },
  inlayHints = {
    enable = true,
    lifetimeElisionHints = {
      enable = true,
      useParameterNames = true,
    },
  },
  files = {
    excludeDirs = { ".git", "target" },
    watcher = "client",
    watcherExclude = {
      "**/target/**",
      "**/Cargo.lock",
    },
  },
  diagnostics = {
    enable = true,
    experimental = {
      enable = true,
    },
  },
}

vim.g.rustaceanvim = {
  dap = {
    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
  },
  server = {
    on_attach = nvlsp.on_attach,
    settings = {
      ["rust-analyzer"] = rust_analyzer_config,
    },
  },
}
