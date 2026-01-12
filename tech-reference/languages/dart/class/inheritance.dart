// 継承
class BaseClass {
  final int value = 100;
  void helloWorld() => print("Hello World!");
}
 
class SubClass extends BaseClass {
  // 既存クラスを拡張して、新しいクラスを作成できる
  // 継承元のクラスのフィールドとメソッドも使用可能
}
 
void main() {
  final subClass = SubClass();
  print(subClass.value); // 出力結果: 100
  subClass.helloWorld(); // 出力結果: "Hello World!"
}
