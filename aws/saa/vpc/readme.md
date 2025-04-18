# Amazon VPC（Virtual Private Cloud）
AWS上で動作する仮想ネットワーク環境を提供するサービス。  
VPCでネットワーク空間を作成し、その中にインスタンスなどのAWSリソースを配置できる。

## サブネット
VPC内のネットワーク空間を論理的に分割したもの。  
各サブネットは、1つのAZに属し、1つのAZ内に複数のサブネットを作成できます。

## CIDR（Classless Inter-Domain Routing）ブロック
ネットワークの範囲を指定するIPアドレスの設定方法のこと。  
CIDRはIPアドレスを「172.16.0.100/24」のように表記します。この「/24」をプレフィックス長と言う。  
プレフィックスに該当するIPアドレスの部分がネットワークアドレスとなる。  
 → このネットワークアドレスの範囲を「CIDRブロック」という

VPCではCIDRブロックのプレフィックス長を/16から/28の間で指定する。

### CIDRブロックが「172.16.0.0/24」の予約IPアドレス（利用できないIPアドレス）
* 172.16.0.0 … ネットワークアドレス
* 172.16.0.1 … VPCルーター用
* 172.16.0.2 … DNSサーバー用
* 172.16.0.3 … 将来の利用のためにAWSで予約
* 172.16.0.255… ネットワークブロードキャストアドレス

## IPアドレスの種類
### プライベートIPアドレス
* PC内でのみ有効なIPアドレス
* VPC内の他のインスタンスや、VPCと接続しているネットワークと通信するために使用する  
* すべてプライベートIPアドレスが自動で割り当てられる
* AWSリソースを停止・起動した後も同一のIPアドレスが利用される

### パブリックIPアドレス
* インターネット上で一意のIPアドレス
* インターネットなどVPC外のネットワークと通信できる
* インスタンスをパブリックサブネットに作成するときに、自動で割り当てられる
* AWSリソースが停止する時にIPアドレスが解放（AWSに返却）される
* AWSリソースが起動する時に新規のIPアドレスが割り当てられる

### Elastic IPアドレス
* インターネットと通信可能な固定のパブリックIPアドレス
* AWSアカウントと紐づいており、AWSリソースに手動で割り当てる必要あり
* AWSリソースが停止・起動してもIPアドレスが変わらない
* AWSリソースが終了しても同一のIPアドレスが保有されるので、利用料金が発生し続ける
* 保有しているElastic IPアドレスを使用して、同一のIPアドレスを別のAWSリソースに再び割り当てられる


## ルートテーブル
VPC内での通信において、どのネットワークへデータを転送するかを定義する機能。  

* VPC内の各サブネットは、1つのルートテーブルを関連付けることができる
* ルートテーブルが関連付けられていないサブネットは、VPC全体に適用される「メインルートテーブル」に従ってルーティングが行われる

## インターネットゲートウェイ
VPC内のAWSリソースとインターネットを接続する機能。

* インターネットゲートウェイへのルーティングが設定されたサブネットは、パブリックサブネットになる
* インターネットゲートウェイは一つのVPCに一つしか作成できない
* 複数のパブリックサブネットで共有して利用する

## NATゲートウェイ
プライベートサブネットからインターネットへの通信を可能にするIPv4専用の機能。　　
プライベートサブネット内にあるAWSリソースのプライベートIPアドレスを、NATゲートウェイのパブリックIPアドレス（Elastic IPアドレス）に変換し、インターネットへ接続する。

* NATゲートウェイを利用するには？
  * Elastic IPアドレスを割り当てたNATゲートウェイをパブリックサブネット内に作成
  * プライベートサブネットのルートテーブルにターゲットがNATゲートウェイのルーティングを設定
* プライベートサブネット内リソースから、インターネットへの接続開始要求は通す
* インターネットから、プライベートサブネット内リソースへの接続開始要求は通さない
* AWSによってAZ内で冗長化されており、NATゲートウェイの機器障害時やトラフィック増加時でも継続して利用可能


## VPCエンドポイント
セキュリティ上の制約でインターネットとの通信が制限されているプライベートサブネット内のAWSリソースから、インターネットゲートウェイを経由せずにVPC外のAWSサービスへアクセス可能にする機能。

### ゲートウェイ型
* S3やDynamoDBへ、接続したいリソースが配置されているVPCにVPCエンドポイントを割り当て、ルートテーブルにターゲットがVPCエンドポイントのルーティングを設定する。

* S3とDynamoDBで利用可能

## セキュリティグループ
VPC上でネットワークアクセスをインスタンスごとに制御するファイアウォールのこと。
* 設定は許可ルールのみ指定し、拒否ルールは指定できない
* デフォルトの設定では、すべてのインバウンド通信（外部から内部への通信）を拒否、すべてのアウトバウンド通信（内部から外部への通信）を許可している
* インスタンスへのインバウンド通信には許可ルールを設定する必要がある
* セキュリティグループは通信の状態を管理する「ステートフル」なファイアウォール
  * インバウンドまたはアウトバウンドで許可されている通信に関連する後続の通信（リクエストに対応するレスポンスなど）は、明示的に許可設定をしなくても通信が許可される
* セキュリティグループでは、
送信元や宛先にIPアドレスの範囲を指定する他、別のセキュリティグループも指定できる
  * 指定したセキュリティグループに所属するインスタンスからの通信を一括して許可できるので、送信元や宛先のインスタンス台数が変化する場合に便利

