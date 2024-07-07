return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader><space>",
      LazyVim.pick("find_files", {
        root = false,
      }),
      desc = "Find Files (cwd)",
    },
    {
      "<leader>/",
      LazyVim.pick("live_grep", {
        root = false,
      }),
      desc = "Grep (cwd)",
    },
  },
}
