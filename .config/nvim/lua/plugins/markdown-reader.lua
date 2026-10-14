-- Keep ordinary Markdown editing raw; reader mode restores the previous state.
local render_was_enabled

local function toggle_reader()
  if not vim.bo.filetype:match("^markdown") then
    vim.notify("Markdown reader mode requires a Markdown buffer", vim.log.levels.INFO)
    return
  end
  require("zen-mode").toggle()
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      enabled = false,
      anti_conceal = { enabled = false },
      heading = { sign = false, width = "block" },
      code = { sign = false, width = "block" },
    },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>mr", toggle_reader, desc = "Markdown Reader", ft = { "markdown", "markdown.mdx" } },
    },
    init = function()
      vim.api.nvim_create_user_command("MarkdownReader", toggle_reader, { desc = "Toggle Markdown reader mode" })
    end,
    opts = {
      window = {
        width = 85,
        options = {
          wrap = true,
          linebreak = true,
          breakindent = true,
          number = false,
          relativenumber = false,
          signcolumn = "no",
          foldcolumn = "0",
          cursorline = false,
          list = false,
          colorcolumn = "",
        },
      },
      plugins = { twilight = { enabled = false } },
      on_open = function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype:match("^markdown") then
          local render = require("render-markdown")
          render_was_enabled = render.get()
          render.enable()
        end
      end,
      on_close = function()
        if render_was_enabled ~= nil then
          require("render-markdown").set(render_was_enabled)
          render_was_enabled = nil
        end
      end,
    },
  },
}
