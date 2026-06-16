# yt-dlp
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

#### 詳細なオプションや最新情報は公式[GitHub](https://github.com/yt-dlp/yt-dlp)を参照してください。

## 音声ファイルの安全性の確認

ダウンロードした音声ファイルが正しいフォーマット・内容であるかを確認するための手順をまとめます。

### 1. fileコマンドでフォーマット確認
ファイルの種類やエンコーディングを確認できます。
```sh
file <ファイル名>
```
例: `file sample.mp3` → "Audio file with ID3 version 2.4.0, MP3 encoding" などと表示されます。  
👉 これで少なくとも「拡張子だけが mp3 で中身が違う」という偽装は見抜けます。



### 2. ffprobeで音声情報確認
ffprobe（ffmpegパッケージに含まれる）で、ビットレートやサンプリングレート、コーデックなど詳細な音声情報を確認できます。
```sh
ffprobe -hide_banner <ファイル名>.mp3
```
* ffprobe  
→ メタ情報を取得するコマンド。ファイルを「再生」したり「変換」したりはしません。安全に情報だけ確認します。
* -hide_banner  
→ 実行時に表示される FFmpeg/ffprobe のバージョン情報や著作権表示を非表示にします。
（純粋にファイル情報だけ見たい時に便利）

```yaml
Input #0, mp3, from 'yourfile.mp3':
  Metadata:
    title           : sample
  Duration: 00:03:12.34, start: 0.000000, bitrate: 64 kb/s
  Stream #0:0: Audio: mp3, 48000 Hz, stereo, fltp, 64 kb/s
```
👉 これで
* Metadata: 曲名、アーティストなどタグ情報
* Duration: 再生時間
* bitrate: ビットレート（音質の目安）
* Audio: mp3, 44100 Hz, stereo: コーデックとチャンネル数  
が分かります。

### 3. afplayで再生確認（macOS）
実際に音声が再生できるかを確認します。
```sh
afplay <ファイル名>
```
👉 音声が普通に流れれば「少なくとも再生可能な音声ファイル」です。



### 注意点
- 不審なファイルや拡張子偽装に注意し、必ず`file`や`ffprobe`で中身を確認してください。
- 容量と再生時間の整合性 → 例：1MB しかないのに10分再生できる → 不自然。
- 公開・配布前には必ず自分で再生確認を行い、意図しない内容が含まれていないかチェックしましょう。
- ffprobeやafplayがインストールされていない場合は、Homebrewで`brew install ffmpeg`などで導入できます。