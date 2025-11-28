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
local consts = require("lib.consts")

require("lazy").setup({
  -- Lsp
  { "williamboman/mason.nvim", config = true },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.lsp.lspconfig")
      require("plugins.lsp.diagnostic")
    end,
    dependencies = "williamboman/mason.nvim",
  },
  {
    "nvimtools/none-ls.nvim",
    config = reqfunc("plugins.lsp.null"),
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
    config = reqfunc("plugins.lsp.quarto"),
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  { "folke/lazydev.nvim", config = reqfunc("plugins.lsp.lazydev") },
  -- {  -- TODO
  --   "ray-x/go.nvim",
  --   config = reqfunc("plugins.lsp.go"),
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  -- },

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
    config = reqfunc("plugins.completion"),
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    config = reqfunc("public.snippets"),
  },

  -- Syntax
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = reqfunc("plugins.syntax.treesitter"),
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
  },
  { "nvim-treesitter/nvim-treesitter-context", dependencies = "nvim-treesitter/nvim-treesitter" },
  {
    "Wansmer/treesj",
    config = reqfunc("plugins.syntax.treesj"),
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  -- Debug
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("plugins.debug.dap")
      require("plugins.colorscheme.dap").setup()
    end,
    dependencies = "williamboman/mason.nvim",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = reqfunc("plugins.debug.dapui"),
  },

  -- Navigation
  { "kyazdani42/nvim-tree.lua", config = reqfunc("plugins.navigation.tree") },
  { "stevearc/aerial.nvim", config = reqfunc("plugins.navigation.aerial") },
  {
    "nvim-telescope/telescope.nvim",
    -- lazy = false,  -- TODO
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- "prochri/telescope-all-recent.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      require("plugins.navigation.telescope")
      require("plugins.colorscheme.telescope")
    end,
  },

  -- Integrations
  { "3rd/image.nvim", config = reqfunc("plugins.integrations.image") },
  { "aserowy/tmux.nvim", config = reqfunc("plugins.integrations.tmux") },
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
  { "GCBallesteros/jupytext.nvim", config = reqfunc("plugins.integrations.jupytext") },
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    config = reqfunc("plugins.integrations.molten"),
    dependencies = "3rd/image.nvim",
  },
  { "mistweaverco/kulala.nvim", config = reqfunc("plugins.integrations.http") },
  {
    "jbyuki/nabla.nvim",
    config = reqfunc("plugins.integrations.nabla"),
    dependencies = {
      -- "nvim-neo-tree/neo-tree.nvim",  -- TODO
      "williamboman/mason.nvim",
    },
  },
  "gpanders/editorconfig.nvim",

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins.git.gitsigns")
      require("plugins.colorscheme.gitsigns").setup()
    end,
  },
  { "FabijanZulj/blame.nvim", config = reqfunc("plugins.git.blame") },
  { "sindrets/diffview.nvim", config = reqfunc("plugins.git.diffview") },

  -- SQL
  { "tpope/vim-dadbod", config = reqfunc("plugins.database") },
  { "kristijanhusak/vim-dadbod-completion", dependencies = "tpope/vim-dadbod" },
  { "kristijanhusak/vim-dadbod-ui", dependencies = "tpope/vim-dadbod" },
  { "pbogut/vim-dadbod-ssh", dependencies = "tpope/vim-dadbod" },

  -- Tweaks
  { "echasnovski/mini.nvim", config = reqfunc("plugins.tweaks.mini") },
  { "numToStr/Comment.nvim", config = true },
  { "kylechui/nvim-surround", config = reqfunc("plugins.tweaks.surround") },
  { "chrisgrieser/nvim-recorder", config = reqfunc("plugins.tweaks.recorder") },
  { "vim-scripts/Tabmerge", config = reqfunc("plugins.tweaks.tabmerge") },
  { "chrisgrieser/nvim-spider", config = reqfunc("plugins.tweaks.spider") },
  {
    "chentoast/marks.nvim",
    config = function()
      require("plugins.tweaks.marks")
      require("plugins.colorscheme.marks").setup()
    end,
  },

  -- UI
  { "nvim-tree/nvim-web-devicons", config = require("lib.consts").ICONS_ENABLED },
  { "nvim-lualine/lualine.nvim", config = reqfunc("plugins.ui.lualine") },
  { "nanozuki/tabby.nvim", config = reqfunc("plugins.ui.tabby") },
  { "lukas-reineke/indent-blankline.nvim", config = reqfunc("plugins.ui.indent") },
  -- "zbirenbaum/neodim",

  -- Colorscheme
  {
    "rose-pine/neovim",
    config = function()
      require("plugins.colorscheme.main").setup()
    end,
  },
}, { defaults = { lazy = false } })
