setlocal foldmethod=expr
setlocal foldexpr=GetPhpFold(v:lnum)

function! GetPhpFold(lnum)
    let line = getline(a:lnum)

    " Empty lines get the same fold level as the line before them.
    " e.g. blank lines between class methods continue the class-level fold.
    if line =~? '\v^\s*$'
        return '='
    endif

    " Fold blocks of 'use' statements that have no indentation.
    " i.e. namespace imports
    if line =~? '\v^use\s+' && getline(a:lnum+1) =~? '\v^(use\s+)@!'
        " Stop the fold at the last use statement.
        return '<1'
    elseif line =~? '\v^use\s+'
        return '1'
    endif

    " handle classes, class methods, and independent functions
    if line =~? '\v^\s*(class|(abstract\s+|public\s+|private\s+|static\s+|private\s+)*function)\s+\k'
        " The code inside the class or function determines the fold level, 
        " and it starts after the curly.  However, the curly may not always 
        " be right after the class or function declaration, so search for it.
        let nextCurly = FindNextDelimiter(a:lnum, '{', 'f')
        return '>' . IndentLevel(nextnonblank(nextCurly + 1))
    elseif line =~? '{'
        " The fold level of the curly is determined by the next non-blank line
        return IndentLevel(nextnonblank(a:lnum + 1))
    elseif line =~? '\v}'
        " The fold level the closing curly closes is determined by the previous non-blank line
        " But only if not followed by an else, catch, or finally
        return '<' . IndentLevel(prevnonblank(a:lnum-1))
    endif

    " Cause indented multi-line comments (/* */) to be folded.
    if line =~? '\v/\*'
        return '>'.IndentLevel(a:lnum)
    elseif line =~? '\v\*/'
        return '<' . IndentLevel(a:lnum-1)
    endif

    let prevClassFunc = FindPrevClassFunc(a:lnum)
    if a:lnum - prevClassFunc == 1
        return 'a1'
    elseif prevClassFunc > 0
        return '='
    endif

    return IndentLevel(a:lnum)
endfunction

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! FindNextDelimiter(lnum, delim, dir, ...)
    let current = a:lnum
    " searching forward with limit
    if a:dir == 'f' && a:0 > 0
        let stopLine = current + a:1
    " searching forward without limit
    elseif a:dir == 'f'
        let stopLine = line('$')
    " searching backward with limit
    elseif a:dir == 'b' && a:0 > 0
        let stopLine = current - a:1
    " searching backward without limit
    elseif a:dir == 'b'
        let stopLine = 1
    " searching unknown direction, error.
    else
        return -2
    endif


    if a:0 > 0
        let limit = current + a:1
    else
        let limit = stopLine
    endif

    while current <= limit
        if getline(current) =~? a:delim
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction

" Looks for a class or function declaration that could have opened the current fold region.
" This is only matters between the declaration and the opening curly, so return error if a curly is found first.
" While this could be done with FindNextDelimiter(), this has a default limit of 10 as there shouldn't ever be more
" than number of implements or arguments
function! FindPrevClassFunc(lnum, ...)
    let current = a:lnum

    " If the limit given is out range, pretend it's 10.
    if a:0 == 0 || a:1 < 1 || a:1 > 10
        let stopLine = current - 10
    else
        let stopLine = current - a:1
    endif

    " If there aren't enough lines above the current line, set the end to the first line
    if stopLine < 1
        let stopLine = 1
    endif

    while current >= stopLine
        if getline(current) =~? '{'
            return -2
        elseif getline(current) =~? '\v^\s*(class|(abstract\s+|public\s+|private\s+|static\s+|private\s+)*function)\s+\k'
            return current
        endif

        let current -= 1
    endwhile

    return -2
endfunction
