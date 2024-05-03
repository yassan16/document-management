// generics
// 型を指定することで、プログラムの一般性を高める機能
// これを使用することで、同じような処理を異なる型で行えるようになる
// 使用する型にはばを持たせる場合、TやKなどの文字を使用するのが慣習

class Box<T> {
 
  T _item;
  Box(this._item);
 
  set item(T item) => _item = item;
 
  T get item => _item;
}
 
void main() {
  // Tにintをあてはめる
  Box<int> intBox = Box<int>(0);
  intBox.item = 5;
  print(intBox.item); // 出力結果: 5
  // intBox.item = "Hello,World"; // 型が確定しているのでエラー
 
  // TにStringをあてはめる
  Box<String> stringBox = Box<String>("");
  stringBox.item = "Hello, World";
  print(stringBox.item); // 出力結果: Hello, World
  // stringBox.item = 5; // 型が確定しているのでエラー
}
