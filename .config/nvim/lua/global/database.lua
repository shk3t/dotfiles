local ulib = require("lib.utils")
local tlib = require("lib.base.table")

local private = ulib.require_or("private.database", { itr_configs = {}, my_db_pass = "def" })

local M = {}

local user = vim.env.USER
local my_pass = private.my_db_pass

M.local_configs = {
  { name = "azazon_auth", url = "postgres://" .. user .. ":" .. my_pass .. "@0.0.0.0:5432/azazon_auth" },
  { name = "azazon_order", url = "postgres://" .. user .. ":" .. my_pass .. "@0.0.0.0:5432/azazon_order" },
  { name = "azazon_stock", url = "postgres://" .. user .. ":" .. my_pass .. "@0.0.0.0:5432/azazon_stock" },
  { name = "azazon_payment", url = "postgres://" .. user .. ":" .. my_pass .. "@0.0.0.0:5432/azazon_payment" },

  { name = "sok_local", url = "postgres://" .. user .. ":" .. my_pass .. "@0.0.0.0:5432/sok" },
  { name = "lms_local", url = "postgres://" .. user .. ":" .. my_pass .. "@0.0.0.0:5432/lms" },
  { name = "itr_local", url = "mysql://" .. user .. ":" .. my_pass .. "@0.0.0.0:3306/itrapi" },
  { name = "wb_local", url = "postgres://" .. user .. ":" .. my_pass .. "@0.0.0.0:5432/wb" },
}

M.local_configs = tlib.merge_lists(M.local_configs, private.itr_configs)

return M
