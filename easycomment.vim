function! IsLineCommented(l)
    if b:comment_style == "inline"
        return getline(a:l) =~ '\v^\s*'.escape(b:comment_opener, "\/*")
    endif
    return 0
endfunction

function! ToggleCommentVisual() range
    if exists("b:comment_style")
        let fl = getpos("'<")[1]
        let ll = getpos("'>")[1]

        if getline(fl) =~ '\v^\s*'.escape(b:comment_opener, "\/*")
            call Uncomment(fl, ll)
        else
            echo "commenting"
            call Comment(fl, ll)
        endif
    endif
endfunction

function! ToggleCommentLine()
    if exists("b:comment_style")
        let l = getpos(".")[1]

        if getline(l) =~ '\v^\s*'.escape(b:comment_opener, "\/*")
            call Uncomment(l, l)
        else
            call Comment(l, l)
        endif
    endif
endfunction

function! Comment(fl, ll)
    if b:comment_style == "inline"
        call InlineComment(a:fl, a:ll)
    elseif b:comment_style == "block"
        call BlockComment(a:fl, a:ll)
    endif
endfunction

function! Uncomment(fl, ll)
    if b:comment_style == "inline"
        call InlineUncomment(a:fl, a:ll)
    elseif b:comment_style == "block"
        call BlockUncomment(a:fl, a:ll)
    endif
endfunction

function! BlockComment(fl, ll)
    call setline(a:fl, b:comment_opener.getline(a:fl))
    call setline(a:ll, getline(a:ll).b:comment_closer)

    let padding = repeat(" ", strlen(b:comment_opener))
    let i = a:fl+1
    while i <= (a:ll - 1)
        call setline(i, padding.getline(i))
        let i = i + 1
    endwhile
endfunction

function! InlineComment(fl, ll)
    let i = a:fl
    while i <= a:ll
        if !IsLineCommented(i)
            let cl = getline(i)
            let cl2 = b:comment_opener.cl
            call setline(i, cl2)
        endif
        let i = i + 1
    endwhile
endfunction

function! BlockUncomment(fl, ll)
    let i = a:fl
    call setline(a:fl, substitute(getline(a:fl), '\v^(\s*)'.escape(b:comment_opener, "\/*"), '\1', ""))
    call setline(a:ll, substitute(getline(a:ll), '\v(\s*)'.escape(b:comment_closer, "\/*")."$", '\1', ""))

    let padding = repeat(" ", strlen(b:comment_opener))
    let i = a:fl+1
    while i <= (a:ll - 1)
        call setline(i, substitute(getline(i), "^".padding, "", ""))
        let i = i + 1
    endwhile
endfunction

function! InlineUncomment(fl, ll)
    let i = a:fl
    while i <= a:ll
        let cl = getline(i)
        let cl2 = substitute(cl, '\v^(\s*)'.escape(b:comment_opener, "\/*"), '\1', "")
        call setline(i, cl2)
        let i = i + 1
    endwhile
endfunction

