vim.g.rustaceanvim = function()
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

  return {
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    server = {
      on_attach = nvlsp.on_attach,
      default_settings = {
        ["rust-analyzer"] = {
          assist = {
            importPrefix = "by_self",
          },
          cargo = {
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
            buildScripts = true,
            allFeatures = true,
          },
          check = {
            command = "clippy",
            allFeatures = true,
          },
          procMacro = {
            enable = true,
          },
          inlayHints = {
            lifetimeElisionHints = {
              enable = true,
              useParameterNames = true,
            },
          },
        },
      },
    },
  }
end
