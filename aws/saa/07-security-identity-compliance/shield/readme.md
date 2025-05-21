# AWS Shield
DDoS攻撃*からの保護に特化したサービス。  
AWS Shieldには、すべてのAWSユーザーが無償で利用できる「AWS Shield Standard」と、有償版の「AWS Shield Advanced」がある。

*DoS攻撃とは？  
ウェブサイトやサーバーに大量のアクセスを送り込むことで、サービスを停止させる攻撃のこと。

## AWS Shield Standard
ネットワーク層およびトランスポート層への一般的なDDoS攻撃からAWSリソースを保護する。  
デフォルトで有効になっている。

## AWS Shield Advanced
EC2インスタンス、Elastic Load Balancing、Amazon CloudFrontなどを標的としたDDoS攻撃に対して、高度な保護サービスを利用できる。

* API Gatewayをサポートしていない

### 例
* 高度化された大規模な攻撃からの保護
* DDoS攻撃発生時のモニタリングやレポート
* AWSのDDoS対応チームによるサポート
* 攻撃によって増加したAWS利用料金の補填
