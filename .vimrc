" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned ba
filetype off

" Use a compatible data dir for both Neovim and Vim.
if has('nvim')
  let s:data_dir = stdpath('data')
else
  let s:data_dir = expand('~/.vim')
endif

let s:plug_path = s:data_dir . '/site/autoload/plug.vim'
if empty(glob(s:plug_path))
  if executable('curl')
    silent execute '!curl -fLo ' . shellescape(s:plug_path) . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endif
endif

if filereadable(s:plug_path)
  execute 'source ' . fnameescape(s:plug_path)
  call plug#begin(s:data_dir . '/plugged')
  if has('nvim')
    Plug 'folke/flash.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  endif
  call plug#end()
  if has('nvim') && (
        \ empty(glob(s:data_dir . '/plugged/flash.nvim')) ||
        \ empty(glob(s:data_dir . '/plugged/nvim-lspconfig')) ||
        \ empty(glob(s:data_dir . '/plugged/nvim-cmp')) ||
        \ empty(glob(s:data_dir . '/plugged/cmp-nvim-lsp')) ||
        \ empty(glob(s:data_dir . '/plugged/LuaSnip')) ||
        \ empty(glob(s:data_dir . '/plugged/cmp_luasnip')) ||
        \ empty(glob(s:data_dir . '/plugged/nvim-treesitter'))
        \ )
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
else
  echom 'vim-plug not found; install it to enable Neovim plugins'
endif

if has('nvim')
  lua << EOF
pcall(function()
  require("flash").setup()
end)

pcall(function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "cmake", "make" },
    highlight = { enable = true },
    indent = { enable = true },
  })
end)

pcall(function()
  local cmp = require("cmp")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
    },
  })

  vim.lsp.config("clangd", {
    cmd = {
      "/opt/homebrew/opt/llvm/bin/clangd",
      "--background-index",
      "--clang-tidy",
      "--completion-style=detailed",
      "--header-insertion=iwyu",
    },
    capabilities = capabilities,
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  })
  vim.lsp.enable("clangd")

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local opts = { buffer = args.buf, silent = true }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    end,
  })
end)
EOF

  nnoremap <silent> s <cmd>lua require("flash").jump()<cr>
  xnoremap <silent> s <cmd>lua require("flash").jump()<cr>
  onoremap <silent> s <cmd>lua require("flash").jump()<cr>
  nnoremap <silent> S <cmd>lua require("flash").treesitter()<cr>
  xnoremap <silent> S <cmd>lua require("flash").treesitter()<cr>
  onoremap <silent> S <cmd>lua require("flash").treesitter()<cr>
  onoremap <silent> r <cmd>lua require("flash").remote()<cr>
  onoremap <silent> R <cmd>lua require("flash").treesitter_search()<cr>
  xnoremap <silent> R <cmd>lua require("flash").treesitter_search()<cr>
  cnoremap <silent> <C-s> <cmd>lua require("flash").toggle()<cr>
endif

augroup CppToolchain
  autocmd!
  autocmd FileType c,cpp let &l:formatprg = '/opt/homebrew/opt/llvm/bin/clang-format'
  autocmd BufWritePre *.c,*.cc,*.cpp,*.cxx,*.h,*.hh,*.hpp,*.hxx silent! undojoin | normal! mzgggqG`z
augroup END

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on


" TODO: Pick a leader key
let mapleader = " "

" Security
set modelines=0

" Show line numbers
set relativenumber

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
" set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Cursor shape: block in normal/visual, beam in insert.
" Keep explicit terminal escapes for consistent behavior inside/outside tmux.
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20,sm:block
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[2 q"

" Force immediate cursor-shape refresh on mode transitions.
augroup CursorShapeRefresh
  autocmd!
  autocmd ModeChanged * redraw!
augroup END
