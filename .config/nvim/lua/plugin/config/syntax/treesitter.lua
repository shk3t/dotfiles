require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.treesitter.start()
  end,
})

-- TODO
-- incremental_selection = {
--   enable = true,
--   keymaps = {
--     node_incremental = "n",
--     node_decremental = "N",
--   },
-- },

-- keymap("v", "n", function()
--   require("nvim-treesitter.incremental_selection").node_incremental()
--   inputs.norm("o")
-- end)
-- keymap("v", "N", function()
--   require("nvim-treesitter.incremental_selection").node_decremental()
--   inputs.norm("o")
-- end)
