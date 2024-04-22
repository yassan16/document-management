void main() {
  // 10進数
  const int a = 100;
  print(a); // 100
  // 16進数
  const int b = 0x64;
  print(b);
  // +
  const int c = a + 5;
  print(c); // 105
  // -
  const int d = a - 5;
  print(d); // 95
  // *
  const int e = a * 2;
  print(e); // 200
  // /
  const int f = a ~/ 2;
  print(f); // 50
  // %
  const int g = a % 30;
  print(g); // 10
  // 新たな変数
  int h = 10;
  // ++
  h++;
  print(h); // 11
  // --
  h--;
  print(h); // 10
  // abs() 絶対値
  final int i = h.abs();
  print(i); // 10
  // 負の数
  int j = -10;
  // abs()
  final int k = j.abs();
  print(k); // 10
  // isEven 偶数かどうか
  print(h.isEven); // true
  print(j.isEven); // true
  // isOdd 奇数かどうか
  print(h.isOdd); // false
  print(j.isOdd); // false
  // sign
  print(0.sign); // 0
  const int l = 2;
  print(l.sign); // 1
  const int m = -3;
  print(m.sign); // -1
  // 代入演算子
  int n = 50;
  // +=
  n += 5; // n = n + 5;
  print(n); // 55
  // -=
  n -= 5; // n = n - 5;
  print(n); // 50
  // *=
  n *= 2; // n = n * 2;
  print(n); // 100
  // /=
  n ~/= 2; // n = n ~/ 2;
  print(n); // 50
  // %=
  n %= 7; // n = n % 7;
  print(n); // 1
}
