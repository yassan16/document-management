# コードリーディング 学習ロードマップ

既存のコードベースを効率的に読み解くための考え方とテクニック。フロントエンド、APIサーバー、データベースを持つWebアプリケーションを想定。

-----

## 目次

1. [基本マインドセット](#基本マインドセット)
2. [全体像の把握](#全体像の把握)
3. [フロントエンド編](#フロントエンド編)
4. [APIサーバー編](#apiサーバー編)
5. [データベース編](#データベース編)
6. [実践テクニック](#実践テクニック)
7. [ツール活用](#ツール活用)

-----

## 基本マインドセット

### 1. 全部を理解しようとしない

- 最初から100%理解しようとしない
- 必要な部分から段階的に理解を深める
- 「今の目的に必要な範囲」に集中する

### 2. Input/Outputに着目する

- 内部処理は後回し
- 「何を受け取って、何を返すか」を先に把握
- ブラックボックスとして扱い、必要に応じて中身を見る

### 3. 動かしながら読む

- 静的に読むだけでなく、実際に動かす
- デバッガやログで実行フローを確認
- 仮説を立てて検証する

### 4. メモを取りながら読む

- 理解したことを図や文章で残す
- 疑問点をリスト化
- 後で振り返れるようにする

-----

## 全体像の把握

### Step 1: ディレクトリ構成を確認

```
project/
├── frontend/          # フロントエンド
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   └── api/       # API呼び出し
├── backend/           # APIサーバー
│   ├── src/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   └── models/
├── database/          # DBマイグレーション等
│   └── migrations/
└── docker-compose.yml
```

### Step 2: エントリーポイントを特定

| レイヤー | 確認すべきファイル |
|---------|-------------------|
| フロントエンド | `main.tsx`, `App.tsx`, `index.html` |
| APIサーバー | `main.go`, `app.py`, `index.ts` |
| ルーティング | `routes.ts`, `router.go`, `urls.py` |

### Step 3: 設定ファイルを読む

- `package.json` / `go.mod` / `requirements.txt` → 依存関係
- `.env.example` → 環境変数（外部サービス連携のヒント）
- `docker-compose.yml` → サービス構成
- `tsconfig.json` / `eslint.config.js` → プロジェクト規約

### Step 4: READMEとドキュメント

- セットアップ手順
- アーキテクチャ説明
- API仕様書（OpenAPI等）

-----

## フロントエンド編

### 3.1 ルーティングから始める

```tsx
// ページ構成を把握
<Routes>
  <Route path="/" element={<Home />} />
  <Route path="/users" element={<UserList />} />
  <Route path="/users/:id" element={<UserDetail />} />
</Routes>
```

- どんなページがあるか
- URLとコンポーネントの対応
- 認証が必要なルートの確認

### 3.2 ページ → コンポーネントの流れ

```
Page（ページ全体）
  └── Container（データ取得・状態管理）
       └── Presenter（表示のみ）
            └── 共通Component
```

- ページコンポーネントから読み始める
- データの流れ（props）を追う
- 状態管理（useState, Redux, Zustand等）の場所を特定

### 3.3 API呼び出しを追う

```tsx
// APIクライアントの実装を確認
const fetchUsers = async () => {
  const response = await api.get('/users');
  return response.data;
};
```

- どのエンドポイントを呼んでいるか
- リクエスト/レスポンスの型定義
- エラーハンドリングの方法

### 3.4 状態管理を理解する

| パターン | 確認ポイント |
|---------|-------------|
| ローカルstate | `useState`, `useReducer` |
| グローバルstate | Redux, Zustand, Recoil, Context |
| サーバーstate | React Query, SWR, Apollo |

### 3.5 確認すべきポイント

- [ ] 主要なページの構成を把握した
- [ ] データの取得方法を理解した
- [ ] 状態管理のパターンを特定した
- [ ] 共通コンポーネントの場所を把握した

-----

## APIサーバー編

### 4.1 ルーティングから始める

```go
// エンドポイント一覧を把握
r.GET("/users", userController.List)
r.GET("/users/:id", userController.Get)
r.POST("/users", userController.Create)
r.PUT("/users/:id", userController.Update)
r.DELETE("/users/:id", userController.Delete)
```

- エンドポイントの一覧
- HTTPメソッドとパス
- ミドルウェア（認証、ログ等）

### 4.2 レイヤー構造を理解する

```
Request
   ↓
[Controller] → リクエスト受付、バリデーション、レスポンス返却
   ↓
[Service] → ビジネスロジック
   ↓
[Repository] → データアクセス
   ↓
[Model/Entity] → データ構造
   ↓
Database
```

### 4.3 1つのエンドポイントを深掘り

特定のAPIを選んで、リクエストからレスポンスまで追う。

```
GET /users/:id の場合

1. Controller: パラメータ取得、バリデーション
2. Service: ビジネスルール適用
3. Repository: DBクエリ実行
4. Model: データ構造の定義
5. Response: JSONシリアライズ
```

### 4.4 横断的関心事を確認

| 関心事 | 確認ポイント |
|--------|-------------|
| 認証 | JWT検証、セッション管理 |
| 認可 | ロールチェック、リソースアクセス制御 |
| バリデーション | 入力チェックの実装場所 |
| エラーハンドリング | 例外処理、エラーレスポンス形式 |
| ログ | ログ出力の方法、レベル |
| トランザクション | DB操作の境界 |

### 4.5 確認すべきポイント

- [ ] エンドポイント一覧を把握した
- [ ] レイヤー構造を理解した
- [ ] 認証・認可の仕組みを把握した
- [ ] エラーハンドリングのパターンを理解した

-----

## データベース編

### 5.1 ER図を描く/確認する

```
┌──────────┐     ┌──────────────┐     ┌──────────┐
│  users   │────<│ user_roles   │>────│  roles   │
└──────────┘     └──────────────┘     └──────────┘
     │
     │1
     │
     │*
┌──────────┐
│  posts   │
└──────────┘
```

- テーブル間のリレーション
- 主キー、外部キー
- 多対多の中間テーブル

### 5.2 マイグレーションファイルを読む

```sql
-- テーブル定義から設計意図を読み取る
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP  -- 論理削除
);

CREATE INDEX idx_users_email ON users(email);
```

- カラムの型と制約
- インデックスの設計
- 論理削除 vs 物理削除

### 5.3 モデル/エンティティ定義を確認

```go
type User struct {
    ID        uuid.UUID  `gorm:"primaryKey"`
    Email     string     `gorm:"uniqueIndex"`
    Posts     []Post     `gorm:"foreignKey:UserID"`  // リレーション
    CreatedAt time.Time
    UpdatedAt time.Time
    DeletedAt *time.Time `gorm:"index"`
}
```

- ORMのマッピング
- リレーションの定義方法
- バリデーションタグ

### 5.4 クエリパターンを確認

```go
// N+1問題の有無を確認
// Bad: N+1
users := db.Find(&users)
for _, u := range users {
    db.Find(&u.Posts)  // ループ内でクエリ
}

// Good: Eager Loading
db.Preload("Posts").Find(&users)
```

- JOIN vs サブクエリ
- Eager Loading の使用
- ページネーションの実装

### 5.5 確認すべきポイント

- [ ] テーブル構成を把握した（ER図）
- [ ] 主要なリレーションを理解した
- [ ] インデックス設計を確認した
- [ ] クエリパターンを把握した

-----

## 実践テクニック

### 6.1 特定機能を追う

1つの機能（例: ユーザー登録）を選び、End-to-Endで追う。

```
[ユーザー登録フロー]

Frontend:
  1. SignupForm.tsx → フォーム入力
  2. useSignup.ts → API呼び出し
  3. api/auth.ts → POST /auth/signup

Backend:
  4. AuthController.Signup → リクエスト受付
  5. AuthService.CreateUser → ビジネスロジック
  6. UserRepository.Create → DB保存
  7. メール送信（非同期）

Database:
  8. users テーブルにINSERT
  9. email_verifications テーブルにINSERT
```

### 6.2 クラス図を描く

継承やインターフェースの関係を可視化。

```
<<interface>>
UserRepository
      △
      │
      ├── UserRepositoryImpl（本番用）
      │
      └── UserRepositoryMock（テスト用）
```

### 6.3 シーケンス図を描く

処理の流れを時系列で可視化。

```
Frontend    API Gateway    AuthService    UserRepo    Database
    │            │              │            │           │
    │──POST /signup──>│         │            │           │
    │            │──validate──>│            │           │
    │            │              │──create───>│           │
    │            │              │            │──INSERT──>│
    │            │              │<───────────│<──────────│
    │<───201────│<─────────────│            │           │
```

### 6.4 デバッガを活用する

```javascript
// ブレークポイントを設定して変数を確認
debugger;

// または console.log で追跡
console.log('>>> UserService.create', { input, user });
```

### 6.5 Git履歴を活用する

```bash
# 特定ファイルの変更履歴
git log --oneline -20 -- src/services/UserService.ts

# 特定機能の実装コミットを探す
git log --grep="ユーザー登録" --oneline

# 特定行の変更者を確認
git blame src/services/UserService.ts
```

-----

## ツール活用

### 7.1 IDE機能

| 機能 | 用途 |
|------|------|
| Go to Definition | 定義元にジャンプ |
| Find References | 使用箇所を検索 |
| Call Hierarchy | 呼び出し階層を表示 |
| Type Hierarchy | 継承関係を表示 |
| Search Everywhere | シンボル検索 |

### 7.2 可視化ツール

| ツール | 用途 |
|--------|------|
| DB diagram tools | ER図の自動生成 |
| Mermaid | Markdown内で図を描く |
| PlantUML | UML図の作成 |
| Dependency Cruiser | 依存関係の可視化 |

### 7.3 API確認ツール

| ツール | 用途 |
|--------|------|
| Swagger UI | API仕様の確認・実行 |
| Postman / Insomnia | APIリクエストのテスト |
| curl | CLIからのAPI呼び出し |
| Network DevTools | ブラウザでの通信確認 |

### 7.4 データベースツール

| ツール | 用途 |
|--------|------|
| DBeaver / TablePlus | GUIでDB操作 |
| pgcli / mycli | CLIでDB操作 |
| EXPLAIN ANALYZE | クエリ実行計画の確認 |

-----

## コードリーディングのチェックリスト

### 全体像

- [ ] ディレクトリ構成を把握した
- [ ] 使用技術・フレームワークを特定した
- [ ] エントリーポイントを見つけた
- [ ] 設定ファイルを確認した

### フロントエンド

- [ ] ページ構成を把握した
- [ ] 状態管理のパターンを理解した
- [ ] API呼び出しの方法を確認した

### APIサーバー

- [ ] エンドポイント一覧を把握した
- [ ] レイヤー構造を理解した
- [ ] 認証・認可の仕組みを把握した

### データベース

- [ ] テーブル構成を把握した（ER図）
- [ ] リレーションを理解した
- [ ] クエリパターンを確認した

### 深掘り

- [ ] 1つの機能をEnd-to-Endで追った
- [ ] 疑問点をリスト化した
- [ ] 理解した内容をメモ/図にした

-----

*コードリーディングは繰り返し行うことでスキルが向上します。最初は時間がかかっても、パターンを覚えることで効率が上がります。*
