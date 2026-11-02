-- smart-splits.nvim backend for Rex (https://www.superlogical.com/rex).
-- Enabled from plugins/smart-splits.lua with multiplexer_integration = "rex".
-- Resizing goes through the resize_block action in ~/.config/rex/init.lua.
local Direction = require("smart-splits.types").Direction

local split_keys = {
  [Direction.left] = "left",
  [Direction.right] = "right",
  [Direction.up] = "above",
  [Direction.down] = "below",
}

local function rex_bin()
  local bin = vim.fn.exepath("rex")
  if bin == "" then
    bin = "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex"
  end
  return bin
end

local function rex(args)
  local cmd = { rex_bin() }
  vim.list_extend(cmd, args)
  local result = vim.system(cmd, { text = true }):wait()
  return result.code == 0, result.stdout or ""
end

local function rex_json(args)
  local ok, out = rex(args)
  if not ok or out == "" then
    return nil
  end
  local decoded_ok, decoded = pcall(vim.json.decode, out)
  return decoded_ok and decoded or nil
end

local function find_leaf(node, block_id)
  if node.block_id == block_id then
    return node
  end
  if node.split then
    return find_leaf(node.split.before, block_id) or find_leaf(node.split.after, block_id)
  end
end

---@type SmartSplitsMultiplexer
local M = {} ---@diagnostic disable-line: missing-fields

M.type = "rex"

function M.is_in_session()
  return vim.env.REX_BLOCK ~= nil and vim.env.REX_SESSION ~= nil
end

function M.current_pane_id()
  local view = rex_json({ "session", "inspect", vim.env.REX_SESSION, "--json" })
  if not view then
    return nil
  end
  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      return window.focused_block_id
    end
  end
end

function M.current_pane_at_edge(direction)
  local view = rex_json({ "session", "inspect", vim.env.REX_SESSION, "--json" })
  for _, window in ipairs(view and view.windows or {}) do
    local layer = window.layers and window.layers[1]
    local leaf = layer and layer.layout and find_leaf(layer.layout, vim.env.REX_BLOCK)
    if leaf then
      local x, y, w, h = unpack(leaf.rect)
      local eps = 1e-6
      if direction == Direction.left then
        return x <= eps
      elseif direction == Direction.right then
        return x + w >= 1 - eps
      elseif direction == Direction.up then
        return y <= eps
      else
        return y + h >= 1 - eps
      end
    end
  end
  return false
end

function M.current_pane_is_zoomed()
  return false
end

function M.next_pane(direction)
  return rex({ "focus", "-s", vim.env.REX_SESSION, direction })
end

function M.resize_pane(direction, amount)
  local result = rex_json({
    "do",
    "resize_block",
    "-s",
    vim.env.REX_SESSION,
    "direction=" .. direction,
    "amount=" .. tostring(amount),
    "block_id=" .. vim.env.REX_BLOCK,
  })
  return result ~= nil and result.changed == true
end

function M.split_pane(direction, _size) ---@diagnostic disable-line: unused-local
  return rex({ "split", "-s", vim.env.REX_SESSION, "-b", vim.env.REX_BLOCK, "--split=" .. split_keys[direction] })
end

function M.update_mux_layout_details() end

return M
