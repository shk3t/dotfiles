local highlight = require("lib.base.color").highlight

local function setup_mark_colors()
  highlight("MarkSignNumHL", { link = "NONE" })
end

return { setup = setup_mark_colors }
