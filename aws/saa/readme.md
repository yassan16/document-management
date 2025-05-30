# SAA試験　全体像
項目ごとに内容をリスト化している。  
また項目ごとに、主要な機能を洗い出している。  

試験内容は、以下の大分類5項目
* 運用上の優秀性
* セキュリティ
* 信頼性
* パフォーマンス効率
* コスト最適化


## AWSクラウドの基本
* オンプレミスとクラウド
* AWSの概要

## 主要なサービス
* VPC
  * サブネット
    * パブリックサブネット
    * プライベートサブネット
  * CIDR（Classless Inter-Domain Routing）ブロック
    * 予約されたIPアドレス
  * IPアドレスの種類
    * プライベートIPアドレス
    * パブリックIPアドレス
    * Elastic IPアドレス
  * ルートテーブル
  * インターネットゲートウェイ
  * NATゲートウェイ
    * NAT(Network Address Translation)
  * NATインスタンス
  * Egress-Onlyインターネットゲートウェイ
  * ENI（Elastic Network Interface）
    * Elastic Fabric Adapter (EFA)
  * 拡張ネットワーキング（Enhanced Networking）
  * VPCフローログ
  * VPCエンドポイント
    * ゲートウェイ型
    * AWS PrivateLink（インターフェイス型）
  * VPCエンドポイントポリシー
  * VPCでのセキュリティ
    * セキュリティグループ
    * ネットワークACL
  * AWS Network Firewall
    * ファイアウォール
    * ファイアウォールポリシー
    * ルールグループ
  * VPCの相互接続
    * VPCピアリング
    * AWS Transit Gateway
  * Amazon VPC Lattice
* EC2
  * EC2インスタンスの作成の流れ
    1. Amazon マシンイメージ（AMI）の選択
    2. インスタンスタイプの選択
    3. キーペアの設定
    4. ネットワークの設定
    5. ストレージの設定
        * Amazon EBS（Elastic Block Store）
        * インスタンスストア
    6. 高度な設定
        * プレイスメントグループ
          * クラスタープレイスメントグループ
          * パーティションプレイスメントグループ
          * スプレッドプレイスメントグループ
        * メタデータ
* S3
  * 構成要素
    * オブジェクト
    * バケット
  * ストレージクラス
    * S3 Standard
    * Intelligent-Tiering
    * 標準-IA：標準-低頻度アクセス （Standard-Infrequent Access）
    * 1ゾーン-IA：1ゾーン-低頻度アクセス（One Zone-Infrequent Access）
    * Glacier Instant Retrieval
    * Glacier Flexible Retrieval
    * Glacier Deep Archive
    * ライフサイクルポリシー
  * 主要な機能
    * 静的Webサイトホスティング
    * 署名付きURL
    * S3イベント通知
    * リクエスタ支払い
    * S3 Glacierの復元リクエスト
      * 標準取り出し
      * 迅速取り出し
      * 大容量（バルク）取り出し
  * データ保護
    * バージョニング
    * MFA Delete
    * オブジェクトロック
      * リーガルホールド
      * リテンションモード
        * ガバナンスモード
        * コンプライアンスモード
  * データ転送
    * S3 Transfer Acceleration
    * マルチパートアップロード
    * S3レプリケーション
  * アクセス制御
    * バケットポリシー
    * IAMポリシー（ユーザーポリシー）
    * ACL（アクセスコントロールリスト）
  * データ暗号化
    * サーバー側の暗号化（Server-Side Encryption:SSE）
      * S3が管理している鍵を使用する (SSE-S3)
      * AWS KMS（AWS Key Management Service）に保存されているKMSキーを使用する (SSE-KMS)
      * ユーザーが管理している鍵を使用する (SSE-C)
    * クライアント側の暗号化
      * AWS KMS（AWS Key Management Service）に保存されているKMSキーを使用する
      * クライアント側に保存したルートキーを使用する
* IAM（Identity and Access Management）
  * ユーザーの種類
    * AWSアカウント（ルートユーザー）
    * IAMユーザー
      * IAMグループ
    * IAMロール
      * インスタンスプロファイル
    * ポリシー
      * タイプ
        * IDベースのポリシー
        * リソースベースのポリシー
      * 構成要素
        * Effect：許可または拒否の指定
        * Action：AWSリソースに対して実行できる操作（例：s3:PutObject）
        * Resource：Actionの対象とするAWSリソース（例：特定のS3バケット）
        * Principal：権限のリクエスト元（例：特定のIAMユーザー）
        * Condition：ポリシーが適用される条件（例：特定のIPアドレス範囲からのアクセス）
      * Permissions Boundary（アクセス許可境界）
* ELB/Auto Scaling

## コンピューティング
* Lambda
  * Lambda関数
    * 実行行時間
    * 課金方式
    * 実行タイミング
    * Compute Savings Plans
  * Lambda関数のトリガー
  * Lambda関数のアクセス権限
    * デフォルトの権限
  * VPCアクセス
    * NATゲートウェイ
    * VPCエンドポイント
  * 同時実行
    * コールドスタート
    * ウォームスタート
    * プロビジョニング
  * 暗号化ヘルパー
* API Gateway
  * REST API（RESTful API）
    * ステートレス
  * HTTP API
  * WebSocket API
  * API キャッシュ
  * 使用量プラン
  * VPCリンク
    * NLB
  * オーソライザー
  * 独自ドメイン名の使用
  * Canaryリリース
* ECS/Fargate/EKS

## ストレージ
* EBS
* EFS
* Fsx
* Storage Gateway
* Snow Family

## データベース
* RDS/Aurora
* Redshift
* DynamoDB
* ElastiCashe

## マネジメント、ガバナンス
* CloudWatch
* CloudTrail
* Elastic Beanstalk
* CloudFormation
* Trusted Advisor
* Systems Manager

## セキュリティー、アイデンティティ、コンプライアンス
* WAF/Shield
* KMS/CloudHSM

## ネットワーク、コンテンツ配信
* Route 53
* CloudFront
* Global Accelerator
* Direct Connect/VPN

## アプリケーション統合
* SQS
* SNS

## 分析
* Kinesis
* EMR
* Glue
* Athena

## 機械学習
* Comprehend
* Transcribe
* Textract
* Translate

## その他サービス
* （随時記載）
