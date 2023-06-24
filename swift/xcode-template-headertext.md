# デフォルトのヘッダーコメントのテンプレート
Xcodeでのファイル作成時に、ヘッダーコメントを変更する方法を記載する。

## 全てのプロジェクトに反映させる場合

### 1. 以下のファイルを作成する
`~/Library/Developer/Xcode/UserData/IDETemplateMacros.plist`

finderで開ける場合は、  
1. メニューバーの「移動」をクリック。
2. 「フォルダへ移動...」を選択する。
3. ダイアログボックスが表示されたら、パスを入力する。


### 2. `IDETemplateMacros.plist`を編集する
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

## プロジェクト個別に変更したい場合

### 1. 以下のファイルを作成する
`~/プロジェクト名.xcodeproj/xcshareddata/IDETemplateMacros.plist`


### 2. 上記と同じように`IDETemplateMacros.plist`を編集する
上記の「全てのプロジェクトに反映させる場合」も行なっていた場合、この「プロジェクト個別の変更内容」が優先して反映される。


## 参考サイト
・[Xcodeで作成したファイル自動付与されるコメントを変える](https://zenn.dev/hulk510/articles/xcode-header-comment-edit)

・[[Apple]Customize text macros](https://help.apple.com/xcode/mac/9.0/index.html?localePath=en.lproj#/dev91a7a31fc)

