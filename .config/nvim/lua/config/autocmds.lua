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

-- Save current buffer when window loses focus
vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.modifiable and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.modified then
      vim.cmd("silent! write")
    end
  end,
})

-- Auto-close lazygit when opening a file from it
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local buftype = vim.bo.buftype
    local bufname = vim.api.nvim_buf_get_name(0)

    -- Only close lazygit if we're entering a normal file buffer (not terminal, not empty)
    if buftype == "" and bufname ~= "" and not bufname:match("term://") then
      vim.defer_fn(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_name = vim.api.nvim_buf_get_name(buf)
          -- Close any lazygit terminal windows
          if vim.bo[buf].buftype == "terminal" and buf_name:match("lazygit") then
            vim.api.nvim_win_close(win, true)
            break
          end
        end
      end, 100)
    end
  end,
})
