# Easy Comment for Vim

Easy Comment is a Vim plugin which makes it easy to comment out lines and
blocks of code. It supports configuration for both block- and inline-style
comments. There are a few definitions included for some languages, but you can
define the comment character and commenting style for your language in your
`.vimrc`

## Installation

If you use Vundle, in your `.vimrc` add this line,

    Plugin 'jdhillon/vim-easycomment'

Then do,

    :PluginInstall()


## Configuration

You will now want to map the `ToggleCommentVisual` and `ToggleCommentLine` to
the same key, by adding the following lines to `.vimrc`

    vmap <silent> <C-_> :call ToggleCommentVisual()<CR>
    nmap <silent> <C-_> :call ToggleCommentLine()<CR>

The suggested mapping is <kbd>Ctrl + /</kbd> (due to historical reasons, 
forward slash is represented as underscore when mapping keys in Vim). The first
mapping will invoke `ToggleCommentVisual()` on any visual selection, causing
comment/uncommenting of the lines spanned by that selection. The second mapping
can be invoked without any selection, and will comment/uncomment the current
line.

## Defining Comment Styles

Commenting styles are defined by the use of buffer-scoped variables (prefixed
with `b:`) defined by autocommands which are run when a given file-type is
detected. To explain by example, consider Python -- each comment begins with
`#` and only line beginning with that character are commented out. So, we would
define this like so,

    au FileType python let b:comment_style="inline"
    au FileType python let b:comment_opener="#"

These two variables are defined only for buffers where the python file type is
detected. The `b:comment_style` variable is set to `"inline"` so that means
each line being commented will have a character prepended to it. The 
`b:comment_opener` variable is set to `#` so comments begin with `#`. With this
configuration, if a block of Python code is visually selected and then
commented out, each line will have a `#` prepended to it. If they were already
commented out, then they would be uncommented.

A block comment is any comment where there are opening and closing characters
indicating the start and end of the comment, and they can be on different
lines. Any lines between the beginning and the ending are also in the comment.
Examples of this style are CSS, HTML and C.

For block-style commenting, you need to define three variables:

    au FileType css let b:comment_style="block"
    au FileType css let b:comment_opener="/*"
    au FileType css let b:comment_closer="*/"

The third variable simply indicates which sequence marks the end of the
comment.
