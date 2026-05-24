vim.g.mapleader = " " -- Leader key
vim.opt.expandtab = true -- Uses spaces instead of tabs
vim.opt.tabstop = 2 -- Number of spaces a tab counts for
vim.opt.softtabstop = 2 -- Number of spaces for editing tabs (e.g., when pressing <Tab>)
vim.opt.shiftwidth = 2 -- Number of spaces used for auto-indent (>> << etc.)
vim.opt.number = true -- Shows absolute line numbers for all lines
vim.opt.relativenumber = false -- Shows relative numbers except current line
vim.opt.wrap = false 
vim.opt.sidescrolloff = 10 -- Keeps 8 columns of context when scrolling horizontally
vim.opt.termguicolors = true

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })

-- Copy entire line to system clipboard
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })

-- Copy entire buffer to system clipboard
vim.keymap.set("n", "<leader>ya", 'ggVG"+y', { desc = "Copy entire buffer to system clipboard" })

-- Paste from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before cursor from system clipboard" })
