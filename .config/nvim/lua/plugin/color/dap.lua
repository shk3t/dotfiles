local sign_define = vim.fn.sign_define

local function define_dap_signs()
  sign_define("DapBreakpoint", { text = "󰪥", texthl = "Error" })
  sign_define("DapStopped", {
    text = "ඞ",
    texthl = "Error",
    linehl = "CursorLine",
  })
  sign_define("DapBreakpointCondition", { text = "󰘥", texthl = "WarningMsg" })
  sign_define("DapLogPoint", { text = "󰗖", texthl = "MoreMsg" })
end
define_dap_signs()
