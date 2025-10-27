local js = {
  left = 'console.log("',
  right = '")',
  mid_var = '", ',
  right_var = ")",
  find_treesitter_variable = function(opts)
    if opts.node:type() == "property_identifier" then
      return opts.get_node_text(opts.node:parent())
    elseif opts.node:type() == "identifier" then
      return opts.get_node_text(opts.node)
    else
      return nil
    end
  end,
}

return {
  "maxpetretta/debugprint.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-mini/mini.nvim", -- Needed to enable :ToggleCommentDebugPrints for NeoVim 0.9
  },
  opts = {
    print_tag = "🪵",
    display_counter = false,
    filetypes = {
      ["javascript"] = js,
      ["javascriptreact"] = js,
      ["typescript"] = js,
      ["typescriptreact"] = js,
    },
    keymaps = {
      normal = {
        plain_below = "glp",
        plain_above = "glP",
        variable_below = "glv",
        variable_above = "glV",
        variable_below_alwaysprompt = nil,
        variable_above_alwaysprompt = nil,
        textobj_below = "glo",
        textobj_above = "glO",
        toggle_comment_debug_prints = "glc",
        delete_debug_prints = "gld",
      },
      visual = {
        variable_below = "glv",
        variable_above = "glV",
      },
    },
    commands = {
      toggle_comment_debug_prints = "ToggleCommentDebugPrints",
      delete_debug_prints = "DeleteDebugPrints",
    },
  },
  -- The 'keys' and 'cmds' sections of this configuration are only needed if
  -- you want to take advantage of `lazy.nvim` lazy-loading.
  cmd = {
    "ToggleCommentDebugPrints",
    "DeleteDebugPrints",
  },
  keys = {
    { "gl", "", desc = "+logging", mode = "n" },
    { "glp", mode = "n" },
    { "glP", mode = "n" },
    { "glv", mode = "n" },
    { "glV", mode = "n" },
    { "glo", mode = "n" },
    { "glO", mode = "n" },
    { "glc", mode = "n" },
    { "gld", mode = "n" },
    { "glv", mode = "x" },
    { "glV", mode = "x" },
  },
  version = "*",
}
