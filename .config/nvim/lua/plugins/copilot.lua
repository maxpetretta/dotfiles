return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  opts = {
    panel = { enabled = false },
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<C-y>",
        next = "<C-n>",
        prev = "<C-p>",
        dismiss = "<C-e>",
      },
    },
  },
}
