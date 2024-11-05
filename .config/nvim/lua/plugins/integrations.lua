local keymap = vim.keymap.set
local nabla = require("nabla")
local VERTICAL_BORDERS = require("lib.consts").VERTICAL_BORDERS
local autocmd = vim.api.nvim_create_autocmd

-- Image rendering support
local image_cfg = {
  backend = "ueberzug", -- Kitty will provide the best experience, but you need a compatible terminal
  integrations = {}, -- do whatever you want with image.nvim's integrations
  max_width = 100, -- tweak to preference
  max_height = 18, -- ^
  max_height_window_percentage = math.huge, -- this is necessary for a good experience
  max_width_window_percentage = math.huge,
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
}
require("image").setup(image_cfg)
-- autocmd("FileType", {
--   pattern = { "molten_output" },
--   callback = function() 
--     require("image").setup(image_cfg)
--   end,
-- })

-- Markdown preview
vim.g.mkdp_auto_close = 0

-- Latex preview
keymap("n", "<Space>lk", function()
  nabla.popup({ border = VERTICAL_BORDERS })
end)
keymap("n", "<Space>LK", nabla.toggle_virt)
