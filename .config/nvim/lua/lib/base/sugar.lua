local M = {}

M.fallback = function(action, args, default)
  local ok, result = pcall(action, unpack(args or {}))
  return ok and result or default
end

M.require_or = function(module, default)
  return M.fallback(require, { module }, default)
end

return M
