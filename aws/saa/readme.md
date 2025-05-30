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
* EC2
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
* VPC
* S3
* IAM
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
