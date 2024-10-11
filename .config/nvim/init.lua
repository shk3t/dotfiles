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
  {
    "vhyrro/luarocks.nvim",
    opts = { rocks = { "magick" } },
  },
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
  "kkharji/sqlite.lua",
  "echasnovski/mini.nvim",
  "folke/neodev.nvim",
  "nvim-neotest/nvim-nio",
  "3rd/image.nvim",

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
  "jmbuhr/otter.nvim",

  -- Completions
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "f3fora/cmp-spell",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "rcarriga/cmp-dap",
  -- "Exafunction/codeium.nvim",
  "olimorris/codecompanion.nvim",
  -- "tzachar/cmp-ai",

  -- Syntax tree
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter-context",
  "Wansmer/treesj",
  -- rest-nvim/tree-sitter-http,

  -- Snippets
  "saadparwaiz1/cmp_luasnip",
  { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
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

  -- Integrations
  "aserowy/tmux.nvim",
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  "antosha417/nvim-lsp-file-operations",
  "GCBallesteros/jupytext.nvim",
  { "benlubas/molten-nvim", build = ":UpdateRemotePlugins" },
  "quarto-dev/quarto-nvim",
  "rest-nvim/rest.nvim",
  "jbyuki/nabla.nvim",

  -- Telescope
  { "nvim-telescope/telescope.nvim", lazy = true },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "prochri/telescope-all-recent.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  "debugloop/telescope-undo.nvim",
  "nvim-telescope/telescope-ui-select.nvim",

  -- Navigation
  "kyazdani42/nvim-tree.lua",
  "stevearc/aerial.nvim",

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
  -- "catppuccin/nvim",
  -- "Shatur/neovim-ayu",
  -- "folke/tokyonight.nvim",
  -- "EdenEast/nightfox.nvim",
  -- "nyoom-engineering/oxocarbon.nvim",
  -- "ellisonleao/gruvbox.nvim",
  -- "rebelot/kanagawa.nvim",
  -- "projekt0n/github-nvim-theme",
  -- "Mofiqul/vscode.nvim",
  -- "marko-cerovac/material.nvim",
  -- "jthvai/lavender.nvim",
  -- "Mofiqul/dracula.nvim",
  -- "kdheepak/monochrome.nvim",
  -- "kvrohit/substrata.nvim",
  -- "tiagovla/tokyodark.nvim",
  -- "cpea2506/one_monokai.nvim",
  -- "maxmx03/fluoromachine.nvim",
  -- "slugbyte/lackluster.nvim",
}, { defaults = { lazy = false } })

require("plugins")
