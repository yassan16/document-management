// 2つの整数を受け取り、その和を返す関数
int sum(int a,int b) {
  return a + b;
}
 
// 引数を受け取らず、単純な文字列を返す関数。アロー構文。
String greeting() => "こんにちは世界";
 
// 名前付きの引数を受け取る関数。2つの数字の和を返す。
// {}を書くことで呼び出す際に、名前付きで引数を指定させる。
// required nullを許容していない
int namedSum({required int a,int b = 5}) => a + b;
 
// 名前付きと非名前付きの引数を受け取る関数。3つの数字の和を返す。
int basicAndNamedSum(int a,{required int b,int c = 10}) => a + b + c;

main() {
  // sum関数を使用
  int x = 3;
  int y = 5;
  int result = sum(x, y);
  print("$xと$yの和は$resultです。"); // 出力結果: 3と5の和は8です。
 
  // greeting関数を使用
  String message = greeting();
  print(message); // 出力結果: こんにちは世界
 
  // namedSum関数を使用
  int result2 = namedSum(a: 4);
  print("aを指定した結果: $result2"); // 出力結果: aを指定した結果: 9
  int result3 = namedSum(a: 4,b: 4);
  print("aとbを指定した結果: $result3"); // 出力結果: aとbを指定した結果: 8
 
  // basicAndNamedSum関数を使用
  int result4 = basicAndNamedSum(20, b: 30);
  print("aとbを指定した結果: $result4"); // 出力結果: aとbを指定した結果: 60
  int result5 = basicAndNamedSum(10, b: 10,c: 10);
  print("aとbとcを指定した結果: $result5"); // 出力結果: aとbとcを指定した結果: 30
}
