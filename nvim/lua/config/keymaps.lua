-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Buffers
vim.keymap.set("n", "<leader>bF", ":bf<cr>", { noremap = true, silent = true, desc = "[F]irst buffer" })
vim.keymap.set("n", "<leader>bL", ":bl<cr>", { noremap = true, silent = true, desc = "[L]ast buffer" })
