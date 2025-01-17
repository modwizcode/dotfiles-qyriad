" Extended from lifepillar/vim-solarized8.

highlight clear
syntax reset

" Load the "base" colorscheme.
runtime colors/solarized8.vim

" Override the set name from above.
let g:colors_name = "solarized_grey"

" Override just these specific colors.
" The first one makes the normal background a medium-dark grey, instead of the blue
" solarized8 uses.
" The second one changes the Line number color to go better with said changed Normal
" background color.
highlight Normal            guibg=#1b1b1b
highlight LineNR ctermfg=11 guibg=#212728

"highlight link CocMenuSel PmenuSel
