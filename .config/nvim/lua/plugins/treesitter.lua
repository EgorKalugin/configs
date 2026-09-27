-- nvim-treesitter is pinned to the rewritten `main` branch, where
-- `ensure_installed` / `highlight` / `indent` no longer exist as options.
-- Parsers are installed imperatively and highlighting + indenting are switched
-- on per buffer instead.

-- there is no `jsonc` parser: nvim-treesitter registers the `jsonc` filetype
-- against the `json` parser (see its plugin/filetypes.lua), same for jsx -> javascript
local parsers = {
  "python",
  "rust",
  "javascript",
  "html",
  "css",
  "lua",
  "json",
  "go",
  "gomod",
  "gosum",
  "gowork",
}

-- the parsers above that ship an indents.scm query
local has_indents = {
  css = true,
  go = true,
  html = true,
  javascript = true,
  json = true,
  lua = true,
  python = true,
  rust = true,
}

local function attach(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype == "" then
    return
  end

  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  local installed = require("nvim-treesitter.config").get_installed "parsers"

  if not lang or not vim.list_contains(installed, lang) then
    return
  end

  if not pcall(vim.treesitter.start, buf, lang) then
    return
  end

  if has_indents[lang] then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local function attach_all()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      attach(buf)
    end
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- NvChad's spec sets the master-only `:TSUpdate | TSInstallAll`
    build = ":TSUpdate",

    config = function(_, opts)
      -- resolving opts runs NvChad's opts function, which dofiles the base46
      -- syntax + treesitter highlight groups; reuse its parser list too
      local wanted = vim.list.unique(vim.list_extend(vim.deepcopy(opts.ensure_installed or {}), parsers))

      local installed = require("nvim-treesitter.config").get_installed "parsers"
      local missing = vim.tbl_filter(function(lang)
        return not vim.list_contains(installed, lang)
      end, wanted)

      if #missing > 0 then
        -- install off the event loop, it shells out to the tree-sitter cli
        vim.schedule(function()
          require("nvim-treesitter").install(missing):await(function()
            vim.schedule(attach_all)
          end)
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          attach(args.buf)
        end,
      })

      -- the plugin loads on BufReadPost, so FileType has already fired for the
      -- buffer that triggered the load
      attach_all()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    -- it has no loader of its own and nothing requires it, so without this it
    -- never gets loaded at all
    event = "User FilePost",
    -- `throttle` and `patterns` used to live here, upstream dropped both
    opts = {
      enable = true,
      max_lines = 3,
    },
  },
}
