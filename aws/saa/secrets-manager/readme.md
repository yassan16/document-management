# AWS Secrets Manager
データベースなどにアクセスする際のシークレット（ログイン時の認証情報など）を管理するサービス。

## メリット
* アプリケーションなどからAWSリソースへアクセスする際にSecrets Managerからシークレットを取得することにより、ログイン情報をアプリケーションにハードコーディングしたり平文で入力しておく必要がない
* シークレットは定期的に更新（ローテーション）される
* バージョン管理も行われる
