local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local t = require("ashket.utils").t

-- Line numeration toggle
autocmd({"FocusLost", "WinLeave"}, {command = "set norelativenumber"})
autocmd({"FocusGained", "WinEnter", "BufEnter"}, {
  callback = function()
    if vim.o.number then
      vim.opt.relativenumber = true
    end
  end,
})

-- Open help in vertical split
autocmd("BufEnter", {
  pattern = "*.txt",
  callback = function()
    if vim.o.buftype == "help" then
      vim.cmd("wincmd L")
    end
  end,
})

-- Don't add the comment prefix when I hit o/O on a comment line.
autocmd("FileType", {command = "setlocal formatoptions+=r formatoptions-=co"})
autocmd("FileType", {
  pattern = "markdown",
  command = "setlocal formatoptions-=r",
})

-- Easy Window closing
local function map_easy_closing() keymap("n", "q", ":q<CR>", {
  buffer = true,
  silent = true,
}) end
autocmd("CmdwinEnter", {callback = map_easy_closing})
autocmd("FileType", {
  pattern = {"help", "dap-float"},
  callback = map_easy_closing,
})

-- Highlight yank
autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({timeout = 100}) end,
})

-- Colorscheme
autocmd({"Colorscheme", "SourcePost"}, {
  callback = require("ashket.colors").setup_colors,
})

-- Dap
autocmd("FileType", {
  pattern = "dap-repl",
  callback = function()
    keymap("i", "<C-K>", "<C-W>k", {buffer = true})
    keymap("i", "<C-L>", "<C-W>k", {buffer = true})
    keymap("i", "<C-Q>", "<C-W>k", {buffer = true})
    keymap("i", "<C-W>", "<C-O>db<BS>", {buffer = true})
    keymap("i", "<C-P>", "<Up><End>", {buffer = true, remap = true})
    keymap("i", "<C-N>", "<Down><End>", {buffer = true, remap = true})
    keymap("n", "<CR>", function()
      local line = unpack(vim.api.nvim_win_get_cursor(0))
      local current_buffer = vim.api.nvim_win_get_buf(0)
      local count = vim.api.nvim_buf_line_count(current_buffer)
      if line == count then
        vim.fn.execute(t("normal! <Insert><CR>"))
      else
        require("dap.ui").trigger_actions({mode = "first"})
      end
    end, {buffer = true, remap = true})
  end,
})
autocmd("BufEnter", {
  pattern = "dap-scopes*",
  callback = function()
    keymap("n", "<2-LeftMouse>", function() require("dap.ui").trigger_actions({
      mode = "first",
    }) end, {buffer = true})
  end,
})

-- Telescope
autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  command = "setlocal number | setlocal wrap",
})
