# AWS IAM（Identity and Access Management）
AWSリソースへのアクセスを管理するためのサービス。  
。IAMでは「誰が」「どのリソースに対して」「どの操作を許可または制限するか」を定義し、認証と認可のプロセスを提供する。

## 特徴
* AWSがIAMの機能を無料で提供

## ユーザーの種類
AWSには、2種類のユーザーがある。
* AWSアカウント（ルートユーザー）
  * すべてのサービスに対する全ての権限を持つ
  * 基本的に使用せず、IAMユーザーを使用する
  * MFA推奨
* IAMユーザー
  * 初期では存在せず、AWSアカウントログイン後に作成するアカウント
  * マネジメントコンソール、APIなどでAWSリソースを操作するときに、使用する

またAWSサービスへのアクセスに、「ユーザー名とパスワード」または「アクセスキーとシークレットアクセスキー」を使用して認証する。
* ユーザーIDとパスワード
  * 任意のIDと自分で設定したパスワードを用いた認証方法です。マネジメントコンソールにログインするときに使用
* アクセスキーとシークレットアクセスキー
  * AWSによって作成されるアクセスキーIDと、対になるシークレットアクセスキーを用いた認証方法

## IAMユーザー
AWSリソースの使用に適切な認可をする。  
IAMユーザーは複数人で共有せず、個々にIAMユーザーを作成する。

## IAMグループ
複数のIAMユーザーが所属するグループのこと。  
同一アカウント内の複数のIAMユーザーのアクセス権限を一元的に管理できる。
AWSベストプラクティスでもIAMグループを活用することが推奨されている。

IAMグループは別のIAMグループに所属できない。

## IAMロール
AWSサービスやアプリケーション、他のAWSアカウントに対してAWSリソースへのアクセス権限を付与する際に利用する。  
IAMロールは、一時的なアクセスキーを生成・利用して認証を行い、アプリケーションはこの一時的なキーを用いてAWSリソースにアクセスする。

## ポリシー
AWSリソースへのアクセス権限のこと。  
ポリシーは、JSON形式のテキストで定義される。

ポリシーは、IAMユーザー（IAMグループ）やIAMロール、一部のAWSリソースにアタッチ（付与）やデタッチ（剥奪）が可能。

## Permissions Boundary（アクセス許可境界）
IAMユーザーやIAMロールに対して「ここまでの範囲内であれば自由に操作を行える」という境界のこと。
