Future<String> fetchData() async {
  // 非同期で値を取得する処理
  // 1秒遅延
  await Future.delayed(Duration(seconds: 1));
  return "Hello, World!";
}
 
void main() async {
  // late修飾子を使用して、lateStringという変数を宣言する
  // nullを許容したくはないが、変数の値セットに時間がかかる場合に、late修飾子を使用する
  late String lateString;
 
  // fetchData関数を呼び出して、非同期で値を取得する
  lateString = await fetchData();
 
  // 変数の値を表示する
  print(lateString);
}
