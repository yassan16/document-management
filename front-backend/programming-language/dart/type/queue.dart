import 'dart:collection';
 
void main() {
  // Queueを作成
  Queue<String> colors = Queue();
 
  // Queueに要素を追加
  colors.addAll(['赤',"青","黄","緑"]);
  print("colors: $colors"); // 出力結果: colors: {赤, 青, 黄, 緑}
 
  // Queueの先頭から要素を取り出す
  String firstColor = colors.removeFirst();
  print("先頭の色: $firstColor"); // 出力結果: 先頭の色: 赤
  print("colors: $colors"); // 出力結果: colors: {青, 黄, 緑}
 
  // Queueの末尾に要素を追加
  colors.add("紫");
  print("colors: $colors"); // 出力結果: colors: {青, 黄, 緑, 紫}
 
  // Queueが空かどうかを判定
  bool isEmpty = colors.isEmpty;
  print("isEmpty: $isEmpty"); // 出力結果: isEmpty: false
 
  // すべての要素を削除
  colors.clear();
  print("colors: $colors"); // 出力結果: colors: {}
}
