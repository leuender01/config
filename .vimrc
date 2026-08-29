
            "██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
            "██║   ██║██║████╗ ████║██╔══██╗██╔════╝
            "██║   ██║██║██╔████╔██║██████╔╝██║     
            "╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
            " ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
            "  ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝


"|Plugins Instalar e configurar|{{{
    call plug#begin()
        
        Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
        Plug 'Xuyuanp/nerdtree-git-plugin'
        Plug 'dracula/vim', {'as' : 'dracula'}
        Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
        Plug 'KabbAmine/vCoolor.vim'
        Plug 'tpope/vim-dadbod'
        Plug 'kristijanhusak/vim-dadbod-ui'
        Plug 'gergap/vim-ollama'
        Plug 'neoclide/coc.nvim', {'branch' : 'release'}
        Plug 'preservim/NERDTree'
        Plug 'ryanoasis/vim-devicons'
        Plug '~/meuplugin'

    call plug#end()
    if has('termguicolors')
        set termguicolors
    else
        set t_Co=256
    endif

    "}}}

    "|Mapeamento|{{{
    "
    " syntax map_mode <o_que_voce_digita> <o_que_é_execultado>
    " nnoremap – Permite mapear as teclas no modo normal.
    " inoremap – Permite mapear as teclas no modo de inserção.
    " vnoremap – Permite mapear as teclas no modo visual.

    map <C-t> :tabn<CR>
    map <C-r> :tabc<CR>
    map <C-b> :bn<CR>

    nnoremap <Up> <Nop> 
    nnoremap & :s/^/\/\//g<CR>
    nnoremap <Left> <Nop> 
    nnoremap <Right> <Nop> 
    nnoremap <Down> <Nop> 

    set updatetime=200
    augroup AutoSave
        autocmd!
        autocmd InsertLeave,TextChanged * silent! update
    augroup END

    "}}}

    filetype plugin indent on"{{{
    syntax on
    set title
    set encoding=UTF-8
    set backspace=indent,eol,start
    set noerrorbells
    set confirm
    set hidden
    set splitbelow
    set splitright
    set fillchars=vert:│,fold:-,eob:~,lastline:@
    set clipboard=unnamedplus

    set path=.,**
    set noswapfile
    set nobackup
    set undodir=~/.vim/undodir
    set undofile

    set nowrap
    set linebreak
    set nolist
    set listchars=tab:›-,space:·,trail:◀,eol:↲

    set number 
    set relativenumber
    set scrolloff=2
    set cursorline

    let &t_SI="\e[6 q"
    let &t_EI="\e[2 q"

    set autoindent
    set smartindent

    set expandtab
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4

    set ignorecase
    set smartcase
    set incsearch
    set wildmenu
    colorscheme dracula
    hi CursorLine guibg=#202130
    hi Visual guifg=NONE guibg=#000021
    hi Normal guibg=NONE
    hi statusline   cterm=NONE ctermfg=0 ctermbg=7   guibg=#C1C2D0 guifg=#000000
    hi statuslinenc cterm=NONE ctermfg=0 ctermbg=240 guibg=#616270 guifg=#000000

    set spelllang=pt_br,en
    set nospell
    set complete+=kspell
    set completeopt=menuone,longest
    set shortmess+=c
    set wildmenu
    set wildmode=longest,full
    set wildoptions=pum
    set noshowmode
    set laststatus=2
    set autoread

    set viminfo='50,<1000,s10,h,n~/.viminfo/.viminfo
    "}}}

    " |VimScript|{{{

    autocmd BufNewFile * silent! 0r ~/.vim/skel/skel.%:e
    "[O Gatilho(autocmd BufNewFile *)]
    "**autocmd: define um comando automatico que vim executará sozinho quando determinado evento acontecer;
    "**BufNewFile: É o evento gatilho. Significa "toda vez que você abrir um arquivo novo que ainda não";
    "** *: Aplica esse gatilho para qualquer nome ou tipo de arquivo;

    "[A Ação Principal (silent! 0r ~/.vim/skel/skel.%:e)]
    "**silent!: Diz para o Vim executar o comando em silêncio, sem exibir mensagens de erro na tela caso o arquivo de esqueleto (template) não seja encontrado.
    "**0r: O comando r (read) insere o conteúdo de um arquivo externo no arquivo atual. O 0 força o Vim a inserir esse conteúdo logo na linha zero (ou seja, no primeiríssimo topo do documento).
    "**~/.vim/skel/skel.%:e: Este é o caminho do modelo. A mágica está no %:e, que pega a extensão do arquivo atual.
    
    
    
    augroup sincronizar
        autocmd!
        autocmd BufEnter,FocusGained,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
    augroup END

    command! Dockervisual execute "vsplit | terminal /home/@leuender/UNIALFA/drive/bin/dockervil"  | vertical resize 60
    augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
        " zo abre as dobras onde esta o cursor
        " zc fecha as dobras a onde esta o cursor
        " zf adiciona uma dobra
        " za alterna entre abrir e fechar dobras
        " zR Abre todas as dobras do arquivo
        " zM fecha todas as dobras do arquivo
    augroup END
    "}}}

    " |Linha de status|{{{

    "  %F – Exibe o caminho completo do arquivo atual.
    " %M –  O indicador de arquivo modificado aparece enquanto o aquivo não for salvo.
    " %Y – Exibe o tipo de arquivo no buffer.
    " %R – Exibe o indicador de somente leitura.
    " %b – Mostra o caractere ASCII/Unicode sob o cursor.
    " 0x%B – Mostra o caractere hexadecimal sob o cursor.
    " %l – Exibe o número da linha.
    " %c – Exibe o número da coluna.
    " %p%% – Mostra a porcentagem da posição do cursor em relação ao topo do arquivo.

    set statusline=

    set statusline+=\ %F\ %M\ %Y\ %R
    set statusline+=%=   
    set statusline+=\ row:\ %l\ col:\ %c\ percent:\ %p%%
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    "}}}

    "|Auto complete vim|{{{

    " other plugin before putting this into your config
    set signcolumn=yes

    inoremap <silent><expr> <Tab>
         \ coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"

    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction
    autocmd CursorHold * silent call CocActionAsync('highlight')

    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif

    nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
    nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)
    nnoremap <silent> K :call ShowDocumentation()<CR>
    
    autocmd CursorHold * silent call CocActionAsync('highlight')    

"}}}   

"{{{ |Vim-Ollama|

let g:prompt_basico = "Responda sempre em portugues"
let g:ollama_review_prompt = "Revise o código , Me mostre falhas ou pontos com possíveis falhas, e me sugira melhorias. Por favor, mantenha a estrutura do código original e responda de forma concisa e objetiva. Evite usar linguagem técnica excessiva e prefira explicar em termos simples e diretos. Agradeço!"
let g:ollama_check_prompt = g:prompt_basico . ", Corrija principalmente erros de sintaxe, tipagem e sugira pontos de melhoria, documente esse código explicando as funcionalidades de maneira clara e de fácil manutenção!"
let g:ollama_options = { 'num_predict': 300 }
let g:ollama_chat_timeout = 1000
command! OllamaCheck execute "%OllamaTask " . g:ollama_check_prompt

"}}}

"{{{ NerdTree
let NERDTreeShowHidden=1
nnoremap <C-e> :NERDTreeToggle<CR>
autocmd VimEnter * :NERDTree | wincmd p
let g:NERDTreeGitStatusUseNerdFonts = 1 
let g:NERDTreeGitStatusIndicatorMapCustom = {
            \ 'Modified'  :'✹',
            \ 'Staged'    :'✚',
            \ 'Untracked' :'✭',
            \ 'Renamed'   :'➜',
            \ 'Unmerged'  :'═',
            \ 'Deleted'   :'✖',
            \ 'Dirty'     :'✗',
            \ 'Ignored'   :'☒',
            \ 'Clean'     :'✔︎',
            \ 'Unknown'   :'?',
            \ }
let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "689FB6"
let s:darkBlue = "44788E"
let s:purple = "834F79"
let s:lightPurple = "834F79"
let s:red = "AE403F"
let s:beige = "F5C06F"
let s:yellow = "F09F17"
let s:orange = "D4843E"
let s:darkOrange = "F16529"
let s:pink = "CB6F6F"
let s:salmon = "EE6E73"
let s:green = "8FAA54"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'
let g:WebDevIconsDisableDefaultFolderSymbolColorFromNERDTreeDir = 1
let g:WebDevIconsDisableDefaultFileSymbolColorFromNERDTreeFile = 1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeSyntaxEnabledExtensions = ['c', 'h', 'c++', 'cpp', 'php', 'rb', 'js', 'css', 'html'] 
let g:NERDTreeSyntaxEnabledExactMatches = ['node_modules', 'favicon.ico'] 
let g:NERDTreeHighlightCursorline = 0
"}}}

" LeaderF{{{
    map <C-p> :LeaderfFile<CR>
"}}}
