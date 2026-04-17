void main() {
  // Mapの作成
  Map<String,int> ages = {
    'Alice': 25,
    'Bob': 30,
    'Charlie': 35,
  };
 
  // Mapに要素の追加
  ages['David'] = 40;
  print("追加後のages: $ages");
  /*
  出力結果:
  追加後のages: 
   {
    'Alice': 25,
    'Bob': 30,
    'Charlie': 35,
    'David': 40
  }
  */
 
  // Mapから要素の取り出し
  // as はキーに対応する値は存在し、int型であることを証明している
  int charlieAge = ages['Charlie'] as int;
  print("Charlieの年齢: $charlieAge"); // 出力結果: Charlieの年齢: 35
 
  // Mapの要素の削除
  ages.remove('David');
  print("削除後のages: $ages");
  /*
  削除後のages:
  出力結果:
   {
    'Alice': 25,
    'Bob': 30,
    'Charlie': 35
  }
  */
 
  // Mapのkeysを取得する
  List<String> keys = ages.keys.toList();
  print("keys: $keys"); // 出力結果: [Alice, Bob, Charlie]
 
  // Mapのvaluesを取得する
  List<int> values = ages.values.toList();
  print("values: $values"); // 出力結果: [25,30,35]
 
  // Mapに含まれる要素の数を取得する
  int length = ages.length;
  print("要素の数: $length"); // 要素の数: 3
 
  // Mapが空かどうかをチェックする
  bool isEmpty = ages.isEmpty;
  print("isEmpty: $isEmpty"); // isEmpty: false
}
