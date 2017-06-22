" vim-plug---START
call plug#begin('~/.config/nvim/plugged')

" Plugins
Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'kien/ctrlp.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/syntastic'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'

call plug#end()

" vim-plug---END

" Solarized
syntax enable
set background=dark
colorscheme solarized
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

set list
set listchars=tab:――,space:·,trail:·

autocmd BufRead,BufNewFile *.cs,*.java set tabstop=4 shiftwidth=4 expandtab
autocmd BufRead,BufNewFile *.rb,*.css,*.js set tabstop=2 shiftwidth=2 expandtab
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
autocmd BufLeave * if &buftype == '' && !&readonly && &modifiable && &modified && expand("%:t") != "" | call TrimTrailingInvisibles() | call TrimTrailingLines() | w | SyntasticCheck | GitGutter | endif

augroup END

set statusline=%f
set statusline+=\ %y
set statusline+=[%{&ff}]
set statusline+=%r
set statusline+=%h
set statusline+=%{ModifiedSym()}
set statusline+=%=
set statusline+=%{SyntasticStatuslineFlag()}
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

" Misc
nmap <leader>h :noh<CR>

" Plugin configuration
" ctrlp
let g:ctrlp_custom_ignore = '\v(node_modules|\.git|tmp)$'
let g:ctrlp_show_hidden = 1

" NERD Commenter
let g:NERDSpaceDelims = 1

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1

" Syntastic
let g:syntastic_stl_format = "[Err: first:%fe total:%e] [Warn: first:%fw total:%w]"
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_enable_signs = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_error_symbol = "\u2717"
let g:syntastic_warning_symbol = "\uFE0E"
