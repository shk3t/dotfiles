local keymap = vim.keymap.set

keymap({ "n", "x" }, "<F5>", vim.cmd.MarkdownPreviewToggle, { buffer = true })
