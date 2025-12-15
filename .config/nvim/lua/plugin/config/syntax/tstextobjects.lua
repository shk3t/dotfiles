local keymap = vim.keymap.set
local move = require("nvim-treesitter-textobjects.move")
local repeatable_move = require("nvim-treesitter-textobjects.repeatable_move")
local select = require("nvim-treesitter-textobjects.select")
local swap = require("nvim-treesitter-textobjects.swap")

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
    include_surrounding_whitespace = false,
    selection_modes = {
      ["@function.outer"] = "V",
      ["@function.inner"] = "V",
      ["@class.outer"] = "V",
      ["@class.inner"] = "V",
      ["@code_cell.outer"] = "V",
      ["@code_cell.inner"] = "V",
    },
  },
  move = {
    set_jumps = true,
  },
})

-- TODO: use another mappings for assignment (`e`)
-- TODO: also restore good mappings for dap jumps (`]_`)
local keymaps = {
  select = {
    ["is"] = "@assignment.lhs",
    ["as"] = "@assignment.rhs",
    ["ib"] = "@block.inner",
    ["ab"] = "@block.outer",
    ["ic"] = "@call.inner",
    ["ac"] = "@call.outer",
    ["iC"] = "@class.inner",
    ["aC"] = "@class.outer",
    ["if"] = "@function.inner",
    ["af"] = "@function.outer",
    ["ia"] = "@parameter.inner",
    ["aa"] = "@parameter.outer",
    ["ij"] = "@code_cell.inner",
    ["aj"] = "@code_cell.outer",
  },
  move = {
    goto_previous_start = {
      ["[s"] = "@assignment.outer",
      ["[b"] = "@block.outer",
      ["[c"] = "@call.outer",
      ["[C"] = "@class.outer",
      ["[f"] = "@function.outer",
      ["[a"] = "@parameter.inner",
      ["[j"] = "@code_cell.inner",
    },
    goto_next_start = {
      ["]s"] = "@assignment.outer",
      ["]b"] = "@block.outer",
      ["]c"] = "@call.outer",
      ["]C"] = "@class.outer",
      ["]f"] = "@function.outer",
      ["]a"] = "@parameter.inner",
      ["]j"] = "@code_cell.inner",
    },
  },
  swap = {
    swap_previous = {
      ["<s"] = "@assignment.outer",
      ["<b"] = "@block.inner",
      ["<c"] = "@call.outer",
      ["<C"] = "@class.outer",
      ["<f"] = "@function.outer",
      ["<a"] = "@parameter.inner",
      ["<j"] = "@code_cell.outer",
    },
    swap_next = {
      [">s"] = "@assignment.outer",
      [">b"] = "@block.inner",
      [">c"] = "@call.outer",
      [">C"] = "@class.outer",
      [">f"] = "@function.outer",
      [">a"] = "@parameter.inner",
      [">j"] = "@code_cell.outer",
    },
  },
}

for key, query in pairs(keymaps.select) do
  keymap({ "x", "o" }, key, function()
    select.select_textobject(query)
  end)
end
for action, entries in pairs(keymaps.move) do
  for key, query in pairs(entries) do
    keymap({ "n", "x", "o" }, key, function()
      move[action](query)
    end)
  end
end
for action, entries in pairs(keymaps.swap) do
  for key, query in pairs(entries) do
    keymap("n", key, function()
      swap[action](query)
    end)
  end
end

keymap({ "n", "x", "o" }, ";", repeatable_move.repeat_last_move_next)
keymap({ "n", "x", "o" }, ",", repeatable_move.repeat_last_move_previous)
keymap({ "n", "x", "o" }, "f", repeatable_move.builtin_f_expr, { expr = true })
keymap({ "n", "x", "o" }, "F", repeatable_move.builtin_F_expr, { expr = true })
keymap({ "n", "x", "o" }, "t", repeatable_move.builtin_t_expr, { expr = true })
keymap({ "n", "x", "o" }, "T", repeatable_move.builtin_T_expr, { expr = true })
