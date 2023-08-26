local keymap = vim.keymap.set

-- jupytext
vim.g.jupytext_fmt = "py"

-- Magma.nvim
keymap("v", "<Space>m", ":<C-U>MagmaEvaluateVisual<CR>")
keymap("n", "<Space>ml", vim.cmd.MagmaEvaluateLine)
keymap("n", "<Space>mr", vim.cmd.MagmaReevaluateCell)
keymap("n", "<Space>md", vim.cmd.MagmaDelete)
keymap("n", "<Space>mk", vim.cmd.MagmaShowOutput)

keymap("n", "<Space>MD", vim.cmd.MagmaDeinit)
keymap("n", "<Space>MR", vim.cmd.MagmaRestart)
keymap("n", "<Space>MQ", vim.cmd.MagmaInterrupt)
keymap("n", "<Space>MS", vim.cmd.MagmaSave)
keymap("n", "<Space>ML", vim.cmd.MagmaLoad)

vim.g.magma_automatically_open_output = true
vim.g.magma_output_window_borders = false
vim.g.magma_image_provider = "kitty"
