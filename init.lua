-- init.lua

-- Set leader key to space
vim.g.mapleader = ' '

-- Line number and relative line number
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, useful for resizing splits for example!
vim.opt.mouse = "a"

-- Tab and indent settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Enable break indent
vim.opt.breakindent = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 15

-- Bootstrap lazy.nvim
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

-- Load plugins
require("lazy").setup({
  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    },
  },

  -- Autocompletion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'onsails/lspkind-nvim',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',

  -- Autopairs
  'windwp/nvim-autopairs',

  -- Git integration
  'lewis6991/gitsigns.nvim',

  -- Theme
  {
    "catppuccin/nvim",
    as = "catppuccin"
  },

  -- Telescope for fuzzy finding
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Treesitter for better syntax highlighting
  'nvim-treesitter/nvim-treesitter',
  'nvim-tree/nvim-web-devicons',
})

-- Set Catppuccin theme
vim.cmd [[colorscheme catppuccin]]

-- Treesitter configuration for better syntax highlighting
require('nvim-treesitter.configs').setup {
  ensure_installed = { "bash", "lua", "python", "javascript", "html", "css", "json" }, -- list of languages to install parsers for
  highlight = {
    enable = true,
  },
}

-- Configure LSP
local lspconfig = require('lspconfig')

-- Example configuration for Python LSP (pyright)
lspconfig.pyright.setup{}

-- Configure Telescope
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-n>"] = require('telescope.actions').move_selection_next,
        ["<C-p>"] = require('telescope.actions').move_selection_previous,
      },
    },
  }
}

-- Configure Gitsigns
require('gitsigns').setup{}

-- Configure nvim-cmp for autocompletion
local cmp = require'cmp'
local lspkind = require('lspkind')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part will show ellipsis_char instead (must define maxwidth first)
    })
  }
})

-- Setup nvim-autopairs
require('nvim-autopairs').setup{}
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline('?', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
lspconfig.pyright.setup {
  capabilities = capabilities
}

