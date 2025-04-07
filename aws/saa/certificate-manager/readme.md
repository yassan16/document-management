# AWS Certificate Manager（ACM）
SSL/TLS証明書を作成・管理できるマネージドサービス。  
ACMで管理しているSSL/TLS証明書（サーバー証明書）をAmazon CloudFront、Elastic Load Balancing、Amazon API Gatewayなどに適用することで、ユーザーとの通信をHTTPSで暗号化するとともに、ドメイン（ping-t.com など）の使用権を確認してアクセス先のサーバーが本物であるという証明をする。

## 特徴
* ACMで管理するSSL/TLS証明書はACMから発行できる
* ACMから発行した証明書は有効期限が切れる前に自動で更新される
* ユーザー独自の証明書もインポートして利用できる
* インポートした証明書はユーザーが更新する必要あり

## メモ
* Certificate: 証明書
