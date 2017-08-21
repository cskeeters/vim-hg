autocmd BufNewFile,BufRead *.txt call CheckHGCommit()
function! CheckHGCommit()
    let lineno = search("HG: user:", 'n')
    if lineno != 0
        set ft=hgci
    endif
endfunction
