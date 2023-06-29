" PLUGINS
call plug#begin('~/.local/share/nvim/plugin/')
" Dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'kkharji/sqlite.lua'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'folke/neodev.nvim'

" Lsp
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'jay-babu/mason-null-ls.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'jose-elias-alvarez/null-ls.nvim'

" Completions
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'rcarriga/cmp-dap'

" Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/playground' " Snippets
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

" Integration
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
"Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'goerz/jupytext.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown' }
Plug 'aserowy/tmux.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'sindrets/diffview.nvim'
" Plug 'hkupty/iron.nvim'
" Plug 'kana/vim-textobj-user'
" Plug 'GCBallesteros/vim-textobj-hydrogen'

" Navigation
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'prochri/telescope-all-recent.nvim'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'debugloop/telescope-undo.nvim'
Plug 'stevearc/aerial.nvim'
Plug 'ThePrimeagen/harpoon'

" Tweaks
Plug 'lyokha/vim-xkbswitch'
Plug 'numToStr/Comment.nvim'
Plug 'kylechui/nvim-surround'
Plug 'chrisgrieser/nvim-recorder'
Plug 'vim-scripts/Tabmerge'
Plug 'AckslD/nvim-trevJ.lua'
"Plug 'windwp/nvim-autopairs'
"Plug 'windwp/nvim-ts-autotag'

" Indentation improve
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'gpanders/editorconfig.nvim'
Plug 'Vimjas/vim-python-pep8-indent'
"Plug 'MaxMEllon/vim-jsx-pretty'

" Interface
Plug 'nvim-lualine/lualine.nvim'
Plug 'nanozuki/tabby.nvim'
"Plug 'zbirenbaum/neodim'

" Colorschemes
Plug 'rose-pine/neovim'
Plug 'catppuccin/nvim'
"Plug 'folke/tokyonight.nvim'
"Plug 'bluz71/vim-nightfly-guicolors'
"Plug 'EdenEast/nightfox.nvim'
"Plug 'tiagovla/tokyodark.nvim'
"Plug 'bkegley/gloombuddy'
"Plug 'yashguptaz/calvera-dark.nvim'
"Plug 'shaunsingh/moonlight.nvim'
"Plug 'shaunsingh/oxocarbon.nvim', { 'do': './install.sh' }
"Plug 'ellisonleao/gruvbox.nvim'
"Plug 'rebelot/kanagawa.nvim'
call plug#end()


" True Colors
set termguicolors


" LUA
lua require("ashket")
