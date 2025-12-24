local keymap = vim.keymap.set
local consts = require("consts")
local quicker = require("quicker")

quicker.setup({
  keys = {
    {
      "zq",
      function()
        quicker.toggle_expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Toggle expand quickfix context",
    },
    { "u", quicker.refresh, desc = "Refresh quickfix list" },
  },
  edit = {
    enabled = true,
    autosave = "unmodified",
  },
  constrain_cursor = true,
  highlight = {
    treesitter = true,
    lsp = true,
    load_buffers = false,
  },
  follow = {
    enabled = false,
  },
  type_icons = {
    E = consts.ICONS.DIAGNOSTIC.ERROR,
    W = consts.ICONS.DIAGNOSTIC.WARN,
    I = consts.ICONS.DIAGNOSTIC.INFO,
    N = consts.ICONS.DIAGNOSTIC.INFO,
    H = consts.ICONS.DIAGNOSTIC.HINT,
  },
  borders = {
    vert = "│",
    strong_header = "─",
    strong_cross = "┼",
    strong_end = "┤",
    soft_header = "╴",
    soft_cross = "┤",
    soft_end = "│",
  },
  max_filename_width = function()
    return math.floor(math.min(95, vim.o.columns / 2))
  end,
})

keymap("n", "<Space>q", function()
  require("quicker").toggle()
end, { desc = "Toggle quickfix" })
