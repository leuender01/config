command! Olamundo echo "Óla, mundo!,Meu primeiro plugin"

let b:contexto = "\nseparei em blocos cada arquivo com a seguinte sintaxe:\n"
            \ . "Syntaxe:\n\n"
            \ . "INICIO--------------\n"
            \ . "Nome_arquivo:[NOME/PATH]\n"
            \ . "[CONTEUDO]\n\n"
            \ . "-------------FIM\n\n\n"
            \ . "Explicação:\n"
            \ . "|----{ INICIO--------------: Representa inicio de um bloco contendo nome_arquivo e dados}\n"
            \ . "|--------{ Nome_arquivo:[NOME/PATH]: contem o nome do arquivo ou o caminho dele no meu sistema de arquivos}\n"
            \ . "|--------{ [CONTEUDO]: Contem o conteudo do arquivo se estiver vazio o arquivo esta vazio }\n"
            \ . "|----{ -------------FIM: Respresenta fim de um bloco contento nome_arquivo e dados }\n\n"

function! Learquivo(...)
    if a:0 == 0
        return
    endif

    let l:arg_total = []
    for arg in a:000
        if arg == '%'
            let l:caminho_atual = expand('%:p')
            if !empty(l:caminho_atual)
                call add(l:arg_total, l:caminho_atual)
            endif
        elseif l:arg =~ '\*'
            let l:achados = glob(l:arg, 0, 1)
            let l:arg_total = extend(l:arg_total, l:achados)
        else
            call add(l:arg_total, l:arg)
        endif
    endfor
    let l:string = ""
    for arq in l:arg_total
        if filereadable(arq)
            let l:cabe = "\n\n Nome_arquivo: " . arq . '------' . "\n\n"
            let l:linhas = readfile(arq)
            let l:string .= "\n\nINICIO--------------\n" .  "\n" .l:cabe . join(l:linhas, "\n") . "\n\n" . "-------------FIM\n\n"
        endif
    endfor
    let l:prompt = g:ollama_review_prompt . "\n" . g:prompt_basico . b:contexto
    execute "OllamaTask " . l:prompt . "\n" . l:string . "\n"


endfunction

command! -nargs=* OllamaLista call Learquivo(<f-args>)

let g:popup_input_text = ""
let g:popup_wind_id = 0
let g:search_history = [] 

function! GetSuggestions(text)
    if empty(a:text)
        return []
    endif
    " Retorna itens que começam com o texto digitado
    return filter(copy(g:search_history), 'v:val =~? "^' . a:text . '"')
endfunction

function! CloseSuggestions()
    if g:suggestion_wind_id != 0
        call popup_close(g:suggestion_wind_id)
        let g:suggestion_wind_id = 0
    endif
endfunction

function! UpdateSuggestions(text)
    if len(g:search_history) > 0
        call CloseSuggestions()
    endif
    let l:suggestions = GetSuggestions(a:text)
    
    if !empty(l:suggestions)
        let l:pos = popup_getpos(g:popup_wind_id)
        let g:suggestion_wind_id = popup_create(l:suggestions, {
                    \ 'line' : (l:pos.line + l:pos.height) - 2,
                    \ 'col': l:pos.col + 1,
                    \ 'padding': [0, 0, 0, 0],
                    \ 'border': [0, 0, 0, 0],
                    \ 'borderhighlight': ['FloatBorder'],
                    \ 'cursorline': 1,
                    \ 'zindex': 201,
                    \ })
    endif 
endfunction


function! Filtertext(winid, key)
    if a:key == "\<CR>"
        if len(g:search_history) > 0
            call CloseSuggestions()
        endif
        if len(g:search_history) < 120
            call add(g:search_history, g:popup_input_text)
        endif
        call popup_close(a:winid, g:popup_input_text)
        return 1
    elseif a:key == "\<Esc>" || a:key == "\<C-C>"
        if len(g:search_history) > 0
            call CloseSuggestions()
        endif
        call popup_close(a:winid, v:null)
        return 1
    elseif a:key == "\<BS>"
        if len(g:popup_input_text) > 0
            let g:popup_input_text = g:popup_input_text[:-2]
        endif
    elseif a:key =~ '^[[:print:]]$'
        let g:popup_input_text .= a:key
    endif


    call popup_settext(a:winid, [g:popup_input_text . '_'])
    call UpdateSuggestions(g:popup_input_text)
    return 1
endfunction


function! Resultado(winid, result)
    if a:result isnot v:null
        call system('firefox --search ' . shellescape(a:result) . '&')
    else
        echo "error"
    endif
endfunction

function! Navegar()
    let g:popup_input_text = ""
    let g:popup_wind_id = popup_create(['_'], {
        \ 'pos': 'center',
        \ 'filter': 'Filtertext',
        \ 'zindex': 200,
        \ 'drag': 1,
        \ 'title': "Barra de Pesquisa do Navegador",
        \ 'callback': 'Resultado',
        \ 'border': [1, 1, 1, 1],
        \ 'padding': [1 ,8 ,1 ,0],
        \ 'highlingth': 'Normal',
        \ 'borderhighligth': ['FloatBorder'],
      \ })
endfunction

map <C-n>  :call Navegar()<CR>

function! PegarLinha(linha1, linha2)
    let l:linhas = getline( a:linha1, a:linha2)
    if empty(linhas)
        return
    endif
    let l:text_selecionado  = join(l:linhas, "\n")
    let l:template = "traduza para portugues de maneira facil de entender, o trecho a abaixo" . l:text_selecionado
    let l:resultado = substitute(l:template, "\n", " ", "g")
    let l:payload = json_encode({
        \ 'model': 'qwen2.5-coder:latest',
        \ 'prompt': l:resultado,
        \ 'stream': v:true
        \ })
    vnew
    setlocal buftype=nofile bufhidden=wipe noswapfile wrap
    let b:target_buf = bufnr('%')
    call setline(1, ["|-------TraduzirSelecao-------|",""])

    function! s:OnStream(target_buf, channel, msg)
        try
            let l:json = json_decode(a:msg)
            if has_key(l:json, 'response')
                let l:pedaco = l:json['response']
                if bufexists(a:target_buf)
                    let l:last_line = getbufline(a:target_buf, "$")[0]
                    if l:pedaco =~ "\n"
                        let l:partes = split(l:pedaco, "\n", 1)
                        call setbufline(a:target_buf, "$", l:last_line . l:partes[0])
                        for l:p in l:partes[1:]
                            call appendbufline(a:target_buf, "$", l:p)
                        endfor
                    else
                        call setbufline(a:target_buf, "$", l:last_line . l:pedaco)
                    endif
                endif
            endif
        endtry
    endfunction

    let l:cmd = ['curl', '-s', '-N', '-X', 'POST', 'http://localhost:11434/api/generate', '-d', l:payload]
    call job_start(l:cmd, {
        \ 'out_cb': function('s:OnStream', [b:target_buf])
      \ })
endfunction


command! -range TraduzirSelecao :call PegarLinha(<line1>,<line2>)
