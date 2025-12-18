require("blame").setup({
  date_format = "%H:%M %d.%m.%Y",
  max_summary_width = 35,
  mappings = {
    commit_info = "K",
    stack_push = "<C-P>",
    stack_pop = "<C-N>",
    show_commit = "<CR>",
    close = { "<Esc>", "q" },
  },
})

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
