local lib = require("lib.main")

local private = lib.require_or("private.database", { itr_configs = {}, my_db_pass = "def" })

local M = {}

local user = vim.env.USER
local my_pass = private.my_db_pass

M.local_configs = {
  { name = "sok_local", url = "postgres://" .. user .. ":" .. my_pass .. "@localhost:5432/sok" },
  { name = "lms_local", url = "postgres://" .. user .. ":" .. my_pass .. "@localhost:5432/lms" },
  { name = "itr_local", url = "mysql://" .. user .. ":" .. my_pass .. "@localhost:3306/itrapi" },
  { name = "wb_local", url = "postgres://" .. user .. ":" .. my_pass .. "@localhost:5432/wb" },
}

M.local_configs = vim.tbl_extend("force", M.local_configs, private.itr_configs)

return M
