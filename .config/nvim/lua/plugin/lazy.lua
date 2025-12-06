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

---@param modname string
local function reqfunc(modname)
  return function()
    return require(modname)
  end
end

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
      "williamboman/mason.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "nvimtools/none-ls.nvim",
    config = reqfunc("plugin.config.lsp.null"),
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
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
  { "folke/lazydev.nvim", config = reqfunc("plugin.config.lsp.lazydev") },
  {
    "ray-x/go.nvim",
    config = reqfunc("plugin.config.lsp.go"),
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- Completions
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "rcarriga/cmp-dap",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = reqfunc("plugin.config.completion"),
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = reqfunc("plugin.data.snippets"),
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
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = reqfunc("plugin.config.syntax.treesitter"),
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
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
      require("plugin.color.dap").setup()
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = reqfunc("plugin.config.debug.dapui"),
  },

  -- Navigation
  { "kyazdani42/nvim-tree.lua", config = reqfunc("plugin.config.navigation.tree") },
  { "stevearc/aerial.nvim", config = reqfunc("plugin.config.navigation.aerial") },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-live-grep-args.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      require("plugin.config.navigation.telescope")
      require("plugin.color.telescope").setup()
    end,
  },

  -- Integrations
  { "3rd/image.nvim", config = reqfunc("plugin.config.integrations.image") },
  { "aserowy/tmux.nvim", config = reqfunc("plugin.config.integrations.tmux") },
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_auto_close = 1
    end,
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  { "antosha417/nvim-lsp-file-operations", config = true },
  { "GCBallesteros/jupytext.nvim", config = reqfunc("plugin.config.integrations.jupytext") },
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemoteplugin.config",
    config = reqfunc("plugin.config.integrations.molten"),
    dependencies = "3rd/image.nvim",
  },
  {
    "mistweaverco/kulala.nvim",
    config = reqfunc("plugin.config.integrations.kulala"),
    ft = { "http", "rest" },
  },
  {
    "jbyuki/nabla.nvim",
    config = reqfunc("plugin.config.integrations.nabla"),
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  { "gpanders/editorconfig.nvim" },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugin.config.git.gitsigns")
      require("plugin.color.gitsigns").setup()
    end,
    dependencies = "nvim-telescope/telescope.nvim",
  },
  { "FabijanZulj/blame.nvim", config = reqfunc("plugin.config.git.blame") },
  { "sindrets/diffview.nvim", config = reqfunc("plugin.config.git.diffview") },

  -- SQL
  { "tpope/vim-dadbod", config = reqfunc("plugin.config.database") },
  { "kristijanhusak/vim-dadbod-completion", dependencies = "tpope/vim-dadbod" },
  { "kristijanhusak/vim-dadbod-ui", dependencies = "tpope/vim-dadbod" },
  { "pbogut/vim-dadbod-ssh", dependencies = "tpope/vim-dadbod" },

  -- Tweaks
  { "echasnovski/mini.nvim", config = reqfunc("plugin.config.tweaks.mini") },
  { "numToStr/Comment.nvim", config = true },
  { "kylechui/nvim-surround", config = reqfunc("plugin.config.tweaks.surround") },
  { "chrisgrieser/nvim-recorder", config = reqfunc("plugin.config.tweaks.recorder") },
  { "vim-scripts/Tabmerge", config = reqfunc("plugin.config.tweaks.tabmerge") },
  { "chrisgrieser/nvim-spider", config = reqfunc("plugin.config.tweaks.spider") },
  {
    "chentoast/marks.nvim",
    config = function()
      require("plugin.config.tweaks.marks")
      require("plugin.color.marks").setup()
    end,
  },

  -- UI
  { "nvim-tree/nvim-web-devicons", config = require("consts").ICONS.ENABLED },
  { "nvim-lualine/lualine.nvim", config = reqfunc("plugin.config.ui.lualine") },
  { "nanozuki/tabby.nvim", config = reqfunc("plugin.config.ui.tabby") },
  { "lukas-reineke/indent-blankline.nvim", config = reqfunc("plugin.config.ui.indent") },
  -- "zbirenbaum/neodim",

  -- Colorscheme
  {
    "rose-pine/neovim",
    config = function()
      require("plugin.color.colorscheme").setup()
    end,
  },

  rocks = { hererocks = true },
}, {
  defaults = { lazy = false },
})
