" todo-highlight.vim
" MIT License
" Copyright (c) 2025 underson666666

" todo.md ファイル内の要素をハイライトするプラグインです。

if exists('g:loaded_todo_highlight')
  finish
endif
let g:loaded_todo_highlight = 1

" ファイルを読み込む
runtime! highlight.vim
runtime! task.vim
runtime! date.vim
runtime! backup.vim
runtime! git.vim
runtime! project.vim

augroup TodoHighlight
  autocmd!
  autocmd BufRead,BufNewFile,BufWinEnter *.md if expand('%:t') == 'todo.md' | call TodoHighlightProjects() | endif
  autocmd BufRead,BufNewFile,BufWinEnter *.md if expand('%:t') == 'todo.md' | call HighlightAt() | endif
  autocmd BufRead,BufNewFile todo.md call HighlightDueDate()
  autocmd BufWritePost todo.md call TodoBackup()
augroup END

command! AddTodoLine call AddTodoLine()
command! AddTodayLine call AddTodayLine()
command! AddTodayInline call AddTodayInline()
command! TodoCommit call TodoGitCommit()

augroup TodoProjects
  autocmd!
  autocmd BufReadPost todo.md call ExtractTodoProjects()
augroup END

nnoremap <Space> :call ToggleTaskStatus(0)<CR>
nnoremap <S-Space> :call ToggleTaskStatus(1)<CR>
