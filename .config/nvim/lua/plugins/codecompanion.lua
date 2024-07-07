return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- Optional
    {
      "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
      opts = {},
    },
  },
  -- config = function()
  --   vim.cmd([[cab cc CodeCompanion]])
  -- end,
  opts = function(_, opts)
    opts.adapters = {
      openai = require("codecompanion.adapters").use("openai", {
        env = {
          api_key = "cmd:op read op://Personal/li35cesolop4poff7edtccrwyi/credential --no-newline",
        },
      }),
    }
    opts.display = {
      chat = {
        window = {
          width = 0.4,
        },
      },
    }
  end,
  keys = {
    { "<leader>a", "", desc = "ai", mode = { "n", "v" } },
    {
      "<leader>ac",
      "<cmd>CodeCompanionToggle<cr>",
      desc = "Code Companion Chat",
      mode = { "n", "v" },
      noremap = true,
      silent = true,
    },
    {
      "<leader>aa",
      "<cmd>CodeCompanionActions<cr>",
      desc = "Code Companion Actions",
      mode = { "n", "v" },
      noremap = true,
      silent = true,
    },
    { "ga", "<cmd>CodeCompanionAdd<cr>", desc = "Code Companion Add", mode = { "v" }, noremap = true, silent = true },
  },
}
