# AWS Certificate Manager（ACM）
SSL/TLS証明書を作成・管理できるマネージドサービス。  
ACMで管理しているSSL/TLS証明書（サーバー証明書）をAmazon CloudFront、Elastic Load Balancing、Amazon API Gatewayなどに適用することで、ユーザーとの通信をHTTPSで暗号化するとともに、ドメイン（ping-t.com など）の使用権を確認してアクセス先のサーバーが本物であるという証明をする。

## 特徴
* ACMで管理するSSL/TLS証明書はACMから発行できる
* ACMから発行した証明書は、有効期限が切れる前に自動で更新される
* ユーザー独自の証明書も、インポートして利用できる
* インポートした証明書は、ユーザーが更新する必要あり
  * 証明書の失効を防ぐために、EventBridgeでルールを設定し、ACMから証明書の有効期限が近づいた際に発生するイベントをトリガーとして、通知を送ることが可能


## メモ
* Certificate: 証明書
