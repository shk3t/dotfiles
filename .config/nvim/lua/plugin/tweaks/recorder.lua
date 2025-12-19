local consts = require("consts")

require("recorder").setup({
  slots = { "a", "b" },
  dynamicSlots = "static",
  mapping = {
    startStopRecording = "q",
    playMacro = "@",
    switchSlot = "Q",
    editMacro = "cq",
    deleteAllMacros = "dq",
    yankMacro = "yq",
    addBreakPoint = [[\b]],
  },
  clear = false,
  logLevel = vim.log.levels.OFF,
  lessNotifications = true,
  useNerdfontIcons = consts.ICONS.ENABLED,
})
