require("base")

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
  "echasnovski/mini.nvim",
  "folke/neodev.nvim",
  "nvim-neotest/nvim-nio",
  -- "vhyrro/luarocks.nvim",

  -- Lsp
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "nvimtools/none-ls.nvim",
  "nvimtools/none-ls-extras.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "jay-babu/mason-null-ls.nvim",
  "ray-x/go.nvim",

  -- Completions
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "f3fora/cmp-spell",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "rcarriga/cmp-dap",
  -- "Exafunction/codeium.nvim",

  -- Syntax tree
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter-context",
  "Wansmer/treesj",

  -- Snippets
  "saadparwaiz1/cmp_luasnip",
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",

  -- Debug
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "mxsdev/nvim-dap-vscode-js",

  -- Git
  "lewis6991/gitsigns.nvim",
  "FabijanZulj/blame.nvim",
  "sindrets/diffview.nvim",

  -- SQL
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-completion",
  "kristijanhusak/vim-dadbod-ui",
  "pbogut/vim-dadbod-ssh",

  -- Other integrations
  -- "aserowy/tmux.nvim",
  "iamcco/markdown-preview.nvim",
  "antosha417/nvim-lsp-file-operations",
  "goerz/jupytext.vim",
  { "dccsillag/magma-nvim", build = ":UpdateRemotePlugins" },
  -- "hkupty/iron.nvim",
  -- "kana/vim-textobj-user",
  -- "GCBallesteros/vim-textobj-hydrogen",
  -- "rest-nvim/rest.nvim",
  -- "andweeb/presence.nvim",

  -- Telescope
  { "nvim-telescope/telescope.nvim", lazy = true },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "prochri/telescope-all-recent.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  "debugloop/telescope-undo.nvim",

  -- Navigation
  "kyazdani42/nvim-tree.lua",
  "stevearc/aerial.nvim",
  "ThePrimeagen/harpoon",

  -- Tweaks
  "lyokha/vim-xkbswitch",
  -- "ivanesmantovich/xkbswitch.nvim",
  "numToStr/Comment.nvim",
  "kylechui/nvim-surround",
  "chrisgrieser/nvim-recorder",
  "vim-scripts/Tabmerge",
  "chentoast/marks.nvim",
  "chrisgrieser/nvim-spider",
  -- "windwp/nvim-autopairs",
  -- "windwp/nvim-ts-autotag",

  -- Indentation improve
  "lukas-reineke/indent-blankline.nvim",
  "gpanders/editorconfig.nvim",
  -- "MaxMEllon/vim-jsx-pretty",

  -- Interface
  "nvim-tree/nvim-web-devicons",
  "nvim-lualine/lualine.nvim",
  "nanozuki/tabby.nvim",
  -- "zbirenbaum/neodim",

  -- Colorschemes
  "rose-pine/neovim",
  "catppuccin/nvim",
  "Shatur/neovim-ayu",
  "folke/tokyonight.nvim",
  "EdenEast/nightfox.nvim",
  "bkegley/gloombuddy",
  "shaunsingh/oxocarbon.nvim",
  "ellisonleao/gruvbox.nvim",
  "rebelot/kanagawa.nvim",
}, { defaults = { lazy = false } })

require("plugins")
