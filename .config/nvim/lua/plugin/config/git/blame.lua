require("blame").setup({ width = 35, date_format = "%H:%M %d.%m.%Y" })

vim.keymap.set("n", "<Space>GB", vim.cmd.BlameToggle)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "blame",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.wrap = false
    vim.opt_local.cursorlineopt = "line"
  end,
})
