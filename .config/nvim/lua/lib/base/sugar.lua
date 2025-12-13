local M = {}

function M.fallback(action, args, default)
  local ok, result = pcall(action, unpack(args or {}))
  return ok and result or default
end

function M.require_or(module, default)
  return M.fallback(require, { module }, default)
end

return M
