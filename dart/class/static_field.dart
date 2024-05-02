class Person {
  // 作成された人数を数える、クラス変数
  static int counter = 0;
  String name;
  int age;
  // 何番目かを示すインスタンス変数
  late int id;
 
  // 初期化子
  Person(this.name,this.age) {
    id = counter + 1;
    counter++;
  }
 
  void greeting() {
    print("こんにちは、私は$nameです。年齢は$age歳です。");
  }
}
 
void main() {
  print("counter: ${Person.counter}"); // 出力結果: counter: 0
  // インスタンス1
  final Person person1 = Person("Alice",20);
  print("counter: ${Person.counter},id: ${person1.id}"); // 出力結果: counter: 1,id: 1
  // インスタンス2
  final Person person2 = Person("Bob",30);
  print("counter: ${Person.counter},id: ${person2.id}"); // 出力結果: counter: 2,id: 2
  // インスタンス3
  final Person person3 = Person("Charlie",40);
  print("counter: ${Person.counter},id: ${person3.id}"); // 出力結果: counter: 3,id: 3
}
