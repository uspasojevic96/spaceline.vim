" =============================================================================
" Filename: spaceline.vim
" Author: taigacute
" URL: https://github.com/taigacute/spaceline.vim
" License: MIT License
" =============================================================================
"
function! s:short_statusline() abort
    let s:statusline=""
    let s:statusline.="%#HomeMode#"
    let s:statusline.="%{spaceline#buffer#buffer()}"
    let s:statusline.="%#ShortRight#"
    let s:statusline.=g:sep.homemoderight
    let s:statusline.="%#emptySeperate1#"
    let s:statusline.="%="
    let s:statusline.="%#StatusLineinfo#"
    let s:statusline.="%{spaceline#file#file_type()}"
    return s:statusline
endfunction

function! s:ActiveStatusLine()
    let squeeze_width = winwidth(0) / 2
    let s:statusline=""
    let s:statusline.="%#HomeMode#"
    let s:statusline.="\ "
    let s:statusline.="%{spaceline#vimode#vim_mode()}"
    let s:statusline.="%#HomeModeRight#"
    let s:statusline.=g:sep.homemoderight
    let s:statusline.="%#FileName#"
    let s:statusline.="\ "
    let s:statusline.="%{spaceline#file#file_name()}"
    let s:statusline.="\ "
    let s:statusline.="%#FileNameRight#"
    let s:statusline.=g:sep.filenameright

    if !empty(spaceline#diagnostic#diagnostic_error())|| !empty(spaceline#diagnostic#diagnostic_warn()) && squeeze_width >40
        let s:statusline.="%#CocError#"
        let s:statusline.="\ "
        let s:statusline.="%{spaceline#diagnostic#diagnostic_error()}"
        let s:statusline.="\ "
        let s:statusline.="%#CocWarn#"
        let s:statusline.="%{spaceline#diagnostic#diagnostic_warn()}"
        let s:statusline.="\ "
    elseif !empty(spaceline#file#file_size()) && squeeze_width > 40
        let s:statusline.="%#Filesize#"
        let s:statusline.="%{spaceline#file#file_size()}"
        let s:statusline.="\ "
    endif
    if !empty(spaceline#vcs#git_branch())
        let s:statusline.="%#GitLeft#"
        let s:statusline.=g:sep.gitleft
        let s:statusline.="%#GitInfo#"
        let s:statusline.="\ "
        let s:statusline.="%{spaceline#vcs#git_branch()}"
        let s:statusline.="\ "
        if !empty(get(b:,'coc_git_status'))
          let diff_data = get(b:,'coc_git_status', '')
          if matchend(diff_data, '+') > 0
            let s:statusline.="%#GitAdd#"
            let s:statusline.= "%{spaceline#vcs#diff_add()}"
          endif
          if matchend(diff_data, '-') > 0
            let s:statusline.="%#GitRemove#"
            let s:statusline.= "%{spaceline#vcs#diff_remove()}"
          endif
          if matchend(diff_data, '\~') > 0
            let s:statusline.="%#GitModified#"
            let s:statusline.= "%{spaceline#vcs#diff_modified()}"
          endif
        endif
        let s:statusline.="%#GitRight#"
        let s:statusline.=g:sep.gitright
    endif
    if !empty(expand('%:t')) && empty(spaceline#vcs#git_branch()) && &filetype != 'defx' && &filetype != 'coc-explorer' && &filetype != 'debui'
        let s:statusline.="%#emptySeperate1#"
        let s:statusline.=g:sep.emptySeperate1
    endif
    if empty(expand('%:t')) && empty(spaceline#vcs#git_branch())
        let s:statusline.="%#emptySeperate1#"
        let s:statusline.=g:sep.emptySeperate1
    endif
    let s:statusline.="%#CocBar#"
    let s:statusline.="\ "
    let s:statusline.="%{spaceline#status#coc_status()}"
    let s:statusline.="%="
    if squeeze_width >40
      let s:statusline.="%#VistaNearest#%"
      let s:statusline.="%{spaceline#vista#visa_nearest()}"
    endif
    let s:statusline.="%#LineInfoLeft#"
    let s:statusline.=g:sep.lineinfoleft
    if squeeze_width > 40
      let s:statusline.="%#StatusEncod#"
      let s:statusline.="\ "
      let s:statusline.="%{spaceline#file#file_encode()}"
      let s:statusline.="\ "
      let s:statusline.="%#StatusFileFormat#%{spaceline#file#file_format()}"
    endif
    let s:statusline.="%#LineFormatRight#"
    let s:statusline.=g:sep.lineformatright
    let s:statusline.="%#StatusLineinfo#%{spaceline#file#file_type()}"
    let s:statusline.="%#EndSeperate#"
    let s:statusline.="%{spaceline#scrollbar#scrollbar_instance()}"
    return s:statusline
endfunction

function! s:InActiveStatusLine()
    let s:statusline=""
    let s:statusline.="%#HomeMode#"
    let s:statusline.="%#HomeMode#%{spaceline#buffer#buffer()}"
    let s:statusline.="%#InActiveHomeRight#"
    let s:statusline.=g:sep.homemoderight
    let s:statusline.="%#InActiveFilename#"
    let s:statusline.="\ "
    let s:statusline.="%{spaceline#file#file_name()}"
    let s:statusline.="%="
    let s:statusline.="%#StatusLineinfo#%{spaceline#file#file_type()}"
    return s:statusline
endfunction

function! spaceline#colorscheme_init()
  let l:theme = g:spaceline_colorscheme
  let colorstring ='call'.' '.'spaceline#colorscheme#'.l:theme.'#'.l:theme.'()'
  execute colorstring
endfunction

function! s:SetStatusline()
    if index(g:spaceline_shortline_filetype, &filetype) >= 0
      let &l:statusline=s:short_statusline()
      call spaceline#colorscheme_init()
      return
    endif
    let &l:statusline=s:ActiveStatusLine()
    call spaceline#colorscheme_init()
endfunction

function! spaceline#setInActiveStatusLine()
    let &l:statusline=s:InActiveStatusLine()
    call spaceline#colorscheme_init()
endfunction

function! spaceline#spacelinetoggle()
	if get(g:,'loaded_spaceline',0) ==1
    call s:SetStatusline()
  else
    let &l:statusline=''
  endif
endfunction
