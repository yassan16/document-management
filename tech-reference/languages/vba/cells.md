# Cells
Cellsプロパティにより単一セルの行列指定が可能。

```
Worksheetオブジェクト.Cells(行番号, 列番号)
```

## サンプルコード

Excelの画面
|  | A | B | C |
| -- | -- |-- |-- |
| 1 | 0 | 1 | 2 |
| 2 | 3 | 4 | 5 |

1列目の1~3行目の値を文字列結合している。

```vba
Sub getRowText()
    Dim result As String
    
    For rowCount = 1 To 3
        result = result & Cells(1, rowCount).Value
    Next rowCount
    
    Debug.Print result　'012
End Sub
```

## 参考サイト
* [インデックス番号を使ってセルを参照する](https://learn.microsoft.com/ja-jp/office/vba/excel/concepts/cells-and-ranges/refer-to-cells-by-using-index-numbers)
* [【Excel VBA】行番号と列番号を指定してセルを参照する…Cellsプロパティ](https://officek.net/excelvba/v-range/vr-range/vrr-cells/)
