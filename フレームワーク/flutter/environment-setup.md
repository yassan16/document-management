# 環境構築
実際に行った環境構築の手順を記載する。

## Flutterのダウンロード
以下からダウンロードする。  
[https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

このとき、OSとデバイスを選んでから「Download then install Flutter」を見ること。

## ターミナルでシェルの確認
```
echo $SHELL
```

## パスを通す
/bin/zsh の場合、ホームディレクトリは配下「.zshrc」ファイルを編集する。
```
export PATH=$HOME/<flutterをダウンロードした場所>/flutter/bin:$PATH
```
ターミナルを一度閉じる。

## パスの確認
flutterのパスが表示されていれば完了。
```
which flutter
```

## Flutter docterで確認
ターミナルでflutterの起動に問題ないか、調べる。
```
flutter doctor
```

## 問題があった場合は、`CocoaPods`をダウンロード
`CocoaPods`をダウンロードする。
```
$ sudo gem install cocoapods
```
/bin/zsh の場合、ホームディレクトリは配下「.zshrc」ファイルを編集する。
```
export PATH=$HOME/.gem/bin:$PATH
```
ターミナルを一度閉じる。


