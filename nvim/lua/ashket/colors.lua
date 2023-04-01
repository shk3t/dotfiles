vim.cmd [[colorscheme rose-pine]]


local colorscheme_setups = {
    ["default"] = function()
        vim.fn.sign_define("DapBreakpoint", {text = "󰪥", texthl = "Error"})
        vim.fn.sign_define("DapStopped", {text = "ඞ", texthl = "Error", linehl="CursorLine"})
    end,
    ["rose-pine"] = function()
        require("rose-pine").setup({disable_italics = true})
        -- local palette = require("rose-pine.palette")
        -- vim.api.nvim_set_hl(0, "DapBreakpoint", {fg = palette.gold})
        -- vim.api.nvim_set_hl(0, "DapStopped", {fg = palette.love})
    end,
    ["calvera"] = function() vim.g.calvera_borders = true end,
}

colorscheme_setups.default()

for colorscheme, setup in pairs(colorscheme_setups) do
    if vim.g.colors_name == colorscheme then
        setup()
        return
    end
end
