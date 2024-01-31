local keymap = vim.keymap.set

-- jupytext
vim.g.jupytext_fmt = "py"

-- Magma.nvim
keymap("x", "<Space>j", ":<C-U>MagmaEvaluateVisual<CR>")
keymap("n", "<Space>jl", vim.cmd.MagmaEvaluateLine)
keymap("n", "<Space>jr", vim.cmd.MagmaReevaluateCell)
keymap("n", "<Space>jd", vim.cmd.MagmaDelete)
keymap("n", "<Space>jk", vim.cmd.MagmaShowOutput)

keymap("n", "<Space>JD", vim.cmd.MagmaDeinit)
keymap("n", "<Space>JR", vim.cmd.MagmaRestart)
keymap("n", "<Space>JQ", vim.cmd.MagmaInterrupt)
keymap("n", "<Space>JS", vim.cmd.MagmaSave)
keymap("n", "<Space>JL", vim.cmd.MagmaLoad)

vim.g.magma_automatically_open_output = true
vim.g.magma_output_window_borders = false
vim.g.magma_image_provider = "kitty"
