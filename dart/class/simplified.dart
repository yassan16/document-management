class Person {
  String _name;
  int _age;
 
  // コンストラクタ
  Person(this._name,this._age);
  // リダイレクトコンストラクタ
  Person.fromJson(Map<String,dynamic> json)
  : this(json['name'],json['age']); // 普通のコンストラクタを呼び出している
 
  // _nameのセッター
  set name(String name) => _name = name;
  // _nameのゲッター
  String get name => _name;
 
  // _ageのセッター
  set age(int age) {
    // 年齢が150より小さければ代入
    if (age < 150) {
      _age = age;
    } else {
      print("相応しい値ではありません");
    }
  }
  // _ageのゲッター
  int get age => _age;
 
  void greeting() {
    print("こんにちは、私は$_nameです。年齢は$_age歳です。");
  }
}
 
void main() {
  // 勇者ジョン
  final Person person = Person("勇者ジョン",16);
  person.name = "勇者ジョン2";
  person.age = 18;
  print("名前: ${person.name}"); // 出力結果: 名前: 勇者ジョン2
  print("年齢: ${person.age}"); // 出力結果: 年齢: 18
  // 勇者アリス
  final Person alice = Person.fromJson({
    "name": "勇者アリス",
    "age": 20,
  });
  alice.name = "勇者アリス2";
  alice.age = 160;
  print("名前: ${alice.name}"); // 出力結果: 名前: 勇者アリス2
  /*
  出力結果:
  相応しい値ではありません
  年齢: 20
  */
  print("年齢: ${alice.age}");
 
  alice.greeting(); // 出力結果: こんにちは、私は勇者アリス2です。年齢は20歳です。
}
