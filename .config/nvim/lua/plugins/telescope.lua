return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader><space>",
      LazyVim.pick("find_files", {
        root = false,
        hidden = true,
      }),
      desc = "Find Files (cwd)",
    },
    {
      "<leader>/",
      LazyVim.pick("live_grep", {
        root = false,
        hidden = true,
      }),
      desc = "Grep (cwd)",
    },
  },
}
