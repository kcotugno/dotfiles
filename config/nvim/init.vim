" vim-plug---START
call plug#begin('~/.config/nvim/plugged')

" Plugins
Plug 'airblade/vim-gitgutter'
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/syntastic'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'
Plug 'altercation/vim-colors-solarized'

call plug#end()

" vim-plug---END

set number
syntax enable
set background=dark
colorscheme solarized
set nowrap
filetype plugin indent on

set list
set listchars=tab:»»,trail:~

set tabstop=2
set shiftwidth=2
set expandtab

autocmd BufRead,BufNewFile *.h,*.c,*.cpp, set tabstop=8 shiftwidth=8 expandtab
autocmd BufRead,BufNewFile *.cs,*.java set tabstop=4 shiftwidth=4 expandtab
autocmd BufRead,BufNewFile *.asm set filetype=nasm

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
nmap <C-\> :NERDTreeToggle<CR>
nmap <leader>. :TagbarToggle<CR>

" Plugin configuration
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
let g:syntastic_ruby_checkers = ['rubocop', 'mri']
let g:syntastic_error_symbol = "\u2717"
let g:syntastic_warning_symbol = "\uFE0E"
