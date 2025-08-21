class BaseClass {
  int value;
 
  BaseClass(this.value);
 
  void helloWorld() => print("Hello World!");
}
class SubClass extends BaseClass {
  // super()と記述することで、継承元クラスのコンストラクタを使用できる
  SubClass(int value) 
  : super(value); // BaseClassのコンストラクタ;
}
void main() {
  final subClass = SubClass(10);
  print(subClass.value); // 出力結果: 10
}
