local autocmd = vim.api.nvim_create_autocmd
local consts = require("consts")
local highlight = require("lib.base.color").highlight

local function set_wide_border()
  local vert_split_fg = vim.api.nvim_get_hl(0, { name = "WinSeparator" }).fg
  highlight("WinSeparator", { bg = vert_split_fg })
end

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

  vim.opt.pumblend = consts.TRANSPARENCY
  vim.opt.winblend = consts.TRANSPARENCY
  highlight("Pmenu", { blend = consts.TRANSPARENCY })
  highlight("PmenuSel", { blend = 0 })
  highlight("FloatBorder", { blend = consts.TRANSPARENCY })
  highlight("NormalFloat", { blend = consts.TRANSPARENCY })
end

local function clear_spell_check_highlights()
  highlight("SpellBad", { undercurl = false })
  highlight("SpellCap", { undercurl = false })
  highlight("SpellRare", { undercurl = false })
  highlight("SpellLocal", { undercurl = false })
end

local colorscheme_setups = {
  ["rose-pine"] = function()
    require("rose-pine").setup({
      styles = {
        italic = false,
      },
    })
  end,
  ["calvera"] = function()
    vim.g.calvera_borders = true
  end,
}

autocmd("Colorscheme", {
  callback = function()
    highlight("CursorLineNr", { bold = true })
    set_wide_border()
    set_transparent_bg()
    clear_spell_check_highlights()
  end,
})

return {
  setup = function()
    colorscheme_setups[consts.COLORSCHEME]()
    vim.cmd.colorscheme(consts.COLORSCHEME)
  end,
}
