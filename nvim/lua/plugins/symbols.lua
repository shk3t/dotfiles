local opts = {noremap = true, silent = true}
vim.keymap.set("n", "gs", "m'<Cmd>AerialOpen<CR>", opts)

require("aerial").setup({
  layout = {default_direction = "prefer_left", max_width = {25, 0.3}},
  icons = {Collapsed = ">>>"},
  highlight_on_jump = false,
  attach_mode = "window",
  close_on_select = true,
  -- filter_kind = false,
})
