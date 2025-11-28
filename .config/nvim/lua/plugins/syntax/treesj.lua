local keymap = vim.keymap.set

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

keymap("n", "gJ", tsj.join)
keymap("n", "gS", tsj.split)
keymap("n", "U", tsj.toggle)
