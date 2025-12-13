local state = require("state")
local tables = require("lib.base.table")

local M = {}

function M.cache(keyseq, action, args)
  local value = tables.geget(state.cache, keyseq)
  if value == nil then
    value = action(unpack(args or {}))
    tables.seset(state.cache, keyseq, value)
  end
  return value
end

return M
