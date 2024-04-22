void main() {
  // 長さ
  const String str = "Hello World";
  print(str.length); // 11
  // 切り出し
  final String str2 = str.substring(6);
  print(str2); // World
  // 大文字
  final String str3 = str.toUpperCase();
  print(str3); // "HELLO WORLD"
  // 小文字
  final String str4 = str.toLowerCase();
  print(str4); // "hello world"
  // 空
  final bool str5 = str.isEmpty;
  print(str5); // false
  // 空ではない
  final bool str6 = str.isNotEmpty;
  print(str6); // true
}
