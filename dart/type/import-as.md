# importとas
importとasについて記載する。

## import
他のDartプログラムを取り込むことができる。
これにより、Dartには標準で用意されていない機能を使用することができる。

```
import 'dart:xxxx
```

## as
import文で別名を使用して、他のライブラリをインポートすることができる。
asキーワードを使用すると、インポートされたライブラリの名前を変更できる。

```
import 'dart:math' as math;
```
mathクラスのインスタンスにあるメソッドのように使用できる。
