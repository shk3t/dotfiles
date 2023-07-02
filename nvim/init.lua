require("core")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Dependencies
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
  "kkharji/sqlite.lua",
  "tjdevries/colorbuddy.nvim",
  "echasnovski/mini.nvim",
  "folke/neodev.nvim",

  -- Lsp
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "jay-babu/mason-null-ls.nvim",
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "jose-elias-alvarez/null-ls.nvim",

  -- Completions
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "rcarriga/cmp-dap",

  -- Syntax
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "nvim-treesitter/nvim-treesitter-context",
  "nvim-treesitter/playground",

  -- Snippets
  "saadparwaiz1/cmp_luasnip",
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",

  -- Integration
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  -- "dccsillag/magma-nvim", -- { "do": ":UpdateRemotePlugins" },
  "goerz/jupytext.vim",
  "iamcco/markdown-preview.nvim", -- { "do": ":call mkdp#util#install()", "for": "markdown" },
  "aserowy/tmux.nvim",
  "lewis6991/gitsigns.nvim",
  "sindrets/diffview.nvim",
  -- "hkupty/iron.nvim",
  -- "kana/vim-textobj-user",
  -- "GCBallesteros/vim-textobj-hydrogen",

  -- Navigation
  "kyazdani42/nvim-tree.lua",
  "stevearc/aerial.nvim",
  "ThePrimeagen/harpoon",
  -- "cbochs/grapple.nvim",

  -- Telescope
  "nvim-telescope/telescope.nvim",
  {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
  "prochri/telescope-all-recent.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  "debugloop/telescope-undo.nvim",

  -- Tweaks
  "lyokha/vim-xkbswitch",
  "numToStr/Comment.nvim",
  "kylechui/nvim-surround",
  "chrisgrieser/nvim-recorder",
  "vim-scripts/Tabmerge",
  "AckslD/nvim-trevJ.lua",
  "chentoast/marks.nvim",
  -- "windwp/nvim-autopairs",
  -- "windwp/nvim-ts-autotag",

  -- Indentation improve
  "lukas-reineke/indent-blankline.nvim",
  "gpanders/editorconfig.nvim",
  "Vimjas/vim-python-pep8-indent",
  -- "MaxMEllon/vim-jsx-pretty",

  -- Interface
  "nvim-lualine/lualine.nvim",
  "nanozuki/tabby.nvim",
  -- "zbirenbaum/neodim",

  -- Colorschemes
  "rose-pine/neovim",
  "catppuccin/nvim",
  -- "folke/tokyonight.nvim",
  -- "bluz71/vim-nightfly-guicolors",
  -- "EdenEast/nightfox.nvim",
  -- "tiagovla/tokyodark.nvim",
  -- "bkegley/gloombuddy",
  -- "yashguptaz/calvera-dark.nvim",
  -- "shaunsingh/moonlight.nvim",
  -- "shaunsingh/oxocarbon.nvim",
  -- "ellisonleao/gruvbox.nvim",
  -- "rebelot/kanagawa.nvim",

}, {defaults = {lazy = true}})

require("plugins")
