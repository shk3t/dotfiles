local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local jlib = require("lib.jupyter")
local quarto = require("quarto")
local VERTICAL_BORDERS = require("lib.consts").VERTICAL_BORDERS
local ulib = require("lib.utils")

local opts = { silent = true }

keymap("v", "<Space>j", ulib.preserve_location(":<C-U>MoltenEvaluateVisual<CR>"), { silent = true })
keymap("n", "<Space>jl", vim.cmd.MoltenEvaluateLine, opts)
keymap("n", "<Space>jr", vim.cmd.MoltenReevaluateCell, opts)
keymap("n", "<Space>jd", vim.cmd.MoltenDelete, opts)
keymap("n", "<Space>jk", function()
  ulib.norm("zt")
  vim.cmd("noautocmd MoltenEnterOutput")
  ulib.map_easy_closing()
end, opts)
keymap("n", "<Space>jq", vim.cmd.MoltenInterrupt, opts)
keymap("n", "<Space>jj", function()
  ulib.rnorm("vij")
  ulib.norm(":<C-U>MoltenEvaluateVisual<CR>")
end, { silent = true })

keymap("n", "<Space>JA", vim.cmd.MoltenReevaluateAll, opts)
keymap("n", "<Space>JI", vim.cmd.MoltenInit, opts)
keymap("n", "<Space>JD", vim.cmd.MoltenDeinit, opts)
keymap("n", "<Space>JR", vim.cmd.MoltenRestart, opts)
keymap("n", "<Space>JS", vim.cmd.MoltenSave, opts)
keymap("n", "<Space>JL", vim.cmd.MoltenLoad, opts)

vim.g.magma_automatically_open_output = true
vim.g.magma_output_window_borders = false
vim.g.molten_auto_open_output = false
vim.g.molten_image_provider = "image.nvim"
vim.g.molten_image_location = "float"
vim.g.molten_wrap_output = true
vim.g.molten_virt_text_output = false
vim.g.molten_virt_lines_off_by_1 = false
vim.g.molten_output_win_border = "none"
vim.g.molten_enter_output_behavior = "open_and_enter"
vim.g.molten_tick_rate = 200

-- Use venv packages by default
if ulib.python_path ~= ulib.DEFAULT_PYTHON_PATH then
  vim.g.python3_host_prog = ulib.python_path
end

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
    -- diagnostics = {
    --   enabled = true,
    --   triggers = { "InsertLeave", "TextChanged" },
    -- },
    -- completion = {
    --   enabled = true,
    -- },
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
      keymap("n", "<Space>JS", function()
        vim.cmd("MoltenExportOutput!")
      end, opts)
      keymap("n", "<Space>JL", vim.cmd.MoltenImportOutput, opts)
    end
  end,
})
vim.api.nvim_create_user_command("NewNotebook", function(opts)
  jlib.new_notebook(opts.args)
end, {
  nargs = 1,
  complete = "file",
})
