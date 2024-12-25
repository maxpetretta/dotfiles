-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Move lines
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
vim.keymap.set("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
vim.keymap.set("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move Line Down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move Line Up" })

-- Move between splits
vim.keymap.set({ "n", "t" }, "<C-S-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
vim.keymap.set({ "n", "t" }, "<C-S-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
vim.keymap.set({ "n", "t" }, "<C-S-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
vim.keymap.set({ "n", "t" }, "<C-S-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

vim.keymap.set({ "n", "t" }, "<C-S-n>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
vim.keymap.set({ "n", "t" }, "<C-S-e>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
vim.keymap.set({ "n", "t" }, "<C-S-i>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
vim.keymap.set({ "n", "t" }, "<C-S-o>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

-- Buffer management
vim.keymap.del("n", "<leader>`")
vim.keymap.set("n", "<leader>bx", "<cmd>%bd|e#<cr>", { desc = "Close All but Current Buffer" })

-- Unbind keymaps for tab management
vim.keymap.del("n", "<leader><tab>o")
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.del("n", "<leader><tab>[")

-- Split buffers using d/D
vim.keymap.set("n", "<leader>d", "<cmd>vsplit<cr>", { desc = "Split Window Right" })
vim.keymap.set("n", "<leader>D", "<cmd>split<cr>", { desc = "Split Window Below" })

-- Open URL under cursor
vim.keymap.set("n", "gx", function()
  vim.cmd("URLOpenUnderCursor")
end, { desc = "Open URL under cursor" })
