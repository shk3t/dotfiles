local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local ulib = require("lib.utils")

local actions = require("aerial.actions")
local aerial = require("aerial")
local function close_restore_prev_pos()
  aerial.close()
  pcall(function()
    ulib.norm("`m")
    vim.cmd.delmarks("m")
  end)
end
aerial.setup({
  layout = { default_direction = "prefer_left", max_width = { 60, 0.3 } },
  icons = { Collapsed = " >" },
  highlight_on_jump = false,
  attach_mode = "window",
  keymaps = {
    ["o"] = actions.jump,
    ["k"] = actions.prev,
    ["j"] = actions.next,
    ["K"] = actions.prev_up,
    ["J"] = actions.next_up,
    ["<C-K>"] = false,
    ["<C-J>"] = false,
    -- ["<C-K>"] = function() tmux.move_top() end,
    -- ["<C-J>"] = function() tmux.move_bottom() end,
    -- ["<C-K>"] = function()
    --   aerial.prev_up()
    --   aerial.next()
    -- end,
    -- ["<C-J>"] = function()
    --   aerial.next_up()
    --   aerial.prev()
    -- end,
    ["H"] = function()
      aerial.tree_close({ recurse = true })
    end,
    ["L"] = function()
      aerial.tree_open({ recurse = true })
    end,
    ["W"] = actions.tree_close_all,
    ["E"] = actions.tree_open_all,
    ["<C-P>"] = actions.prev_up,
    ["<C-O>"] = close_restore_prev_pos,
  },
  close_on_select = true,
  show_guides = true,
  guides = {
    -- When the child item has a sibling below it
    mid_item = "🭲 ",
    -- When the child item is the last in the list
    last_item = "🭲 ",
    -- When there are nested child guides to the right
    nested_top = "🭲 ",
    -- Raw indentation
    whitespace = "  ",
  },
  -- filter_kind = false,
  autojump = true,
})
keymap("n", "<Space>s", "mm:AerialOpen<CR>")
autocmd("FileType", {
  pattern = "aerial",
  callback = function()
    vim.opt_local.cursorlineopt = "line"
  end,
})
