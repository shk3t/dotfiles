local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local harpoon_ui = require("harpoon.ui")
local keymap = vim.keymap.set

local IGNORE_FILE = os.getenv("HOME") .. "/.config/nvim/etc/telescope-ignore.txt"

local paste_action = function(prompt_bufnr)
  local selection = vim.fn.getreg("\"")
  -- ensure that the buffer can be written to
  if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
    vim.api.nvim_paste(selection, true, -1)
  end
end

-- keymap("n", "<Space>f", builtin.find_files)
-- keymap("n", "<Space>g", builtin.live_grep)
-- keymap("n", "<C-F>", builtin.find_files)
keymap("n", "<C-F>", ":Telescope find_files<CR>") -- frecency bug
keymap("n", "<C-G>", builtin.live_grep)
keymap("n", "<Space>j", builtin.buffers)
keymap("n", "<Space>th", builtin.help_tags)
-- keymap("n", "<Space>tm", builtin.man_pages)
keymap("n", "<Space>'", builtin.marks)
keymap("n", "<Space>tk", builtin.keymaps)
-- keymap("n", "<Space>j", builtin.jumplist)
keymap("n", "<Space>tr", builtin.registers)
keymap("n", "<Space>s", builtin.lsp_document_symbols)
keymap("n", "<Space>as", builtin.lsp_dynamic_workspace_symbols)
keymap("n", "<Space>gs", builtin.git_status)
keymap("n", "<Space>gc", builtin.git_commits)
keymap("n", "<Space>gb", builtin.git_branches)

keymap("n", "<Space>ha", require("harpoon.mark").add_file)
keymap("n", "<Space>hh", harpoon_ui.toggle_quick_menu)
for i = 1, 9 do
  keymap("n", "'" .. i, function() harpoon_ui.nav_file(i) end)
end

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

    -- /home/ashket/.local/share/nvim/plugin/telescope.nvim/lua/telescope/mappings.lua
    mappings = {
      i = {
        -- ["<C-H>"] = false,
        ["<C-P>"] = actions.cycle_history_prev,
        ["<C-N>"] = actions.cycle_history_next,
        ["<C-J>"] = actions.move_selection_next,
        ["<C-K>"] = actions.move_selection_previous,
        ["<Tab>"] = actions.move_selection_next,
        ["<S-Tab>"] = actions.move_selection_previous,
        ["<Esc>"] = actions.close,
        ["<C-V>"] = paste_action,
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
        "fd",
        "--type=f",
        -- "--strip-cwd-prefix",
        "--hidden",
        "--no-ignore",
        "--ignore-file",
        IGNORE_FILE,
      },
    },
    buffers = {sort_mru = true, ignore_current_buffer = true},
    lsp_references = {include_declaration = false, show_line = false},
    diagnostics = {severity_limit = "WARN"}, -- Only warnings and errors
    -- lsp_document_symbols = {
    --     ignore_symbols = {
    --         "variable",
    --         "boolean",
    --         "string",
    --         "number",
    --         "array",
    --         "package",
    --         "module",
    --         "property",
    --     },
    -- },
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
  },
})

telescope.load_extension("fzf")

require("telescope-all-recent").setup({
  pickers = {
    find_files = {disable = false, use_cwd = false, sorting = "frecency"},
  },
})
