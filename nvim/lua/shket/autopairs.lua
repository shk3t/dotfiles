local autopairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

autopairs.setup({
    disable_filetype = {"TelescopePrompt"},
    disable_in_macro = false, -- disable when recording or executing a macro
    disable_in_visualblock = false, -- disable when insert after visual block mode
    ignored_next_char = [=[[%w%%%'%[%"%.ёйцукенгшщзхъфывапролджэячсмитьбю%$%(%{%`%*]]=],
    enable_moveright = true,
    enable_afterquote = false, -- add bracket pairs after quote
    enable_check_bracket_line = true, -- check bracket in same line
    enable_bracket_in_quote = true,
    check_ts = true,
    map_cr = true,
    map_bs = true, -- map the <BS> key
    map_c_h = false, -- Map the <C-h> key to delete a pair
    map_c_w = false, -- map <c-w> to delete a pair if possible
})

for _, punct in pairs {",", ";"} do
    autopairs.add_rules {
        Rule("", punct):with_move(function(opts)
            return opts.char == punct
        end):with_pair(cond.none()):with_del(cond.none()):with_cr(cond.none()):use_key(punct),
    }
end

require("nvim-ts-autotag").setup({
    -- filetypes = {
    --     "html",
    --     "htmldjango",
    --     "javascript",
    --     "typescript",
    --     "javascriptreact",
    --     "typescriptreact",
    --     "markdown",
    -- },
})
