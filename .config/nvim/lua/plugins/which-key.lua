return {
  "folke/which-key.nvim",
  opts = {
    preset = "helix",
    spec = {
      -- Disable debug keymap group
      { "<leader>d", group = false },
      { "<leader>dp", group = true },
      { "<leader>dpp", hidden = true },
      { "<leader>dps", hidden = true },
      { "<leader>dph", hidden = true },
    },
  },
  dependencies = {
    {
      "mrjones2014/legendary.nvim",
      dependencies = { "kkharji/sqlite.lua" },
      opts = {
        extensions = {
          smart_splits = true,
          codecompanion = true,
          lazy_nvim = { auto_register = true },
          which_key = { auto_register = true },
        },
      },
      keys = {
        { "<leader>k", "<cmd>Legendary<cr>", desc = "Show All Commands" },
      },
    },
  },
}
