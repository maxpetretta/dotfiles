-- File watcher to auto-open externally modified files
-- Useful when Claude Code is modifying files in another terminal tab

local M = {}
local uv = vim.loop
local watchers = {}
local debounce_timers = {}
local has_focus = true -- Track whether Neovim has focus

-- Debounce file changes to avoid opening the same file multiple times
local function debounce_open_file(filepath, delay)
  delay = delay or 500 -- 500ms debounce

  -- Cancel existing timer for this file
  if debounce_timers[filepath] then
    debounce_timers[filepath]:stop()
    debounce_timers[filepath]:close()
  end

  -- Create new timer
  local timer = uv.new_timer()
  debounce_timers[filepath] = timer

  timer:start(delay, 0, function()
    vim.schedule(function()
      -- Only auto-open if Neovim doesn't have focus (external change)
      if has_focus then
        return
      end

      -- Check if file exists
      local stat = uv.fs_stat(filepath)
      if stat and stat.type == "file" then
        local relative_path = vim.fn.fnamemodify(filepath, ":~:.")
        vim.notify("File modified: " .. relative_path, vim.log.levels.INFO)

        -- Open the file
        vim.cmd("edit " .. vim.fn.fnameescape(filepath))

        -- Try to jump to the first changed line
        vim.defer_fn(function()
          -- Run git diff to find changed lines
          local diff_output = vim.fn.system("git diff --unified=0 " .. vim.fn.shellescape(filepath))

          -- Parse diff output to find first changed line number
          -- Look for pattern: @@ -X,Y +A,B @@ where A is the new line number
          for line in diff_output:gmatch("[^\r\n]+") do
            local new_line = line:match("@@ %-%d+,?%d* %+(%d+),?%d* @@")
            if new_line then
              local target_line = tonumber(new_line)
              vim.api.nvim_win_set_cursor(0, {target_line, 0})
              vim.cmd("normal! zz") -- Center the line in the window
              break
            end
          end
        end, 50)
      end
    end)
    timer:stop()
    timer:close()
    debounce_timers[filepath] = nil
  end)
end

-- Check if a directory is a git repository
local function is_git_repo(dir)
  local git_dir = dir .. "/.git"
  local stat = uv.fs_stat(git_dir)
  return stat ~= nil
end

function M.watch_directory(dir)
  -- Don't watch if already watching
  if watchers[dir] then
    return
  end

  -- Only watch if this is a git repository
  if not is_git_repo(dir) then
    return
  end

  local handle = uv.new_fs_event()
  watchers[dir] = handle

  handle:start(dir, { recursive = true }, function(err, filename, events)
    if err then
      vim.schedule(function()
        vim.notify("File watcher error: " .. err, vim.log.levels.ERROR)
      end)
      return
    end

    if filename then
      local filepath = dir .. "/" .. filename

      -- Only watch relevant files (skip common ignore patterns)
      if not filename:match("%.git/")
        and not filename:match("node_modules/")
        and not filename:match("%.DS_Store")
        and not filename:match("%.swp$")
        and not filename:match("%.swo$")
        and not filename:match("~$") then

        -- Check if it's a file modification
        if events.change or events.rename then
          debounce_open_file(filepath)
        end
      end
    end
  end)
end

function M.setup()
  -- Watch the current working directory
  local cwd = vim.fn.getcwd()
  M.watch_directory(cwd)

  -- Update watcher when changing directories
  vim.api.nvim_create_autocmd("DirChanged", {
    group = vim.api.nvim_create_augroup("FileWatcherDirChange", { clear = true }),
    callback = function()
      -- Stop all existing watchers
      for _, handle in pairs(watchers) do
        if not handle:is_closing() then
          handle:stop()
          handle:close()
        end
      end
      watchers = {}

      -- Start watching new directory
      local new_cwd = vim.fn.getcwd()
      M.watch_directory(new_cwd)
    end,
  })

  -- Track focus state and reload files when gaining focus
  vim.api.nvim_create_autocmd("FocusGained", {
    group = vim.api.nvim_create_augroup("FileWatcherFocus", { clear = true }),
    pattern = "*",
    callback = function()
      has_focus = true
      vim.cmd("checktime")
    end,
  })

  vim.api.nvim_create_autocmd("FocusLost", {
    group = vim.api.nvim_create_augroup("FileWatcherFocusLost", { clear = true }),
    pattern = "*",
    callback = function()
      has_focus = false
    end,
  })
end

return M
