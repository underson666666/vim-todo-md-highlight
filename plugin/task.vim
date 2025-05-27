" task.vim

function! AddTodoLine()
  let today = strftime('%Y-%m-%d')
  let line = '- [ ] +project due:' . today . ' :cactus:TASK @context created:' . today
  call append(line('.'), line)
  call cursor(line('.') + 1, 1)
endfunction

command! AddTodoLine call AddTodoLine()

function! AddTodayLine()
  let today = strftime('%Y-%m-%d(%a)')
  let current_line = line('.')
  call append(current_line, today)
endfunction

command! AddTodayLine call AddTodayLine()

function! AddTodayInline()
  let today = strftime('%Y-%m-%d')
  let current_col = col('.')
  let current_line = getline('.')
  let new_line = current_line[:current_col - 1] . today . current_line[current_col:]
  call setline('.', new_line)
  call cursor(line('.'), current_col + len(today))
endfunction
command! AddTodayInline call AddTodayInline()

" スペースキーで状態を変更
function! ToggleTaskStatus(reverse)
  let current_line = getline('.')
  let status_match = matchstr(current_line, '\[.\{1}\]')

if a:reverse
    " 逆回転
    if status_match == '[ ]'
      let new_line = substitute(current_line, '\[ \]', '\[b\]', '')
    elseif status_match == '[b]'
      let new_line = substitute(current_line, '\[b\]', '\[w\]', '')
    elseif status_match == '[w]'
      let new_line = substitute(current_line, '\[w\]', '\[x\]', '')
    elseif status_match == '[x]'
      let new_line = substitute(current_line, '\[x\]', '\[-\]', '')
    elseif status_match == '[-]'
      let new_line = substitute(current_line, '\[-\]', '\[ \]', '')
    else
      return "ステータスが見つかりません"
    endif
  else
    " 通常回転
    if status_match == '[ ]'
      let new_line = substitute(current_line, '\[ \]', '\[-\]', '')
    elseif status_match == '[-]'
      let new_line = substitute(current_line, '\[-\]', '\[x\]', '')
    elseif status_match == '[x]'
      let new_line = substitute(current_line, '\[x\]', '\[w\]', '')
    elseif status_match == '[w]'
      let new_line = substitute(current_line, '\[w\]', '\[b\]', '')
    elseif status_match == '[b]'
      let new_line = substitute(current_line, '\[b\]', '\[ \]', '')
    else
      return "ステータスが見つかりません"
    endif
  endif

  call setline('.', new_line)
endfunction

nnoremap <Space> :call ToggleTaskStatus(0)<CR>
nnoremap <S-Space> :call ToggleTaskStatus(1)<CR>
