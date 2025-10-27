return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files by default
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false, -- Only works on Windows for hidden files/directories
        hide_by_name = { ".git", ".turbo", "dist", "node_modules" },
        never_show = { ".DS_Store" },
      },
    },
  },
}
