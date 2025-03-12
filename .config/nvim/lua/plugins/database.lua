local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local urllib = require("lib.url")
local local_configs = require("local.database").local_configs

keymap("n", "<Space>db", vim.cmd.DBUIToggle)
keymap("n", "<Space>DR", vim.cmd.DBUIFindBuffer)
autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    keymap("n", "<C-CR>", "mmvip<Plug>(DBUI_ExecuteQuery)", { buffer = true })
    keymap("v", "<C-CR>", "mm<Plug>(DBUI_ExecuteQuery)", { buffer = true })
    keymap({ "n", "v" }, "<C-S>", ":<C-U>write<CR><Plug>(DBUI_SaveQuery)", { buffer = true })
    keymap({ "n", "v" }, "<Space>E", "<Plug>(DBUI_EditBindParameters)", { buffer = true })
  end,
})
autocmd("FileType", {
  pattern = "dbui",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.keymap.del("n", "<C-K>", { buffer = true })
    vim.keymap.del("n", "<C-J>", { buffer = true })
    keymap("n", "D", "<Plug>(DBUI_DeleteLine)", { buffer = true })
    keymap("n", "h", "<Plug>(DBUI_GotoParentNode)<Plug>(DBUI_SelectLine)", { buffer = true })
    keymap("n", "l", "<Plug>(DBUI_SelectLine)", { buffer = true })
    keymap("n", "R", "<Plug>(DBUI_Redraw)", { buffer = true })
  end,
})

autocmd("FileType", {
  pattern = "dbout",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.wrap = false
    vim.opt_local.cursorlineopt = "line"
    vim.opt_local.foldenable = false
    vim.diagnostic.enable(false)
  end,
})

vim.g.db_ui_execute_on_save = false
vim.g.db_ui_auto_execute_table_helpers = false
vim.g.db_ui_force_echo_notifications = true
vim.g.db_ui_show_help = false
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
  connection_ok = "󰩐 ",
  connection_error = "󰯇 ",
}

vim.g.dbs = local_configs
