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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = reqfunc("plugin.lsp.masoninstall"),
    dependencies = "mason-org/mason.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugin.lsp.lspconfig")
      require("plugin.lsp.diagnostic")
    end,
    dependencies = {
      "saghen/blink.cmp",
      "nvim-telescope/telescope.nvim",
      "williamboman/mason.nvim",
    },
  },
  {
    "stevearc/conform.nvim",
    config = reqfunc("plugin.lsp.conform"),
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
    config = reqfunc("plugin.lsp.quarto"),
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    config = reqfunc("plugin.lsp.lazydev"),
  },
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    config = reqfunc("plugin.lsp.go"),
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- Completions
  {
    "saghen/blink.cmp",
    version = "1.*",
    config = reqfunc("plugin.completion.blinkcmp"),
    dependencies = "L3MON4D3/LuaSnip",
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = reqfunc("plugin.completion.luasnip"),
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
    branch = "main",
    build = ":TSUpdate",
    config = reqfunc("plugin.syntax.treesitter"),
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = reqfunc("plugin.syntax.tstextobjects"),
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  { "nvim-treesitter/nvim-treesitter-context", dependencies = "nvim-treesitter/nvim-treesitter" },
  {
    "Wansmer/treesj",
    config = reqfunc("plugin.syntax.treesj"),
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  -- Debug
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("plugin.debug.dap")
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = reqfunc("plugin.debug.dapui"),
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },

  -- Navigation
  {
    "stevearc/oil.nvim",
    config = reqfunc("plugin.navigation.oil"),
    dependencies = "nvim-mini/mini.icons",
  },
  {
    "stevearc/aerial.nvim",
    config = reqfunc("plugin.navigation.aerial"),
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
    config = reqfunc("plugin.navigation.telescope"),
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = reqfunc("plugin.navigation.harpoon"),
    dependencies = "nvim-lua/plenary.nvim",
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
    config = reqfunc("plugin.integrations.kulala"),
  },
  {
    "jbyuki/nabla.nvim",
    config = reqfunc("plugin.integrations.nabla"),
    dependencies = "williamboman/mason.nvim",
  },
  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugin.integrations.gitsigns")
    end,
    dependencies = "nvim-telescope/telescope.nvim",
  },
  -- Database
  { "tpope/vim-dadbod", config = reqfunc("plugin.integrations.dadbod") },
  {
    "kristijanhusak/vim-dadbod-ui",
    config = reqfunc("plugin.integrations.dadbodui"),
    dependencies = "tpope/vim-dadbod",
  },
  { "kristijanhusak/vim-dadbod-completion", dependencies = "tpope/vim-dadbod" },
  { "pbogut/vim-dadbod-ssh", dependencies = "tpope/vim-dadbod" },

  -- Tweaks
  {
    "nvim-mini/mini.indentscope",
    config = reqfunc("plugin.tweaks.mini"),
  },
  { "numToStr/Comment.nvim", config = true },
  { "kylechui/nvim-surround", config = reqfunc("plugin.tweaks.surround") },
  { "chrisgrieser/nvim-recorder", config = reqfunc("plugin.tweaks.recorder") },
  { "chrisgrieser/nvim-spider", config = reqfunc("plugin.tweaks.spider") },
  { "vim-scripts/Tabmerge", config = reqfunc("plugin.tweaks.tabmerge") },
  {
    "stevearc/quicker.nvim",
    ft = "qf",
    config = reqfunc("plugin.tweaks.quicker"),
  },

  -- UI
  {
    "nvim-mini/mini.icons",
    config = reqfunc("plugin.ui.mini"),
  },
  { "nvim-lualine/lualine.nvim", config = reqfunc("plugin.ui.lualine") },
  { "lukas-reineke/indent-blankline.nvim", config = reqfunc("plugin.ui.ibl") },

  -- Colorscheme
  {
    "rose-pine/neovim",
    config = function()
      require("color.base")
      require("color.plugins")
      require("color.rosepine")
    end,
  },
}, {
  defaults = {
    lazy = false,
  },
})
