local M = {}

M.python_path = (function()
  local cwd = vim.fn.getcwd()
  local venvdirs = {"venv", ".venv"}

  for _, venvdir in pairs(venvdirs) do
    local venvpath = cwd .. "/" .. venvdir
    local pybin = venvpath .. "/bin/python"
    if vim.fn.executable(pybin) == 1 then return pybin end

    if vim.fn.isdirectory(venvpath) == 1 then
      for venvsubdir, filetype in vim.fs.dir(venvpath) do
        pybin = venvpath .. "/" .. venvsubdir .. "/bin/python"
        if filetype == "directory" and vim.fn.executable(pybin) == 1 then return pybin end
      end
    end
  end

  return "/usr/bin/python"
end)()

M.python_default_config = {
  type = "python",
  request = "launch",
  pythonPath = M.python_path,
}

return M
