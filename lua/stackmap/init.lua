local M = {}

-- M.setup = function(opts)
--   print("Options:", opts)
-- end

-- functions we need:
-- - vim.keymap.set(...) --> create new keymaps
-- - nvim_get_keymap

local find_mapping = function(maps, lhs)
  for _, value in ipairs(maps) do
    if value.lhs == lhs then
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
      existing_maps[lhs] = existing
    end
  end

  for lhs, rhs in pairs(mappings) do
    -- TODO: need some way to pass options in here
    vim.keymap.set(mode, lhs, rhs)
  end

  M._stack[name] = {
    mode = mode,
    existing = existing_maps,
    mappings = mappings,
  }

end

M.pop = function(name)
  local state = M._stack[name]
  M._stack[name] = nil

  for lhs, rhs in pairs(state.mappings) do
    if state.existing[lhs] then
      -- handle mappings that existed
      local og_mapping = state.existing[lhs]

      -- TODO: Handle the options from the table
      vim.keymap.set(state.mode, lhs, og_mapping.rhs)
    else
      -- handle mappings that didn't exist
      vim.keymap.del(state.mode, lhs)
    end
  end
end

--[[
lua require("stackmap").push("debug_mode", "n", {
  [" st"] = "echo 'Hello'",
  [" sz"] = "echo 'Goodbye'",
})
...
push "debug"
push "other"
pop "debug"
pop "other
lua require("mapstack").pop("debug_mode")
]]

M._clear = function()
  M._stack = {}
end

return M
