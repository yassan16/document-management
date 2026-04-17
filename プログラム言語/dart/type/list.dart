void main() {
  // 空のListを作成する
  List<String> fruits = [];
 
  // 要素を追加する
  fruits.add("りんご");
  fruits.add("バナナ");
  fruits.add("オレンジ");
 
  // 要素を取得する
  String fruit1 = fruits[0];
  String fruit2 = fruits.elementAt(1);
  print("fruit1: $fruit1"); // 出力結果: fruit1: りんご
  print("fruit2: $fruit2"); // 出力結果: fruit2: バナナ
 
  // 要素を更新する
  fruits[2] = "グレープフルーツ"; // オレンジ -> グレープフルーツ
  print("fruits: $fruits"); // 出力結果: fruits: [りんご, バナナ, グレープフルーツ]
 
  // 要素を削除する
  fruits.remove("りんご"); // りんごを削除
  fruits.removeAt(0); // 新しい配列の最初の要素、バナナが削除
  print("fruits: $fruits"); // 出力結果: fruits: [グレープフルーツ]
 
  // 要素を挿入する
  fruits.insert(0,"マンゴー");
  print("fruits: $fruits"); // 出力結果: fruits: [マンゴー, グレープフルーツ]
 
  // 要素を並び替える
  fruits.sort(); // ABC順、数字が小さい順に並び替えられる
  // グレープフルーツのunicode: %u30B0%u30EC%u30FC%u30D7%u30D5%u30EB%u30FC%u30C4%0A
  // マンゴーのunicode: %u30DE%u30F3%u30B4%u30FC%0A
  print("fruits: $fruits"); // 出力結果: fruits: [グレープフルーツ, マンゴー]
 
  // すべての要素を削除する
  fruits.clear();
  print("fruits: $fruits"); // 出力結果: fruits: []
 
  // 指定した要素が含まれているかどうかを判定する
  bool containsBanana = fruits.contains("バナナ");
  print("バナナは含まれているか: $containsBanana"); // 出力結果: バナナは含まれているか: false
 
  // 要素数を取得
  int length = fruits.length;
  print("配列の長さ: $length"); // 出力結果: 配列の長さ: 0
 
  // Listが空かどうかを判定する
  bool isEmpty = fruits.isEmpty;
  print("isEmpty: $isEmpty"); // 出力結果: isEmpty: true
 
  // Listが空でないかどうかを判定する
  bool isNotEmpty = fruits.isNotEmpty;
  print("isNotEmpty: $isNotEmpty"); // 出力結果: isNotEmpty: false
}
