// クラスの拡張
// クラスを拡張することで、編集できないクラスに新たなメソッドを追加することができる
// thisを使用することで、そのクラスの値を使用できる


extension StringExtension on String {
  // １文字目だけを大文字にするメソッド
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
 
void main() {
  String str = "hello world";
  print(str.capitalize()); // "Hello world"
}
