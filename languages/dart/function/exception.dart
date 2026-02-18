void main() {
  try {
    // 例外が発生する可能性のあるコード
    int a = 10 ~/ 0;
    print('aの値は $a です。');
  } catch (e) {
    // 例外が発生した場合の処理
    print('例外が発生しました: $e');
  } finally {
    // 必要に応じて実行する処理
    print('処理が完了しました。');
  }
 
  try {
    // 例外が発生する可能性のあるコード
    int a = 10 ~/ 0;
    print('aの値は $a です。');
  } on UnsupportedError catch (e) {
    // 例外が発生した場合の処理
    print('例外が発生しました: $e');
  } finally {
    // 必要に応じて実行する処理
    print('処理が完了しました。');
  }
}
 
