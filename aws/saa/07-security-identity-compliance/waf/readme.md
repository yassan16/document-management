# AWS WAF（Web Application Firewall）
脆弱性を突いた外部からの攻撃や不正アクセスから、Webアプリケーションを保護するサービス。

具体的には、以下を防御する。
* SQLインジェクション
  * ウェブサイトに悪意のあるデータを送り込むことで情報を盗み出す
* クロスサイトスクリプティング
  * ユーザーになりすまして不正な操作を行う

Amazon CloudFront、Application Load Balancer、Amazon API Gatewayなどに割り当てて利用する。  
 → NLBはサポートしていない。

## Web ACL
アクセス制御リストのこと。  
訪問者のIPアドレスや、ウェブページへのリクエスト内容*1に基づいて、どのようなアクセスを許可し、どのようなアクセスを遮断するかを細かく決めることができる。

*1 例：HTTPヘッダー、HTTP本文、ウェブページのアドレス

設定例を記載する。
* 地理的一致ルール
  * 特定の国からのアクセスを全て遮断
* レートベースのルール 
  * 短時間に異常に多くのリクエストを送ってくるIPアドレスを自動的にブロックする

