# ファイルの作成
フォルダとファイルを新たに作成し、ファイルに内容を書き込む方法を記載。

## サンプルソース

```java
package makeFile;

import java.io.File;
import java.io.FileWriter;

public class Main {

    public static void main(String[] args) {
        // 出力先のパス
        String outputFolder = "E:\\programming\\010_CSV\\sample\\";
        String outputFile = "sample.txt";

        // フォルダ作成
        File file1 = new File(outputFolder);
        if(file1.exists() == false){
            file1.mkdirs();
        }

        // ファイル作成
        File file2 = new File(file1, outputFile);
        try {
            if(file2.exists() == false) {
                file2.createNewFile();
                System.out.println("ファイル作った");
            }
            // 書き込む
            FileWriter filewriter = new FileWriter(file2);
            filewriter.write("hello world" + "\n");
            filewriter.write("改行しました。");

            // 終了して保存
            filewriter.flush();
            filewriter.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}

```
