# yt-dlp

## ツールの概要
yt-dlpは、youtube-dlをベースに機能拡張・高速化された動画ダウンロード用コマンドラインツールです。YouTubeをはじめとする多くの動画・音声サイトに対応し、最新の仕様変更にも迅速に追従しています。

## ダウンロード方法
macOSではHomebrewを使って簡単にインストールできます。

```sh
brew install yt-dlp
```

## 使い方
基本的な使い方は、ダウンロードしたい動画のURLを指定してコマンドを実行するだけです。

### 動画をダウンロード
```sh
yt-dlp <動画のURL>
```

### 音声のみを抽出
```sh
yt-dlp -x --audio-format mp3 <動画のURL>
```

### 詳細なオプションや最新情報は公式GitHub（https://github.com/yt-dlp/yt-dlp）を参照してください。
