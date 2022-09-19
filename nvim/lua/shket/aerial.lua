local buf_keymap = vim.api.nvim_buf_set_keymap
local opts = {noremap = true, silent = true}

require("aerial").setup({
    on_attach = function(bufnr)
        -- Toggle the aerial window with <leader>a
        buf_keymap(bufnr, 'n', 'gs', '<cmd>AerialOpen<CR>', opts)
        -- Jump forwards/backwards with '{' and '}'
        -- buf_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', opts)
        -- buf_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', opts)
        -- -- Jump up the tree with '[[' or ']]'
        -- buf_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', opts)
        -- buf_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', opts)
    end,

    icons = {
        Collapsed = ">>>"
    },

    -- attach_mode = "global",

    -- default_direction = "prefer_left",
    -- show_guides = true,
    -- guides = {
    -- --     -- mid_item = "├─",
    -- --     -- last_item = "└─",
    -- --     -- nested_top = "│ ",
    --     mid_item = "    ",
    --     last_item = "    ",
    --     nested_top = "    ",
    --     whitespace = "    "
    -- }
    highlight_on_jump = false,
})
