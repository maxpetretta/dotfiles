-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.list = false
vim.opt.scrolloff = 9
vim.g.ai_cmp = false -- Disable Copilot suggestions as a cmp source

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

-- Expand "cc" to "CodeCompanion"
vim.cmd([[cab cc CodeCompanion]])

-- Set .example filetypes
vim.filetype.add({
  extension = {
    example = "conf",
    vars = "conf",
  },
})

-- Flash highlights for VSCode
if vim.g.vscode then
  vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#727072" })
  vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#ffd866", fg = "#221f22", bold = true })
  vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#4d494c", fg = "#c8d3f5" })
  vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#4d494c", fg = "#727072" })
end
