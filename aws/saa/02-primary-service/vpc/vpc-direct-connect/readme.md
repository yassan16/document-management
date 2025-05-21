# AWS Direct Connect
AWS Direct Connect（DX）はオンプレミスなどのユーザー環境からAWSへ、専用回線を使ってセキュアに接続するサービス。  
インターネット回線ではなく専用回線を敷設して使用するので、安定した高速なネットワークで接続できる。

Direct Connectは、Direct ConnectロケーションのDirect ConnectエンドポイントからAWSネットワークへの接続を保証している。AWSユーザーはDirect Connectロケーション内にルーターを設置し、オンプレミスから専用線を引き込む必要がある。工事費用と時間をかけてでも、安定した通信と強固なセキュリティ環境を求めるケースに適している。

## AWS Direct Connectロケーション
オンプレミスとAWSのデータセンターとを相互に接続するポイントのこと。  
各リージョンに複数用意されており、ユーザーは接続するロケーションを選択できる。

## AWS Direct Connectエンドポイント
Direct Connectエンドポイントとは、Direct Connectサービス提供範囲にあるオンプレミス側の終端のルーターのこと。Direct Connectロケーション内に物理的に設置されており、AWSユーザーが設置したルーターと接続する。

## Direct Connectを使用した接続の種類
Direct Connectにはパブリック接続とプライベート接続がある。
* パブリック接続
  * S3やDynamoDBなどのVPC外にあるAWSリソースへの接続に利用
* プライベート接続
  * VPCに仮想プライベートゲートウェイ（VGW：Virtual Private Gateway）を配置し、VPC内のAWSリソースへ接続する

## Direct Connectゲートウェイ
Direct Connectエンドポイントから複数のVPCに接続したい場合は「Direct Connectゲートウェイ」を利用する。  
  → Direct Connectのプライベート接続はDirect Connectエンドポイントと仮想プライベートゲートウェイを1対1で接続するので、通常は1つのVPCにしか接続できないため

Direct ConnectゲートウェイはDirect Connectエンドポイントと仮想プライベートゲートウェイの間に配置されて、世界中の各リージョンにある複数のVPCへ接続できるようになる。なお、VPCは他のAWSアカウントのものであっても接続できる。

### VPC同士の通信
Direct Connectゲートウェイで接続した複数のVPCは、Direct Connectエンドポイントとの通信は可能だが、Direct Connectゲートウェイ経由でVPC同士の通信はできない。  

VPC同士の通信を行う場合は、VPCピアリングもしくはAWS Transit Gatewayを利用する。AWS Transit Gatewayは、複数のVPCやオンプレミスネットワークを相互に接続するハブ機能を持つサービスである。これにより、複数のVPCを1つのハブで管理し、ネットワーク経路を簡素化できます。  
また、Direct Connectゲートウェイを併用することで、オンプレミスネットワークとAWS内の複数のVPCを効率的に接続することが可能です。
