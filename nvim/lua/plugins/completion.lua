local cmp = require("cmp")
local consts = require("lib.consts")
local luasnip = require("luasnip")

local confirm_complete = function()
  if cmp.visible() then
    cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
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
    ["<C-E>"] = cmp.mapping.close(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-CR>"] = confirm_complete,
    ["<C-K>"] = cmp.mapping(
      cmp.mapping.select_prev_item({
        select = false,
        behavior = cmp.SelectBehavior.Insert,
      }),
      { "i", "c" }
    ),
    ["<C-J>"] = cmp.mapping(
      cmp.mapping.select_next_item({
        select = false,
        behavior = cmp.SelectBehavior.Insert,
      }),
      { "i", "c" }
    ),
    ["<C-P>"] = cmp.mapping.select_prev_item(),
    ["<C-N>"] = cmp.mapping.select_next_item(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      elseif cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    -- { name = "codeium" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
    -- {name = "spell"},
    { name = "nvim_lsp_signature_help" },
  }),
  formatting = {
    format = function(entry, vim_item)
      for _, redundant_pattern in pairs({ "%(.*%)", "~", "?" }) do
        vim_item.abbr = vim_item.abbr:gsub(redundant_pattern, "")
      end
      if consts.ICONS_ENABLED then
        vim_item.kind = ("%s %s"):format(consts.CMP_KIND_ICONS[vim_item.kind], vim_item.kind)
      end
      if vim_item.kind:find("Codeium") then
        vim_item.kind_hl_group = "Error"
      end
      return vim_item
    end,
  },
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
  preselect = cmp.PreselectMode.None,
  performance = {
    fetching_timeout = 50,
    -- max_view_entries = 20,
  },
  experimental = {
    ghost_text = false, -- this feature conflict with copilot.vim's preview.
  },
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = cmp.config.sources({ { name = "dap" } }),
})

cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
  sources = cmp.config.sources({
    { name = "vim-dadbod-completion" },
    { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
    -- {name = "spell"},
  }),
  formatting = {
    format = function(entry, vim_item)
      if consts.ICONS_ENABLED then
        vim_item.kind = ("%s %s"):format(consts.CMP_KIND_ICONS[vim_item.kind], vim_item.kind)
      end
      if vim_item.menu == "[DB]" then
        vim_item.kind = "Database"
        vim_item.kind_hl_group = "Keyword"
        vim_item.menu = ""
      end
      return vim_item
    end,
  },
})

require("luasnip.loaders.from_vscode").lazy_load()

-- require("codeium").setup({
--   -- enable_chat = true,
-- })
