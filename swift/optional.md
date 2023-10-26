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
Optional型では、変数の宣言と同時に自動的にnilが代入される

```Swift
var b: String? // nil
var c: String? = "初期化" // 初期化
```

## Optional型のアンラップ
Optional型は値を保持していない可能性があるため、非オプショナル型の変数と同じように扱う事ができない。  
Optional型の値に対して操作を行う場合は、一度値を取り出す必要がある。 (アンラップという)

```Swift
var int1: Int = 1
var int2: Int? = 2
var result = int1 + int2
// force-unwrap using '!' to abort execution if the optional value contains 'nil'
```

アンラップするには以下の方法がある。(非オプショナル型)
* Optional Binding
* ??演算子
* !演算子で強制アンラップ

それぞれ以降で解説する。

## Optional Binding
Optional Bindingは、条件分岐や繰り返しの条件で使用することができる。  
if-let文のフォーマットで記述し、Optional型の値が存在するときは、true を返し、nilのときは false を返す。  

Optional変数の中の値を判別した上で、以降の処理に進めるか制御できる。

```Swift
if let 定数名 = Optional型の値 { // 処理内容　}
```

### if let
変数の値がnilでなければ、letの定数にセットし、以降の処理を行う。  
変数s1はこのスコープ内で使用可能。以降の処理では使用できない。

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
関数内でのみ使用可能。

```Swift
var str2: String?
func textStr() -> String {
    guard let s2 = str2 else { return "nilやで" }
    return s2
}
print(textStr()) // nilやで
```

## ??演算子
??演算子は、値が存在しない場合にデフォルトの値を代入できる。  
値がある場合は、デフォルト値はスキップされる。

```Swift
var int3: Int?
var int4 = int3 ?? 3  // 3
var int5 = int4 ?? 99 // 3
```

## !演算子で強制アンラップ
!演算子は、強制的にOptional型の値を取り出せる。  
強制的に値を取り出すため、もし値がないときは実行時にエラーが発生する。  
強制アンラップは、プログラムの実行時にエラーが発生するので、意図しないバグを招く可能性がある。

```Swift
var int6: Int? = 1
var int7 = int6! + 1 // 2
```
エラー
```Swift
var int8: Int?
var int9 = int8! + 1
// Fatal error: Unexpectedly found nil while unwrapping an Optional value
```

## 暗黙的にアンラップ
宣言時に、 `! `をつけることでアンラップを明示的にしなくても自動的に値を取り出すことができる。

エラー
```Swift
var int10: Int!
var int11 = int10 + 10 // 20
// Fatal error: Unexpectedly found nil while unwrapping an Optional value
```

## Optional Chaining
Optional Chainingを使用すると、アンラップせずにアクセスすることができる。  
もし、値がない場合は nilを返す。

```Swift
var int12: Int? = 10
print(int12?.distance(to: 1)) // Optional(-9) // 値がない場合はnil

if let int13 = int12?.distance(to: 1) {
  print(int13) // -9
} else {
　　　　print("値がありません")
}
```

## mapメソッド
mapメソッドを使うと、アンラップをせずに値の取得をすることができる。  
値が存在すれば実行し、値が存在しなければ何も実行されない。

```Swift
var int14: Int? = 10
var int15 = int14.map { val in val * 10 } // Optional(100)
```

## 参考サイト
* [Swiftの始め方](https://swift.codelly.dev/guide/%E5%9F%BA%E6%9C%AC%E3%81%AE%E5%9E%8B/Optional%E5%9E%8B.html)
