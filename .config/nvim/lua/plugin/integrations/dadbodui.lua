local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local keydel = vim.keymap.del
local cmds = require("lib.cmds")

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

keymap("n", "<Space>db", vim.cmd.DBUIToggle)
keymap("n", "<Space>DR", vim.cmd.DBUIFindBuffer)

autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    keymap("n", "<C-CR>", cmds.preserve_pos_pre("vip<Plug>(DBUI_ExecuteQuery)"), { buffer = true, expr = true })
    keymap("x", "<C-CR>", cmds.preserve_pos_pre("<Plug>(DBUI_ExecuteQuery)"), { buffer = true, expr = true})
    keymap({ "n", "x" }, "<C-S>", ":<C-U>write<CR><Plug>(DBUI_SaveQuery)", { buffer = true })
    keymap("n", "<Space>E", "<Plug>(DBUI_EditBindParameters)", { buffer = true })
  end,
})
autocmd("FileType", {
  pattern = "dbui",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.wo.cursorlineopt = "line"
    keymap("n", "D", "<Plug>(DBUI_DeleteLine)", { buffer = true })
    keymap("n", "h", "<Plug>(DBUI_GotoParentNode)<Plug>(DBUI_SelectLine)", { buffer = true })
    keymap("n", "l", "<Plug>(DBUI_SelectLine)", { buffer = true })
  end,
})
autocmd("FileType", {
  pattern = "dbout",
  callback = function()
    vim.wo.number = false
    vim.wo.signcolumn = "no"
    vim.wo.wrap = false
    vim.wo.cursorlineopt = "line"
    vim.wo.foldenable = false
    vim.diagnostic.enable(false)
  end,
})
