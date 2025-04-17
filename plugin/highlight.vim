" highlight.vim

function! TodoHighlightProjects()
  let s:todo_projects = get(g:, 'todo_projects', ['projectA', 'projectB', 'projectC'])
  let s:todo_colors = get(g:, 'todo_colors', ['lightblue', 'green', 'cyan', 'lightmagenta', 'darkgreen', 'darkcyan', 'lightred', 'blue', 'lightyellow', 'lightgreen'])

  for i in range(len(s:todo_projects))
    let project = s:todo_projects[i]
    let color = s:todo_colors[i % len(s:todo_colors)]

    execute 'highlight Todo' . i . ' ctermfg=' . color . ' guifg=' . color
    execute 'syntax match Todo' . i . ' /+' . project . '\>/'
  endfor
endfunction

function! HighlightAt()
  " @ をハイライトする
  let s:at_color = 'magenta'

  execute 'highlight TodoAt ctermfg=' . s:at_color . ' guifg=' . s:at_color
  execute 'syntax match TodoAt /@/'
endfunction

function! HighlightDueDate()
  let due_date_days = get(g:, 'todo_due_date_days', 3)
  let today = strftime('%Y-%m-%d')
  let today_time = Strptime(today, '%Y-%m-%d')

  execute 'highlight TodoDueDateNear ctermfg=yellow guifg=yellow'
  execute 'highlight TodoDueDateExpired ctermfg=red guifg=red'

  let line_num = 1
  while line_num <= line('$')
    let line = getline(line_num)
    let due_date_match = matchstr(line, '\vdue:\zs\d{4}-\d{2}-\d{2}')

    if due_date_match != ''
      let due_date_time = Strptime(due_date_match, '%Y-%m-%d')
      " let diff_days = s:date_diff(today_time, due_date_time)
      let diff_days = DateDiff(due_date_time, today_time)

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