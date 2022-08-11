" PLUGINS
call plug#begin('~/.local/share/nvim/plugin/')
" Dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'kkharji/sqlite.lua'
Plug 'tjdevries/colorbuddy.nvim'

" Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'jose-elias-alvarez/null-ls.nvim'
"Plug 'glepnir/lspsaga.nvim'

" Cmp
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
"Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }

" Snippets
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

" Integration
Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'ahmedkhalf/jupyter-nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'goerz/jupytext.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Navigation
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'stevearc/aerial.nvim'
"Plug 'nvim-telescope/telescope-media-files.nvim'

" Automation
Plug 'lyokha/vim-xkbswitch'
Plug 'numToStr/Comment.nvim'
Plug 'Pocco81/auto-save.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
Plug 'kylechui/nvim-surround'

" Indentation improve
Plug 'Vimjas/vim-python-pep8-indent'

" Interface
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/playground'
Plug 'nvim-lualine/lualine.nvim'
Plug 'zbirenbaum/neodim'

" Colorschemes
Plug 'folke/tokyonight.nvim'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'EdenEast/nightfox.nvim'
Plug 'tiagovla/tokyodark.nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'Everblush/everblush.vim'
Plug 'FrenzyExists/aquarium-vim'
Plug 'catppuccin/nvim'
Plug 'rose-pine/neovim'
Plug 'bkegley/gloombuddy'
Plug 'yashguptaz/calvera-dark.nvim'
Plug 'shaunsingh/moonlight.nvim'
call plug#end()


" True Colors
set termguicolors


" LUA
lua require("shket")
