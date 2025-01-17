" zoomwintab.vim - simple zoom window vim
" Maintainer: Dmitry "troydm" Geurkov <d.geurkov@gmail.com>
" Version: 0.1
" Description: zoomwintab.vim is a simple zoom window plugin
" that uses tabs feature to zoom into a window inspired by ZoomWin
" Last Change: 11 February, 2013
" License: Vim License (see :help license)
" Website: https://github.com/troydm/zoomwintab.vim
"
" See zoomwintab.vim for help.  This can be accessed by doing:
" :help zoomwintab

let s:save_cpo = &cpo
set cpo&vim


" functions {{{1
" zoomwintab#RefreshAirline {{{2
function! zoomwintab#RefreshAirline()
    if exists('g:loaded_airline') && g:loaded_airline
        exe 'AirlineRefresh'
    endif
endfunction

" ZoomWinTabIn {{{2
function! zoomwintab#In()
    if exists('*getcmdwintype') && getcmdwintype() != ''
        return
    endif
    if exists('t:zoomwintab')
        return
    endif
    if winnr('$') == 1
        return
    endif
    let bufn = bufnr('%')
    let tabpage = tabpagenr()
    let swbuf = &switchbuf
    set switchbuf&
    exe 'tab sb '.bufn
    let &switchbuf = swbuf
    if tabpage != tabpagenr()
        let t:zoomwintab = &stal
        let t:zoomwintabnr = tabpage
        if g:zoomwintab_hidetabbar == 1
            set showtabline=0
        endif
    endif
    call zoomwintab#RefreshAirline()
endfunction

" ZoomWinTabOut {{{2
function! zoomwintab#Out()
    if !exists('t:zoomwintab')
        return
    endif
    let &stal = t:zoomwintab
    let tabpage = t:zoomwintabnr
    tabclose
    if tabpagenr() != tabpage
        exe 'tabnext '.tabpage
    endif
    call zoomwintab#RefreshAirline()
endfunction

" ZoomWinTabToggle {{{2
function! zoomwintab#Toggle()
    if exists('t:zoomwintab')
        call zoomwintab#Out()
    else
        call zoomwintab#In()
    endif
endfunction

" ZoomWinTabStatus {{{2
function! zoomwintab#Status()
    if exists('t:zoomwintab')
        return 'zoomed in'
    else
        return ''
    endif
endfunction

" commands {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
