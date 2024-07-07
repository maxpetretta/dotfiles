return {
  "sontungexpt/url-open",
  event = "VeryLazy",
  cmd = "URLOpenUnderCursor",
  opts = {
    open_only_when_cursor_on_url = true,
    highlight_url = {
      all_urls = { enabled = false },
      cursor_move = { enabled = true, fg = "#78DCE8" },
    },
  },
}
