class Person {
  static int _counter = 0;
  String name;
  int age;
  late int id;
 
  Person(this.name, this.age) {
    id = _counter + 1;
    _counter++;
  }
  // クラスメソッド
  static int getCounter() => _counter;
 
  // ゲッターをつかい、クラス変数のように扱う
  static int get counter => _counter;
}
 
void main() {
  // personがいない場合
  print("counter: ${Person.getCounter()}"); // 出力結果: counter: 0
  // ゲッター
  print("counter: ${Person.counter}"); // 出力結果: counter: 0
 
  // インスタンス1
  Person person1 = Person("Alice", 20);
  print("counter: ${Person.getCounter()}, id: ${person1.id}"); // 出力結果: counter: 1, id: 1
  // ゲッター
  print("counter: ${Person.counter}, id: ${person1.id}"); // 出力結果: counter: 1, id: 1
 
  // インスタンス2
  Person person2 = Person("Bob", 30);
  print("counter: ${Person.getCounter()}, id: ${person2.id}"); // 出力結果: counter: 2, id: 2
  // ゲッター
  print("counter: ${Person.counter}, id: ${person2.id}"); // 出力結果: counter: 2, id: 2
 
  // インスタンス3
  Person person3 = Person("Charlie", 40);
  print("counter: ${Person.getCounter()}, id: ${person3.id}"); // 出力結果: counter: 3, id: 3
  // ゲッター
  print("counter: ${Person.counter}, id: ${person3.id}"); // 出力結果: counter: 3, id: 3
}
