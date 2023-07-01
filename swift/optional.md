# Optional型
Swiftの変数は、nilを許容していない。(Null Safetyな言語)  
nilを許容するには、Optional型を使用する必要がある。

## 基本的な変数

```Swift
var a: String = "Swift"
print(a) // Swift

// nilは許容していない
a = nil
// 実行結果
// 'nil' cannot be assigned to type 'String'

```

## Optional型の宣言
変数の後ろに`?`を記述する。

```Swift
// Optional型では、変数の宣言と同時に自動的にnilが代入される
var b: String? // nil
```

## Optinal型のアンラップ
Optional型は値を保持していない可能性があるため、非オプショナル型の変数と同じように扱う事ができない。  
Optional型の値に対して操作を行う場合は、一度値を取り出す必要がある。 (アンラップという)

```Swift
var int1: Int = 1
var int2: Int? = 2
var result = int1 + int2
// force-unwrap using '!' to abort execution if the optional value contains 'nil'
```

## Optional Binding
Optional Bindingは、条件分岐や繰り返しの条件で使用することができる。  
if-let文のフォーマットで記述し、Optional型の値が存在するときは、true を返し、nilのときは false を返す。  

Optional変数の中の値を判別した上で、以降の処理に進めるか制御できる。

```Swift
if let 定数名 = Optional型の値 { // 処理内容　}
```

### if let
変数の値がnilでなければ、letの定数にセットし、以降の処理を行う。

```Swift
var str1: String? = "abc"
if let s1 = str1 {
    s1.count  // 3
} else {
    print("nilです")
}
```

### guard let
guard文は、条件が成立しないときに実行される構文。  
変数がnilのときはfalse判定になり、returnする。値がある場合は、そのまま処理が続行される。

```Swift
var str2: String?
func textStr() -> String {
    guard let s2 = str2 else { return "nilやで" }
    return s2
}
print(textStr()) // nilやで
```


## 参考サイト
* [Swiftの始め方](https://swift.codelly.dev/guide/%E5%9F%BA%E6%9C%AC%E3%81%AE%E5%9E%8B/Optional%E5%9E%8B.html)
