local opts = {noremap = true, silent = true}
vim.keymap.set("n", "gs", "<cmd>AerialOpen<CR>", opts)

require("aerial").setup({
    layout = {default_direction = "prefer_left", max_width = {40, 0.3}},
    icons = {Collapsed = ">>>"},
    highlight_on_jump = false,
    attach_mode = "window",
    -- filter_kind = false,
})
