# privateメソッドをクラス外から呼び出す方法
UT実施時に、直接呼び出してテストしたい時があった。  
そのとき調べた`リフレクション`について記載する。

## サンプルコード
テスト対象のクラス
```Java
class Sample {
  private String target(String str, int i){
    return str + i;
  }
}
```

テストコード
```Java
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

class SampleTest{
   private String testTargetMethod(){
       Sample sample = new Sample();
       String result;
       try {
           // class変数を使用して、テスト対象メソッドを取得
           Method method = Target.class.getDeclaredMethod("target", String.class, int.class);  // メソッド名、第１引数の型、第2引数の型
           // 外部からアクセスすることを許可する
           method.setAccessible(true);
           // メソッドを実行
           result = (String) method.invoke(sample, "テスト", 10);  // テスト対象インスタンス、第１引数、第2引数
       } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
           throw new RuntimeException(e);
       }
       return result;
   }
}
```


## 参考サイト
* [jUnitでprivateメソッドをテストする](https://yuiktmr.blog/article/20220124_jUnitPrivate)
* [Junitでprivateメソッドのテスト方法](https://qiita.com/village/items/2f0d99b25eef0c8fd4ec)
