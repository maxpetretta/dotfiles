return {
  {
    "reklai/canvasdiff.nvim",
    cmd = "CanvasDiff",
    keys = {
      { "<leader>rv", "<cmd>CanvasDiff<cr>", desc = "Review: CanvasDiff overview" },
    },
    opts = {
      keymaps = {
        global = { compare = false, checkout = false },
        -- Ctrl-Space is the tmux prefix; use a review key to return from source.
        file = { back = "<leader>rq" },
        -- Preserve Ctrl-N for the existing smart-splits pane navigation.
        canvas = { cycle_next = false },
      },
    },
  },
  {
    "martindur/zdiff.nvim",
    cmd = "Zdiff",
    keys = {
      { "<leader>rz", "<cmd>Zdiff<cr>", desc = "Review: Zdiff overview" },
    },
    opts = {
      default_expanded = true,
    },
  },
}
