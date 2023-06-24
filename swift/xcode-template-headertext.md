# デフォルトのヘッダーコメントのテンプレート
Xcodeでのファイル作成時に、ヘッダーコメントを変更する方法を記載する。

## 1. 以下のファイルを作成する
`~/Library/Developer/Xcode/UserData/IDETemplateMacros.plist`

finderで開ける場合は、  
1. メニューバーの「移動」をクリック。
2. 「フォルダへ移動...」を選択する。
3. ダイアログボックスが表示されたら、パスを入力する。

## 2. `IDETemplateMacros.plist`を編集する
`<string>`のタグ内がヘッダーコメント部分に該当するので、変更することでソースに反映できる。

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>FILEHEADER</key>
<string>
//  ___FILENAME___
//  ___TARGETNAME___
//  
//  Created by ___USERNAME___ on ___DATE___
//  ___COPYRIGHT___
//</string>
</dict>
</plist>
```

## 参考サイト
・Xcodeで作成したファイル自動付与されるコメントを変える  
  `https://zenn.dev/hulk510/articles/xcode-header-comment-edit`  

・[Apple] Customize text macros  
`https://help.apple.com/xcode/mac/9.0/index.html?localePath=en.lproj#/dev91a7a31fc`

