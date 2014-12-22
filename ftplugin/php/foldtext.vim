" Vim folding via fold-expr
" Language: PHP
"
" Maintainer: Jake Soward <swekaj@gmail.com>
"
" Options: 
"           b:phpfold_text             = 1 - Enable custom foldtext() function
"           b:phpfold_text_right_lines = 0 - Display the line count on the right
"                                            instead of the left.
"           b:phpfold_text_percent     = 0 - Display the percentage of lines the
"                                            fold represents.
"
if exists('b:phpfold_text') && !b:phpfold_text
    finish
endif

setlocal foldtext=GetPhpFoldText()

if !exists('b:phpfold_text_right_lines')
    let b:phpfold_text_right_lines = 0
endif

if !exists('b:phpfold_text_percent')
    let b:phpfold_text_percent = 0
endif

function! GetPhpFoldText()
    let line = getline(v:foldstart)

    let text = ''

    if line =~? '\v^\s*/\*\*?\s*$' " Comments
        " If the DocBlocks are being folded with the function they document, include the function signature in the foldtext.
        if b:phpfold_doc_with_funcs
            let funcline = FindNextFunc(v:foldstart)
            if funcline > 0
                let text .= ExtractFuncName(funcline) . '{...}'
            endif
        endif
        " Display the docblock summary, if it's one two lines attempt to display both lines for the entire summary.
        let nline = getline(v:foldstart+1)
        if nline =~? '\v^\s*\*\s+[^@]'
            let text .= ' - '.substitute(nline, '\v\s*\*(\s|\*)*', '', '')
            if nline !~? '\v\.$'
                let n2line = getline(v:foldstart+2)
                if n2line =~? '\v\.(\s|$)'
                    let text .= substitute(getline(v:foldstart+2), '\v\s*\*(.{-}\.)\s*.*', '\1', '')
                endif 
            endif
        endif
    elseif line =~? '\v\s*(abstract\s+|public\s+|private\s+|static\s+|private\s+)*function\s+\k'
        " Name functions and methods
        let text .= ExtractFuncName(v:foldstart)
        let text .= '{...}'
    elseif getline(v:foldstart-1) =~? '\v\)\s+use\s+\(|\s*(abstract\s+|public\s+|private\s+|static\s+|private\s+)*function\s+(\k+[^)]+$|\([^{]*$)'
        " If a named function's arguments are multiple lines and in their own fold, display the arguments in a list
        let cline = v:foldstart
        while cline <= v:foldend
            let text .= substitute(getline(cline), '\v^\s*([^,]+,?).*', '\1 ', '')
            let cline += 1
        endwhile
    elseif line =~? '\v\Wfunction\s+\(' " Closures
        " Start with the line save the indent spacing.
        let text .= substitute(line, '\v^\s*', '\1', '')
        let text .= '...'
        " The end result of all of this is an attempt to convey an overview of the closure.
        " If there is a variable-use list defined, it is displayed.
        " If either the argument list or variable-use list are listed on one line, then they are included in the fold text.
        " If either of them are listed on multiple lines, they are instead display as (...).
        " The function block is displayed as {...}.
        " Examples:
        "   --- 4 lines: $closure = function () {...}-----
        "   --- 8 lines: $closure = function () use ($var1, $var2) {...}-----
        "   -- 13 lines: $closure = function ($arg1) use (...) {...}-----
        if line =~? '\v\)\s+use\s+\([^)]*$'
            " Arg list is on one line, use list is not.
            let text .= ') {...'
        elseif FuncHasUse(v:foldstart+1) > 0
            " Arg lsit is on multiple lines and there is a use list.
            let uline = getline(FuncHasUse(v:foldstart+1))
            " If the use list is on multiple lines, display (...) for it, otherwise display the list
            if uline =~? '\vuse\s+\([^)]+\) \{'
                let text .= substitute(uline, '\v^.*\)\s+use\s+(\([^)]+\)\s*\{)', ') use \1...', '')
            else
                let text .= ') use (...) {...'
            endif
        elseif line =~? '\v\(\) \{\s*$' || line =~? '\vuse\s+\([^)]+\)\s+\{\s*$'
            " The arg list (if present) and use list are both on one line or there is no use list and no arguments
            let text .= ''
        else
            " The arg list is on multiple lines and there is no use list
            let text .= ') {...'
        endif
        let text .= ExtractEndDelim(v:foldend)
    elseif line =~? '\v^use\s+'
        " Display the last part of each namespace import/alias in a list
        let text .= 'use '
        let cline = v:foldstart
        while cline <= v:foldend
            let text .= substitute(getline(cline), '\v^use\s+.{-}(\k+);.*', '\1, ', '')
            let cline += 1
        endwhile
        let text = substitute(text, ', $', '', '')
    elseif line =~? '\v^\s*class\s*\k'
        let text .= substitute(line, '^\s*', '', '')
        if line =~? '\vimplements\s*$'
            let cline = v:foldstart+1
            let line = getline(cline)
            while line !~? '\v^\s*\{'
                let text .= substitute(line, '^\s*', ' ', '')
                let cline += 1
                let line = getline(cline)
            endwhile
        endif
        let text .= ' {...}'
    elseif line =~? '\v^\s*case\s*.*:'
        " If there are multiple case statements in a row, display them all in a list
        let cline = v:foldstart
        while line =~? '\v^\s*case\s*.*:'
            let text .= substitute(line, '\v^\s*(.{-}:)\s*$', '\1 ', '')
            let cline += 1
            let line = getline(cline)
        endwhile
    elseif line =~? '\v^\s*default:'
        " Remove any leading or trailing whitespace around default:
        let text .= 'default: '
    elseif line =~? '\v^\s*do \{'
        let text .= substitute(line, '\v^\s*', '', '')
        let text .= '...'
        let text .= substitute(getline(v:foldend), '\v^\s*', '', '')
    else
        " Handle simple folds such as arrays and stand-alone function declarations.
        let text .= substitute(line, '\v[ }]*(.{-})\s*(\S*)$', '\1 \2', '')
        let text .= '...'
        let etext = ExtractEndDelim(v:foldend)
        if empty(etext)
            let text .= ExtractEndDelim(v:foldend+1)
        else
            let text .= etext
        endif
    endif

    let lines = v:foldend-v:foldstart+1

    let percentage = ''
    if b:phpfold_text_percent
        let percentage = printf(" [% 4.1f%%]", (lines*1.0)/line('$')*100)
    endif

    let endtext = printf(" % *d lines", NumColWidth(1), lines)

    " Start off with the normal, the fold-level dashes and number of lines in the fold.
    if !b:phpfold_text_right_lines
        let text = '+' . v:folddashes . endtext . percentage . ': ' . text
    else
        " Place the fold-level dashes and number of lines in fold on the right

        " First, add the indentation back to the text, makes it look nicer.
        let text = substitute(line, '\S.*', '', '') . text

        " Determine whether the signs column is being displayed.  The
        " `sign place` command will list all signs placed, or just
        " '^@--- Signs ---^@' if no signs are placed.
        redir => signs
        silent execute "sign place buffer=" . bufnr("%")
        redir END
        let signsWidth = strchars(signs) > 15 ? 2 : 0

        " The amount of space we have to display text: window width less fold
        " column width,  number column width, and the signs column.
        let displayWidth = winwidth(0) - &foldcolumn - NumColWidth() - signsWidth

        " The text to display on the right
        let endtext .= percentage . ' +' . v:folddashes

        " Amount of space for text less the line count and fold level dashes
        let availableWidth = displayWidth - strwidth(endtext)

        " Make sure the display text doesn't need to be truncated.
        if strwidth(text) > availableWidth
            let text = strpart(text, 0, availableWidth-2) . ' -' . endtext
        else
            let filler = repeat(matchstr(&fillchars, 'fold:\zs.'), displayWidth - strwidth(text . endtext))
            let text .= filler . endtext
        endif
    endif

    return text
endfunction

" Finds how many characters wide the number column is.
function! NumColWidth(...)
    let ignorenuwidth = a:0 > 0 ? a:1 : 0

    " If neither numbers nor relative numbers are shown and not ignore number
    " column width, width is 0
    if !&number && !&relativenumber && !ignorenuwidth
        return 0
    endif

    let lines = line('$')
    let width = 9
    let minwidth = ignorenuwidth ? 1 : &numberwidth

    while (lines / float2nr(pow(10, width-2))) == 0 && width > minwidth
        let width = width - 1
    endwhile

    return width
endfunction

" Finds the next line that has a function declaration.  Limit search to the folded region.
function! FindNextFunc(lnum)
    let current = a:lnum+1
    let stopline = v:foldend

    while current <= stopline
        if getline(current) =~? '\v\s*\*/'
            if getline(current+1) =~? '\v\s*(abstract\s+|public\s+|static\s+|private\s+)*function\s+\k'
                return current+1
            endif
            return -1
        endif

        let current += 1
    endwhile

    return -2
endfunction

" Extracts the name and visibility of a function from the given line.
function! ExtractFuncName(lnum)
    return substitute(getline(a:lnum), '\v.{-}(abstract\s+|public\s+|private\s+|static\s+|private\s+)*function\s+(\k+).*', '\1\2() ', '')
endfunction

" Extracts the last delimiter(s) of the line.
function! ExtractEndDelim(lnum)
    return matchstr(getline(a:lnum), '\v^[^\]})]*\zs[\]})]+;?\ze.*$')
endfunction

" Determines if the function in the fold region has a use list, and returns where the use keyword is located.
function! FuncHasUse(lnum)
    let current = a:lnum
    let stopLine = v:foldend

    while current <= stopLine
        if getline(current) =~? '\v\s*\)\s+use\s+\('
            return current
        elseif getline(current) =~? '\v^\s*(\)\s+)?\{'
            return -1
        endif
        let current += 1
    endwhile
    return 0
endfunction
