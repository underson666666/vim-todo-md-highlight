" git.vim

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

      " バックアップファイルを削除
      if exists('g:todo_backup_path')
        let l:backup_path = substitute(g:todo_backup_path, '\\', '/', 'g')
        let l:delete_cmd = 'del /q /f "' . l:backup_path . '\*.*"'
        " ファイルが存在しない場合にエラーにならないようにする
        try
          silent! call system(l:delete_cmd)
        catch /E171:/
          " コマンドが無効な場合（例: Windows以外）はエラーを無視
          echom "バックアップファイルの削除に失敗しました: " . l:delete_cmd
        endtry
      endif
  endif

  " バックアップファイルを削除
  if exists('g:todo_backup_path')
    let l:backup_path = substitute(g:todo_backup_path, '\\', '/', 'g')
    let l:delete_cmd = 'del /q /f "' . l:backup_path . '\*.*"'
    " ファイルが存在しない場合にエラーにならないようにする
    try
      silent! call system(l:delete_cmd)
    catch /E171:/
      " コマンドが無効な場合（例: Windows以外）はエラーを無視
      echom "バックアップファイルの削除に失敗しました: " . l:delete_cmd
    endtry
  endif
endfunction

command! TodoCommit call TodoGitCommit()