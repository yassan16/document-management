# AWSインフラ 学習ロードマップ

リクエストフローに沿ってAWSサービスを学習することで、各サービスが「なぜ存在するのか」を理解する。Web 3層アーキテクチャ（ALB + EC2 + RDS）をベースに、データの流れに沿った学習ガイド。

-----

## 目次

1. [全体像：リクエストの流れ](#全体像リクエストの流れ)
1. [Step 0: 土台を作る (VPC / Networking)](#step-0-土台を作る-vpc--networking)
1. [Step 1: ユーザーがURLを叩く (Route 53 / DNS)](#step-1-ユーザーがurlを叩く-route-53--dns)
1. [Step 2: エッジでキャッシュする (CloudFront / CDN)](#step-2-エッジでキャッシュする-cloudfront--cdn)
1. [Step 3: リクエストを受け付ける (ALB / ELB)](#step-3-リクエストを受け付ける-alb--elb)
1. [Step 4: 処理を実行する (EC2 / Compute)](#step-4-処理を実行する-ec2--compute)
1. [Step 5: データを読み書きする (RDS / Database)](#step-5-データを読み書きする-rds--database)
1. [Step 6: 静的ファイルを扱う (S3 / Storage)](#step-6-静的ファイルを扱う-s3--storage)
1. [Step 7: 運用・監視する (CloudWatch / 監視)](#step-7-運用監視する-cloudwatch--監視)
1. [横断的に学ぶべき重要概念](#横断的に学ぶべき重要概念)
1. [学習リソース](#学習リソース)
1. [学習のコツ](#学習のコツ)

-----

## 全体像：リクエストの流れ

```
User (PC/Mobile)
     |
[Step 1] Route 53 (DNS - 名前解決)
     |
[Step 2] CloudFront (CDN - キャッシュ/配信最適化)
     |
[Step 0] Internet Gateway (VPCの入り口)
     |
[Step 3] ALB (負荷分散)
     |
[Step 4] EC2 (Web/Appサーバー) ---[IAM Role]
     |                              |
[Step 5] RDS (データ保存)     [Step 6] S3 (静的ファイル)
     |
[Step 7] CloudWatch (監視・ログ)
```

-----

## Step 0: 土台を作る (VPC / Networking)

サーバーが動作する「家（ネットワーク）」を理解する。ここが一番難しく、かつ最重要。

### Region / Availability Zone (AZ)

- Region: 地理的に離れたデータセンター群（東京、大阪、バージニアなど）
- AZ: 同一Region内の独立したデータセンター
- 耐障害性: 複数AZに分散配置することで単一障害点を排除

### VPC (Virtual Private Cloud)

- AWS上のプライベートなネットワーク空間
- CIDRブロック: IPアドレス範囲の指定（例: 10.0.0.0/16）
- 1つのVPCに複数のサブネットを作成可能

### Subnet (Public vs Private)

- Public Subnet: インターネットから直接アクセス可能（ALB, NAT Gateway配置）
- Private Subnet: インターネットから隔離（EC2, RDS配置）
- 使い分け: 外部公開するものはPublic、隠すべきものはPrivate

### Route Table / Internet Gateway

- Internet Gateway (IGW): VPCとインターネットを接続する扉
- Route Table: 通信の宛先制御（「0.0.0.0/0 → IGW」でインターネットへ）
- Public SubnetのRoute TableにIGWを紐付ける

### NAT Gateway

- Private Subnetからインターネットへの片方向通信を実現
- ユースケース: OS更新、外部APIへのリクエスト
- 注意: 課金が高い（時間課金 + データ転送量）

### Network ACL vs Security Group

| 項目 | Security Group | Network ACL |
|------|---------------|-------------|
| 適用レベル | インスタンス（ENI） | サブネット |
| ステート | ステートフル（戻りは自動許可） | ステートレス（戻りも明示的に許可必要） |
| デフォルト | すべて拒否 | すべて許可 |
| ルール | 許可のみ | 許可・拒否 |
| 用途 | 主要なアクセス制御 | サブネット単位の追加防御層 |

#### 学習目標

- [ ] VPC、Subnet、Route Tableの関係を図示できる
- [ ] Public/Private Subnetの使い分けを説明できる
- [ ] Security GroupとNetwork ACLの違いを説明できる

-----

## Step 1: ユーザーがURLを叩く (Route 53 / DNS)

ブラウザに `example.com` と入力した瞬間の処理。

### DNSの基礎

- ドメイン名からIPアドレスへの変換（名前解決）
- Route 53: AWSのマネージドDNSサービス
- ホストゾーン: ドメインのDNSレコードを管理する単位

### レコードタイプ

- Aレコード: ドメイン → IPv4アドレス
- AAAAレコード: ドメイン → IPv6アドレス
- CNAME: ドメイン → 別のドメイン（エイリアス）
- Aliasレコード: AWSリソース（ALB, CloudFront等）への直接紐付け（AWS独自）

### ルーティングポリシー

- シンプルルーティング: 単一リソースへの振り分け
- 加重ルーティング: 複数リソースへの比率指定
- レイテンシールーティング: 最も低遅延なリージョンへ
- フェイルオーバールーティング: ヘルスチェック連動の切り替え
- 位置情報ルーティング: ユーザーの地理的位置に基づく

#### 学習目標

- [ ] DNSの名前解決の流れを説明できる
- [ ] A, CNAME, Aliasレコードの違いを説明できる
- [ ] 適切なルーティングポリシーを選択できる

-----

## Step 2: エッジでキャッシュする (CloudFront / CDN)

コンテンツをユーザーに近い場所（エッジロケーション）から配信し、レイテンシを削減。

### CloudFrontの役割

- CDN (Content Delivery Network): 世界中のエッジロケーションからコンテンツ配信
- キャッシュ: 静的コンテンツをエッジに保持し、オリジンへの負荷を軽減
- セキュリティ: DDoS対策、WAF連携、HTTPS強制

### Origin設定

- S3 Origin: 静的ファイル（画像、CSS、JS）の配信
- ALB/EC2 Origin: 動的コンテンツ（API）の配信
- カスタムOrigin: オンプレミスサーバー等

### Origin Access Control (OAC)

- S3バケットへのアクセスをCloudFront経由のみに制限
- S3のパブリックアクセスを無効にしつつ、CloudFront経由で配信
- 旧方式のOAI (Origin Access Identity) より推奨

### キャッシュ戦略

- TTL (Time To Live): キャッシュの有効期限
- キャッシュキー: URL、ヘッダー、クエリ文字列の組み合わせ
- キャッシュ無効化 (Invalidation): 強制的にキャッシュをクリア
- Cache Policy / Origin Request Policy: キャッシュ動作の詳細設定

#### 学習目標

- [ ] CloudFrontのメリットを説明できる
- [ ] S3 + CloudFront構成でOACを設定できる
- [ ] 適切なキャッシュ戦略を設計できる

-----

## Step 3: リクエストを受け付ける (ALB / ELB)

リクエストを受け取り、複数のサーバーに振り分ける受付係。

### ALB (Application Load Balancer)

- L7ロードバランサー: HTTP/HTTPSレベルでの振り分け
- パスベースルーティング: `/api/*` → API用サーバー、`/static/*` → 静的サーバー
- ホストベースルーティング: `api.example.com` → API用、`www.example.com` → Web用
- NLB (Network Load Balancer): L4（TCP/UDP）レベル、超高パフォーマンス用途

### Target Group

- ALBが振り分ける先のサーバーグループ
- ターゲットタイプ: instance（EC2）、ip、lambda
- ポート設定: ALBからTarget Groupへの通信ポート

### Health Check

- 定期的にターゲットの正常性を確認
- 異常なターゲットにはリクエストを送らない
- 設定項目: パス、間隔、閾値、タイムアウト

### SSL/TLS終端 (ACM連携)

- ACM (AWS Certificate Manager): SSL証明書の無料発行・自動更新
- ALBでHTTPSを終端し、バックエンドはHTTPで通信（負荷軽減）
- リダイレクト: HTTP → HTTPSの自動転送設定

#### 学習目標

- [ ] ALBの主要な機能を説明できる
- [ ] Target Groupとヘルスチェックを設定できる
- [ ] ACMで証明書を発行し、ALBに設定できる

-----

## Step 4: 処理を実行する (EC2 / Compute)

アプリケーションが動作するサーバー。

### AMI (Amazon Machine Image)

- OSとソフトウェアの「金型」
- Amazon Linux、Ubuntu、Windows等
- カスタムAMI: 自分の設定を含めたイメージを作成可能

### Instance Type

- 命名規則: `c5.xlarge` = ファミリー(c) + 世代(5) + サイズ(xlarge)
- ファミリー: 汎用(t, m)、コンピューティング最適化(c)、メモリ最適化(r)、ストレージ最適化(i, d)
- サイズ: nano < micro < small < medium < large < xlarge < 2xlarge...

### Security Group

- インスタンスレベルのファイアウォール
- インバウンド: 外部からの通信許可
- アウトバウンド: 外部への通信許可
- ベストプラクティス: IPではなくSecurity Group IDで許可をつなげる

### Auto Scaling

- 負荷に応じてインスタンス数を自動増減
- Launch Template: 起動するインスタンスの設定テンプレート
- スケーリングポリシー: CPU使用率、リクエスト数等に基づくルール
- 最小/最大/希望キャパシティの設定

#### 学習目標

- [ ] 適切なインスタンスタイプを選択できる
- [ ] Security Groupを適切に設定できる
- [ ] Auto Scalingを設定できる

-----

## Step 5: データを読み書きする (RDS / Database)

アプリケーションがデータを保存・取得するデータベース。

### RDS (Relational Database Service)

- AWSマネージドのリレーショナルDB
- 対応エンジン: MySQL, PostgreSQL, MariaDB, Oracle, SQL Server, Aurora
- 自動バックアップ、パッチ適用、フェイルオーバーをAWSが管理

### Multi-AZ

- プライマリDBと別AZにスタンバイDBを自動作成
- プライマリ障害時に自動フェイルオーバー（数分）
- 注意: 料金が約2倍

### Read Replica

- 読み取り専用のDBコピー
- 読み取り負荷の分散に使用
- クロスリージョンレプリカも可能（災害対策）

### DB Subnet Group

- RDSを配置するサブネットのグループ
- 複数AZのPrivate Subnetを指定（Multi-AZ用）
- RDSはPrivate Subnetに配置するのがベストプラクティス

#### 学習目標

- [ ] RDSのメリットを説明できる
- [ ] Multi-AZとRead Replicaの違いを説明できる
- [ ] 適切なDB Subnet Groupを設計できる

-----

## Step 6: 静的ファイルを扱う (S3 / Storage)

画像、ログ、バックアップ等をEC2やRDSの外に保存。

### S3 (Simple Storage Service)

- オブジェクトストレージ: ファイルをオブジェクトとして保存
- 高耐久性: 99.999999999%（イレブンナイン）
- 容量無制限: 実質的に上限なし

### Bucket / Object

- Bucket: オブジェクトを格納するコンテナ（グローバルで一意の名前）
- Object: 実際のファイル（キー = パス + ファイル名）
- プレフィックス: フォルダのような論理的な階層構造

### アクセス権限

- バケットポリシー: バケット単位のアクセス制御（JSON形式）
- IAMポリシー: ユーザー/ロール単位のアクセス制御
- ACL: レガシーな方法（現在は非推奨）
- ブロックパブリックアクセス: 意図しない公開を防止する設定

### ストレージクラス

- Standard: 頻繁にアクセスするデータ
- Standard-IA: 低頻度アクセス（取り出し料金あり）
- Glacier: アーカイブ用（取り出しに時間がかかる）
- ライフサイクルポリシー: 自動的にストレージクラスを移行

#### 学習目標

- [ ] S3の基本概念を説明できる
- [ ] 適切なアクセス権限を設定できる
- [ ] ストレージクラスを使い分けられる

-----

## Step 7: 運用・監視する (CloudWatch / 監視)

システムの状態を把握し、問題を早期に検知する。

### CloudWatch Metrics

- AWSリソースのメトリクス（CPU使用率、ネットワーク、ディスク等）を自動収集
- カスタムメトリクス: アプリケーション固有の値を送信可能
- ダッシュボード: メトリクスを可視化

### CloudWatch Logs

- ログの収集・保存・検索
- ロググループ / ログストリーム: ログの論理的な分類
- CloudWatch Logs Agent: EC2からログを送信
- Logs Insights: SQLライクなクエリでログを分析

### CloudWatch Alarms

- メトリクスの閾値に基づいてアラートを発報
- アクション: SNS通知、Auto Scaling、EC2アクション
- 複合アラーム: 複数条件の組み合わせ

### CloudTrail

- AWS APIコールの履歴を記録（誰が、いつ、何をしたか）
- セキュリティ監査、コンプライアンス対応に必須
- S3にログを保存し、長期保管

### AWS Config

- リソースの構成変更を追跡
- コンプライアンスルール: 「S3バケットが公開されていないこと」等のチェック
- 構成履歴: 過去のある時点の構成を確認可能

#### 学習目標

- [ ] CloudWatch Metricsでリソースを監視できる
- [ ] CloudWatch Logsでログを収集・分析できる
- [ ] CloudTrailで操作履歴を確認できる

-----

## 横断的に学ぶべき重要概念

### セキュリティ (IAM / Security)

#### IAM (Identity and Access Management)

- User: AWSにアクセスする人
- Group: Userをまとめたもの
- Role: AWSリソースに付与する権限（EC2 → S3アクセス等）
- Policy: 「何ができるか」を定義するJSON

#### IAM Roleの重要性

- EC2にアクセスキーを埋め込まない
- EC2にIAM Roleを付与し、必要な権限を与える
- 一時的な認証情報が自動でローテーション

#### Security Groupの連鎖

```
[ALBのSG] → (許可) → [EC2のSG] → (許可) → [RDSのSG]
```

IPアドレスではなく、Security Group IDで許可をつなげる。

#### VPCエンドポイント

- Private Subnetからインターネットを経由せずにAWSサービスにアクセス
- Gateway型: S3, DynamoDB
- Interface型: その他のAWSサービス
- メリット: セキュリティ向上、NAT Gateway不要でコスト削減

#### Secrets Manager / Parameter Store

- Secrets Manager: DB認証情報等の機密情報を安全に管理、自動ローテーション
- Parameter Store: 設定値の管理（無料枠あり、シンプル）
- アプリケーションにハードコードしない

#### WAF (Web Application Firewall)

- Webアプリケーションへの攻撃を防御
- SQLインジェクション、XSS、レートリミット等
- CloudFront、ALBに適用可能
- マネージドルール: AWSやサードパーティ提供の定義済みルール

#### 学習目標

- [ ] IAM User, Group, Role, Policyの違いを説明できる
- [ ] EC2にIAM Roleを付与して権限管理できる
- [ ] VPCエンドポイントのメリットを説明できる
- [ ] Secrets Managerで機密情報を管理できる

-----

### コスト管理

#### 課金の罠

- NAT Gateway: 時間課金（約$0.045/h）+ データ転送量。放置すると高額に
- Multi-AZ RDS: 料金が約2倍
- EIPの未使用課金: 使っていないElastic IPに課金される
- CloudWatch Logs: データ取り込み量に応じて課金

#### 無料枠

- 12ヶ月無料枠: EC2 t2.micro 750h/月、RDS 750h/月、S3 5GB等
- 永久無料枠: Lambda 100万リクエスト/月、DynamoDB 25GB等
- 注意: 無料枠を超えると即課金開始

#### コスト可視化ツール

- Cost Explorer: 過去のコストを可視化・分析
- Budgets: 予算を設定し、閾値超過時にアラート
- Cost Anomaly Detection: 異常なコスト増加を自動検知

#### 学習目標

- [ ] 主要サービスの課金体系を理解している
- [ ] 無料枠の範囲を把握している
- [ ] Budgetsでアラートを設定できる

-----

## 学習リソース

### 書籍

- 『Amazon Web Services 基礎からのネットワーク＆サーバー構築』
- 『AWS認定ソリューションアーキテクト - アソシエイト教科書』
- 『AWSではじめるインフラ構築入門』

### オンラインリソース

- [AWS公式ドキュメント](https://docs.aws.amazon.com/)
- [AWS Skill Builder](https://skillbuilder.aws/) - AWS公式の無料学習プラットフォーム
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [AWS ハンズオンチュートリアル](https://aws.amazon.com/getting-started/hands-on/)

### 実践的学習

- AWS無料枠でWordPress構築（VPC, EC2, RDS, ALBを網羅）
- AWS認定資格の取得（SAA: Solutions Architect Associate）
- クラウドネイティブな設計パターンの学習

-----

## 学習のコツ

### 1. 手を動かす

座学だけでなく、実際にAWSコンソールで構築する。無料枠を活用。

### 2. 段階的に進める

Step 0（VPC）を理解してからEC2、RDSへ進む。飛ばすと後で混乱する。

### 3. 全体像を意識する

個々のサービスだけでなく、リクエストフロー全体での役割を理解する。

### 4. 障害を想定する

「このサービスが落ちたらどうなる？」を常に考える。Multi-AZ、Auto Scalingの意味が理解できる。

### 5. IaC化する

コンソールで構築できたら、Terraform/CloudFormationでコード化。再現性と理解が深まる。

### 6. コストを意識する

無料枠を把握し、Budgetsでアラートを設定してから学習開始。

-----

## チェックリスト活用法

各セクションの「学習目標」チェックボックスを活用して進捗を管理。すべてにチェックが入ったら次のStepへ進む目安とする。

-----

*このロードマップは継続的にアップデートしていくことを推奨します。AWS認定資格の取得や実務経験に合わせて、内容を見直してください。*
