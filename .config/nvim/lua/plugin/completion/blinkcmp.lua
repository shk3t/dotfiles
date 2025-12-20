local consts = require("consts")

require("blink.cmp").setup({
  keymap = {
    preset = "none",
    ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
    ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
    ["<C-K>"] = { "select_prev", "fallback" },
    ["<C-J>"] = { "select_next", "fallback" },
    ["<C-L>"] = { "show", "select_and_accept" },
    ["<C-E>"] = { "hide" },
    ["<C-U>"] = { "scroll_documentation_up" },
    ["<C-D>"] = { "scroll_documentation_down" },
  },
  snippets = { preset = "luasnip" },
  completion = {
    list = {
      max_items = 64,
      selection = {
        preselect = false,
      },
    },
    accept = {
      resolve_timeout_ms = 40,
    },
    menu = {
      border = nil,
      draw = {
        padding = 1,
        gap = 1,
        snippet_indicator = "",
        columns = { { "label" }, { "label_description" }, { "kind_icon", "kind" } },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
      window = { border = consts.ICONS.BORDER },
    },
  },
  signature = {
    enabled = true,
    trigger = {
      show_on_insert = true,
    },
    window = { border = consts.ICONS.BORDER },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
    sorts = { "exact", "score", "sort_text" },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    per_filetype = {
      sql = { "dadbod", "snippets", "buffer" },
    },
    providers = {
      snippets = {
        score_offset = 4,
      },
      dadbod = {
        module = "vim_dadbod_completion.blink",
        fallbacks = { "buffer" },
        score_offset = 5,
      },
    },
  },
  appearance = {
    nerd_font_variant = "mono",
    kind_icons = consts.ICONS.KINDS,
  },
  cmdline = {
    keymap = {
      preset = "inherit",
      ["<Tab>"] = { "show_and_insert", "select_next" },
      ["<C-L>"] = { "show", "select_accept_and_enter" },
    },
    completion = {
      list = { selection = { preselect = false } },
      menu = { auto_show = true },
    },
  },
  term = { enabled = false },
})
