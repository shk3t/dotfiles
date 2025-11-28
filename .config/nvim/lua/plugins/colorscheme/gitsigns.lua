local highlight = require("lib.utils").highlight
local consts = require("lib.consts")

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
