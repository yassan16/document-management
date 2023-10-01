# deep copyの実装方法
表題の件についてまとめる。

## Cloneable
コピーしたいクラスに「Cloneable」を `implements` することで、Objectクラスの「clone」メソッドを使用する。

## Objectクラス clone()メソッド
`protected` であるため、コピーしたいクラスからでないと呼び出すことができない。

```java
@IntrinsicCandidate
protected native Object clone() throws CloneNotSupportedException;
```


## 参考サイト
* [【Java】ディープコピーの実装方法](https://medium-company.com/java-%E3%83%87%E3%82%A3%E3%83%BC%E3%83%97%E3%82%B3%E3%83%94%E3%83%BC/)
* [Javaでオブジェクトをコピーする](https://www.techiedelight.com/ja/copy-objects-in-java/)
