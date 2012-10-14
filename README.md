lose.vim
========

I find Vim's find command incredibly useful. However, there are a few issues
I have with it that are addressed in this plugin.

Lose presents `:Lose` which is functionally equivalent to vim's built-in find
command with a few differences. First, if multiple files match the search, the
user selects which one to open. Second, globbing is supported so `*.txt` is a
valid query.

Just like Vim's built-in find command, the `path` option must be set by
running `set path=<path dir>`. However, including `**` to allow searching
subdirectories is unnecessary for Lose.

Installation
------------

If you don't have a preferred installation method, I recommend
installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and
then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/marczych/vim-lose.git

Once help tags have been generated, you can view the manual with
`:help lose`.

License
-------

Copyright (c) Marc Zych.  Distributed under the same terms as Vim itself.
See `:help license`.
