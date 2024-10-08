local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local jlib = require("lib.jupyter")
local quarto = require("quarto")

local opts = { silent = true }

keymap("v", "<Space>j", ":<C-U>MoltenEvaluateVisual<CR>", opts)
keymap("n", "<Space>jl", vim.cmd.MoltenEvaluateLine, opts)
keymap("n", "<Space>jr", vim.cmd.MoltenReevaluateCell, opts)
keymap("n", "<Space>jd", vim.cmd.MoltenDelete, opts)
keymap("n", "<Space>jk", vim.cmd.MoltenShowOutput, opts)
keymap("n", "<Space>jh", vim.cmd.MoltenHideOutput, opts)

keymap("n", "<Space>JI", vim.cmd.MoltenInit, opts)
keymap("n", "<Space>JD", vim.cmd.MoltenDeinit, opts)
keymap("n", "<Space>JR", vim.cmd.MoltenRestart, opts)
keymap("n", "<Space>JQ", vim.cmd.MoltenInterrupt, opts)
keymap("n", "<Space>JS", vim.cmd.MoltenSave, opts)
keymap("n", "<Space>JL", vim.cmd.MoltenLoad, opts)

vim.g.magma_automatically_open_output = true
vim.g.magma_output_window_borders = false
vim.g.molten_auto_open_output = false
vim.g.molten_image_provider = "image.nvim"
vim.g.molten_wrap_output = true
vim.g.molten_virt_text_output = true
vim.g.molten_virt_lines_off_by_1 = true

-- Jupyter notebook `.ipynb` files conversion
require("jupytext").setup({
  style = "markdown",
  output_extension = "md",
  force_ft = "markdown",
})

-- Quarto: Molten LSP integration
quarto.setup({
  lspFeatures = {
    -- NOTE: put whatever languages you want here:
    languages = { "r", "python", "rust" },
    chunks = "all",
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  keymap = {
    -- NOTE: setup your own keymaps:
    hover = "H",
    definition = "gd",
    rename = "<leader>rn",
    references = "gr",
    format = "<leader>gf",
  },
  codeRunner = {
    enabled = true,
    default_method = "molten",
  },
})
-- activate LSP on entering markdown buffer
autocmd("FileType", {
  pattern = "markdown",
  callback = quarto.activate,
})
-- automatically import output chunks from a jupyter notebook
autocmd("BufAdd", {
  pattern = { "*.ipynb" },
  callback = jlib.init_molten_buffer,
})
-- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
autocmd("BufEnter", {
  pattern = { "*.ipynb" },
  callback = function(e)
    if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
      jlib.init_molten_buffer(e)
      vim.bo.filetype = "markdown"
    end
  end,
})
-- automatically export output chunks to a jupyter notebook on write
autocmd("BufWritePost", {
  pattern = { "*.ipynb" },
  callback = function()
    if require("molten.status").initialized() == "Molten" then
      vim.cmd("MoltenExportOutput!")
    end
  end,
})
-- local runner = require("quarto.runner")
-- vim.keymap.set("n", "<Space>qc", runner.run_cell, opts)
-- vim.keymap.set("n", "<Space>qa", runner.run_above, opts)
-- vim.keymap.set("n", "<Space>qA", runner.run_all, opts)
-- vim.keymap.set("n", "<Space>ql", runner.run_line, opts)
-- vim.keymap.set("v", "<Space>q", runner.run_range, opts)
-- vim.keymap.set("n", "<Space>QA", function()
--   runner.run_all(true)
-- end, opts)
