void main() {
  const double a = 11.5;
  // +
  const double b = a + 5.2;
  print(b); // 16.7
  // -
  const double c = a - 6.3;
  print(c); // 5.2
  // *
  const double d = a * 3;
  print(d); // 34.5
  // /
  const double e = a / 2;
  print(e); // 5.75
  // 単項演算子
  double f = 16.5;
  f++;
  print(f); // 17.5
  f--;
  print(f); // 16.5
  // 代入演算子
  // +=
  f += 2.0;
  print(f); // 18.5
  // -=
  f -= 2.0;
  print(f); // 16.5
  // *=
  f *= 2.0;
  print(f); // 33
  // /=
  f /= 2.0;
  print(f); // 16.5
  // フィールド
  // 正数・ゼロ・負数か判別する
  print(f.sign); // 1
  double g = -f;
  print(f.sign); // -1
  double h = 0.0;
  print(h.sign); // 0
  // メソッド
  final double i = f.abs();
  print(i); // 16.5
  final double j = g.abs();
  print(j); // 16.5
}
