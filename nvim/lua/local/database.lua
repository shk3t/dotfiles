local urllib = require("lib.url")

local M = {}

M.local_configs = {
  { name = "wb_local", url = "postgres://ashket:1think1dump@localhost:5432/wb" },
  {
    name = "itr_local",
    url = "mysql://ashket:1think1dump@localhost:3306/itresume",
  },

  {
    name = "wb_dev",
    url = "ssh://itresume-dev:postgres://wb_admin:" .. urllib.urlencode(
      [[w1V|6y66<"biSzI-L)*,@xe#GV08Sof3S1A}$m1yE4-p2wl2ia]]
    ) .. "@localhost:5432/wb",
  },
  {
    name = "wb_prod",
    url = "ssh://salesify:postgres://wb_admin:"
      .. urllib.urlencode([[$?R^ze3-N[48;=1:-/ZHt-VT]0(v4CanPTN7n,}9]])
      .. "@localhost:5432/wb",
  },
  {
    name = "wb0_dev",
    url = "ssh://itresume-dev:postgres://wb_admin:" .. urllib.urlencode(
      [[w1V|6y66<"biSzI-L)*,@xe#GV08Sof3S1A}$m1yE4-p2wl2ia]]
    ) .. "@localhost:5432/wb0",
  },
  {
    name = "itr_dev",
    url = "ssh://itresume-dev:mysql://root:qweasd963@localhost:3306/itresume",
  },
  {
    name = "geekbrains",
    url = "ssh://geekbrains:postgres://autotests_admin:" .. urllib.urlencode(
      [[$K6JBBN56h4o$GaQ27t3*Gu%M7*d3UoZ4yVZAj3r]]
    ) .. "@localhost:5432/autotests",
  },

  -- {
  --   name = "skillbox_prod",
  --   url = "ssh://skillbox:postgres://skillbox_admin:" .. urllib.urlencode([[8HdKAvqP$vK!k##2P*SmjtKihd*mNUW4XaVSykdL]]) ..
  --     "@localhost:5432/skillbox",
  -- },
}

return M
