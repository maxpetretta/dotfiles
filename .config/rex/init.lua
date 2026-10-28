-- Ported from ~/.config/ghostty/config and ~/.tmux.conf

local terminal = "com.superlogical.terminal"
local editors = { nvim = true, vim = true }

-- Whether the focused pane is running Neovim, which handles these keys itself
-- via smart-splits.nvim and hands off to Rex at the edge of its own splits
-- (~/.config/nvim/lua/smart-splits/mux/rex.lua)
local function pane_is_vim(ctx)
  local proc = rex.block.call(terminal, "process", { block_id = ctx.block_id })
  local fg = proc and proc.foreground
  return fg ~= nil and editors[fg.name] == true
end

-- Focus panes: ctrl + hjkl (QWERTY) and neio (Colemak), passed through to Neovim
local focus = {
  h = "left", j = "down", k = "up", l = "right",
  n = "left", e = "down", i = "up", o = "right",
}
for key, direction in pairs(focus) do
  rex.bind("ctrl+" .. key, function(ctx, ev)
    if pane_is_vim(ctx) then
      return false
    end
    rex.session.focus_direction{ direction = direction }
    return true
  end)
end

-- Path from the layout root to a block's leaf, as { node, side } steps
local function layout_path(node, block_id, path)
  if node.block_id == block_id then
    return path, node
  end
  if node.split then
    for _, side in ipairs({ "before", "after" }) do
      path[#path + 1] = { node = node, side = side }
      local found, leaf = layout_path(node.split[side], block_id, path)
      if found then
        return found, leaf
      end
      path[#path] = nil
    end
  end
end

local function first_block(node)
  while node.split do
    node = node.split.before
  end
  return node.block_id
end

-- Resize like tmux's resize-pane: move the nearest divider in `direction` by
-- `amount` cells. Runs on the server, so Neovim (smart-splits) can call it with
-- `rex do resize_block` when it has no split of its own to resize.
rex.action{
  name  = "resize_block",
  title = "Resize Pane by Cells",
  args  = { direction = "string", amount = "number?", block_id = "string?" },
  run   = function(ctx, args)
    local block_id = args.block_id or ctx.block_id
    local horizontal = args.direction == "left" or args.direction == "right"
    local orientation = horizontal and "horizontal" or "vertical"

    local view, err = rex.session.view{}
    if not view then error(err, 0) end
    for _, window in ipairs(view.windows or {}) do
      local layout = window.layers and window.layers[1] and window.layers[1].layout
      local path, leaf
      if layout then
        path, leaf = layout_path(layout, block_id, {})
      end
      if path then
        for i = #path, 1, -1 do
          local node = path[i].node
          if node.split.direction == orientation then
            local size = rex.block.call(terminal, "size", { block_id = block_id })
            local axis = horizontal and 3 or 4
            local cells = (horizontal and size.columns or size.rows) / leaf.rect[axis]
            local delta = (args.amount or 5) / (cells * node.rect[axis])
            if args.direction == "left" or args.direction == "up" then
              delta = -delta
            end
            local ratio = math.min(math.max(node.split.ratio + delta, 0.05), 0.95)
            local _, rerr = rex.session.resize_pane{
              direction = orientation,
              before_block_id = first_block(node.split.before),
              after_block_id = first_block(node.split.after),
              ratio = ratio,
            }
            if rerr then error(rerr, 0) end
            return { changed = true }
          end
        end
        return { changed = false }
      end
    end
    return { changed = false }
  end,
}

-- Resize panes: ctrl + arrows, passed through to Neovim (smart-splits resizes its
-- splits, then calls resize_block at its edge); ctrl+shift + arrows always resize
-- the Rex pane, even when it holds Neovim
for _, direction in ipairs({ "left", "down", "up", "right" }) do
  rex.bind("ctrl+" .. direction, function(ctx, ev)
    if pane_is_vim(ctx) then
      return false
    end
    rex.invoke("resize_block", { direction = direction, block_id = ctx.block_id })
    return true
  end)
  rex.bind("ctrl+shift+" .. direction, "pane.resize", { direction = direction })
end

rex.bind("ctrl+z", "pane.zoom")
rex.bind("ctrl+shift+r", "client.config.reload")

-- Shift+Enter sends ESC+CR so agents insert a newline (Ghostty: text:\x1b\r)
rex.bind("shift+enter", function(ctx, ev)
  rex.block.call(terminal, "write", {
    block_id = ctx.block_id,
    data = "\27\r",
  })
  return true
end)
