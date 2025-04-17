" backup.vim

function! TodoBackup()
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