# AWS Control Tower
AWSにおけるベストプラクティスに基づいた、セキュアなマルチアカウント環境（ランディングゾーンと呼ばれる）のセットアップを自動化するマネージドサービス。

Control Towerでは、AWSにおけるベストプラクティスに基づいた構成や設定、ルールの組み合わせをガードレール（コントロールとも呼ばれます）として提供している。  

特定のアクションやリソースの利用を事前に制限することで、セキュリティポリシーやコンプライアンスに違反する行為を防ぐ。

## ガードレール（コントロール）
AWSにおけるベストプラクティスに基づいた構成や設定、ルールの組み合わせのこと。  

* 予防コントロール.....対象の操作を実施できないようにする
* 検出コントロール.....リソースが作成された後に監視し、違反を検知して通知する
* プロアクティブコントロール.....CloudFormationでルールに沿ったリソースのみを作成可能にする

## プロアクティブコントロール
* コントロールの一種であるプロアクティブコントロールは、CloudFormationを利用して作成されるリソースが、事前に定義したポリシーやルールに適合しているかを確認し、違反したリソースの作成を拒否する。

