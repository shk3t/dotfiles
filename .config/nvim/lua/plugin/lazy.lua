local reqfunc = require("lib.base.sugar").require_func

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Lsp
  { "williamboman/mason.nvim", config = true },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugin.config.lsp.lspconfig")
      require("plugin.config.lsp.diagnostic")
    end,
    dependencies = {
      "saghen/blink.cmp",
      "stevearc/conform.nvim",
      "nvim-telescope/telescope.nvim",
      "williamboman/mason.nvim",
    },
  },
  {
    "stevearc/conform.nvim",
    config = reqfunc("plugin.config.lsp.conform"),
    dependencies = "williamboman/mason.nvim",
  },
  {
    "jmbuhr/otter.nvim",
    config = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "quarto-dev/quarto-nvim",
    config = reqfunc("plugin.config.lsp.quarto"),
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    config = reqfunc("plugin.config.lsp.lazydev"),
  },
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    config = reqfunc("plugin.config.lsp.go"),
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  { "antosha417/nvim-lsp-file-operations", config = true },  -- TODO: remove

  -- Completions
  {
    "saghen/blink.cmp",
    config = reqfunc("plugin.config.completion.blinkcmp"),
    dependencies = "L3MON4D3/LuaSnip",
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = reqfunc("plugin.config.completion.luasnip"),
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },

  -- Syntax
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = reqfunc("plugin.config.syntax.treesitter"),
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = reqfunc("plugin.config.syntax.tstextobjects"),
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.nvim", -- mini.ai
    },
  },
  { "nvim-treesitter/nvim-treesitter-context", dependencies = "nvim-treesitter/nvim-treesitter" },
  {
    "Wansmer/treesj",
    config = reqfunc("plugin.config.syntax.treesj"),
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  -- Debug
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("plugin.config.debug.dap")
      require("plugin.color.dap")
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = reqfunc("plugin.config.debug.dapui"),
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },

  -- Navigation
  {
    "kyazdani42/nvim-tree.lua", -- TODO: remove
    config = reqfunc("plugin.config.navigation.tree"),
    dependencies = "echasnovski/mini.nvim", -- mini.icons
  },
  {
    "stevearc/aerial.nvim",
    config = reqfunc("plugin.config.navigation.aerial"),
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-live-grep-args.nvim",
      "debugloop/telescope-undo.nvim",
    },
    config = reqfunc("plugin.config.navigation.telescope"),
  },

  -- Integrations
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_auto_close = 1
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    config = reqfunc("plugin.config.integrations.kulala"),
  },
  {
    "jbyuki/nabla.nvim",
    config = reqfunc("plugin.config.integrations.nabla"),
    dependencies = "williamboman/mason.nvim",
  },
  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugin.config.integrations.gitsigns")
    end,
    dependencies = "nvim-telescope/telescope.nvim",
  },
  { "FabijanZulj/blame.nvim", config = reqfunc("plugin.config.integrations.blame") },
  -- Database
  { "tpope/vim-dadbod", config = reqfunc("plugin.config.integrations.dadbod") },
  {
    "kristijanhusak/vim-dadbod-ui",
    config = reqfunc("plugin.config.integrations.dadbodui"),
    dependencies = "tpope/vim-dadbod",
  },
  { "kristijanhusak/vim-dadbod-completion", dependencies = "tpope/vim-dadbod" },
  { "pbogut/vim-dadbod-ssh", dependencies = "tpope/vim-dadbod" },

  -- Tweaks
  {
    "echasnovski/mini.nvim",
    config = function()
      require("plugin.config.tweaks.mini")
      require("plugin.config.ui.mini")
    end,
  },
  { "numToStr/Comment.nvim", config = true },
  { "kylechui/nvim-surround", config = reqfunc("plugin.config.tweaks.surround") },
  { "chrisgrieser/nvim-recorder", config = reqfunc("plugin.config.tweaks.recorder") },
  { "chrisgrieser/nvim-spider", config = reqfunc("plugin.config.tweaks.spider") },
  { "vim-scripts/Tabmerge", config = reqfunc("plugin.config.tweaks.tabmerge") },

  -- UI
  { "nvim-lualine/lualine.nvim", config = reqfunc("plugin.config.ui.lualine") },
  { "lukas-reineke/indent-blankline.nvim", config = reqfunc("plugin.config.ui.ibl") },

  -- Colorscheme
  {
    "rose-pine/neovim",
    config = function()
      require("plugin.color.base")
      require("plugin.color.telescope")
      require("plugin.color.rosepine")
    end,
  },
}, {
  defaults = {
    lazy = false,
  },
})
