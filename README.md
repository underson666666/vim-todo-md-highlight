# todo_highlight.vim

`todo.md` ファイルのタスク管理を強化する Vim プラグインです。

## 特徴

* プロジェクト名、`@context`、完了日をハイライト表示
* スペースキーでタスクの状態を切り替え
* `AddTodoLine` コマンドでタスク行を簡単に追加

## インストール

1.  Vim のプラグインディレクトリに `todo_highlight.vim` を配置します。
    * 例: `~/.vim/plugin/todo_highlight.vim`
2.  Vim を再起動します。

## 使い方

### ハイライト

`todo.md` ファイルを開くと、以下の要素が自動的にハイライトされます。

* プロジェクト名: `g:todo_colors` で指定した色でハイライト (デフォルト: 青、緑、シアンなど)
* `@context`: マゼンタでハイライト
* 完了日:
    * 過去日: 赤色でハイライト
    * 今日から `g:todo_due_date_days` 日以内 (デフォルト: 3日) : 黄色でハイライト

### タスクの状態を切り替え

* スペースキー: タスクの状態を `[ ]` -> `[-]` -> `[x]` -> `[w]` -> `[b]` -> `[ ]` の順に切り替え
* Shift + スペースキー: タスクの状態を逆順に切り替え

### タスク行を追加

`:AddTodoLine` コマンドを実行すると、カーソル位置の次の行にタスク行を追加します。

## 設定

以下の変数を `~/.vimrc` に記述することで、プラグインの動作をカスタマイズできます。

* `g:todo_projects`: プロジェクト名のリスト (デフォルト: `['projectA', 'projectB', 'projectC']`)
* `g:todo_colors`: プロジェクト名のハイライト色のリスト (デフォルト: `['blue', 'green', 'cyan', 'darkmagenta', 'darkblue', 'darkgreen', 'darkcyan', 'white', 'darkyellow', 'palegreen']`)
* `g:todo_due_date_days`: 完了日が近いタスクをハイライトする日数 (デフォルト: 3)

## 例

```vim
" ~/.vimrc

let g:todo_projects = ['work', 'home', 'study']
let g:todo_colors = ['red', 'blue', 'green']
let g:todo_due_date_days = 2

## 注意事項
- 完了日の形式は `YYYY-MM-DD` に対応しています。
- `g:todo_colors` の色は、Vim の color scheme によって表示が異なる場合があります。
- Windows 版の Vim では、`strptime()` 関数が使用できないため、日付計算に独自の関数を使用しています。