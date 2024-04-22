void main() {
  // Setの作成
  Set<String> fruits = {"りんご","バナナ","オレンジ"};
 
  // Setの要素の追加
  fruits.add("ぶどう");
  print("fruits: $fruits"); // 出力結果: fruits: {りんご, バナナ, オレンジ, ぶどう}
 
  // Setの要素の削除
  fruits.remove("オレンジ");
  print("fruits: $fruits"); // 出力結果: fruits: {りんご, バナナ, ぶどう}
 
  // Setに要素が含まれるかどうかのチェック
  bool containsBanana = fruits.contains("バナナ");
  print("Setにバナナが含まれるかどうか $containsBanana"); // 出力結果: Setにバナナが含まれるかどうか true
 
  // Setが空かどうかを判定
  bool isEmpty = fruits.isEmpty;
  print("isEmpty $isEmpty"); // 出力結果: isEmpty false
 
  // 再び同じ要素を追加
  fruits.add("りんご");
  print("fruits: $fruits"); // 出力結果: fruits: {りんご, バナナ, ぶどう}
 
  // すべての要素を削除
  fruits.clear();
  print("fruits: $fruits"); // 出力結果 fruits: {}
 
}
