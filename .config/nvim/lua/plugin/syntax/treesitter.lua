local autocmd = vim.api.nvim_create_autocmd

require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
