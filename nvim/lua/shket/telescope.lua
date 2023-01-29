local telescope = require("telescope")
local actions = require("telescope.actions")
local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}
local IGNORE_FILE = os.getenv("HOME") .. "/.config/nvim/etc/telescope-ignore.txt"

local cmd_telescope = "<Cmd>lua require('telescope.builtin')"

keymap("n", "<Space>f", cmd_telescope .. ".find_files()<CR>", opts)
keymap("n", "<Space>g", cmd_telescope .. ".live_grep()<CR>", opts)
keymap("n", "<Space>b", cmd_telescope .. ".buffers()<CR>", opts)
keymap("n", "<Space>th", cmd_telescope .. ".help_tags()<CR>", opts)
-- keymap("n", "<Space>tm", cmd_telescope .. ".man_pages()<CR>", opts)
keymap("n", "<Space>tm", cmd_telescope .. ".marks()<CR>", opts)
keymap("n", "<Space>tk", cmd_telescope .. ".keymaps()<CR>", opts)
keymap("n", "<Space>tj", cmd_telescope .. ".jumplist()<CR>", opts)
keymap("n", "<Space>tr", cmd_telescope .. ".registers()<CR>", opts)
keymap("n", "<Space>s", cmd_telescope .. ".lsp_document_symbols()<CR>", opts)
keymap("n", "<Space>as", cmd_telescope .. ".lsp_dynamic_workspace_symbols()<CR>", opts)

telescope.setup({
    defaults = {
        sorting_strategy = "ascending",
        layout_config = {
            height = 0.8,
            -- preview_cutoff = 120,
            -- prompt_position = "bottom",
            prompt_position = "top",
            width = 0.8,
            preview_width = 0.55,
        },
        border = true,
        file_ignore_patterns = {"node_modules"},

        mappings = {
            i = {
                -- ["<C-H>"] = false,
                ["<C-P>"] = actions.cycle_history_prev,
                ["<C-N>"] = actions.cycle_history_next,
                ["<C-J>"] = actions.move_selection_next,
                ["<C-K>"] = actions.move_selection_previous,
                ["<Esc>"] = actions.close,
            },
        },
        vimgrep_arguments = {
            "rg",
            "--vimgrep",
            "--smart-case",
            "--trim",
            "--hidden",
            "--no-ignore",
            "--ignore-file",
            IGNORE_FILE,
        },
    },
    pickers = {
        find_files = {
            find_command = {
                "fdfind",
                "--type=f",
                "--strip-cwd-prefix",
                "--hidden",
                "--no-ignore",
                "--ignore-file",
                IGNORE_FILE,
            },
        },
        buffers = {sort_mru = true},
        lsp_references = {include_declaration = false, show_line = false},
        diagnostics = {severity_limit = "WARN"}, -- Only warnings and errors
        -- lsp_dynamic_workspace_symbols = {ignore_symbols = {"node_modules"}},
        -- jumplist = {show_line = false}
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
        -- media_files = {
        -- 	-- filetypes whitelist
        -- 	-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
        -- 	filetypes = { "png", "webp", "jpg", "jpeg" },
        -- 	find_cmd = "rg", -- find command (defaults to `fd`)
        -- },
    },
})

telescope.load_extension("fzf")
-- telescope.load_extension("media_files")

-- local TelescopePrompt = {
--     TelescopeNormal = {
--         bg = '#2d3149',
--     },
--     TelescopeBorder = {
--         bg = '#000000',
--         fg = "#000000",
--     },
--     TelescopeTitle = {
--         fg = '#2d3149',
--         bg = '#2d3149',
--     },
--     TelescopePreview = {
--         fg = '#1F2335',
--         bg = '#1F2335',
--     },
--     TelescopeResults = {
--         fg = '#1F2335',
--         bg = '#1F2335',
--     },
-- }
-- for hl, col in pairs(TelescopePrompt) do
--     vim.api.nvim_set_hl(0, hl, col)
-- end
-- local ret = vim.api.nvim_get_hl_by_name("Keyword", true)
-- string.format("%06x", 11252415)
