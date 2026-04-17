void main() {
  // null許容変数を宣言して、初期値をnullに設定
  String? nullableString;
  // nullかどうかを判定して出力
  checkNull(nullableString);
  // 変数に値を代入する
  nullableString = "Hello, World!";
  // nullかどうかを判定して出力
  checkNull(nullableString);
}
 
void checkNull(String? nullableString) {
  // nullチェックが必要な場合、if文を使用する
  if (nullableString == null) {
    print("nullableStringはnullです");
  } else {
    print("nullableStringの値は$nullableStringです");
  }
}
