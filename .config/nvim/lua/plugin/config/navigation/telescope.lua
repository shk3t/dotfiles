local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local consts = require("consts")
local grep_actions = require("telescope-live-grep-args.actions")
local grep_shortcuts = require("telescope-live-grep-args.shortcuts")
local inputs = require("lib.base.input")
local telescope = require("telescope")
local undo_actions = require("telescope-undo.actions")
local utils = require("plugin.util.telescope")
local IGNORE_FILE = consts.NVIM_ETC .. "/telescope-ignore.txt"

local telescope_config = {
  defaults = {
    initial_mode = "insert",
    sorting_strategy = "ascending",
    layout_config = {
      height = 0.9,
      prompt_position = "top",
      width = 0.9,
      preview_width = 0.55,
    },
    border = true,
    borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    results_title = "",
    file_ignore_patterns = { "node_modules" },
    mappings = {
      i = {
        ["<C-P>"] = actions.cycle_history_prev,
        ["<C-N>"] = actions.cycle_history_next,
        ["<C-J>"] = actions.move_selection_next,
        ["<C-K>"] = actions.move_selection_previous,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<C-V>"] = utils.paste_action,
        ["<C-Q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<S-ScrollWheelUp>"] = actions.move_selection_previous,
        ["<S-ScrollWheelDown>"] = actions.move_selection_next,
      },
      n = {
        ["<C-Q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["0"] = function()
          inputs.norm("0w")
        end,
        ["^"] = function()
          inputs.norm("0w")
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
    diagnostics = { severity_limit = "WARN" },
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
          ["<C-S>"] = grep_actions.quote_prompt(),
          ["<C-G>"] = function(prompt_bufnr)
            grep_actions.quote_prompt({ postfix = " --iglob ****" })(prompt_bufnr)
            inputs.norm("2h")
          end,
          ["<C-T>"] = utils.set_prompt_action("TODO(:| |$)"),
        },
      },
    },
    undo = {
      use_delta = true,
      side_by_side = false,
      vim_diff_opts = { ctxlen = 20 },
      entry_format = "state #$ID, $STAT, $TIME",
      time_format = "",
      saved_only = false,
      mappings = {
        i = {
          ["<CR>"] = undo_actions.yank_additions,
          ["<S-CR>"] = undo_actions.yank_deletions,
          ["<C-Y>"] = undo_actions.yank_deletions,
          ["<C-R>"] = undo_actions.restore,
        },
      },
    },
  },
}
utils.adjust_iconpath_display(telescope_config, { "find_files", "buffers" }, { "live_grep_args" })

telescope.setup(telescope_config)
telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
telescope.load_extension("undo")

keymap("n", "<C-P>", builtin.resume)
keymap("n", "<C-F>", function()
  builtin.find_files()
end)
keymap("x", "<C-F>", utils.visual_picker(builtin.find_files))
keymap("n", "<C-G>", telescope.extensions.live_grep_args.live_grep_args)
keymap("x", "<C-G>", function()
  grep_shortcuts.grep_visual_selection({
    postfix = "",
    quote = false,
    trim = true,
  })
end)
keymap("n", "g<Tab>", builtin.buffers)
keymap("n", "<Space><C-O>", function()
  builtin.jumplist({ show_line = false, trim_text = true })
end)
keymap("n", "<Space>u", telescope.extensions.undo.undo)
keymap("n", "<Space>q", builtin.quickfix)
keymap("n", "<Space>Q", builtin.quickfixhistory)
keymap("n", "<Space>/", builtin.search_history)
keymap("n", "<Space>:", builtin.command_history)
keymap("n", "<Space>th", builtin.help_tags)
keymap("n", "<Space>tm", builtin.man_pages)
keymap("n", "<Space>tk", builtin.keymaps)
keymap("n", "<Space>tl", builtin.highlights)
keymap("n", "<Space>ts", builtin.spell_suggest)

autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.wo.number = true
    vim.wo.wrap = true
  end,
})
