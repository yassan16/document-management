void main() async {
  print("main関数が始まりました");
  // 配列の要素として関数を渡す
  // 非同期関数１，非同期関数２が同時に実行される
  // 一番最後に完了した関数が終了したのち、処理が進む
  await Future.wait([
    asyncFunction1(),
    asyncFunction2()
  ]);
  print("main関数が終了しました");
  /*
  出力結果:
  main関数が始まりました
  非同期関数1が始まりました
  非同期関数2が始まりました
  非同期関数2が終了しました
  非同期関数1が終了しました
  main関数が終了しました
  */
}
 
// 3秒待つ非同期関数
Future<void> asyncFunction1() async {
  print("非同期関数1が始まりました");
  const duration = Duration(seconds: 3);
  await Future.delayed(duration);
  print("非同期関数1が終了しました");
}
 
// 2秒待つ非同期関数
Future<void> asyncFunction2() async {
  print("非同期関数2が始まりました");
  const duration = Duration(seconds: 2);
  await Future.delayed(duration);
  print("非同期関数2が終了しました");
}
