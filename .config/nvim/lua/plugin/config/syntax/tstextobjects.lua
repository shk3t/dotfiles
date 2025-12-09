local keymap = vim.keymap.set
local move = require("nvim-treesitter-textobjects.move")
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

local keymaps = {
  select = {
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
  move = {
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
  },
  swap = {
    swap_previous = {
      ["c<a"] = "@parameter.inner",
      ["c<f"] = "@function.outer",
      ["c<j"] = "@code_cell.outer",
    },
    swap_next = {
      ["c>a"] = "@parameter.inner",
      ["c>f"] = "@function.outer",
      ["c>j"] = "@code_cell.outer",
    },
  },
}

for key, query in pairs(keymaps.select) do
  keymap({ "x", "o" }, key, function() -- TODO: replace all `v` to `x`
    select.select_textobject(query)
  end)
end

for action, entries in pairs(keymaps.move) do
  for key, query in pairs(entries) do
    keymap({ "n", "x", "o" }, key, function() -- TODO: do we really need `o`?
      move[action](query) -- TODO: [] function selection is slower?
    end)
  end
end

for action, entries in pairs(keymaps.swap) do
  for key, query in pairs(entries) do
    keymap("n", key, function()
      move[action](query)
    end)
  end
end
