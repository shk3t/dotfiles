local M = {}

function M.replace_termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.typekeys(keyseq)
  vim.api.nvim_feedkeys(M.replace_termcodes(keyseq), "t", false)
end

function M.norm(command)
  vim.cmd("normal! " .. M.replace_termcodes(command))
end

function M.rnorm(command)
  vim.cmd("normal " .. M.replace_termcodes(command))
end

function M.tnorm(command)
  M.typekeys("<C-\\><C-O>")
  vim.cmd("normal! " .. M.replace_termcodes(command))
end

return M
