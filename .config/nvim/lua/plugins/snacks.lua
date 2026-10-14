return {
  "folke/snacks.nvim",
  opts = {
    lazygit = {
      win = {
        position = "float",
      },
      configure = false,  -- disable auto-theming, use global lazygit config only
    },
    terminal = {
      win = {
        position = "float",
        style = "terminal",
        wo = {
          winbar = "",
          winhighlight = "Normal:Normal,NormalFloat:Normal",
        },
      },
    },
  },
}
