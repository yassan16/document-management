class Person {
  String name;
  int age;
 
  // コンストラクタ
  Person(this.name,this.age);
  // リダイレクトコンストラクタ
  Person.fromJson(Map<String,dynamic> json)
  : this(json['name'],json['age']); // 普通のコンストラクタを呼び出している
 
  void greeting() {
    print("こんにちは、私は$nameです。年齢は$age歳です。");
  }
}
 
void main() {
  final Person person = Person("勇者ジョン",16);
  person.greeting(); // 出力結果: こんにちは、私は勇者ジョンです。年齢は16歳です。
  final Person alice = Person.fromJson({
    "name": "勇者アリス",
    "age": 20,
  });
  alice.greeting(); // 出力結果: こんにちは、私は勇者アリスです。年齢は20歳です。
}
