local consts = require("consts")
local files = require("lib.file")
local state = require("state")
local tables = require("lib.base.table")

local M = {}

M.reload_local_config = function()
  local local_config_path = files.backward_file_search_c(consts.LOCAL_CONFIG_FILE)
  if local_config_path then
    state.local_config = dofile(local_config_path)
  end
end

M.local_config_or = function(local_keyseq, global_value, opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, { reload = true })
  if opts.reload then
    M.reload_local_config()
  end

  return tables.geget(state.local_config, local_keyseq) or global_value
end

(function()
  M.reload_local_config()
end)()

return M
