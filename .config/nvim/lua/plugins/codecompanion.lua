return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
  },
  opts = {
    display = {
      action_palette = {
        provider = "default",
      },
      chat = {
        window = {
          width = 0.4,
        },
      },
      diff = {
        provider = "mini_diff",
      },
    },
    strategies = {
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
      },
      cmd = {
        adapter = "anthropic",
      },
    },
  },
  keys = {
    {
      "<leader>a",
      "<cmd>CodeCompanionChat Toggle<cr>",
      desc = "Code Companion Chat",
      mode = { "n", "v" },
      noremap = true,
      silent = true,
    },
    {
      "<leader>a",
      "<cmd>'<,'>CodeCompanion<cr>",
      desc = "Code Companion Inline",
      mode = { "v" },
      noremap = true,
      silent = true,
    },
    {
      "<C-a>",
      "<cmd>CodeCompanionActions<cr>",
      desc = "Code Companion Actions",
      mode = { "n", "v" },
      noremap = true,
      silent = true,
    },
    {
      "ga",
      "<cmd>CodeCompanionChat Add<cr>",
      desc = "Code Companion Add",
      mode = { "v" },
      noremap = true,
      silent = true,
    },
  },
}
