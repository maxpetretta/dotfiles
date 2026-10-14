-- Agent review: the git index is the "reviewed" checkpoint. Agents write to the
-- working tree; stage a hunk to accept it, discard it to reject it.
return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    opts = {
      highlights = {
        -- DiffAdd/DiffDelete are fg-only in the monokai overrides, so give the
        -- line backgrounds explicit colours (same 21% tints as MiniDiffOver*)
        line_insert = "#3D3F37",
        line_delete = "#463139",
      },
      explorer = {
        auto_refresh = true, -- pick up agent writes as they land
      },
    },
  },
  {
    "georgeguimaraes/review.nvim",
    version = "*",
    dependencies = {
      "esmuellert/codediff.nvim",
      "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
    keys = {
      { "<leader>r", "", desc = "+review" },
      { "<leader>rr", "<cmd>Review<cr>", desc = "Review working tree" },
      { "<leader>rc", "<cmd>Review commits<cr>", desc = "Review commits" },
      { "<leader>rb", "<cmd>Review branch<cr>", desc = "Review branch" },
      { "<leader>rn", ":Review note<cr>", mode = { "n", "v" }, desc = "Review: note here" },
      { "<leader>re", "<cmd>Review edit<cr>", desc = "Review: edit comment" },
      { "<leader>rd", "<cmd>Review delete<cr>", desc = "Review: delete comment" },
      { "<leader>rx", "<cmd>Review export<cr>", desc = "Review: export" },
    },
    opts = {},
  },
}
