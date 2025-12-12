local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local cmp = require("cmp")
local cmp_dap = require("cmp_dap")
local default_config = require("cmp.config").get()
local inputs = require("lib.base.input")
local luasnip = require("luasnip")
local types = require("cmp.types")
local utils = require("plugin.util.cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<S-Tab>"] = utils.mapping.select_jump_prev_mappping,
    ["<Tab>"] = utils.mapping.select_jump_next_mapping,
    ["<C-P>"] = utils.mapping.select_jump_prev_mappping,
    ["<C-N>"] = utils.mapping.select_jump_next_mapping,
    ["<C-K>"] = cmp.mapping(
      cmp.mapping.select_prev_item({ select = false, behavior = cmp.SelectBehavior.Insert }),
      { "i", "c" }
    ),
    ["<C-J>"] = cmp.mapping(
      cmp.mapping.select_next_item({ select = false, behavior = cmp.SelectBehavior.Insert }),
      { "i", "c" }
    ),
    ["<C-U>"] = cmp.mapping.scroll_docs(-4),
    ["<C-D>"] = cmp.mapping.scroll_docs(4),
    ["<C-E>"] = cmp.mapping.close(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-CR>"] = utils.mapping.confirm_complete,
    ["<C-L>"] = utils.mapping.confirm_complete,
  }),

  sources = cmp.config.sources({
    {name = "lazydev"},
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
    { name = "nvim_lsp_signature_help" },
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item = utils.trim_redundant(vim_item)
      vim_item = utils.add_icon(vim_item)
      return vim_item
    end,
  },
  enabled = function()
    return vim.bo.buftype ~= "prompt" or cmp_dap.is_dap_buffer()
  end,
  preselect = cmp.PreselectMode.None,
  performance = {
    fetching_timeout = 50,
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline({
    ["<C-P>"] = { c = false },
    ["<C-N>"] = { c = false },
  }),
  sources = {
    { name = "buffer" },
  },
  performance = {
    max_view_entries = 20,
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline({
    ["<C-P>"] = { c = false },
    ["<C-N>"] = { c = false },
  }),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  }),
  matching = { disallow_symbol_nonprefix_matching = false },
  performance = {
    max_view_entries = 20,
  },
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = cmp.config.sources({
    { name = "dap" },
  }),
})

cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
  sources = cmp.config.sources({
    { name = "luasnip" },
    { name = "vim-dadbod-completion" },
    { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
  }),
  formatting = {
    format = function(entry, vim_item)
      if vim_item.menu == "[DB]" then
        vim_item.kind = "Database"
        vim_item.kind_hl_group = "Keyword"
        vim_item.menu = ""
      end
      vim_item = utils.trim_redundant(vim_item)
      vim_item = utils.add_icon(vim_item)
      return vim_item
    end,
  },
})

cmp.setup.filetype({ "go" }, {
  sorting = {
    comparators = (function()
      local comparators = vim.deepcopy(default_config.sorting.comparators)
      table.insert(comparators, 1, function(entry1, entry2)
        local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
        local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
        if kind1 ~= kind2 then
          if kind1 == types.lsp.CompletionItemKind.Field then
            return true
          end
          if kind2 == types.lsp.CompletionItemKind.Field then
            return false
          end
        end
        return nil
      end)
      return comparators
    end)(),
  },
})

keymap("n", "<Space>ip", function()
  inputs.norm("el")
  vim.cmd.startinsert()
  vim.schedule(function()
    cmp.complete()
    vim.cmd.sleep("100m")
    cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
  end)
end, { desc = "Import package" })

autocmd("InsertLeave", {
  callback = function()
    if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
      luasnip.unlink_current()
    end
  end,
})
