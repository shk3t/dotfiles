local cmp = require("cmp")
local consts = require("consts")
local inputs = require("lib.base.input")
local luasnip = require("luasnip")

local cmp_icons = consts.ICONS.CMP_KIND

local M = {}

M.trim_redundant = function(vim_item)
  for _, redundant_pattern in pairs({ "%(.*%)", "~", "?" }) do
    vim_item.abbr = vim_item.abbr:gsub(redundant_pattern, "")
  end
  return vim_item
end

M.add_icon = function(vim_item)
  if consts.ICONS.ENABLED then
    vim_item.kind = ("%s %s"):format(cmp_icons[vim_item.kind], vim_item.kind)
  end
  return vim_item
end

M.mapping = {
  confirm_complete = cmp.mapping(function(_)
    if cmp.visible() then
      cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
      if vim.fn.mode() == "c" then
        inputs.typekeys("<CR>")
      end
    else
      cmp.complete()
    end
  end, { "i", "c" }),

  select_jump_prev = cmp.mapping(function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    elseif cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { "i", "s" }),

  select_jump_next = cmp.mapping(function(fallback)
    if luasnip.jumpable(1) then
      luasnip.jump(1)
    elseif cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { "i", "s" }),
}

return M
