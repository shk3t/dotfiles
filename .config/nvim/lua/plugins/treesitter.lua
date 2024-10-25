local keymap = vim.keymap.set
local lib = require("lib.main")

require("nvim-treesitter.configs").setup({
  -- ensure_installed = "all",
  highlight = { enable = true },
  indent = {
    enable = true,
    disable = { "css", "c", "cpp", "lua" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      -- init_selection = "<M-w>", -- maps in normal mode to init the node/scope selection
      -- node_incremental = "n", -- increment to the upper named parent
      -- node_decremental = "N", -- decrement to the previous node
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
        ["]j"] = "@code_cell.inner",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
        ["]J"] = "@code_cell.inner",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[a"] = "@parameter.inner",
        ["[j"] = "@code_cell.inner",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
        ["[J"] = "@code_cell.inner",
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",

        ["iC"] = "@class.inner",
        ["aC"] = "@class.outer",

        ["ia"] = "@parameter.inner",
        ["aa"] = "@parameter.outer",

        ["ic"] = "@call.inner",
        ["ac"] = "@call.outer",

        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",

        ["is"] = "@statement.outer",
        ["as"] = "@statement.outer",

        ["ij"] = "@code_cell.inner",
        ["aj"] = "@code_cell.outer",
      },
      selection_modes = {
        ["@function.outer"] = "V",
        ["@function.inner"] = "V",
        ["@class.outer"] = "V",
        ["@class.inner"] = "V",
        ["@code_cell.outer"] = "V",
        ["@code_cell.inner"] = "V",
      },
      include_surrounding_whitespace = false,
    },
    swap = {
      enable = true,
      swap_next = {
        ["c>a"] = "@parameter.inner",
        ["c>f"] = "@function.outer",
        ["c>j"] = "@code_cell.outer",
      },
      swap_previous = {
        ["c<a"] = "@parameter.inner",
        ["c<f"] = "@funciton.outer",
        ["c<j"] = "@code_cell.outer",
      },
    },
  },
})

local function set_preset(preset)
  preset = preset or {}
  return function(override)
    override = override or {}
    override = vim.tbl_deep_extend("force", preset, override)
    return require("treesj.langs.utils").set_default_preset(override)
  end
end
local lang_utils = require("treesj.langs.utils")
local tsj = require("treesj")

local spaceless_dict_preset = set_preset({
  both = { separator = "," },
  split = { last_separator = true },
})
local lua_rec_ignore = { recursive_ignore = { "arguments", "parameters" } }
local js_ts_rec_ignore = { recursive_ignore = { "arguments", "formal_parameters" } }
local js_ts_lang_preset = {
  object = spaceless_dict_preset({ split = js_ts_rec_ignore }),
  object_pattern = spaceless_dict_preset({ both = js_ts_rec_ignore }),
}

tsj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 150,
  cursor_behavior = "hold",
  notify = true,
  langs = {
    python = {
      argument_list = spaceless_dict_preset(),
      parameters = spaceless_dict_preset(),
      tuple = spaceless_dict_preset(),
    },
    javascript = js_ts_lang_preset,
    typescript = js_ts_lang_preset,
    lua = { table_constructor = spaceless_dict_preset({ split = lua_rec_ignore }) },
  },
  dot_repeat = true,
})

keymap("v", "n", function()
  require("nvim-treesitter.incremental_selection").node_incremental()
  lib.norm("o")
end)
keymap("v", "N", function()
  require("nvim-treesitter.incremental_selection").node_decremental()
  lib.norm("o")
end)
keymap("n", "gJ", tsj.join)
keymap("n", "gS", tsj.split)
keymap("n", "U", tsj.toggle)
