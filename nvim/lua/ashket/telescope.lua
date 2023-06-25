local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local harpoon_ui = require("harpoon.ui")
local lga_actions = require("telescope-live-grep-args.actions")
local undo_actions = require("telescope-undo.actions")
local keymap = vim.keymap.set

local IGNORE_FILE = os.getenv("HOME") .. "/.config/nvim/etc/telescope-ignore.txt"

local paste_action = function(prompt_bufnr)
  local selection = vim.fn.getreg("\"")
  -- ensure that the buffer can be written to
  if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
    vim.api.nvim_paste(selection, true, -1)
  end
end

keymap("n", "<C-F>", ":Telescope find_files<CR>") -- frecency bug
keymap("n", "<C-G>", telescope.extensions.live_grep_args.live_grep_args)
keymap("v", "<C-G>", function()
  require("telescope-live-grep-args.shortcuts").grep_visual_selection({
    postfix = "",
    quote = false,
    trim = true,
  })
end)
keymap("n", "<Space>j", builtin.buffers)
keymap("n", "<Space>th", builtin.help_tags)
keymap("n", "<Space>'", builtin.marks)
keymap("n", "<Space>tk", builtin.keymaps)
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
keymap("n", "<Space>u", telescope.extensions.undo.undo)

telescope.setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      height = 0.9,
      -- preview_cutoff = 120,
      -- prompt_position = "bottom",
      prompt_position = "top",
      width = 0.9,
      preview_width = 0.55,
    },
    border = false,
    file_ignore_patterns = {"node_modules"},

    mappings = {
      i = {
        ["<C-C>"] = function() vim.cmd("stopinsert") end,
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
        "--hidden",
        "--no-ignore",
        "--ignore-file",
        IGNORE_FILE,
      },
    },
    buffers = {sort_mru = true, ignore_current_buffer = true},
    lsp_references = {include_declaration = false, show_line = false},
    diagnostics = {severity_limit = "WARN"}, -- Only warnings and errors
    lsp_dynamic_workspace_symbols = {
      ignore_symbols = {
        "variable",
        "boolean",
        "string",
        "number",
        "array",
        "package",
        "module",
        "property",
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-S>"] = lga_actions.quote_prompt(),
          ["<C-G>"] = lga_actions.quote_prompt({postfix = " --iglob "}),
        },
      },
    },
    undo = {
      use_delta = true,
      side_by_side = false,
      diff_context_lines = 5,
      entry_format = "state #$ID, $STAT, $TIME",
      mappings = {
        i = {
          ["<CR>"] = undo_actions.yank_additions,
          ["<S-CR>"] = undo_actions.yank_deletions,
          ["<C-CR>"] = undo_actions.restore,
        },
      },
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
telescope.load_extension("undo")

require("telescope-all-recent").setup({
  database = {max_timestamps = 5},
  scoring = {
    recency_modifier = {
      [1] = {age = 60, value = 100}, -- past hour
      [2] = {age = 240, value = 60}, -- past 4 hours
      [3] = {age = 720, value = 30}, -- past 12 hours
      [4] = {age = 2880, value = 15}, -- past 2 days
      [5] = {age = 10080, value = 5}, -- past week
      [6] = {age = 43200, value = 2}, -- past month
    },
  },
  default = {
    disable = true, -- disable any unkown pickers (recommended)
  },
  pickers = {
    find_files = {disable = false, use_cwd = false, sorting = "frecency"},
  },
})
