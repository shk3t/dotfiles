local autocmd = vim.api.nvim_create_autocmd
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
-- local dap = require("dap")
local lga_actions = require("telescope-live-grep-args.actions")
local telescope = require("telescope")
local undo_actions = require("telescope-undo.actions")
local keymap = vim.keymap.set
local consts = require("lib.consts")
local lib = require("lib.main")
local telelib = require("lib.telescope")
local IGNORE_FILE = vim.fn.stdpath("config") .. "/etc/telescope-ignore.txt"

local fzf_opts = {
  fuzzy = true,
  override_generic_sorter = true,
  override_file_sorter = true,
  case_mode = "smart_case",
}

keymap("n", "<C-F>", function()
  builtin.find_files()
end)
-- keymap("v", "<Space>/", telelib.visual_picker(builtin.current_buffer_fuzzy_find))
keymap("n", "<Space>p", builtin.registers)
keymap("v", "<Space>p", function()
  lib.norm("d")
  builtin.registers()
end)
keymap("v", "<C-F>", telelib.visual_picker(builtin.find_files))
keymap("n", "<C-G>", telescope.extensions.live_grep_args.live_grep_args)
keymap("v", "<C-G>", function()
  require("telescope-live-grep-args.shortcuts").grep_visual_selection({
    postfix = "",
    quote = false,
    trim = true,
  })
end)
keymap("n", "<C-P>", builtin.resume)
keymap("n", "g<Tab>", builtin.buffers)
keymap("n", "<Space>th", builtin.help_tags)
keymap("n", "<Space>tm", builtin.man_pages)
keymap("n", "<Space>tk", builtin.keymaps)
keymap("n", "<Space>ts", builtin.spell_suggest)
keymap("n", "<Space><C-O>", function()
  builtin.jumplist({ show_line = false, trim_text = true })
end)
-- keymap("n", "<Space>l", builtin.lsp_document_symbols)
keymap("n", "<Space>w", function()
  builtin.lsp_dynamic_workspace_symbols()
end)
keymap("v", "<Space>w", telelib.visual_picker(builtin.lsp_dynamic_workspace_symbols))
keymap("n", "<Space>gs", builtin.git_status)
keymap("n", "<Space>gc", builtin.git_commits)
keymap("n", "<Space>gb", builtin.git_branches)
keymap("n", "<Space>u", telescope.extensions.undo.undo)
keymap("n", "<Space>q", builtin.quickfix)
keymap("n", "<Space>Q", builtin.quickfixhistory)
keymap("n", "<Space>:", builtin.command_history)
keymap("n", "<Space>?", builtin.search_history)
keymap("n", [[<Space>"]], builtin.marks)
-- keymap("n", [[<Space>']], telelib.quickfix_picker("Buffer Marks", vim.cmd.MarksQFListAll))
-- keymap(
--   "n",
--   "<Space>tb",
--   telelib.quickfix_picker("Breakpoints", function()
--     vim.cmd.copen()
--     dap.list_breakpoints()
--   end)
-- )

local telescope_config = {
  defaults = {
    initial_mode = "insert",
    sorting_strategy = "ascending",
    layout_config = {
      height = 0.9,
      -- preview_cutoff = 120,
      -- prompt_position = "bottom",
      prompt_position = "top",
      width = 0.9,
      preview_width = 0.55,
    },
    winblend = consts.TRANSPARENCY,
    border = true,
    borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    results_title = "",
    file_ignore_patterns = { "node_modules" },

    mappings = {
      i = {
        -- ["<Esc>"] = actions.close,
        -- ["<C-C>"] = vim.cmd.stopinsert,
        ["<C-P>"] = actions.cycle_history_prev,
        ["<C-N>"] = actions.cycle_history_next,
        ["<C-J>"] = actions.move_selection_next,
        ["<C-K>"] = actions.move_selection_previous,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<C-V>"] = telelib.paste_action,
        ["<C-Q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        -- ["<C-F>"] = actions.to_fuzzy_refine,

        ["<S-ScrollWheelUp>"] = actions.move_selection_previous,
        ["<S-ScrollWheelDown>"] = actions.move_selection_next,
      },
      n = {
        ["<C-Q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["0"] = function()
          lib.norm("0w")
        end,
        ["^"] = function()
          lib.norm("0w")
        end,
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
    buffers = { sort_mru = true, ignore_current_buffer = true },
    lsp_references = { include_declaration = false, show_line = false },
    diagnostics = { severity_limit = "WARN" }, -- Only warnings and errors
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
        "constant",
        "field",
      },
      sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts),
    },
    quickfix = { path_display = {} },
  },
  extensions = {
    fzf = fzf_opts,
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-S>"] = lga_actions.quote_prompt(),
          ["<C-G>"] = function(prompt_bufnr)
            lga_actions.quote_prompt({ postfix = " --iglob ****" })(prompt_bufnr)
            lib.norm("2h")
          end,
        },
      },
    },
    undo = {
      use_delta = true,
      side_by_side = false,
      vim_diff_opts = { ctxlen = 5 },
      entry_format = "state #$ID, $STAT, $TIME",
      mappings = {
        i = {
          ["<CR>"] = undo_actions.yank_additions,
          ["<S-CR>"] = undo_actions.yank_deletions,
          ["<C-CR>"] = undo_actions.restore,
        },
      },
    },
    ["ui-select"] = {
      layout_config = {
        height = 0.25,
        prompt_position = "top",
        width = 0.25,
      },
    },
  },
}
telelib.adjust_iconpath_display(telescope_config, { "find_files", "buffers" }, {
  "live_grep_args",
})
telescope.setup(telescope_config)

telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
telescope.load_extension("undo")
telescope.load_extension("ui-select")

-- https://github.com/prochri/telescope-all-recent.nvim?tab=readme-ov-file#installation
local pickers_frecency_opts = { disable = false, use_cwd = true, sorting = "frecency" }
require("telescope-all-recent").setup({
  database = { max_timestamps = 4 },
  scoring = {
    recency_modifier = {
      [1] = { age = 60, value = 100 }, -- past hour
      [2] = { age = 240, value = 60 }, -- past 4 hours
      [3] = { age = 720, value = 30 }, -- past 12 hours
      [4] = { age = 2880, value = 15 }, -- past 2 days
      [5] = { age = 10080, value = 5 }, -- past week
      [6] = { age = 43200, value = 0 }, -- past month
    },
    -- how much the score of a recent item will be improved.
    boost_factor = 0.0001,
  },
  default = {
    disable = true, -- disable any unkown pickers (recommended)
  },
  pickers = {
    find_files = pickers_frecency_opts,
    lsp_dynamic_workspace_symbols = pickers_frecency_opts,
  },
})

autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.wrap = true
    vim.opt_local.cursorline = true
  end,
})
