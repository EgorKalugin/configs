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
    importGranularity = "module",
    importEnforceGranularity = true,
  },
  cargo = {
    loadOutDirsFromCheck = true,
    runBuildScripts = true,
    buildScripts = true,
    allFeatures = true,
    -- targetDir = "target/rust-analyzer", почему-то не работает
    features = "all",
    noDefaultFeatures = false,
    noSysroot = false,
  },
  check = {
    command = "clippy",
    allFeatures = true,
    -- extraArgs = { "--target-dir", "target/rust-analyzer" },
    -- args = { "--target-dir", "target/rust-analyzer" },
  },
  procMacro = {
    enable = true,
  },
  inlayHints = {
    enable = true,
    typeHints = {
      enable = true,
      hideClosureInitialization = false,
      hideNamedConstructor = false,
    },
    chainingHints = {
      enable = true,
      maxLength = 25,
    },
    parameterHints = {
      enable = true,
      showNamedParameters = true,
    },
    lifetimeElisionHints = {
      enable = true,
      useParameterNames = true,
    },
    reborrowHints = {
      enable = true,
      showReborrows = true,
    },
    expressionAdjustmentHints = {
      enable = true,
      mode = "prefix",
    },
  },
  files = {
    excludeDirs = { ".git", "target", "node_modules", "dist", "build", ".venv" },
    watcher = "client",
    watcherExclude = {
      "**/target/**",
      "**/Cargo.lock",
      "**/node_modules/**",
      "**/dist/**",
      "**/build/**",
      "**/.venv/**",
    },
  },
  diagnostics = {
    enable = true,
    experimental = {
      enable = true,
    },
    disabled = {},
    warningsAsHint = {},
    warningsAsInfo = {},
  },
  lens = {
    enable = true,
    references = true,
    implementations = true,
    run = true,
    debug = true,
    gotoTypeDef = true,
    methodReferences = true,
    referencesADT = true,
    enumVariantReferences = true,
    location = "above_whole_item",
  },
  hover = {
    actions = {
      enable = true,
      implementations = true,
      references = true,
      run = true,
      debug = true,
      gotoTypeDef = true,
    },
    links = {
      enable = true,
    },
    documentation = {
      enable = true,
    },
  },
  completion = {
    autoimport = {
      enable = true,
    },
    postfix = {
      enable = true,
    },
    fullFunctionSignatures = true,
    callable = {
      snippets = "fill_arguments",
    },
  },
  semanticHighlighting = {
    enable = true,
    operator = {
      enable = true,
    },
    punctuation = {
      enable = true,
    },
    strings = {
      enable = true,
    },
  },
  typing = {
    autoClosingAngleBrackets = {
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
