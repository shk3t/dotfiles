local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local lib = require("lib.main")

-- Line numeration toggle
autocmd({ "FocusLost", "WinLeave" }, { command = "setlocal norelativenumber" })
autocmd({ "VimEnter", "FocusGained", "WinEnter" }, {
  callback = function()
    if vim.o.number then
      vim.opt_local.relativenumber = true
    end
  end,
})
-- Dynamic autoscroll near window edges
autocmd({ "VimEnter", "WinEnter", "WinResized" }, {
  callback = function()
    vim.opt_local.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 5)
    vim.opt_local.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) / 5)
  end,
})

-- Open help | man in vertical split
autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype == "help" or vim.bo.filetype == "man" then
      vim.cmd.wincmd("L")
    end
  end,
})

-- Reset mapping for Cmd window
autocmd("CmdwinEnter", {
  callback = function()
    keymap("n", "<CR>", "<CR>", { buffer = true })
  end,
})

-- Don't add the comment prefix when I hit o/O on a comment line.
autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:append("r")
    vim.opt_local.formatoptions:remove("c")
    vim.opt_local.formatoptions:remove("o")
  end,
})
autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.formatoptions:remove("r")
  end,
})

-- Easy Window closing
local function map_easy_closing()
  keymap("n", "q", ":q<CR>", {
    buffer = true,
    silent = true,
  })
end
autocmd("CmdwinEnter", { callback = map_easy_closing })
autocmd("FileType", {
  pattern = { "help", "dap-float", "qf" },
  callback = map_easy_closing,
})

-- Highlight yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})

-- Yank preserve position
autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" then
      pcall(function()
        lib.norm("`m")
        vim.cmd.delmarks("m")
      end)
    end
  end,
})

-- Do not restore deleted marks
autocmd("VimLeavePre", { command = "wshada!" })

-- Dap

-- Sql
autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    keymap("n", "<C-CR>", "mmvip<Plug>(DBUI_ExecuteQuery)", { buffer = true })
    keymap("x", "<C-CR>", "mm<Plug>(DBUI_ExecuteQuery)", { buffer = true })
    keymap({ "n", "x" }, "<C-S>", ":<C-U>write<CR><Plug>(DBUI_SaveQuery)", { buffer = true })
    keymap({ "n", "x" }, "<C-S>", ":<C-U>write<CR><Plug>(DBUI_SaveQuery)", { buffer = true })
    keymap({ "n", "x" }, "<Space>E", "<Plug>(DBUI_EditBindParameters)", { buffer = true })
  end,
})
autocmd("FileType", {
  pattern = "dbui",
  callback = function()
    vim.opt_local.shiftwidth = 2
    keymap("n", "D", "<Plug>(DBUI_DeleteLine)", { buffer = true })
    keymap("n", "h", "<Plug>(DBUI_GotoParentNode)<Plug>(DBUI_SelectLine)", { buffer = true })
    keymap("n", "l", "<Plug>(DBUI_SelectLine)", { buffer = true })
  end,
})
autocmd("FileType", {
  pattern = "dbout",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.wrap = false
    vim.opt_local.cursorlineopt = "line"
    vim.opt_local.foldenable = false
    vim.diagnostic.enable(false)
  end,
})

-- Telescope
autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.wrap = true
    vim.opt_local.cursorline = true
  end,
})
-- Aerial
autocmd("FileType", {
  pattern = "aerial",
  callback = function()
    vim.opt_local.cursorlineopt = "line"
  end,
})
-- Git blame
autocmd("FileType", {
  pattern = "blame",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.wrap = false
    vim.opt_local.cursorlineopt = "line"
  end,
})
