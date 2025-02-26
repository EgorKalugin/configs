require "nvchad.mappings"
-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Move line 
vim.api.nvim_set_keymap('n', '<leader>k', ':m .-2<CR>==', { noremap = true, silent = true, desc = "Move line up"})
vim.api.nvim_set_keymap('n', '<leader>j', ':m .+1<CR>==', { noremap = true, silent = true, desc = "Move line down"})

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
  "n",
  "<Leader>dd",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })
map("n", "<Leader>dq", "<cmd>lua require'dapui'.close()<CR>", { desc = "Close DAP UI" })

local function run_tests()
  local filetype = vim.bo.filetype
  if filetype == "rust" then
    vim.cmd.RustLsp('testables')
  elseif filetype == "python" then
    require('dap-python').test_method() -- Or use `test_class()` for class-level tests
  else
    print("Unsupported filetype for testing: " .. filetype)
  end
end
map("n", "<Leader>dt", run_tests, { desc = "Run tests" })

-- Telescope
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Find Symbols" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Resume Last Telescope" })
vim.keymap.set('n', '<leader>fd', ':Telescope diagnostics bufnr=0<CR>', { noremap = true, silent = true, desc = "Find Diagnostics" })
vim.keymap.set('n', '<leader>gh', ':Telescope git_bcommits<CR>', { noremap = true, silent = true, desc = "Git file history" })

--Gigsigns
vim.keymap.set("n", "<leader>gp", "<cmd>lua require'gitsigns'.preview_hunk()<CR>", { desc = "Preview Git Hunk" })
vim.keymap.set("n", "<leader>gt", "<cmd>lua require'gitsigns'.toggle_current_line_blame()<CR>", { desc = "Toggle Current Line Blame" })

-- LazyGit
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })

-- Harpoon (Start)
local harpoon = require("harpoon")
-- REQUIRED
harpoon:setup()
-- REQUIRED
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
-- list
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-O>", function() harpoon:list():next() end)
-- Harpoon (End)local harpoon = require("harpoon")

-- LSP
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename Symbol" })
