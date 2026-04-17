abstract class RunnableInterface extends WalkableInterface {
  void run();
}
 
abstract class WalkableInterface {
  void walk();
}
 
class Person implements RunnableInterface {
  @override
  void run() => print("走りました！！");
  @override
  void walk() => print("歩きました！！");
}
 
class Dog implements RunnableInterface {
  @override
  void run() => print("四足歩行で駆け抜ける");
  @override
  void walk() => print("散歩している");
}
 
class Robot implements RunnableInterface {
  @override
  void run() => print("エンジンをかなり消費しながら移動している");
  @override
  void walk() => print("エンジンを節約しながら移動している");
}
 
void main() {
  // person
  final Person person = Person();
  person.run(); // 出力結果: 走りました！！
  person.walk(); // 出力結果: 歩きました！！
 
  // dog
  final Dog dog = Dog();
  dog.run(); // 出力結果: 四足歩行で駆け抜ける
  dog.walk(); // 出力結果: 散歩している
 
  // robot
  final Robot robot = Robot();
  robot.run(); // 出力結果: エンジンをかなり消費しながら移動している
  robot.walk(); // 出力結果: エンジンを節約しながら移動している
}
