local api = require("tabby.module.api")
local buf_name = require("tabby.feature.buf_name")

local theme = {
  fill = "TabLineFill",
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = "TabLine",
  current_tab = "TabLineSel",
  tab = "TabLine",
  win = "TabLine",
  tail = "TabLine",
}

require("tabby.tabline").set(function(line)
  return {
    {{"", hl = theme.head}, line.sep("", theme.head, theme.fill)},
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.tab
      return {" ", tab.number(), ":{", tab.name(), "} ", hl = hl}
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      local hl = win.is_current() and theme.current_tab or theme.tab
      return {" ", win.buf_name(), " ", hl = hl}
    end),
    {line.sep("", theme.tail, theme.fill), {"", hl = theme.tail}},
    hl = theme.fill,
  }
end, {
  tab_name = {
    name_fallback = function(tabid)
      local wins = api.get_tab_wins(tabid)
      local cur_win = api.get_tab_current_win(tabid)
      local buf_name = buf_name.get(cur_win)

      if api.is_float_win(cur_win) then
        return "Floating"
      end
      if buf_name == "[No Name]" then
        return "No Name"
      end

      return buf_name
    end,
  },
})
