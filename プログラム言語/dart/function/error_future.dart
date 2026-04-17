import 'dart:async';
 
Future<int> asyncFunction() async {
  // 例外が発生する可能性のある非同期処理
  await Future.delayed(Duration(seconds: 2));
  return 10 ~/ 0;
}
 
void main() async {
  // await
  print("awaitの場合");
  try {
    // エラーが発生する非同期関数を呼び出す
    await asyncFunction();
  } catch(e) {
    // 例外が発生した場合の処理
    print("例外が発生しました $e");
  } finally {
    //　必要に応じた処理
    print("処理が完了しました");
  }
  // then
  // エラーが発生する非同期関数を呼び出す
  print("thenの場合");
  asyncFunction()
  .then((value) => print("10を0で割った値は $value"))
  .catchError((e) => print("例外が発生しました $e"))
  .whenComplete(() => print("処理が完了しました"));
}
