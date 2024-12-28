-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Move between buffer splits
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move Cursor Left" })
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move Cursor Down" })
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move Cursor Up" }) -- Overrides jumplist next
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move Cursor Right" }) -- Overrides jumplist previous

vim.keymap.set("n", "<C-n>", require("smart-splits").move_cursor_left, { desc = "Move Cursor Left" })
vim.keymap.set("n", "<C-e>", require("smart-splits").move_cursor_down, { desc = "Move Cursor Down" })
vim.keymap.set("n", "<C-i>", require("smart-splits").move_cursor_up, { desc = "Move Cursor Up" }) -- Overrides jumplist next
vim.keymap.set("n", "<C-o>", require("smart-splits").move_cursor_right, { desc = "Move Cursor Right" }) -- Overrides jumplist previous

vim.keymap.set("n", "<C-Tab>", require("smart-splits").move_cursor_previous, { desc = "Move Cursor Previous" })

-- Move between terminal splits
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

vim.keymap.set("t", "<C-n>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-e>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-i>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-o>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

-- Resize splits
vim.keymap.set("n", "<C-Left>", require("smart-splits").resize_left, { desc = "Resize Left" })
vim.keymap.set("n", "<C-Down>", require("smart-splits").resize_down, { desc = "Resize Down" })
vim.keymap.set("n", "<C-Up>", require("smart-splits").resize_up, { desc = "Resize Up" })
vim.keymap.set("n", "<C-Right>", require("smart-splits").resize_right, { desc = "Resize Right" })

-- Swapping buffers between windows
vim.keymap.set("n", "<leader>bh", require("smart-splits").swap_buf_left, { desc = "Swap Buffer Left" })
vim.keymap.set("n", "<leader>bj", require("smart-splits").swap_buf_down, { desc = "Swap Buffer Down" })
vim.keymap.set("n", "<leader>bk", require("smart-splits").swap_buf_up, { desc = "Swap Buffer Up" })
vim.keymap.set("n", "<leader>bl", require("smart-splits").swap_buf_right, { desc = "Swap Buffer Right" })

vim.keymap.set("n", "<leader>bn", require("smart-splits").swap_buf_left, { desc = "Swap Buffer Left" })
vim.keymap.set("n", "<leader>be", require("smart-splits").swap_buf_down, { desc = "Swap Buffer Down" })
vim.keymap.set("n", "<leader>bi", require("smart-splits").swap_buf_up, { desc = "Swap Buffer Up" })
vim.keymap.set("n", "<leader>bo", require("smart-splits").swap_buf_right, { desc = "Swap Buffer Right" })

-- Move lines
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
vim.keymap.set("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
vim.keymap.set("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move Line Down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move Line Up" })

-- Buffer management
vim.keymap.del("n", "<leader>`")
vim.keymap.set("n", "<leader>bx", "<cmd>%bd|e#<cr>", { desc = "Close All but Current Buffer" })

-- Split buffers using d/D
vim.keymap.set("n", "<leader>d", "<cmd>vsplit<cr>", { desc = "Split Window Right" })
vim.keymap.set("n", "<leader>D", "<cmd>split<cr>", { desc = "Split Window Below" })

-- Unbind keymaps for tab management
vim.keymap.del("n", "<leader><tab>o")
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.del("n", "<leader><tab>[")

-- Open URL under cursor
vim.keymap.set("n", "gx", function()
  vim.cmd("URLOpenUnderCursor")
end, { desc = "Open URL under cursor" })
