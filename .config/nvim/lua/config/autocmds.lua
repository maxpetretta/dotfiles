-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Disable auto comment insertion
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- Add missing imports, remove unused imports, and format imports on save (TypeScript)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.ts,*.tsx",
  callback = function()
    LazyVim.lsp.action["source.addMissingImports.ts"]()
    LazyVim.lsp.action["source.removeUnused.ts"]()
    -- TODO: Conditionally run this based on the presence of a Biome server
    LazyVim.lsp.action["source.organizeImports.biome"]()
  end,
})
