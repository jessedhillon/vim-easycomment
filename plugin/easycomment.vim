function! s:IsLineCommented(l)
    return getline(a:l) =~ '\v^\s*'.escape(b:comment_opener, "\/*")
endfunction

function! ToggleCommentVisual() range
    if exists("b:comment_style")
        let fl = getpos("'<")[1]
        let ll = getpos("'>")[1]

        if s:IsLineCommented(fl)
            call s:Uncomment(fl, ll)
        else
            call s:Comment(fl, ll)
        endif
    endif
endfunction

function! ToggleCommentLine()
    if exists("b:comment_style")
        let l = getpos(".")[1]

        if s:IsLineCommented(l)
            call s:Uncomment(l, l)
        else
            call s:Comment(l, l)
        endif
    endif
endfunction

function! s:Comment(fl, ll)
    if b:comment_style == "inline"
        call s:InlineComment(a:fl, a:ll)
    elseif b:comment_style == "block"
        call s:BlockComment(a:fl, a:ll)
    endif
endfunction

function! s:Uncomment(fl, ll)
    if b:comment_style == "inline"
        call s:InlineUncomment(a:fl, a:ll)
    elseif b:comment_style == "block"
        call s:BlockUncomment(a:fl, a:ll)
    endif
endfunction

function! s:BlockComment(fl, ll)
    call setline(a:fl, b:comment_opener.getline(a:fl))
    call setline(a:ll, getline(a:ll).b:comment_closer)

    let padding = repeat(" ", strlen(b:comment_opener))
    let i = a:fl+1
    while i <= (a:ll - 1)
        call setline(i, padding.getline(i))
        let i = i + 1
    endwhile
endfunction

function! s:InlineComment(fl, ll)
    let i = a:fl
    while i <= a:ll
        if !s:IsLineCommented(i)
            let cl = getline(i)
            let cl2 = b:comment_opener.cl
            call setline(i, cl2)
        endif
        let i = i + 1
    endwhile
endfunction

function! s:BlockUncomment(fl, ll)
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

function! s:InlineUncomment(fl, ll)
    let i = a:fl
    while i <= a:ll
        let cl = getline(i)
        let cl2 = substitute(cl, '\v^(\s*)'.escape(b:comment_opener, "\/*"), '\1', "")
        call setline(i, cl2)
        let i = i + 1
    endwhile
endfunction

" comment style definitions
au FileType vim,javascript,python,ruby let b:comment_style="inline"
au FileType html,css,c let b:comment_style="block"

au FileType vim let b:comment_opener='"'
au FileType javascript let b:comment_opener='//'
au FileType python,ruby let b:comment_opener='#'

au FileType c,css let b:comment_opener='/*'
au FileType c,css let b:comment_closer='*/'

au FileType html let b:comment_opener='<!--'
au FileType html let b:comment_closer='-->'
