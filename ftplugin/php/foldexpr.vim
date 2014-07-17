setlocal foldmethod=expr
setlocal foldexpr=GetPhpFold(v:lnum)

function! GetPhpFold(lnum)
    let line = getline(a:lnum)

    " Empty lines get the same fold level as the line before them.
    " e.g. blank lines between class methods continue the class-level fold.
    if line =~? '\v^\s*$'
        return '='
    endif

    return IndentLevel(a:lnum)
endfunction

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction
