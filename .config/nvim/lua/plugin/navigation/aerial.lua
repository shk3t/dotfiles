local keymap = vim.keymap.set
local actions = require("aerial.actions")
local aerial = require("aerial")
local consts = require("consts")
local state = require("state")

local function close_restore_prev_pos()
  aerial.close()
  vim.api.nvim_win_set_cursor(0, state.aerial_preserved_position)
  state.aerial_preserved_position = nil
end

aerial.setup({
  layout = {
    default_direction = "prefer_right",
    max_width = { 60, 0.3 },
    win_opts = {
      cursorlineopt = "line",
    },
    placement = "edge",
  },
  attach_mode = "global",
  keymaps = {
    ["K"] = actions.prev_up,
    ["J"] = actions.next_up,
    ["W"] = actions.tree_close_all,
    ["E"] = actions.tree_open_all,
    ["<C-O>"] = close_restore_prev_pos,
  },
  highlight_on_jump = false,
  autojump = true,
  icons = consts.ICONS.KINDS,
  close_on_select = true,
  show_guides = false,
})

keymap("n", "<Space>s", function()
  state.aerial_preserved_position = vim.api.nvim_win_get_cursor(0)
  vim.cmd.AerialOpen()
end)
