return {
  "loctvl842/monokai-pro.nvim",
  opts = {
    terminal_colors = false,
    override = function(c)
      return {
        BlinkCmpGhostText = { fg = c.base.dimmed2 }, -- copilot suggestions
        MiniIconsAzure = {}, -- Fixes crash w/ mini.nvim
        MiniIconsGreen = {},
        MiniIconsGrey = {},
        MiniIconsOrange = {},
        NoiceCmdlineIcon = { fg = c.base.green }, -- Cmdline ">"
        NoiceCmdlinePopupTitle = { fg = c.base.green }, -- Cmdline title
        SnacksIndent = { fg = c.base.dimmed5 }, -- indent guides
        SnacksIndentScope = { fg = c.base.green }, -- active indent
        StatusLine = { bg = "#2C2A2E" }, -- statusline background
        WinSeparator = { fg = c.base.dimmed3 }, -- split border
        Structure = { italic = false }, -- interface identifiers
        ["@keyword.function"] = { bold = false }, -- "function"
        ["@keyword.overrides"] = { fg = c.base.cyan, italic = true }, -- custom capture group for "const", "let", "type"
        ["@keyword.type"] = { fg = c.base.cyan, italic = true }, -- "interface"
        ["@keyword"] = { fg = c.base.red, italic = false }, -- "if", "else", "for", "while"
        ["@lsp.type.enumMember"] = { fg = c.base.white }, -- enums
        ["@lsp.typemod.function.defaultLibrary"] = { fg = c.base.green }, -- global functions
        ["@lsp.typemod.variable.defaultLibrary"] = { fg = c.base.white }, -- global objects
        ["@lsp.typemod.variable.readonly"] = { fg = c.base.white }, -- constant identifiers
        ["@punctuation.bracket"] = { fg = c.base.dimmed2 }, -- brackets
        ["@tag.builtin"] = { fg = c.base.red }, -- HTML tags
        ["@type"] = { fg = c.base.white }, -- imported objects
        ["@variable.member"] = { fg = c.base.white }, -- object properties
      }
    end,
  },
}
