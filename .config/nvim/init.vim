" vim-plug---START
call plug#begin('~/.config/nvim/plugged')

" Plugins
Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'gabesoft/vim-ags'
Plug 'junegunn/fzf'
Plug 'kchmck/vim-coffee-script'
Plug 'majutsushi/tagbar'
Plug 'posva/vim-vue'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/nginx.vim'

call plug#end()

" vim-plug---END


" Solarized
syntax enable
set background=dark
colorscheme solarized
set cursorline
set colorcolumn=80,100
call togglebg#map("")

function SetWhitespace()
  if &background == 'dark'
    hi Whitespace ctermfg=0
  else
    hi Whitespace ctermfg=7
  end
endfunction

call SetWhitespace()
map <F5> :ToggleBG<CR> :call SetWhitespace()<CR>

set spell
set number
set nowrap
filetype plugin indent on

set mouse=a

set list
set listchars=tab:――,space:·,trail:·

let g:NoClean = ["diff"]

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
			\*.vue,
			\*.yml,
			\*.yaml
			\ set tabstop=2 shiftwidth=2 expandtab

autocmd FileType crontab set backupcopy=yes

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
	return &buftype == ''
				\ && index(g:NoClean, &filetype) == -1
				\ && !&readonly
				\ && &modifiable
				\ && &modified
				\ && expand("%:t") != ""
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
    return ""
  end
endfunction

function AddGitGutterToStatusline()
  if &buftype == '' && exists("b:gitgutter_summary")
    return join(["[Git:", join(b:gitgutter_summary, ","), "]"], "")
  else
    return ""
  endif
endfunction

" Shortcuts
" Plugins
nmap <C-\> :NERDTreeToggle<CR>
nmap <leader>. :TagbarToggle<CR>

" Tabs
nmap <leader>tt :tabnew<CR>
nmap <leader>tn :tabnext<CR>
nmap <leader>tp :tabprevious<CR>
nmap <leader>tc :tabclose<CR>
nmap <leader>tm :tabmove<CR>

" Misc
nmap <leader>h :noh<CR>
nnoremap <leader><space> :call Fullscreen()<CR>

function Fullscreen()
	let view = winsaveview()
	let buf = winbufnr(0)
	let found = 0

	for b in win_findbuf(buf)
		let tabwin = win_id2tabwin(b)
		if gettabwinvar(tabwin[0], tabwin[1], "fullscreen_buf") == buf
			let found = 1
			let existing_tab = tabwin[0]
			let existing_win = tabwin[1]
		endif
	endfor
	if found == 1
		if existing_tab == tabpagenr()
			tabclose
		else
			exec "tabnext".existing_tab
		endif
	else
		exec "tabnew +buffer".buf
		let w:fullscreen_buf = buf
	end

	call winrestview(view)
endfunction

" Plugin configuration

" The Silver Searcher
nmap <leader>s :Ags<space>

" FZF
nmap <C-p> :FZF!<CR>

" NERD Commenter
let g:NERDSpaceDelims = 1

" NERD Tree
let g:NERDTreeShowHidden = 1

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1

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
