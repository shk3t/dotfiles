local opts = {noremap = true, silent = true}
vim.keymap.set("n", "gs", "<cmd>AerialOpen<CR>", opts)

require("aerial").setup({
    layout = {max_width = {40, 0.3}},
    icons = {Collapsed = ">>>"},
    highlight_on_jump = false,
    attach_mode = "global",
    -- default_direction = "prefer_left",
    -- filter_kind = false,
})

