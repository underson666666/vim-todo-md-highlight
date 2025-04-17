" project.vim

"todo.mdからプロジェクト名を抽出する関数を定義
function! ExtractTodoProjects()
  " プロジェクト名を格納する空のリストを作成
  let l:projects = []

  " バッファ内の全行を取得する
  for l:line in getline(1, '$')
    " 半角スペースの間にある'+'から始まる文字列を抽出する正規表現を適用
    let l:matches = matchlist(l:line, '\s\zs+.\{-}\ze\s')
    if !empty(l:matches)
      " 抽出されたプロジェクト名はキャプチャグループの0番目の要素に入る
      let l:project = l:matches[0]
      " もし先頭が '+' なら削除する（万が一キャプチャに含まれていた場合の対策）
      " g:todo_projectsが`+`が先頭から始まる文字列を想定していないためである
      if strlen(l:project) > 0 && l:project[0] ==# '+'
        let l:project = l:project[1:]
      endif
      " 重複がなければリストに追加する
      if index(l:projects, l:project) == -1
        call add(l:projects, l:project)
      endif
    endif
  endfor

  " 抽出されたプロジェクト名のリストを表示（確認用）
  " echom "抽出されたプロジェクト: " .  join(l:projects, ', ')

  " 結果をグローバル変数に格納（ハイライト設定などの他の用途で利用可能）
  let g:todo_projects = l:projects
endfunction

" todo.mdを開いた際に自動でプロジェクト名を抽出するautocommandを設定
augroup TodoProjects
  autocmd!
  autocmd BufReadPost todo.md call ExtractTodoProjects()
augroup END