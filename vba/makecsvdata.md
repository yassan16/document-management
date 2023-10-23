# CSVデータの作成

## サンプルコード

```vba
Sub getRowText()
  Dim result As String
  Dim startCol As Integer
  Dim endCol As Integer
  Dim csvFilePath As String

  startCol = 1
  endCol = 3
  csvFilePath = "E:\programming\020_VBA\sample.csv"

  For rowCount = startCol To endCol
    result = result & """" & Cells(1, rowCount).Value & """"

    If rowCount = endCol Then
      GoTo Continue
    End If
    
    result = result & ","
        
Continue:
  Next rowCount
  Debug.Print result

  Open csvFilePath For Append As #1
    Print #1, result
  Close #1
End Sub

```
