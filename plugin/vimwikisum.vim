vim9script

if exists("g:loaded_vimwiki_sum")
    finish
endif
g:loaded_vimwiki_sum = 1

import autoload 'vimwikisum.vim'

# Define the user command for visual mode range
command! -range VimwikiAddCells vimwikisum.SumVisualSelection(<line1>, <line2>)
