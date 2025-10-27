-- return {
--   "neovim/nvim-lspconfig",
--   opts = {
--     servers = {
--       vtsls = {
--         root_dir = require("lspconfig.util").root_pattern(".git", "tsconfig.json", "jsconfig.json", "package.json"),
--         settings = {
--           tsserver = {
--             maxTsServerMemory = 8192,
--           },
--           vtsls = {
--             experimental = {
--               maxInlayHintLength = 25,
--             },
--           },
--         },
--       },
--     },
--   },
-- }
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tsserver = { enabled = false },
      vtsls = { enabled = false },
      tsgo = {
        cmd = { "tsgo", "--lsp", "--stdio" },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        root_markers = {
          ".git",
          "tsconfig.base.json",
          "tsconfig.json",
          "jsconfig.json",
          "package.json",
        },
        enabled = true,
      },
    },
  },
}
