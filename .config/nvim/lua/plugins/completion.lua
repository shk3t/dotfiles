local cmp = require("cmp")
local consts = require("lib.consts")
local lib = require("lib.main")
local luasnip = require("luasnip")
local autocmd = vim.api.nvim_create_autocmd

local confirm_complete = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
    if vim.fn.mode() == "c" then
      vim.api.nvim_input("<CR>")
    end
  else
    cmp.complete()
  end
end, { "i", "c" })

local select_jump_prev_mappping = cmp.mapping(function(fallback)
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  elseif cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end, { "i", "s" })
local select_jump_next_mapping = cmp.mapping(function(fallback)
  if luasnip.jumpable(1) then
    luasnip.jump(1)
  elseif cmp.visible() then
    cmp.select_next_item()
  else
    fallback()
  end
end, { "i", "s" })

autocmd("InsertLeave", {
  callback = function()
    if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
      luasnip.unlink_current()
    end
  end,
})

local function trim_redundant(vim_item)
  for _, redundant_pattern in pairs({ "%(.*%)", "~", "?" }) do
    vim_item.abbr = vim_item.abbr:gsub(redundant_pattern, "")
  end
  return vim_item
end

local function add_icon(vim_item)
  if consts.ICONS_ENABLED then
    vim_item.kind = ("%s %s"):format(consts.CMP_KIND_ICONS[vim_item.kind], vim_item.kind)
  end
  return vim_item
end

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
    -- ["<C-L>"] = confirm_complete,
    ["<C-Y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
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
    ["<C-P>"] = select_jump_prev_mappping,
    ["<C-N>"] = select_jump_next_mapping,
    ["<S-Tab>"] = select_jump_prev_mappping,
    ["<Tab>"] = select_jump_next_mapping,
  }),

  sources = cmp.config.sources({
    { name = "codeium" },
    -- { name = "cmp_ai" },
    { name = "luasnip" },
    { name = "lazydev" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
    -- {name = "spell"},
    { name = "nvim_lsp_signature_help" },
  }),
  formatting = {
    format = function(entry, vim_item)
      -- if entry.source.source.client and entry.source.source.client.name == "tabby_ml" then
      --   vim_item.kind_hl_group = "Error"
      --   vim_item.kind = "Tabby"
      -- end
      if vim_item.kind:find("Codeium") then
        vim_item.kind_hl_group = "Error"
      end
      vim_item = trim_redundant(vim_item)
      vim_item = add_icon(vim_item)
      return vim_item
    end,
  },
  enabled = function()
    return vim.bo.buftype ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
  preselect = cmp.PreselectMode.None,
  performance = {
    fetching_timeout = 50,
    -- max_view_entries = 20,
  },
  experimental = {
    ghost_text = false, -- this feature conflict with copilot.vim's preview.
  },
  -- window =vim
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline({
    ["<C-n>"] = {
      c = false,
    },
    ["<C-p>"] = {
      c = false,
    },
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
    ["<C-n>"] = {
      c = false,
    },
    ["<C-p>"] = {
      c = false,
    },
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
    { name = "codeium" },
    { name = "luasnip" },
    { name = "vim-dadbod-completion" },
    { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
    -- {name = "spell"},
  }),
  formatting = {
    format = function(entry, vim_item)
      if vim_item.kind:find("Codeium") then
        vim_item.kind_hl_group = "Error"
      end
      if vim_item.menu == "[DB]" then
        vim_item.kind = "Database"
        vim_item.kind_hl_group = "Keyword"
        vim_item.menu = ""
      end
      vim_item = trim_redundant(vim_item)
      vim_item = add_icon(vim_item)
      return vim_item
    end,
  },
})

require("luasnip.loaders.from_vscode").lazy_load()
require("global.snippets")

-- require("cmp_ai.config"):setup({
--   max_lines = 1000,
--   provider = "Tabby",
--   notify = true,
--   provider_options = {
--     -- These are optional
--     -- user = 'yourusername',
--     -- temperature = 0.2,
--     -- seed = 'randomstring',
--   },
--   notify_callback = function(msg)
--     vim.notify(msg)
--   end,
--   run_on_every_keystroke = true,
--   ignored_file_types = {
--     -- default is not to ignore
--     -- uncomment to ignore in lua:
--     -- lua = true
--   },
-- })
