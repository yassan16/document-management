# Amazon Macie
S3バケット内のデータ保護に特化したセキュリティサービス。  
機械学習とパターンマッチングを用いて、自動的にS3バケット内のオブジェクトを分析し、個人情報（PII）や秘匿技術などの機密データを識別・分類する。

## 特徴
* S3バケット内のセキュリティとアクセス制御を継続的に評価
* 検知した結果をマネジメントコンソール上に反映する
  * 機密データの未暗号化や不適切な共有、漏洩などの問題
* 検知結果を直接ユーザへ通知する機能は実装されていない
  * 他のAWSサービスと連携することで、ユーザへの通知を自動化することが推奨

## どうやって EventBridge が Macie を“検知”するのか？
EventBridge は「Macie が出力するイベント（評価結果）」をリアルタイムに受け取ることができる。

* Macie は、検出結果（Findings）を EventBridge にイベントとして送信している
* EventBridge は、受け取ったイベントの内容を元に「ルール」を照合する

Macie が S3 に複数の機密データ（たとえば財務情報）を検出した場合
```json
{
  "source": ["aws.macie"],
  "detail-type": ["Macie Finding"],
  "detail": {
    "type": ["SensitiveData:S3Object/Multiple"]
  }
}
```

## Finding
Macie が見つけたセキュリティ上の問題のレポート。
