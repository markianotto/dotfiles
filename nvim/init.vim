"
" TODO
" 1. jumps are weird (you can jump between neovim instances, this sort of
"    interesting, but more of a nuisance for me than something I can use
"    constructively). We need to:
"    i. clear jumps when running nvim, and
"   ii. *not* clear jumps of an already open nvim instance.
"  iii. figure out where jumps are stored.
"   iv. figure out how jumps are normally configured.
"
" 2. gD should map to go to definition, split into new tab return to old tab
"    and go back to definition root, this for some reason doesn't work due to
"    jumps being weird when executing multiple movements in a single macro.
"
"

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" Themes
Plug 'drewtempelmeyer/palenight.vim'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/everforest'
" All Else

" not sure if I need lspconfig if I am already using neoclide's coc.nvim
" Thing is, neovim already supports LSP protocol out of the box and as I
" understand it, lspconfig only deals with config stuff. I know that coc.nvim
" already handles the rust analyzer just fine (without lspconfig), so I'm a
" bit reluctant to have both of these installed in paralell.
" Plug 'neovim/nvim-lspconfig'
Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo', { 'Requires': 'kevinhwang91/promise-async' }
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'luochen1990/rainbow'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'preservim/nerdcommenter'
Plug 'preservim/tagbar'
Plug 'rust-lang/rust.vim'
Plug 'sheerun/vim-polyglot'
Plug 'Shirk/vim-gas'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-surround'
Plug 'universal-ctags/ctags'
Plug 'vim-airline/vim-airline'
Plug 'vim-syntastic/syntastic'
Plug 'wlangstroth/vim-racket'
call plug#end()


" UFO configuration (Folding Code blocks) see kevinhwang91's stuff
" let ufo = :lua require('ufo')
" ufo.enable();

lua << EOF
   vim.wo.foldcolumn = "1" -- why the fuck is this a string
   vim.wo.foldlevel = 5 -- Using ufo provider need a large value, feel free to decrease the value
   vim.wo.foldenable = true
   vim.o.fillchars = [[eob: ,fold:*,foldopen:v,foldsep:│,foldclose:^]]

   vim.keymap.set('n', 'zr', require('ufo').openAllFolds )
   vim.keymap.set('n', 'zm', require('ufo').closeAllFolds )

   require('ufo').enable();
   -- ¦⎹
EOF

nmap zr :lua require('ufo').openAllFolds()<CR>
nmap zm :lua require('ufo').closeAllFolds()<CR>

:set ignorecase    " Make searches case-insensitive
:set smartcase     " Override 'ignorecase' when search pattern contains uppercase characters


setlocal foldcolumn=1
setlocal foldlevel=99 " -- feel free to decrease the value
" setlocal foldenable=1

" nerdcommenter: https://github.com/preservim/nerdcommenter
" FuzzyFinding in files: https://github.com/neoclide/coc-lists

" Get syntax files from config folder
set runtimepath+=~/.config/nvim/syntax

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" --- Theme
" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
 set termguicolors
endif

" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

syntax enable

set background=dark
" For light version:»set background=light«
" Set contrast.
" This configuration option should be placed before `colorscheme everforest`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:everforest_background = 'soft'
colorscheme everforest
" colorscheme palenight

" Disable C-z from job-controlling neovim
nnoremap <c-z> <nop>

" Remap C-c to <esc>
nmap <c-c> <esc>
imap <c-c> <esc>
vmap <c-c> <esc>
omap <c-c> <esc>
" his is a test
"
imap <C-Del> X<Esc>ce<Del>
nmap <C-Del> <Esc>ce
nnoremap <S-x> <Home>v<End>
vnoremap <S-x> <Down>
nnoremap e i<Right>

nmap <silent> <c-k>q :q!<CR>
nnoremap <silent> <A-e> :GFiles<CR>
nnoremap <silent> <A-d> :Files<CR>
" nnoremap <silent> <A-d> :FZF<CR> doesn't include a file preview
noremap <c-k>sd :call <SID>ResetSearch()<CR>

nmap <A-h> <Plug>VM-Add-Cursor-Down<CR>
nmap <A-u> <Plug>VM-Add-Cursor-Up<CR>

" --- Tab Related
" :map <C-5> 5gt
" :imap <A-5> <C-O>5gt
nmap <silent> tn :tabn<CR>
nmap <silent> tp :tabp<CR>
nmap <silent> <c-k>n :tabnew<CR>
map <silent> <c-k><c-n> :tabnew<CR>
nnoremap <silent> ts :tab split<CR> <BAR> :tabp<CR>
" nnoremap <silent> <C-w> :tabclose<CR>
function! SafeTabClose()
    if &modified
        let choice = inputlist([
                    \ 'Buffer has unsaved changes. Choose an option:',
                    \ '1: Discard changes and close tab',
                    \ '2: Save changes and close tab',
                    \ '3: Cancel'
                    \ ])
        if choice == 1
            set nomodified
            tabclose
        elseif choice == 2
            write
            tabclose
        elseif choice == 3
            " Do nothing (Cancel)
        endif
    else
        tabclose
    endif
endfunction

function! SafeTabClose()
  if &modified
    let l:choices = ['Discard', 'Save', 'Cancel']
    call coc#util#quickpick(l:choices, 'Choose an option:', function('HandleChoice'))
  else
    tabclose
  endif
endfunction

function! HandleChoice(id)
  if a:id == 0
    set nomodified
    tabclose
  elseif a:id == 1
    write
    tabclose
  elseif a:id == 2
    " Do nothing (Cancel)
  endif
endfunction

nnoremap <silent> <C-w> :call SafeTabClose()<CR>


map t0 10gt
map t9 9gt
map t8 8gt
map t7 7gt
map t6 6gt
map t5 5gt
map t4 4gt
map t3 3gt
map t2 2gt
map t1 1gt

" Redo mapped to U
nnoremap U :redo<CR>


"window split shorter shortcuts

nnoremap wv :wincmd v<CR>
nnoremap wh :wincmd s<CR>
nnoremap wl :wincmd l<CR>
nnoremap wj :wincmd h<CR>
nnoremap wi :wincmd k<CR>
nnoremap wk :wincmd j<CR>
" maximize window fullscreen window
nnoremap wf :wincmd \| <BAR> :wincmd _<CR>
nnoremap wq :q<CR>
nnoremap w= :wincmd =<CR>
" yank to system clipboard
set clipboard+=unnamedplus


" Note: <c-_> is equivalent to <c-/> (control+forward_slash)
nmap <c-_> <Plug>NERDCommenterInvert<CR>

" --- vim-visual-multi
" vim visual multi settings (see vm-mappings.txt for details)
let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"] = '<A-h>'
let g:VM_maps["Add Cursor Up"] = '<A-u>'


" --- coc-lists
" aka fuzzy find in files

vnoremap <leader>f :<C-u>call <SID>GrepFromSelected(visualmode())<CR>
nnoremap <leader>f :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@

" grep current word under cursor(I think) from current buffer
nnoremap <silent> <space>w  :exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>


function! s:GrepFromSelected(type)
  let saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let word = substitute(@@, '\n$', '', 'g')
  let word = escape(word, '| ')
  let @@ = saved_unnamed_register
  execute 'CocList grep '.word
endfunction

" Generic function param in mapped call (without parenthesis)
" :nnoremap <buffer> <leader> xyz :call SomeFunc(input('Param: '))<CR>
" CocList (grep in files themselves)
"nmap <C-f> :call <SED>FuzzyFind(input('Param: '))<CR>
"function! s:FuzzyFind(str)
  "echo "called FuzzyFind"
  "echo str
"endfunction

" resets search to empty string (all highlights disappear thereby)
function! s:ResetSearch()
  let @/= ""
endfunction


function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction


" Don't add new commented-out line on enter (when in comment-line)
" for some reason »set formatoptions-=cro« isn't permanent, but is being
" overridden by something that is read after this particular config file is
" read. The following command somehow corrects this.
" (web: stackoverflow.com/questions/6076592)
set formatoptions-=cro
autocmd BufNewFile,BufRead * setlocal formatoptions+=cqn

" Syntax highlighting

" Position in code
set number
set ruler

" Don't make noise
set visualbell

" default file encoding
set encoding=utf-8

" Line wrap
set wrap

" Set default tab spacing
set tabstop=3 shiftwidth=3 expandtab

" Function to set tab width to n spaces
function! SetTab(n)
    let &l:tabstop=a:n
    let &l:softtabstop=a:n
    let &l:shiftwidth=a:n
    set expandtab
endfunction

command! -nargs=1 SetTab call SetTab(<f-args>)

" Function to trim extra whitespace in whole file
function! Trim()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

command! -nargs=0 Trim call Trim()

set laststatus=2

" Highlight search results
set hlsearch
set incsearch

" auto + smart indent for code
set autoindent
set smartindent

set t_Co=256

" ASM == JDH8
augroup jdh8_ft
  au!
  autocmd BufNewFile,BufRead *.asm    set filetype=jdh8
augroup END

" SQL++ == SQL
augroup sqlpp_ft
  au!
  autocmd BufNewFile,BufRead *.sqlp   set syntax=sql
augroup END

" .S == gas
augroup gas_ft
  au!
  autocmd BufNewFile,BufRead *.S      set syntax=gas
augroup END

" JFlex syntax highlighting
 augroup jfft
   au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
 augroup END
 au Syntax jflex    so ~/.vim/syntax/jflex.vim

 " Mouse support
 set mouse=a

 " Map F8 to Tagbar
 " nmap <F8> :TagbarToggle<CR>


 " CTags config
 let g:Tlist_Ctags_Cmd='/usr/local/Cellar/ctags/5.8_1/bin/ctags'

 " disable backup files
 set nobackup
 set nowritebackup

 " no delays!
 set updatetime=300
 "" timeout for leader key
 set timeoutlen=1000
 set cmdheight=1
 set shortmess+=c

 set signcolumn=yes

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neoclide/coc.nvim Configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Language Server Protocols
let g:coc_global_extensions = ['coc-solargraph'] " Ruby LSP

" C++ LSP in ~/.dotfiles/nvim/coc-settings.json

" use <tab> for trigger completion and navigate to the next complete item


function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : CheckBackspace() ? "\<Tab>" : coc#refresh()



" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \  coc#_select_confirm() coc#refresh()

" inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Define the CheckBackSpace function
function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

"" Use TAB for various actions
inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ CheckBackSpace() ? "\<Tab>" :
  \ coc#refresh()

"" Use Shift-TAB for moving up in the completion list or deleting a character
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

"" Use Enter for confirming completion or adding a new line
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"


"" COMMENTS

"" Comment out lines in Visual mode
vmap x :call nerdcommenter#Comment('x', 'toggle')<CR>


" function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-n>"

noremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<cr>"


" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" Go to next/previous problem, warning or error.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <A-p> <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap gD <Plug>(coc-definition) <BAR> :execute "tab split"<CR> <BAR> :execute "tabp"<CR> <BAR> <C-o>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation /info in preview window. (search for info
" keyword to find scrolling shortcuts for the modal)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    " If we are looking at a vim-like help file then call »:h some-word-to-look-up«
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    " ... otherwise we use the fancy pants doHover
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>g <Plug>(coc-format-selected)
nmap <leader>g <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups. scrolls
" documentation / info
" Note: these remaps are interesting since they are conditional: the
" »coc#float#has_scroll« call tells us if we have a pop-up window open and
" only if we actually do, do we call »coc#float#has_scroll(1)« and if not
" we call »<C-d>«. I'm not entirely sure why this doesn't retrigger this
" method, or how <C-d> isn't taking precedence over this function.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
  nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
  inoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
  vnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" add cocstatus into lightline
let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
	\ },
	\ 'component_function': {
	\   'cocstatus': 'coc#status'
	\ },
	\ }

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()


" This sends a SIGWINCH (window change signal) to neovim,
" effectively getting rid of the wrongly sized window problem
" when starting the terminal emulator and nvim simultaneously
" (i.e. via broot).
" You might want to uncomment the sleep below if you still run
" into problems, this adds a 20 ms delay which gives nvim
" a bit more time to start up.
" web: https://github.com/neovim/neovim/issues/11330
" autocmd VimEnter * :sleep 20m
autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
set title

