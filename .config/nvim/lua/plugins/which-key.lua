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
      -- since legendary.nvim handles all your keymaps/commands,
      -- its recommended to load legendary.nvim before other plugins
      -- priority = 10000,
      -- lazy = false,
      -- sqlite is only needed if you want to use frecency sorting
      dependencies = { "kkharji/sqlite.lua" },
      opts = {
        extensions = {
          smart_splits = true,
          lazy_nvim = { auto_register = true },
          which_key = { auto_register = true },
        },
      },
      keys = {
        { "<leader>k", "<cmd>Legendary<cr>", desc = "Show All Commands" },
        -- { "<leader>k", "", desc = "commands" },
        -- { "<leader>ka", "<cmd>Legendary autocmds<cr>", desc = "Show Autocmds" },
        -- { "<leader>kc", "<cmd>Legendary commands<cr>", desc = "Show Commands" },
        -- { "<leader>kf", "<cmd>Legendary functions<cr>", desc = "Show Functions" },
        -- { "<leader>km", "<cmd>Legendary keymaps<cr>", desc = "Show Keymaps" },
      },
    },
  },
}
