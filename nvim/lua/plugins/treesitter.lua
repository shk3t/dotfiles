local keymap = vim.keymap.set

require("nvim-treesitter.configs").setup({
  -- ensure_installed = "all",
  highlight = {enable = true, disable = {"sql", "asm"}},
  indent = {enable = true, disable = {"css", "c", "cpp", "lua"}},
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
      goto_next_end = {["]F"] = "@function.outer", ["]C"] = "@class.outer"},
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[a"] = "@parameter.inner",
      },
      goto_previous_end = {["[F"] = "@function.outer", ["[C"] = "@class.outer"},
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
      swap_next = {["c>a"] = "@parameter.inner", ["c>f"] = "@function.outer"},
      swap_previous = {
        ["c<a"] = "@parameter.inner",
        ["c<f"] = "@funciton.outer",
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
local tsj = require("treesj")
local lang_utils = require("treesj.langs.utils")

local spaceless_dict_preset = set_preset({
  both = {separator = ","},
  split = {last_separator = true},
})
local lua_rec_ignore = {recursive_ignore = {"arguments", "parameters"}}
local js_ts_rec_ignore = {recursive_ignore = {"arguments", "formal_parameters"}}
local js_ts_lang_preset = {
  object = spaceless_dict_preset({split = js_ts_rec_ignore}),
  object_pattern = spaceless_dict_preset({both = js_ts_rec_ignore}),
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
    lua = {table_constructor = spaceless_dict_preset({split = lua_rec_ignore})},
  },
  dot_repeat = true,
})

keymap("n", "gJ", tsj.join)
keymap("n", "gS", tsj.split)
keymap("n", "U", tsj.toggle)
