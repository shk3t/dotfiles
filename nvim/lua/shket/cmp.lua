local cmp = require("cmp")
local luasnip = require("luasnip")

vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
            luasnip.unlink_current()
        end
    end,
})

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-U>"] = cmp.mapping.scroll_docs(-4),
        ["<C-D>"] = cmp.mapping.scroll_docs(4),
        ["<C-B>"] = cmp.mapping.scroll_docs(-8),
        ["<C-F>"] = cmp.mapping.scroll_docs(8),
        -- ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-E>"] = cmp.mapping.close(),
        -- ["<C-H>"] = cmp.mapping.abort(),
        ["<C-L>"] = function()
            if cmp.visible() then
                cmp.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                })
            else
                cmp.complete()
            end
        end,
        ["<C-K>"] = cmp.mapping(cmp.mapping.select_prev_item(), {"i", "c"}),
        ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item(), {"i", "c"}),
        ["<C-P>"] = cmp.mapping.select_prev_item(),
        ["<C-N>"] = cmp.mapping.select_next_item(),
        -- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        -- ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
                -- if luasnip.expand_or_jumpable() then
                --     luasnip.expand_or_jump()
            elseif cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            elseif cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, {"i", "s"}),
    }),

    sources = cmp.config.sources({
        {name = "path"},
        {name = "luasnip"},
        {name = "nvim_lsp"},
        {name = "buffer"},
        {name = "nvim_lsp_signature_help"},
        -- { name = "cmp_tabnine" },
    }),
})

-- cmp.setup.filetype({"javascript", "javascriptreact", "typescript", "typescriptreact"}, {
--     sources = cmp.config.sources({
--         {name = "luasnip"},
--         {name = "nvim_lsp"},
--         {name = "buffer"},
--         {name = "nvim_lsp_signature_help"},
--     })
-- })


require("luasnip.loaders.from_vscode").lazy_load()

luasnip.filetype_extend("htmldjango", {"html"})

-- load snippets from path/of/your/nvim/config/my-cool-snippets
-- require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./my-cool-snippets" } })

-- local tabnine = require('cmp_tabnine.config')
-- tabnine:setup({
--	max_lines = 1000;
--	max_num_results = 20;
--	sort = true;
--	run_on_every_keystroke = true;
--	snippet_placeholder = '..';
--	ignored_file_types = { -- default is not to ignore
--		-- uncomment to ignore in lua:
--		-- lua = true
--	};
--	show_prediction_strength = false;
-- })
