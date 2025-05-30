# Amazon ECS（Elastic Container Service）
Docker環境で動作するDockerコンテナを実行、管理するサービス。  
またインフラストラクチャのプロビジョニングやスケール管理など、多くの運用作業を自動化する。

補足： インフラストラクチャのプロビジョニング  
ハードウェア、ソフトウェア、ネットワークなどの計算リソースをセットアップし、使用可能な状態にすること。

## 特徴
* コンテナオーケストレーション
  * 複数のコンテナのデプロイ、管理、スケーリングを一元的に行う仕組み
* 負荷に応じて自動的にリソースを調整し、実行中のコンテナインスタンスの状態を監視し続ける
* 継続的な可用性とパフォーマンスを保証する効率的な運用が可能

## メリット
* 運用上のオーバーヘッド（システムの維持・管理に関わる追加の時間、労力、費用など）を大幅に削減できる
* 開発者はアプリケーションのコードに集中できる

## ECSの主要要素
「クラスター」「タスク」「サービス」がある。

### クラスター
1つ以上のタスクまたはサービスで構成される論理グループのこと。  
クラスターでは、コンテナが動作するVPCやサブネットなどを設定する。

### タスク
ECSで管理するコンテナの実行単位。  
タスク内のコンテナは、実行するコンテナイメージ、CPUやメモリのスペック、タスクロールなどを定義した「タスク定義」に基づいて起動される。  

補足: タスクロールとは？  
コンテナが他のAWSサービスを利用する際に設定するアクセス権限（IAMロール）のこと。

### サービス
クラスター内で必要なタスク数を維持する機能。  
あるタスクが異常終了して必要なタスク数を下回った場合、サービスが新しいタスクを起動して自動復旧する。  
サービスでは、起動するタスクのタスク定義、必要なタスク数、ELBとの連携などを設定する。


## ECSの起動タイプ
「AWS Fargate」と「EC2起動タイプ」がある。

### AWS Fargate
コンテナ向けのサーバーレスコンピューティングエンジン。  
コンテナ実行環境のCPUやメモリのスペック、アクセス権限（IAM）などを設定するだけで、サーバーの環境構築や管理をすることなくコンテナを実行できる。

* 利用料金は、タスクで指定したCPU/メモリに応じて課金される
* 実行したタスクのリソース使用量に対して料金が発生する
* Compute Savings Plans
  * 1年または3年の期間、一定のサービス使用量（1時間あたりの利用料金）を決めて契約することで、通常よりも低価格になる購入オプション

### EC2起動タイプ
ユーザーが管理するEC2インスタンス上でコンテナを実行する。  
コンテナを実行するEC2インスタンス、ネットワーク、IAMなどを設定すると、ECSがAWS CloudFormationのスタックを作成および実行して、構築したコンテナ実行環境をECSに登録する。  
EC2起動タイプでは通常のインスタンスと同様に、OSやミドルウェアのアップデートなどのサーバー管理をユーザーで実施する必要がある。

* 利用料金は、指定したEC2インスタンスタイプに応じて課金される
* インスタンスの起動時間に対して料金が発生する

## ECSにおける自動スケーリング
ECSでは、タスクの数を自動的に増減させるスケーリングを行うことができます。  
ECS上で設定できる自動スケーリングは「ターゲットの追跡」と「ステップスケーリング」の2種類のポリシーから選択できます。 自動スケーリングは、起動タイプがAWS FargateとEC2どちらの場合でも利用可能です。なお、デフォルトでは設定がオフになっているので、使用する場合はユーザーがタスクの最小数・最大数などを設定する必要があります。

ターゲットの追跡: 特定のメトリクスの目標値に基づいて、サービスが実行するタスクの数を増減させる。