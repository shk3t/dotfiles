local M = {}

M.replace_termcodes = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.norm = function(command)
  vim.cmd("normal! " .. M.replace_termcodes(command))
end

M.rnorm = function(command)
  vim.cmd("normal " .. M.replace_termcodes(command))
end

M.tnorm = function(command)
  M.typekeys("<C-\\><C-O>")
  vim.cmd("normal! " .. M.replace_termcodes(command))
end

M.typekeys = function(keyseq)
  vim.api.nvim_feedkeys(M.replace_termcodes(keyseq), "t", false)
end

return M
