local keymap = vim.keymap.set

keymap({ "n", "v" }, "<F5>", vim.cmd.MarkdownPreviewToggle, { buffer = true })
