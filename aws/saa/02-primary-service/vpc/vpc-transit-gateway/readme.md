# AWS Transit Gateway
複数のVPCや複数のオンプレミスネットワークを相互に接続するハブ機能を持つサービス。

## 特徴
* 複数のVPCを1つのハブで相互に接続できる
* AWS Direct ConnectやAWS VPNで接続されたオンプレミスネットワークとも接続できる
* Direct Connect Gatewayを併用することで、オンプレミスネットワークとAWSの複数のVPCを効率的に接続することが可能
* Transit Gateway単体では、異なるリージョンのVPC間を接続することはできない

## オンプレミスネットワークとAWSの複数のVPCを効率的に接続
以下に手順を記載する。

1. AWS Transit GatewayとDirect Connect Gatewayを作成・関連付け:  
 Transit GatewayはVPC間の通信を一元管理し、Direct Connect Gatewayはオンプレミスから複数のVPCへの接続を管理する。  
 これにより、オンプレミスネットワークからAWSの複数VPCへシームレスな通信が可能になる。

2. Transit VIFを設定:  
 Transit VIFは、Direct Connect経由でオンプレミスネットワークとAWS Transit Gatewayを接続するための仮想インターフェース。  
 Transit VIFを設定することで、オンプレミスとAWSの複数のVPC間の通信が、Direct Connectを介して効率的かつ安全に行われるようになる。

3. 各VPCをTransit Gatewayに接続し、ルートテーブルを設定:  
 各VPCをTransit Gatewayにアタッチし、ルートテーブルを設定することで、VPC間およびオンプレミスとの通信が正しく行われるようになる。

