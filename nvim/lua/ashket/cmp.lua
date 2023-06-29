local cmp = require("cmp")
local luasnip = require("luasnip")
local print_table = require("ashket.utils").print_table

local confirm_complete = function()
  if cmp.visible() then
    cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})
  else
    cmp.complete()
  end
end

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
      luasnip.unlink_current()
    end
  end,
})

cmp.setup({
  snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
  mapping = cmp.mapping.preset.insert({
    ["<C-U>"] = cmp.mapping.scroll_docs(-4),
    ["<C-D>"] = cmp.mapping.scroll_docs(4),
    ["<C-B>"] = cmp.mapping.scroll_docs(-8),
    ["<C-F>"] = cmp.mapping.scroll_docs(8),
    -- ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-E>"] = cmp.mapping.close(),
    -- ["<C-H>"] = cmp.mapping.abort(),
    -- ["<C-L>"] = confirm_complete,
    ["<C-CR>"] = confirm_complete,
    ["<C-K>"] = cmp.mapping(cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Insert,
    }), {"i", "c"}),
    ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Insert,
    }), {"i", "c"}),
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
    {name = "luasnip"},
    {name = "nvim_lsp"},
    {name = "path"},
    {name = "buffer", option = {keyword_pattern = [[\k\+]]}}, -- I should think about it
    {name = "nvim_lsp_signature_help"},
    -- { name = "cmp_tabnine" },
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.abbr = string.gsub(vim_item.abbr, "%(.*%)", "")
      vim_item.abbr = string.gsub(vim_item.abbr, "~", "")
      -- vim_item.dup = ({buffer = 0, luasnip = 0})[entry.source.name]
      return vim_item
    end,
  },
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
})

cmp.setup.filetype({"dap-repl", "dapui_watches", "dapui_hover"}, {
  sources = cmp.config.sources({{name = "dap"}}),
})

require("luasnip.loaders.from_vscode").lazy_load()

luasnip.filetype_extend("htmldjango", {"html"})

-- load snippets from path/of/your/nvim/config/my-cool-snippets
-- require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./my-cool-snippets" } })
