vim.cmd('let g:netrw_lifestyle = 3')

local opt = vim.opt

-- line numbers 
opt.relativenumber = true
opt.number = true
opt.cursorline = true

opt.scrolloff = 15

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search setting
opt.ignorecase = true
opt.smartcase = true

--
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

--split windows
opt.splitright = true
opt.splitbelow = true

opt.guifont = "Firacode Nerd Font:h12"
