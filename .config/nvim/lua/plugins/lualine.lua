local function get_short_cwd()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",

  -- SOURCE: https://www.lazyvim.org/plugins/ui#lualinenvim
  opts = function()
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = require("lazyvim.config").icons
    local colors = require("monokai-pro.colorscheme")
    vim.o.laststatus = vim.g.lualine_laststatus

    local theme = {
      normal = {
        a = { bg = colors.base.green, fg = colors.base.black, gui = "bold" },
        b = { bg = colors.base.black, fg = colors.base.white },
        c = { bg = colors.base.black, fg = colors.base.white },
        x = { bg = colors.base.black, fg = colors.base.green },
        y = { bg = colors.base.black, fg = colors.base.green },
      },
      insert = {
        a = { bg = colors.base.yellow, fg = colors.base.black, gui = "bold" },
        x = { bg = colors.base.black, fg = colors.base.yellow },
        y = { bg = colors.base.black, fg = colors.base.yellow },
      },
      command = {
        a = { bg = colors.base.blue, fg = colors.base.black, gui = "bold" },
        x = { bg = colors.base.black, fg = colors.base.blue },
        y = { bg = colors.base.black, fg = colors.base.blue },
      },
      visual = {
        a = { bg = colors.base.magenta, fg = colors.base.black, gui = "bold" },
        x = { bg = colors.base.black, fg = colors.base.magenta },
        y = { bg = colors.base.black, fg = colors.base.magenta },
      },
      replace = {
        a = { bg = colors.base.red, fg = colors.base.black, gui = "bold" },
        x = { bg = colors.base.black, fg = colors.base.red },
        y = { bg = colors.base.black, fg = colors.base.red },
      },
      inactive = {
        a = { bg = colors.base.black, fg = colors.base.yellow, gui = "bold" },
      },
    }

    return {
      options = {
        theme = theme,
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = { { "mode", padding = { left = 1, right = 1 }, separator = { left = "" } } },
        lualine_b = {
          {
            "branch",
            icon = { "", color = { fg = colors.base.white } },
            color = { fg = colors.base.white, bg = colors.base.dimmed4 },
            separator = { right = "" },
          },
        },
        lualine_c = {
          { "filetype", colored = false, icon_only = true, padding = { left = 1, right = 0 } },
          LazyVim.lualine.root_dir({
            icon = "",
            color = { fg = colors.base.white, bg = colors.base.black },
            padding = { left = 0, right = 0 },
          }),
          { LazyVim.lualine.pretty_path({ color = { fg = colors.base.white, bg = colors.base.black } }) },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_x = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
          },
          -- Copilot status
          -- {
          --   function()
          --     local icon = LazyVim.config.icons.kinds.Copilot
          --     local status = require("copilot.api").status.data
          --     return icon .. (status.message or "")
          --   end,
          --   cond = function()
          --     if not package.loaded["copilot"] then
          --       return
          --     end
          --     local ok, clients = pcall(LazyVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
          --     if not ok then
          --       return false
          --     end
          --     return ok and #clients > 0
          --   end,
          --   color = function()
          --     if not package.loaded["copilot"] then
          --       return
          --     end
          --     local status = require("copilot.api").status.data
          --     local status_colors = {
          --       [""] = { fg = colors.base.green, bg = colors.base.black },
          --       ["Normal"] = { fg = colors.base.green, bg = colors.base.black },
          --       ["Warning"] = { fg = colors.base.red, bg = colors.base.black },
          --       ["InProgress"] = { fg = colors.base.cyan, bg = colors.base.black },
          --     }
          --     return status_colors[status.status] or status_colors[""]
          --   end,
          -- },
        },
        lualine_y = {
          -- stylua: ignore
          {
            function()
              local cmd = require("noice").api.status.command.get()
              -- Append a space if the string is only one character
              if #cmd == 1 then
                -- Center a single character in three spaces: " x "
                cmd = " " .. cmd .. " "
              elseif #cmd == 2 then
                -- If two characters, prepend one space: " xy"
                cmd = " " .. cmd
              end
              return cmd
            end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = { bg = colors.base.dimmed4, fg = colors.base.white },
            padding = { left = 1, right = 1 },
            separator = { left = "" },
          },
          {
            "progress",
            color = { fg = colors.base.white, bg = colors.base.dimmed4 },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_z = {
          {
            "location",
            padding = { left = 1, right = 1 },
            separator = { right = "" },
          },
        },
      },
      extensions = {
        "lazy",
        {
          filetypes = { "neo-tree" },
          sections = {
            lualine_a = {
              {
                get_short_cwd,
                padding = { left = 1, right = 1 },
                separator = { left = "", right = "" },
              },
            },
          },
        },
      },
    }
  end,
}
