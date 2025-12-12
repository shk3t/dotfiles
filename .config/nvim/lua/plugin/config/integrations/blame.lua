require("blame").setup({ width = 35, date_format = "%H:%M %d.%m.%Y" })

vim.keymap.set("n", "<Space>GB", vim.cmd.BlameToggle)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "blame",
  callback = function()
    vim.wo.number = false
    vim.wo.signcolumn = "no"
    vim.wo.wrap = false
    vim.wo.cursorlineopt = "line"
  end,
})
