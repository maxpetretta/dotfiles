return {
  "saghen/blink.cmp",
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "codecompanion" },
      per_filetype = {
        codecompanion = { "codecompanion" },
      },
      providers = {
        codecompanion = {
          name = "CodeCompanion",
          module = "codecompanion.providers.completion.blink",
        },
      },
    },
  },
}
