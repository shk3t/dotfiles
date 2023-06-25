-- default values
require("recorder").setup {
  -- Named registers where macros are saved. The first register is the default
  -- register/macro-slot used after startup. 
  slots = {"q", "b"},

  -- default keymaps, see README for description what the commands do
  mapping = {
    startStopRecording = "q",
    playMacro = "@",
    switchSlot = "Q",
    editMacro = "cq",
    yankMacro = "yq", -- also decodes it for turning macros to mappings
    addBreakPoint = [[\b]], -- ⚠️ this should be a string you don't use in insert mode during a macro
  },

  -- clears all macros-slots on startup
  clear = false,

  -- log level used for any notification, mostly relevant for nvim-notify
  -- (note that by default, nvim-notify does not show the levels trace and debug.)
  logLevel = vim.log.levels.OFF,

  
	-- if enabled, only essential or critical notifications are sent.
	-- If you do not use a plugin like nvim-notify, set this to `true`
	-- to remove otherwise annoying notifications.
	lessNotifications = true,

  -- experimental, see README
  dapSharedKeymaps = false,
}
