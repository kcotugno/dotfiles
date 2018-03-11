" vim-plug---START
call plug#begin('~/.config/nvim/plugged')

" Plugins
Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'kien/ctrlp.vim'
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

set number
set nowrap
filetype plugin indent on

set mouse=a

set list
set listchars=tab:――,space:·,trail:·

autocmd BufRead,BufNewFile *.cs,*.java set tabstop=4 shiftwidth=4 expandtab
autocmd BufRead,BufNewFile *.rb,*.css,*.js,*.coffee,*.erb,*.html,*.json,*.vue set tabstop=2 shiftwidth=2 expandtab
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

augroup maximus

autocmd BufWrite * call TrimTrailingInvisibles() | call TrimTrailingLines()
autocmd BufLeave * if &buftype == '' && !&readonly && &modifiable && &modified && expand("%:t") != "" | call TrimTrailingInvisibles() | call TrimTrailingLines() | w | GitGutter | endif

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

" Plugin configuration
" ctrlp
let g:ctrlp_custom_ignore = '\v(node_modules|\.git|tmp)$'
let g:ctrlp_show_hidden = 1

" NERD Commenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = "start"

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
