if exists("loaded_supreme_leader")
    finish
endif
let loaded_supreme_leader = 1


function! s:ColorEcho(str)
  let l:index=0
  for item in split(a:str,"|")
    let l:index+=1
    if l:index % 2
      echon item
    el
      exec "echohl " . item
    en
  endfo
endf

function! s:Menu(selection)
  if a:selection > 0
    " Render inner menus
    let menu = sort(keys(g:supreme_leader_list[nr2char(a:selection)].keys))
  else
    " Render top level menu
    let menu = sort(keys(g:supreme_leader_list))
  endif

  let result = " "
  let arr = []

  for key in menu
    if a:selection > 0
      let result = join([result, '|Label|[|Bold|', key, '|Label|] ', g:supreme_leader_list[nr2char(a:selection)].keys[key][0], '|None| '], '')
    else
      if type(g:supreme_leader_list[key]) == 4
        let binding = g:supreme_leader_list[key].name
        let result = join([result, '|Keyword|[|Bold|', key, '|Keyword|] ', binding, '|None| '], '')
      else
        let binding = g:supreme_leader_list[key][0]
        let result = join([result, '|Label|[|Bold|', key, '|Label|] ', binding, '|None|' ], '')
      endif
    endif
    let nocolor = substitute(result, "Label", '', 'g')
    let nocolor = substitute(nocolor, "None", '', 'g')
    let nocolor = substitute(nocolor, "Keyword", '', 'g')
    let nocolor = substitute(nocolor, "Bold", '', 'g')
    let nocolor = substitute(nocolor, "|", '', 'g')
    if len(nocolor) >= &columns * 0.6
      " let result = join([result, "\n"], '')
      call add(arr, result)
      let result = " "
    else
      let space = 22 - (len(nocolor) % 22)
      while space > 0
        let space -= 1
        let result = join([result, ' '], '')
      endwhile
    endif
  endfor
  if len(result) > 0
    call add(arr, result)
    let result = " "
  endif
  return join(arr, "\n")
endfunction

function! supremeleader#Menu()
  let &cmdheight = 3
  redraw!
  call s:ColorEcho(s:Menu(0))
  let c = getchar()
  let char = nr2char(c)
  if has_key(g:supreme_leader_list, char)
    redraw!
    if type(g:supreme_leader_list[char]) == 4
      call s:ColorEcho(s:Menu(c))
    else
      let &cmdheight = 1
      execute g:supreme_leader_list[char][1]
      return
    endif
    let j = getchar()
    if has_key(g:supreme_leader_list[char].keys, nr2char(j))
      let &cmdheight = 1
      redraw!
      execute g:supreme_leader_list[char].keys[nr2char(j)][1]
    else
      let &cmdheight = 1
      redraw!
    endif
  else
      let &cmdheight = 1
    redraw!
  endif
endfunction

nnoremap <silent> <Space> :call supremeleader#Menu()<cr>

