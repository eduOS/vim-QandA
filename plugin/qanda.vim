
if exists("g:qanda_initloaded") || &cp
    finish
endif

let g:qanda_initloaded = 1

if !has('python')
    echo 'qanda.vim error: requires vim compiled with +python or +python3'
    finish
endif

function! s:showList()
    call qandast#init()
endfunction

function! s:showPanelDetail(oneall)
    if a:oneall == 1
        call qandapn#showPanelist()
    else
        call qandapn#showPanel()
endfunction

command! -nargs=0 QandA call s:showList()
"nnoremap <buffer> <leader>P :call qandast#showPanellist<cr>
nnoremap <buffer> <leader>p :call qandast#showPanel()<cr>
