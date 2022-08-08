scriptencoding utf-8

" vim-plug---START
call plug#begin('~/.config/nvim/plugged')


" Plugins
Plug 'airblade/vim-gitgutter'
Plug 'cespare/vim-toml'
Plug 'vim-scripts/nginx.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'fatih/vim-go'
Plug 'gabesoft/vim-ags'
Plug 'google/protobuf'
Plug 'hashivim/vim-terraform'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'junegunn/fzf'
Plug 'kchmck/vim-coffee-script'
Plug 'lifepillar/vim-solarized8'
Plug 'majutsushi/tagbar'
Plug 'neovim/nvim-lspconfig'
Plug 'OmniSharp/omnisharp-vim'
Plug 'posva/vim-vue'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Shougo/vimproc.vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'

call plug#end()

" vim-plug---END

" Solarized
syntax enable
set termguicolors
colorscheme solarized8
set cursorline
set colorcolumn=80,100

function ToggleBackground(current)
  if a:current ==# 'dark'
    set background=light
    hi Whitespace ctermfg=7 guifg=#eee8d5
  else
    set background=dark
    hi Whitespace ctermfg=0 guifg=#073642
  end
endfunction

call ToggleBackground('light')
nmap <F5> :call ToggleBackground(&background)<CR>

set spell
set number
set nowrap
filetype plugin indent on

set mouse=a

set list
set listchars=tab:――,space:·,trail:·

let g:NoClean = ['diff']

augroup indentation
	autocmd BufRead,BufNewFile
				\ Makefile,
				\*.c,
				\*.cpp,
				\*.go
				\ set tabstop=8 shiftwidth=8 noexpandtab


	autocmd BufRead,BufNewFile
				\ *.cs,
				\*.java
				\ set tabstop=4 shiftwidth=4 expandtab

	autocmd BufRead,BufNewFile
				\ *.rb,
				\*.css,
				\*.js,
				\*.jsx,
				\*.coffee,
				\*.erb,
				\*.html,
				\*.html.tmpl,
				\*.json,
				\*.tf,
				\*.tfvars,
				\*.vue,
				\*.yml,
				\*.yaml
				\ set tabstop=2 shiftwidth=2 expandtab

autocmd FileType crontab set backupcopy=yes

augroup END

" vint: -ProhibitCommandRelyOnUser -ProhibitCommandWithUnintendedSideEffect

function TrimTrailingInvisibles()
  let view = winsaveview()
  %s/\s\+$//e
  call winrestview(view)
endfunction

function TrimTrailingLines()
  let view = winsaveview()
  %s/\n\+\%$//e
  call winrestview(view)
endfunction

" vint: +ProhibitCommandRelyOnUser +ProhibitCommandWithUnintendedSideEffect

function OnWrite()
	if Writeable()
		call CleanFile()
	endif
endfunction

function OnLeave()
	if Writeable()
		call CleanFile()
		write
		GitGutter
	endif
endfunction

function CleanFile()
	call TrimTrailingInvisibles() | call TrimTrailingLines()
endfunction

function Writeable()
	return empty(&buftype)
				\ && index(g:NoClean, &filetype) == -1
				\ && !&readonly
				\ && &modifiable
				\ && &modified
				\ && !empty(expand('%:t'))
endfunction

augroup maximus

autocmd BufWrite * call OnWrite()
autocmd BufLeave * call OnLeave()

augroup END

set statusline=%f
set statusline+=\ %y
set statusline+=[%{&ff}]
set statusline+=%r
set statusline+=%h
set statusline+=%{ModifiedSym()}
set statusline+=%=
set statusline+=%{AddGitGutterToStatusline()}
set statusline+=\ [%c:%l/%L:%p%%]

function ModifiedSym()
  if &modified
    return "[\u270f]"
  else
    return ''
  end
endfunction

function AddGitGutterToStatusline()
  if empty(&buftype) && exists('b:gitgutter_summary')
    return join(['[Git:', join(b:gitgutter_summary, ','), ']'], '')
  else
    return ''
  endif
endfunction

" Shortcuts
" Plugins
nnoremap <C-\> :NERDTreeToggle<CR>
nnoremap <leader>. :TagbarToggle<CR>

" Tabs
nnoremap <leader>tt :tabnew<CR>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprevious<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tm :tabmove<CR>

" Misc
nnoremap <leader>h :noh<CR>
nnoremap <C-]> :exec "tjump ".expand("<cword>")<CR>
nnoremap <leader><space> :call Fullscreen()<CR>

function Fullscreen()
	let view = winsaveview()
	let buf = winbufnr(0)
	let found = 0

	for b in win_findbuf(buf)
		let tabwin = win_id2tabwin(b)
		if gettabwinvar(tabwin[0], tabwin[1], 'fullscreen_buf') == buf
			let found = 1
			let existing_tab = tabwin[0]
			let existing_win = tabwin[1]
		endif
	endfor
	if found == 1
		if existing_tab == tabpagenr()
			tabclose
		else
			exec 'tabnext'.existing_tab
		endif
	else
		exec 'tabnew +buffer'.buf
		let w:fullscreen_buf = buf
	end

	call winrestview(view)
endfunction

" Plugin configuration

" The Silver Searcher
nnoremap <leader>s :Ags<space>

" FZF
nnoremap <C-p> :FZF!<CR>

" NERD Commenter
let g:NERDSpaceDelims = 1

" NERD Tree
let g:NERDTreeShowHidden = 1

" Tagbar
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
	\ }

set completeopt=menu,menuone,noselect

lua <<EOF
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap=true, silent=true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
	buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local cmp = require'cmp'

local sources = {
	{ name = 'nvim_lsp' },
	{ name = 'nvim_lua' },
	{ name = 'buffer' },
}

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources(sources),
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require'lspconfig'.gopls.setup{
	on_attach = on_attach,
	capabilities = capabilities,
}

require'lspconfig'.solargraph.setup{
	on_attach = on_attach,
	bundlerPath = 'bin/bundle',
	useBundler = true,
	capabilities = capabilities,
}

require'lspconfig'.rust_analyzer.setup{
	on_attach = on_attach,
	capabilities = capabilities,
}

require'lspconfig'.clangd.setup{
	on_attach = on_attach,
	capabilities = capabilities,
}
EOF
