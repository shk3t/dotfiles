local M = {}

---@param name string
function M.get_highlight(name)
  return vim.api.nvim_get_hl(0, { name = name })
end

---@param name string
---@param upd_val vim.api.keyset.highlight
---@param ns_id? integer
function M.highlight(name, upd_val, ns_id)
  ns_id = ns_id or 0
  local old_val = vim.api.nvim_get_hl(0, { name = name })
  local merged_val = vim.tbl_extend("force", old_val, upd_val)
  vim.api.nvim_set_hl(ns_id, name, merged_val)
end

return M
