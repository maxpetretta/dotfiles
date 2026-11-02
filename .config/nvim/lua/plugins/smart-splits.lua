return {
  "mrjones2014/smart-splits.nvim",
  event = "VeryLazy",
  opts = {
    default_amount = 5,
    ignored_filetypes = { "neo-tree", "neo-tree-popup", "neo-tree-preview" },
    -- Inside Rex, use the backend in lua/smart-splits/mux/rex.lua; elsewhere auto-detect (tmux)
    multiplexer_integration = (vim.env.REX_BLOCK and not vim.env.TMUX) and "rex" or nil,
  },
}
