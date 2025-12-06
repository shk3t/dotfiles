local highlight = require("lib.base.color").highlight

local function setup_mark_colors()
  highlight("MarkSignNumHL", { link = 0 })
end

return { setup = setup_mark_colors }
