" Vim color file
" Original Author: Todd Werth <todd@infinitered.com>
" Maintainer: Roman Usherenko <roman.usherenko@gmail.com>
" URL: https://github.com/dreyk/ir_black

" This is a 256- and 88- colors friendly variant of "ir_black" by Todd Werth 
"
" The original "ir_black" theme is available at 
" https://github.com/twerth/ir_black

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists('syntax_on')
        syntax reset
    endif
endif
let g:colors_name='ir_black_256'

exec 'source ' . expand('<sfile>:p:h') . '/rgb_colors'

if has('gui_running') || &t_Co == 88 || &t_Co == 256
    " functions {{{"{{{"}}}
    " returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
        let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
        let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    " call <SID>X(group, fg, bg, attr), bg and attr are optional
    fun <SID>X(group, fg, ...)
        if a:fg != ''
            let fg = tolower(a:fg)
            let fg_hex = has_key(g:rgb_colors, fg) ? g:rgb_colors[fg] : a:fg
            let guifg = fg_hex == 'none' ? 'NONE' : ('#' . fg_hex)
            exec 'hi ' . a:group . ' guifg=' . guifg . ' ctermfg=' . <SID>rgb(fg_hex)
        endif
        if a:0 > 0 && a:1 != ''
            let bg = tolower(a:1)
            let bg_hex = has_key(g:rgb_colors, bg) ? g:rgb_colors[bg] : bg
            let guibg = bg_hex == 'none' ? 'NONE' : ('#' . bg_hex)
            exec 'hi ' . a:group . ' guibg=' . guibg . ' ctermbg=' . <SID>rgb(bg_hex)
        endif
        if a:0 > 1 && a:2 != ''
            let attr = a:2
            exec 'hi ' . a:group . ' gui=' . attr . ' cterm=' . attr
        endif
    endfun
    " }}}

    call <SID>X('Normal', 'f7f3e8', '373737')
    call <SID>X('Nontext', '070707')

    " highlight groups
    call <SID>X('Cursor', 'black', 'white')
    call <SID>X('LineNr', '7c7c7c')
    "CursorIM
    "Directory
    "DiffAdd
    "DiffChange
    "DiffDelete
    "DiffText
    "ErrorMsg
    call <SID>X('VertSplit', '202020', '202020', 'none')
    call <SID>X('StatusLine', 'CCCCCC', '202020', 'italic')
    call <SID>X('StatusLineNC', 'black', '202020', 'none')

    " call <SID>X('Folded', 'a0a8b0')
    call <SID>X('Folded', 'white')
    call <SID>X('Title', 'f6f3e8', 'none', 'italic')
    call <SID>X('Visual', 'none', '262D51', 'reverse')

    call <SID>X('SpecialKey', '808080', '343434')

    call <SID>X('WildMenu', 'green', 'yellow')
    call <SID>X('PmenuSbar', 'black', 'white')

    call <SID>X('Error', 'white', 'red')
    call <SID>X('ErrorMsg', 'white', 'FF6C60', 'bold')
    call <SID>X('LongLineWarning', 'none', '371F1C', 'underline')

    call <SID>X('ModeMsg', 'black', 'C6C5FE', 'bold')

if version >= 700 " Vim 7.x specific colors
    call <SID>X('CursorLine', 'none', '121212')
    call <SID>X('CursorColumn', 'none', '121212')
    call <SID>X('MatchParen', 'f6f3e8', '857b6f', 'bold')
    call <SID>X('Pmenu', 'f6f3e8', '444444')
    call <SID>X('PmenuSel', 'black', 'cae682')
    call <SID>X('Search', '', '', 'reverse')
endif

" Syntax highlighting
    call <SID>X('Comment', '7C7C7C')
    call <SID>X('String', 'A8FF60')
    call <SID>X('Number', 'FF73FD')

    call <SID>X('Keyword', '96CBFE')
    call <SID>X('PreProc', '96CBFE')
    call <SID>X('Conditional', '6699CC')

    call <SID>X('Todo', '8f8f8f')
    call <SID>X('Constant', '99CC99')

    call <SID>X('Identifier', 'C6C5FE')
    call <SID>X('Function', 'FFD2A7')
    call <SID>X('Type', 'FFFFB6')
    call <SID>X('Statement', '6699CC')

    call <SID>X('Special', 'E18964')
    call <SID>X('Delimiter', '00A0A0')
    call <SID>X('Operator', 'white')

hi link Character       Constant
hi link Boolean         Constant
hi link Float           Number
hi link Repeat          Statement
hi link Label           Statement
hi link Exception       Statement
hi link Include         PreProc
hi link Define          PreProc
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link StorageClass    Type
hi link Structure       Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link SpecialComment  Special
hi link Debug           Special


" Special for Ruby
    call <SID>X('rubyRegexp', 'b18a3d')
    call <SID>X('rubyRegexpDelimiter', 'ff8000')
    call <SID>X('rubyEscape', 'white')
    call <SID>X('rubyInterpolationDelimiter', '00a0a0')
    call <SID>X('rubyControl', '6699CC')
    call <SID>X('rubyStringDelimiter', 'A8FF60')
    
"hi rubyGlobalVariable          guifg=#FFCCFF      guibg=NONE      gui=NONE      ctermfg=lightblue      ctermbg=NONE      cterm=NONE  "yield
"rubyInclude
"rubySharpBang
"rubyAccess
"rubyPredefinedVariable
"rubyBoolean
"rubyClassVariable
"rubyBeginEnd
"rubyRepeatModifier
"hi link rubyArrayDelimiter    Special  " [ , , ]
"rubyCurlyBlock  { , , }

hi link rubyClass             Keyword 
hi link rubyModule            Keyword 
hi link rubyKeyword           Keyword 
hi link rubyOperator          Operator
hi link rubyIdentifier        Identifier
hi link rubyInstanceVariable  Identifier
hi link rubyGlobalVariable    Identifier
hi link rubyClassVariable     Identifier
hi link rubyConstant          Type  


" Special for XML
hi link xmlTag          Keyword 
hi link xmlTagName      Conditional 
hi link xmlEndTag       Identifier 


" Special for HTML
hi link htmlTag         Keyword 
hi link htmlTagName     Conditional 
hi link htmlEndTag      Identifier 


" Special for Javascript
hi link javaScriptNumber      Number 


    " delete functions {{{
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}
else
    " color terminal definitions
    hi SpecialKey    ctermfg=darkgreen
    hi NonText       cterm=bold ctermfg=darkblue
    hi Directory     ctermfg=darkcyan
    hi ErrorMsg      cterm=bold ctermfg=7 ctermbg=1
    hi IncSearch     cterm=NONE ctermfg=yellow ctermbg=green
    hi Search        cterm=NONE ctermfg=grey ctermbg=blue
    hi MoreMsg       ctermfg=darkgreen
    hi ModeMsg       cterm=NONE ctermfg=brown
    hi LineNr        ctermfg=3
    hi Question      ctermfg=green
    hi StatusLine    cterm=bold,reverse
    hi StatusLineNC  cterm=reverse
    hi VertSplit     cterm=reverse
    hi Title         ctermfg=5
    hi Visual        cterm=reverse
    hi VisualNOS     cterm=bold,underline
    hi WarningMsg    ctermfg=1
    hi WildMenu      ctermfg=0 ctermbg=3
    hi Folded        ctermfg=darkgrey ctermbg=NONE
    hi FoldColumn    ctermfg=darkgrey ctermbg=NONE
    hi DiffAdd       ctermbg=4
    hi DiffChange    ctermbg=5
    hi DiffDelete    cterm=bold ctermfg=4 ctermbg=6
    hi DiffText      cterm=bold ctermbg=1
    hi Comment       ctermfg=darkcyan
    hi Constant      ctermfg=brown
    hi Special       ctermfg=5
    hi Identifier    ctermfg=6
    hi Statement     ctermfg=3
    hi PreProc       ctermfg=5
    hi Type          ctermfg=2
    hi Underlined    cterm=underline ctermfg=5
    hi Ignore        ctermfg=darkgrey
    hi Error         cterm=bold ctermfg=7 ctermbg=1
endif

" vim: set fdl=0 fdm=marker sts=4 sw=4:
