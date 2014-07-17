setlocal foldmethod=expr
setlocal foldexpr=GetPhpFold(v:lnum)

function! GetPhpFold(lnum)
    let line = getline(a:lnum)

    return IndentLevel(a:lnum)

endfunction

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction
