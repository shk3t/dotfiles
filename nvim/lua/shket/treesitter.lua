require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    highlight = {enable = true, disable = {"sql", "asm", "md"}},
    indent = {enable = true, disable = {"python", "css"}},
    incremental_selection = {
        enable = true,
        keymaps = {
            -- init_selection = "<M-w>", -- maps in normal mode to init the node/scope selection
            node_incremental = "an", -- increment to the upper named parent
            node_decremental = "in", -- decrement to the previous node
            -- scope_incremental = "as", -- increment to the upper scope (as defined in locals.scm),
        },
    },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
                ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
                ["]F"] = "@function.outer",
                ["]C"] = "@class.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
                ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[C"] = "@class.outer",
            },
        },
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",

                ["aC"] = "@class.outer",
                ["iC"] = "@class.inner",

                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",

                ["ac"] = "@call.outer",
                ["ic"] = "@call.inner",

                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",

                ["as"] = "@statement.outer",
                ["is"] = "@statement.outer",
            },
            selection_modes = {
                ["@function.outer"] = "V",
                ["@function.inner"] = "V",
                ["@class.outer"] = "V",
                ["@class.inner"] = "V",
            },
            include_surrounding_whitespace = false,
        },
        swap = {
            enable = true,
            swap_next = {
                ["c>a"] = "@parameter.inner",
                ["c>f"] = "@function.outer",
            },
            swap_previous = {
                ["c<a"] = "@parameter.inner",
                ["c<f"] = "@funciton.outer",
            },
        },
    },
})
