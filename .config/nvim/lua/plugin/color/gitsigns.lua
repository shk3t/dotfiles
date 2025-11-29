local consts = require("consts")
local highlight = require("lib.base.color").highlight

local function setup_gitsigns()
  if consts.TRANSPARENCY == 0 then
    return
  end

  highlight("GitSignsUntracked", { bg = "NONE" })
  highlight("GitSignsTopdelete", { bg = "NONE" })
  highlight("GitSignsChangedelete", { bg = "NONE" })
  highlight("GitSignsDelete", { bg = "NONE" })
  highlight("GitSignsChange", { bg = "NONE" })
  highlight("GitSignsAdd", { bg = "NONE" })
end

return { setup = setup_gitsigns }
