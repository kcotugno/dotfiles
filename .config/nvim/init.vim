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
Plug 'hashivim/vim-terraform'
Plug 'junegunn/fzf'
Plug 'kchmck/vim-coffee-script'
Plug 'lifepillar/vim-solarized8'
Plug 'majutsushi/tagbar'
Plug 'posva/vim-vue'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'

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

augroup filetypes
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

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1

" syntastic
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

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
