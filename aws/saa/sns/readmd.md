# Amazon Simple Notification Service（SNS）
フルマネージドのメッセージングサービス。

メッセージとは？  
システム間を連携する通知やデータのこと。  

EメールやSMS、Lambda関数、Amazon SQSを通して、複数のアプリケーションやユーザーに対して同時にメッセージを配信する。Amazon SNSはプッシュ型なので、サブスクライバー（購読者）の状態に関わらずメッセージを配信する。

## 標準機能
標準で、暗号化やフィルタリング機能がある。

## ファンアウト
SNSとSQSを組み合わせると「ファンアウト」構成を実装できる。

ファンアウトとは？  
一つのメッセージを複数の送信先に配信し、それぞれが並列に処理を実行する仕組みのこと。これにより、効率的な分散処理を実現できる。

* 〇 SNSからSQSへメッセージの配信
* ✖ SQSからはできない
  * ポーリング（問い合わせ）できないため

## SNS FIFOトピック（First-In, First-Out 先入れ先出し）
メッセージの順序保証や重複排除が必要な場面で使うキュー型通知トピック。

1. メッセージグループID (MessageGroupId)
* 同じIDのメッセージは、送信順に1つずつ処理される
* つまり「このIDごとに順序を守る」

2. 重複排除ID (MessageDeduplicationId)
* 同じ内容のメッセージが短期間に送られても、重複とみなして無視できる
* 自動生成（メッセージ内容のSHA-256ハッシュ）または手動指定

### トピックの違い

| 特性 | FIFOトピック | Standardトピック |
|:-----------|------------:|:------------:|
| メッセージ順序保証 | ✅ あり（Group単位） | ❌ なし |
| 重複排除 | ✅ 可能 | ❌ なし |
|スループット	| ❌ 最大300メッセージ/秒（デフォルト） | ✅ 数万件/秒も可能 |
| サブスクリプション対応	| SQS FIFOキュー のみ	| SQS, Lambda, HTTP, Emailなど |
| データ整合性	| ✅ 必要なユースケース向き | ❌ 高速だが整合性に欠ける |

## 用語
* パブリッシュ（Publish）	
  * メッセージを「送る（発行する）」こと
* サブスクライブ（Subscribe）
  * メッセージを「受け取るように登録する」こと
* サブスクライバ（Subscriber）
  * メッセージを受け取る側のシステムやサービス（登録済のもの）

### 例
パターン：SNS → SQS  
1. SNSトピック（Publisher） にメッセージが送られる（Publish）
2. SQSキュー（Subscriber） がそのトピックに「サブスクライブ」しておく
3. メッセージが届く → SQSキューがその内容を受け取る

## Auto Scaling
Amazon SNSからAuto Scalingグループに通知を出せない