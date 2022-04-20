local M = {}

M.setup = function(opts)
  print("Options:", opts)
end

-- functions we need:
-- - vim.keymap.set(...) --> create new keymaps
-- - nvim_get_keymap

-- vim.api

local find_mapping = function(maps, lhs)
  for _, value in pairs(maps) do
    if value.lhs == lhs then
      print("Found mapping:", lhs, P(value))
      return value
    end
  end
end

M._stack = {}

M.push = function(name, mode, mappings)
  local maps = vim.api.nvim_get_keymap(mode)

  local existing_maps = {}
  for lhs, rhs in pairs(mappings) do
    local existing = find_mapping(maps, lhs)
    if existing then
      table.insert(existing_maps, existing)
    end
  end

  M._stack[name] = existing_maps

  for lhs, rhs in pairs(mappings) do
    -- TODO: need some way to pass options in here
    vim.keymap.set(mode, lhs, rhs)
  end
end

M.pop = function(name)
end

M.push("debug_mode", "n", {
  [" st"] = "echo 'Hello'",
  [" sz"] = "echo 'Goodbye'",
})
--[[
lua require("stackmap").push("debug_mode", "n", {
  [",t"] = "echo 'Hello'",
  [",sz"] = "echo 'Hello'",
})
]]

return M
