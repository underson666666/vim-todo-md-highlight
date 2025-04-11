" todo-highlight.vim
" MIT License
" Copyright (c) 2025 underson666666

" todo.md ファイル内の要素をハイライトするプラグインです。

if exists('g:loaded_todo_highlight')
  finish
endif
let g:loaded_todo_highlight = 1

augroup TodoHighlight
  autocmd!
  autocmd BufRead,BufNewFile,BufWinEnter *.md if expand('%:t') == 'todo.md' | call s:todo_highlight_projects() | endif
  autocmd BufRead,BufNewFile,BufWinEnter *.md if expand('%:t') == 'todo.md' | call s:highlight_at() | endif
  autocmd BufRead,BufNewFile todo.md call s:highlight_due_date()
  autocmd BufWritePost todo.md call s:todo_backup()
augroup END

function! s:todo_highlight_projects()
  let s:todo_projects = get(g:, 'todo_projects', ['projectA', 'projectB', 'projectC'])
  let s:todo_colors = get(g:, 'todo_colors', ['lightblue', 'green', 'cyan', 'lightmagenta', 'darkgreen', 'darkcyan', 'lightred', 'blue', 'lightyellow', 'lightgreen'])

  for i in range(len(s:todo_projects))
    let project = s:todo_projects[i]
    let color = s:todo_colors[i % len(s:todo_colors)]

    execute 'highlight Todo' . i . ' ctermfg=' . color . ' guifg=' . color
    execute 'syntax match Todo' . i . ' /+' . project . '\>/'
  endfor
endfunction

function! s:highlight_at()
  " @ をハイライトする
  let s:at_color = 'magenta'

  execute 'highlight TodoAt ctermfg=' . s:at_color . ' guifg=' . s:at_color
  execute 'syntax match TodoAt /@/'
endfunction

function! s:add_todo_line()
  let line = '- [ ] +project due:2025-xx-xx TASK @context'
  call append(line('.'), line)
endfunction

command! AddTodoLine call s:add_todo_line()

function! s:add_today_line()
  let today = strftime('%Y-%m-%d(%a)')
  let current_line = line('.')
  call append(current_line, today)
endfunction

command! AddTodayLine call s:add_today_line()

function! s:add_today_inline()
  let today = strftime('%Y-%m-%d')
  let current_col = col('.')
  let current_line = getline('.')
  let new_line = current_line[:current_col - 1] . today . current_line[current_col:]
  call setline('.', new_line)
  call cursor(line('.'), current_col + len(today))
endfunction
command! AddTodayInline call s:add_today_inline()

" スペースキーで状態を変更
function! s:toggle_task_status(reverse)
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

nnoremap <Space> :call <SID>toggle_task_status(0)<CR>
nnoremap <S-Space> :call <SID>toggle_task_status(1)<CR>

" WindowsのVimで+localtimeオプションが有効になっていなかったため自作
function! s:strptime(date_str, format)
  let year = str2nr(matchstr(a:date_str, '\d\{4}'))
  let month = str2nr(matchstr(a:date_str, '-\zs\d\{2}\ze-'))
  let day = str2nr(matchstr(a:date_str, '-\zs\d\{2}\ze$'))

  return [year, month, day]
endfunction

function! s:date_diff(date1, date2)
  let year1 = a:date1[0]
  let month1 = a:date1[1]
  let day1 = a:date1[2]
  let year2 = a:date2[0]
  let month2 = a:date2[1]
  let day2 = a:date2[2]

  let days1 = year1 * 365 + (month1 - 1) * 30 + day1
  let days2 = year2 * 365 + (month2 - 1) * 30 + day2

  return days1 - days2
endfunction

function! s:highlight_due_date()
  let due_date_days = get(g:, 'todo_due_date_days', 3)
  let today = strftime('%Y-%m-%d')
  let today_time = s:strptime(today, '%Y-%m-%d')

  execute 'highlight TodoDueDateNear ctermfg=yellow guifg=yellow'
  execute 'highlight TodoDueDateExpired ctermfg=red guifg=red'

  let line_num = 1
  while line_num <= line('$')
    let line = getline(line_num)
    let due_date_match = matchstr(line, '\vdue:\zs\d{4}-\d{2}-\d{2}')

    if due_date_match != ''
      let due_date_time = s:strptime(due_date_match, '%Y-%m-%d')
      " let diff_days = s:date_diff(today_time, due_date_time)
      let diff_days = s:date_diff(due_date_time, today_time)

      if diff_days < 0 || diff_days == 0
        execute 'syntax match TodoDueDateExpired /' . due_date_match . '/'
      " elseif diff_days <= due_date_days
      elseif diff_days <= due_date_days
        execute 'syntax match TodoDueDateNear /' . due_date_match . '/'
      endif
    endif

    let line_num += 1
  endwhile
endfunction

function! s:todo_backup()
  if !exists('g:todo_backup_path')
    echoerr "g:todo_backup_path is not set!"
    return
  endif

  let l:timestamp = strftime("%Y-%m-%d_%H-%M-%S")
  let l:src = expand("%:p")
  let l:dst = g:todo_backup_path . "\\todo_" . l:timestamp . ".md"
  let l:cmd = 'copy "' . l:src . '" "' . l:dst . '"'
  call system(l:cmd)
endfunction

" Gitに`todo.md`をadd, commitする関数
function! TodoGitCommit()
  " コミットメッセージの入力を促す
  let l:msg = input('Enter commit message: ')

  " 入力が空の場合、デフォルトのメッセージを設定
  if empty(l:msg)
    let l:msg = 'Updated todo.md'
  endif

  " 現在時刻をフォーマットして取得（例: 2025-04-11 14:30:00）
  let l:timestamp = strftime('%Y-%m-%d %H:%M:%S')

  " コミットメッセージにタイムスタンプを付加
  let l:commit_msg = l:msg . ' (' . l:timestamp . ')'

  " Git に todo.md を add する
  let l:add_result = system('git add todo.md')

  " エラー出力があれば表示（オプション）
  if v:shell_error
    echohl ErrorMsg | echom "git add failed: " . l:add_result | echohl None
    return
  endif

  " Git commit を実行
  let l:commit_result = system('git commit -m ' . shellescape(l:commit_msg))

  " コミットに成功したか確認
  if v:shell_error
      echohl ErrorMsg | echom "git commit failed: " . l:commit_result | echohl None
  else
      echom "コミット成功: " . l:commit_msg
  endif
endfunction

command! TodoCommit call TodoGitCommit()
