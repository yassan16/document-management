# セマフォ (semaphore) について
非同期な処理を同期処理として扱うことができる。

## DispatchSemaphoreクラス
このクラスのインスタンスには内部でvalueという数値をカウントする仕組みがあって、「valueが0になるまでは処理を止める」ということができる。

### wait
Valueがデクリメントされる(1引かれる)。処理を待たせる。

### signal
valueがインクリメントされる(1足される)。処理を進める合図を送るようなイメージ。

### 使用イメージ
1. 非同期処理が始まったときに wait()を呼んで value=-1にする。
2. value=-1なので処理が止まる
3. 非同期処理が終わったときに signal()を呼んで value=0 にする。
4. value=0なのでwaitで止まってた場所から処理が始まる。

## 参考サイト
* [[Swift] 複雑な非同期処理が作り出すコールバック地獄とネスト地獄を解消したい! セマフォを使ったシンプルなリファクト方法を試してみた](https://dev.classmethod.jp/articles/sync-process-with-dispatch-semaphore/)
* [DispatchSemaphoreで非同期処理の完了を待つ](https://scior.hatenablog.com/entry/2019/09/11/231626)
