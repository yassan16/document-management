// mixin とは
// 定数をフィールドに持ち、処理が実装されたメソッドを定義しているクラスのこと
// コンストラクタを使用できないので、変数をフィールドに持つことができない
// クラスは複数のmixinを使用できる

// 特徴
// 完成されたメソッドと中身のあるフィールドを定義するときに使用する

mixin HelloMixin {
  final String helloMsg = "Hello";
  void hello() => print("こんにちは");
}
 
mixin GoodByeMixin {
  final String goodbyeMsg = "Goodbye";
  void goodbye() => print("さようなら！");
}
 
class Person with HelloMixin, GoodByeMixin {
  String name;
  Person(this.name);
 
  void greeting() {
    hello(); //出力結果: こんにちは
    print(helloMsg); // 出力結果: Hello
    print("私の名前は$nameです。"); // 出力結果: 私の名前はアリスです
    print(goodbyeMsg); // 出力結果: Goodbye
    goodbye(); // 出力結果: さようなら！
  }
}
 
void main() {
  final Person person = Person("アリス");
  /*
  出力結果:
  こんにちは
  Hello
  私の名前はアリスです
  Goodbye
  さようなら！
  */
  person.greeting();
  print("${person.helloMsg} ${person.goodbyeMsg}"); // 出力結果: Hello Goodbye
}
