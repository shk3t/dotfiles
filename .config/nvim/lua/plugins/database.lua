local keymap = vim.keymap.set
local urllib = require("lib.url")
local local_configs = require("local.database").local_configs

keymap("n", "<Space>db", vim.cmd.DBUIToggle)

-- vim.g.db_ui_icons = {collapsed = {db = "󱘲"}}

vim.g.db_ui_force_echo_notifications = true
vim.g.db_ui_show_help = false
vim.g.db_ui_execute_on_save = false
vim.g.db_ui_icons = {
  expanded = {
    db = "󱤢 ",
    buffers = " ",
    saved_queries = " ",
    schemas = "󰹟 ",
    schema = "󰝣 ",
    tables = "󱂔 ",
    table = "󰕲 ",
  },
  collapsed = {
    db = "󱘲 ",
    buffers = " ",
    saved_queries = " ",
    schemas = "󰗆 ",
    schema = "󰀁 ",
    tables = "󰓫 ",
    table = "󱒋 ",
  },
  saved_query = " ",
  new_query = "󰹨 ",
  tables = "󰖼 ",
  buffers = "󱉯 ",
  add_connection = "󱘖 ",
  connection_ok = "󰩐",
  connection_error = "󰯇 ",
}

vim.g.dbs = local_configs
