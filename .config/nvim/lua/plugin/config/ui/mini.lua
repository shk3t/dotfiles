local consts = require("consts")

if consts.ICONS.ENABLED then
  local icons = require("mini.icons")
  icons.setup()
  icons.mock_nvim_web_devicons()
end
