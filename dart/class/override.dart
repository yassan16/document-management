class BaseClass {
  int value;
 
  BaseClass(this.value);
 
  void helloWorld() => print("Hello,World");
}
 
class SubClass extends BaseClass {
  SubClass(int value) 
  : super(value); // BaseClassのコンストラクタ
 
  @override
  void helloWorld() {
    print("こんにちは、世界"); // 出力結果: こんにちは、世界
    super.helloWorld(); // 出力結果: Hello,World
  }
}
 
void main() {
  final SubClass subClass = SubClass(10);
  print(subClass.value); // 出力結果: 10
  /*
  出力結果:
  こんにちは、世界
  Hello,World
  */
  subClass.helloWorld();
}
