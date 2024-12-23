return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    highlight = {
      set_custom_captures = {
        ["@keyword.overrides"] = "@keyword.function",
        ["@operator.overrides"] = "@keyword.conditional",
      },
    },
  },
}
