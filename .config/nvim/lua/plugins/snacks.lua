return {
  "folke/snacks.nvim",
  opts = {
    lazygit = {
      win = {
        position = "float",
      },
      configure = false,  -- disable auto-theming, use global lazygit config only
      config = {
        os = {
          edit = "nvr --remote {{filename}}",
          editAtLine = "nvr --remote +{{line}} {{filename}}",
          editAtLineAndWait = "nvr --remote-wait +{{line}} {{filename}}",
          editInTerminal = false,
        },
      },
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
