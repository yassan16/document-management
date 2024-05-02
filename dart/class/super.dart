class BaseClass {
  int value;
 
  BaseClass(this.value);
 
  void helloWorld() => print("Hello World!");
}
class SubClass extends BaseClass {
  SubClass(int value) 
  : super(value); // BaseClassのコンストラクタ;
}
void main() {
  final subClass = SubClass(10);
  print(subClass.value); // 出力結果: 10
}
