# CSVデータの作成


## Excelの画面

|  | A | B | C |
| -- | -- |-- |-- |
| 1 | 0 | 1 | 2 |
| 2 | 3 | 4 | 5 |

## 出力結果
"0","1","2"  
"3","4","5"


## サンプルコード

```vba
Sub getCsvFile()
  Dim csvData As String

  Dim startCol As Integer
  Dim endCol As Integer
  Dim startRow As Integer
  Dim endRow As Integer

  Dim csvFilePath As String

  '列
  startCol = 1
  endCol = 3
  '行
  startRow = 1
  endRow = 2
  '出力先
  csvFilePath = "出力先フォルダ\sample.csv"

  '1行ごと
  For rowCount = startRow To endRow
    '1列ごと
    For colCount = startCol To endCol
      csvData = csvData & """" & Cells(rowCount, colCount).Value & """"

      '最終列はカンマを付けずに改行
      If colCount = endCol Then
        csvData = csvData & vbCrLf
        GoTo Continue
      End If
    
      csvData = csvData & ","
        
Continue:
    Next colCount
  Next rowCount

  '作成した値を確認
  Debug.Print csvData

  'CSV出力
  Call outputCsv(csvFilePath, csvData)

End Sub


'出力先、CSVデータ
Sub outputCsv(csvFilePath, csvData)
  'ファイルに書き込む
  Open csvFilePath For Append As #1
    Print #1, csvData
  Close #1
End Sub
```
