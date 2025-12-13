local M = {}

function M.get_highlight(name)
  return vim.api.nvim_get_hl(0, { name = name })
end

function M.highlight(name, upd_val)
  local old_val = vim.api.nvim_get_hl(0, { name = name })
  local merged_val = vim.tbl_extend("force", old_val, upd_val)
  vim.api.nvim_set_hl(0, name, merged_val)
end

return M
