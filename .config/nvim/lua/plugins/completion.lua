local cmp = require("cmp")
local consts = require("lib.consts")
local luasnip = require("luasnip")
local autocmd = vim.api.nvim_create_autocmd

local confirm_complete = function()
  if cmp.visible() then
    cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
  else
    cmp.complete()
  end
end

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
    -- { name = "codeium" },
    -- { name = "cmp_ai" },
    { name = "luasnip" },
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
      -- if vim_item.kind:find("Codeium") then
      --   vim_item.kind_hl_group = "Error"
      -- end
      vim_item = trim_redundant(vim_item)
      vim_item = add_icon(vim_item)
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
  sources = cmp.config.sources({ { name = "dap" } }),
})

cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
  sources = cmp.config.sources({
    { name = "luasnip" },
    { name = "vim-dadbod-completion" },
    { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
    -- {name = "spell"},
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item = trim_redundant(vim_item)
      vim_item = add_icon(vim_item)
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
require("local.snippets")

-- require("codeium").setup({
--   -- enable_chat = true,
-- })

-- require("gen").setup({
--   model = "deepseek-coder-v2", -- The default model to use.
--   quit_map = "q", -- set keymap for close the response window
--   retry_map = "<C-R>", -- set keymap to re-send the current prompt
--   accept_map = "<C-CR>", -- set keymap to replace the previous selection with the last result
--   host = "localhost", -- The host running the Ollama service.
--   port = "11434", -- The port on which the Ollama service is listening.
--   display_mode = "split", -- The display mode. Can be "float" or "split" or "horizontal-split".
--   show_prompt = true, -- Shows the prompt submitted to Ollama.
--   show_model = false, -- Displays which model you are using at the beginning of your chat session.
--   no_auto_close = true, -- Never closes the window automatically.
--   hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`)
--   init = function(options)
--     pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
--   end,
--   -- Function to initialize Ollama
--   command = function(options)
--     local body = { model = options.model, stream = true }
--     return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
--   end,
--   debug = false, -- Prints errors and the command which is run.
-- })
-- vim.keymap.set({ "n", "x" }, "<Space>a", ":Gen<CR>")
--

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

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "qwen25",
    },
    inline = {
      adapter = "qwen25",
    },
    agent = {
      adapter = "qwen25",
    },
  },
  adapters = {
    qwen25 = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "qwen25",
        schema = {
          model = {
            default = "qwen2.5-coder:latest",
          },
          num_ctx = {
            default = 16384,
          },
          num_predict = {
            default = -1,
          },
        },
      })
    end,
  },
})
-- require("codecompanion").setup({
--   strategies = {
--     chat = {
--       adapter = "ollama",
--     },
--     inline = {
--       adapter = "ollama",
--     },
--     agent = {
--       adapter = "ollama",
--     },
--   },
-- })
