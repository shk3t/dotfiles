local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap("n", "<Space>E", "<Cmd>NvimTreeFindFile<CR>", opts)

require("nvim-tree").setup({
    hijack_netrw = false,
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        width = 10,
        mappings = {
            list = {
                {key = "l", action = "edit"},
                {key = "h", action = "close_node"},
            },
        },
    },
    renderer = {
        group_empty = true,
        icons = {
            symlink_arrow = " -> ",
            show = {
                file = false,
                folder = false,
                folder_arrow = true,
                git = false,
            },
            glyphs = {
                folder = {arrow_closed = ">", arrow_open = "v"},
                symlink = "",
            },
        },
    },
    filters = {dotfiles = false},
    actions = {open_file = {window_picker = {enable = false}}},
})
