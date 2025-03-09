abstract class Animal {
 
  // ゲッターも抽象メソッドとして扱える
  // 簡略化されたgetter
  String get animalType;
  String get crySound;
  void cry() {
    print('${animalType}が${crySound}と鳴いています。');
  }
}
 
class Lion extends Animal {
  @override
  String get animalType => 'ライオン';
  @override
  String get crySound => 'ガオー';
 
  void run() => print('草原を走ります。');
}
 
class Elephant extends Animal {
  @override
  String get animalType => '象';
  @override
  String get crySound => 'パオーン';
 
  void walk() => print('森を歩きます。');
}
 
class Penguin extends Animal {
  @override
  String get animalType => 'ペンギン';
  @override
  String get crySound => 'キャッキャッ';
 
  void swim() => print('氷の海を泳ぎます。');
}
 
void main() {
  final lion = Lion();
  lion.cry(); // 出力結果: ライオンがガオーと鳴いています。
  lion.run(); // 出力結果: 草原を走ります。
 
  final elephant = Elephant();
  elephant.cry(); // 出力結果: 象がパオーンと鳴いています。
  elephant.walk(); // 出力結果: 森を歩きます。
 
  final penguin = Penguin();
  penguin.cry(); // 出力結果: ペンギンがキャッキャッと鳴いています。
  penguin.swim(); // 出力結果: 氷の海を泳ぎます。
}
