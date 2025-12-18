local autocmd = vim.api.nvim_create_autocmd
local consts = require("consts")
local highlight = require("lib.base.color").highlight

local function set_transparent_bg()
  if consts.TRANSPARENCY == 0 then
    return
  end

  highlight("Normal", { bg = "NONE" })
  highlight("NormalNC", { bg = "NONE" })
  highlight("NonText", { bg = "NONE" })
  highlight("LineNr", { bg = "NONE" })
  highlight("SignColumn", { bg = "NONE" })
  highlight("TabLineFill", { bg = "NONE" })
  highlight("TabLine", { bg = "NONE" })

  vim.o.pumblend = consts.TRANSPARENCY
  vim.o.winblend = consts.TRANSPARENCY
  highlight("Pmenu", { blend = consts.TRANSPARENCY })
  highlight("PmenuSel", { blend = 0 })
  highlight("NormalFloat", { blend = consts.TRANSPARENCY })
  highlight("FloatBorder", { blend = consts.TRANSPARENCY })
end

local setup = function()
  highlight("CursorLineNr", { bold = true })
  set_transparent_bg()
end

autocmd("Colorscheme", { callback = setup })
