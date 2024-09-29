local urllib = require("lib.url")

local M = {}

local user = vim.env.USER

M.local_configs = {
  { name = "lms_local", url = "postgres://" .. user .. ":1think1dump@localhost:5432/lms" },
  {
    name = "lms_dev",
    url = "ssh://itresume-dev:postgres://lms_admin:"
      .. urllib.urlencode([[WFmk6b3c%wDKXT^X&SUU#*y^@JmsptdnDFpLiAdV]])
      .. "@localhost:5432/lms_db",
  },
  {
    name = "lms_corp",
    url = "ssh://itresume-corp:postgres://lms_admin:"
      .. urllib.urlencode([[H4D6dB6YNnb7VirrFsz&mzqfhLYKh6oR%g35Z*eX]])
      .. "@localhost:5432/lms",
  },
  { name = "sok_local_docker", url = "postgres://postgres:qweasd963@localhost:2345/analysis" },
  { name = "sok_local", url = "postgres://" .. user .. ":1think1dump@localhost:5432/sok" },
  {
    name = "sok_dev",
    url = "ssh://itresume-dev:postgres://sok_admin:qweasd963@localhost:5432/sok",
  },
  {
    name = "sok_prod",
    url = "ssh://itresume-prod:mysql://root:qweasd963@localhost:3306/sok",
  },
  {
    name = "sok_corp",
    url = "ssh://itresume-corp:mysql://root:@localhost:3306/sok",
  },

  {
    name = "itr_local",
    url = "mysql://ashket:1think1dump@localhost:3306/itrapi",
  },
  {
    name = "itr_dev",
    url = "ssh://itresume-dev:mysql://root:qweasd963@localhost:3306/itresume",
  },
  {
    name = "itr_prod",
    url = "ssh://itresume-prod:mysql://root:qweasd963@localhost:3306/production",
  },

  { name = "wb_local", url = "postgres://" .. user .. ":1think1dump@localhost:5432/wb" },

  { name = "mp", url = "postgres://postgres:pass@localhost:2345/postgres" },

  -- {
  --   name = "wb_dev",
  --   url = "ssh://itresume-dev:postgres://wb_admin:" .. urllib.urlencode(
  --     [[w1V|6y66<"biSzI-L)*,@xe#GV08Sof3S1A}$m1yE4-p2wl2ia]]
  --   ) .. "@localhost:5432/wb",
  -- },
  -- {
  --   name = "salesify",
  --   url = "ssh://salesify:postgres://wb_admin:"
  --     .. urllib.urlencode([[$?R^ze3-N[48;=1:-/ZHt-VT]0(v4CanPTN7n,}9]])
  --     .. "@localhost:5432/wb",
  -- },
  -- { name = "goto", url = "postgres://" .. user .. ":1think1dump@localhost:5432/goto" },
  -- {
  --   name = "geekbrains",
  --   url = "ssh://geekbrains:postgres://autotests_admin:" .. urllib.urlencode(
  --     [[$K6JBBN56h4o$GaQ27t3*Gu%M7*d3UoZ4yVZAj3r]]
  --   ) .. "@localhost:5432/autotests",
  -- },

  -- {
  --   name = "skillbox_prod",
  --   url = "ssh://skillbox:postgres://skillbox_admin:" .. urllib.urlencode([[8HdKAvqP$vK!k##2P*SmjtKihd*mNUW4XaVSykdL]]) ..
  --     "@localhost:5432/skillbox",
  -- },
}

return M
