class Person {
  String name;
  int age;
 
  // コンストラクタ
  // 一つ目の値がnameに、二つ目の値がageにセットされる
  Person(this.name,this.age);
  // 省略可能な引数も指定可能
  // 三つ目の引数を呼び出した場合、指定した値がセットされる
  // 省略した場合、Japanがセットされる
  Person(this.name,this.age, {this.country = 'Japan'});
 
  void greeting() {
    print("こんにちは、私は$nameです。年齢は$age歳です。");
  }
}
 
void main() {
  final Person person = Person("勇者ジョン",16);
  person.greeting(); // 出力結果: こんにちは、私は勇者ジョンです。年齢は16歳です。
}
