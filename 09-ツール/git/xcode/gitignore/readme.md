# メモ書き 
Xcodeでの.gitignoreについてまとめている。

## .gitignoreが反映されない
.gitignoreがうまく反映されないことがある。  
そのときに参考にした記事や方法をまとめておく。

### 対応方法
リモートリポジトリに、名前の含まれたフォルダ名でコミットされていたので、pushされないようにした。  
結局、Xcode側のUI操作を使用せずに、ターミナルからgitコマンドでpushまで行うと反映された。

### 参考サイト
* [【2021年版】Xcodeを使用する場合の.gitignoreの内容及び、その解説](https://qiita.com/higan96/items/36d3877a85ab8fc36ea7)
* [【Xcode/Swift】Xcodeでの.gitignoreの設定方法、自分が使っている.gitignoreの内容を解説](https://ios-docs.dev/xcode-gitignore/)
* [Xcodeにて.gitignoreが反映されない時の解決方法](https://qiita.com/chitomo12/items/a44592ddfc833f8dabf7)
* [XcodeでGitを操作してみた](https://dev.classmethod.jp/articles/tried-git-with-xcode/)
* [[GitHub]Swift.gitignore](https://github.com/github/gitignore/blob/main/Swift.gitignore)
* [【Xcode/Git】.gitignoreファイルの設定方法！役割や反映されない解決法とは？](https://tech.amefure.com/swift-git-gitignore)
* [プロジェクト新規作成をしたらはじめにやってること](https://zenn.dev/nkysyuichi/articles/7694975d156dcc)
