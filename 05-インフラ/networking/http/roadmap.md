# HTTP通信 学習ロードマップ

開発エンジニア向けのHTTP通信を体系的に学習するためのガイド。基礎的なプロトコルの理解から、セキュリティ、パフォーマンス最適化、最新のHTTP/3まで段階的に習得していく。

---

## 目次

1. [全体像：HTTP通信の学習フロー](#全体像http通信の学習フロー)
1. [Phase 1: 基礎理解（初級）](#phase-1-基礎理解初級)
1. [Phase 2: 実践的な通信（中級）](#phase-2-実践的な通信中級)
1. [Phase 3: セキュリティと最適化（上級）](#phase-3-セキュリティと最適化上級)
1. [Phase 4: 発展的なトピック（エキスパート）](#phase-4-発展的なトピックエキスパート)
1. [ベストプラクティス](#ベストプラクティス)
1. [学習リソース](#学習リソース)
1. [学習のコツ](#学習のコツ)

---

## 全体像：HTTP通信の学習フロー

```mermaid
flowchart TD
    subgraph Phase1["Phase 1: 基礎理解"]
        Protocol[HTTPプロトコルの基本]
        ReqRes[リクエスト/レスポンス]
        Methods[HTTPメソッド]
        StatusCodes[ステータスコード]
        Headers[HTTPヘッダー]
    end

    subgraph Phase2["Phase 2: 実践的な通信"]
        ContentNego[コンテンツネゴシエーション]
        Auth[認証・認可]
        Cookie[Cookie・セッション]
        Cache[キャッシュ制御]
        CORS[CORS]
    end

    subgraph Phase3["Phase 3: セキュリティと最適化"]
        HTTPS[HTTPS/TLS]
        SecHeaders[セキュリティヘッダー]
        Performance[パフォーマンス最適化]
        Streaming[ストリーミング]
    end

    subgraph Phase4["Phase 4: 発展的なトピック"]
        HTTP2[HTTP/2・HTTP/3]
        WebSocket[WebSocket]
        SSE[Server-Sent Events]
        APIDesign[APIデザインパターン]
        Troubleshoot[トラブルシューティング]
    end

    Phase1 --> Phase2
    Phase2 --> Phase3
    Phase3 --> Phase4
```

### HTTP通信の全体フロー

ブラウザからサーバーへリクエストが届くまでの流れを理解することで、各コンポーネントの役割が明確になる。

```mermaid
sequenceDiagram
    participant Browser as ブラウザ
    participant DNS as DNSサーバー
    participant TCP as TCP/IP
    participant TLS as TLS
    participant Server as Webサーバー

    Browser->>DNS: ドメイン名解決
    DNS-->>Browser: IPアドレス
    Browser->>TCP: TCP接続確立（3ウェイハンドシェイク）
    TCP-->>Browser: 接続確立
    Browser->>TLS: TLSハンドシェイク（HTTPS時）
    TLS-->>Browser: 暗号化確立
    Browser->>Server: HTTPリクエスト
    Server-->>Browser: HTTPレスポンス
    Browser->>TCP: TCP接続終了
```

---

## Phase 1: 基礎理解（初級）

HTTPプロトコルの基本的な仕組みを理解する。

### 1.1 HTTPプロトコルの基本

#### HTTPとは

HTTP（HyperText Transfer Protocol）は、WebブラウザとWebサーバー間でデータをやり取りするためのプロトコル。

```mermaid
flowchart LR
    Client[クライアント<br/>ブラウザ] -->|リクエスト| Server[サーバー<br/>Webサーバー]
    Server -->|レスポンス| Client
```

#### なぜHTTPを理解する必要があるか

- **デバッグ**: APIの問題を特定・解決できる
- **パフォーマンス**: 最適化の判断ができる
- **セキュリティ**: 脆弱性を理解し対策できる
- **設計**: RESTful APIを正しく設計できる

#### HTTPの特徴

| 特徴 | 説明 |
|------|------|
| ステートレス | 各リクエストは独立、前のリクエストの情報を保持しない |
| テキストベース | 人間が読める形式（HTTP/1.x）、バイナリ（HTTP/2以降） |
| クライアント・サーバーモデル | クライアントがリクエスト、サーバーがレスポンス |
| 拡張可能 | ヘッダーで機能を追加可能 |

#### URL構造

```
https://example.com:443/path/to/resource?query=value#fragment
└─┬─┘  └────┬────┘└┬┘└───────┬───────┘└────┬────┘└───┬──┘
スキーム   ホスト  ポート    パス       クエリ   フラグメント
```

| 要素 | 説明 | 例 |
|------|------|-----|
| スキーム | プロトコル | `http`, `https` |
| ホスト | サーバーのドメイン名またはIP | `example.com` |
| ポート | 接続先ポート（省略可） | `443`（HTTPSデフォルト） |
| パス | リソースの場所 | `/api/users` |
| クエリ | パラメータ | `?id=123&sort=asc` |
| フラグメント | ページ内の位置（サーバーに送信されない） | `#section1` |

#### TCP/IPとの関係

HTTPはアプリケーション層のプロトコルで、TCP/IPスタックの上で動作する。

```mermaid
flowchart TB
    subgraph App["アプリケーション層"]
        HTTP[HTTP/HTTPS]
    end
    subgraph Transport["トランスポート層"]
        TCP[TCP]
    end
    subgraph Network["ネットワーク層"]
        IP[IP]
    end
    subgraph Link["データリンク層"]
        Ethernet[Ethernet/WiFi]
    end

    HTTP --> TCP
    TCP --> IP
    IP --> Ethernet
```

#### 学習目標

- [ ] HTTPの基本的な役割を説明できる
- [ ] URLの各構成要素を理解している
- [ ] ステートレスの意味を説明できる
- [ ] TCP/IPとの関係を理解している

---

### 1.2 リクエストとレスポンス

#### HTTPメッセージの構造

```mermaid
flowchart TB
    subgraph Request["HTTPリクエスト"]
        RL[リクエストライン<br/>GET /api/users HTTP/1.1]
        RH[ヘッダー<br/>Host: example.com<br/>Content-Type: application/json]
        RB[ボディ（オプション）<br/>{"name": "田中"}]
    end

    subgraph Response["HTTPレスポンス"]
        SL[ステータスライン<br/>HTTP/1.1 200 OK]
        RSH[ヘッダー<br/>Content-Type: application/json<br/>Content-Length: 123]
        RSB[ボディ<br/>{"id": 1, "name": "田中"}]
    end
```

#### HTTPリクエストの例

```http
GET /api/users/123 HTTP/1.1
Host: api.example.com
Accept: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
User-Agent: Mozilla/5.0
```

```http
POST /api/users HTTP/1.1
Host: api.example.com
Content-Type: application/json
Content-Length: 42

{"name": "田中太郎", "email": "tanaka@example.com"}
```

#### HTTPレスポンスの例

```http
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 89
Date: Mon, 01 Jan 2024 00:00:00 GMT
Cache-Control: max-age=3600

{"id": 123, "name": "田中太郎", "email": "tanaka@example.com", "createdAt": "2024-01-01"}
```

#### curlでの確認

```bash
# 基本的なGETリクエスト
curl https://api.example.com/users

# ヘッダーを含めて表示
curl -i https://api.example.com/users

# 詳細な通信内容を表示
curl -v https://api.example.com/users

# POSTリクエスト
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "田中太郎"}'
```

#### JavaScript/TypeScriptでの実装

```typescript
// Fetch API - GETリクエスト
const response = await fetch('https://api.example.com/users/123');
const user = await response.json();
console.log(user);

// Fetch API - POSTリクエスト
const response = await fetch('https://api.example.com/users', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    name: '田中太郎',
    email: 'tanaka@example.com',
  }),
});

if (!response.ok) {
  throw new Error(`HTTP error! status: ${response.status}`);
}

const newUser = await response.json();
```

#### 学習目標

- [ ] HTTPリクエスト/レスポンスの構造を説明できる
- [ ] curlでリクエストを送信・確認できる
- [ ] Fetch APIでHTTPリクエストを実装できる

---

### 1.3 HTTPメソッド

#### 主要なHTTPメソッド

```mermaid
flowchart LR
    subgraph Safe["安全なメソッド"]
        GET[GET<br/>取得]
        HEAD[HEAD<br/>ヘッダーのみ取得]
        OPTIONS[OPTIONS<br/>サポートメソッド確認]
    end

    subgraph Unsafe["安全でないメソッド"]
        POST[POST<br/>作成]
        PUT[PUT<br/>置換]
        PATCH[PATCH<br/>部分更新]
        DELETE[DELETE<br/>削除]
    end
```

| メソッド | 用途 | 冪等性 | 安全性 | リクエストボディ |
|---------|------|--------|--------|------------------|
| GET | リソース取得 | Yes | Yes | なし |
| HEAD | ヘッダーのみ取得 | Yes | Yes | なし |
| POST | リソース作成 | No | No | あり |
| PUT | リソース完全置換 | Yes | No | あり |
| PATCH | リソース部分更新 | No | No | あり |
| DELETE | リソース削除 | Yes | No | 通常なし |
| OPTIONS | サポートメソッド確認 | Yes | Yes | なし |

#### 冪等性（べきとうせい）とは

同じリクエストを何度実行しても、結果が同じになる性質。

```typescript
// 冪等な操作（PUT）- 何度実行しても同じ結果
// PUT /users/123 → ユーザー123を指定した内容で上書き
await fetch('/api/users/123', {
  method: 'PUT',
  body: JSON.stringify({ name: '田中太郎', age: 30 }),
});

// 冪等でない操作（POST）- 実行するたびに新しいリソースが作成される
// POST /users → 新しいユーザーを作成
await fetch('/api/users', {
  method: 'POST',
  body: JSON.stringify({ name: '田中太郎' }),
});
```

#### なぜ冪等性が重要か

- **リトライ**: ネットワークエラー時に安全に再試行できる
- **キャッシュ**: 冪等なメソッドはキャッシュ可能
- **並行処理**: 同時実行時の予測可能性

#### 安全性とは

サーバーの状態を変更しない性質。GETリクエストは何度実行してもサーバーのデータを変更しない。

```typescript
// 安全な操作（GET）- サーバーの状態を変更しない
await fetch('/api/users/123'); // 読み取りのみ

// 安全でない操作（DELETE）- サーバーの状態を変更する
await fetch('/api/users/123', { method: 'DELETE' }); // データを削除
```

#### メソッドの使い分け

```typescript
// GET - リソースの取得
const users = await fetch('/api/users').then(r => r.json());

// POST - リソースの作成（サーバーがIDを決定）
const newUser = await fetch('/api/users', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ name: '田中太郎' }),
}).then(r => r.json());

// PUT - リソースの完全置換（クライアントがIDを指定）
await fetch('/api/users/123', {
  method: 'PUT',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ name: '田中次郎', email: 'jiro@example.com' }),
});

// PATCH - リソースの部分更新
await fetch('/api/users/123', {
  method: 'PATCH',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email: 'new@example.com' }), // emailのみ更新
});

// DELETE - リソースの削除
await fetch('/api/users/123', { method: 'DELETE' });
```

#### 学習目標

- [ ] 各HTTPメソッドの用途を説明できる
- [ ] 冪等性と安全性の違いを説明できる
- [ ] 適切なメソッドを選択できる

---

### 1.4 ステータスコード

#### ステータスコードの分類

```mermaid
flowchart TD
    subgraph 1xx["1xx: 情報"]
        100[100 Continue]
        101[101 Switching Protocols]
    end

    subgraph 2xx["2xx: 成功"]
        200[200 OK]
        201[201 Created]
        204[204 No Content]
    end

    subgraph 3xx["3xx: リダイレクト"]
        301[301 Moved Permanently]
        302[302 Found]
        304[304 Not Modified]
    end

    subgraph 4xx["4xx: クライアントエラー"]
        400[400 Bad Request]
        401[401 Unauthorized]
        403[403 Forbidden]
        404[404 Not Found]
        422[422 Unprocessable Entity]
    end

    subgraph 5xx["5xx: サーバーエラー"]
        500[500 Internal Server Error]
        502[502 Bad Gateway]
        503[503 Service Unavailable]
    end
```

#### よく使うステータスコード

| コード | 名称 | 説明 | 使用場面 |
|--------|------|------|---------|
| 200 | OK | 成功 | GETの成功 |
| 201 | Created | 作成成功 | POSTでリソース作成成功 |
| 204 | No Content | 成功（レスポンスボディなし） | DELETEの成功 |
| 301 | Moved Permanently | 恒久的リダイレクト | URL変更（SEO考慮） |
| 302 | Found | 一時的リダイレクト | ログイン後のリダイレクト |
| 304 | Not Modified | 未変更 | キャッシュ有効 |
| 400 | Bad Request | リクエスト不正 | バリデーションエラー（形式） |
| 401 | Unauthorized | 認証エラー | 未ログイン |
| 403 | Forbidden | 権限エラー | アクセス権限なし |
| 404 | Not Found | リソース未発見 | 存在しないURL |
| 422 | Unprocessable Entity | 処理不可 | バリデーションエラー（意味） |
| 429 | Too Many Requests | リクエスト過多 | レート制限 |
| 500 | Internal Server Error | サーバーエラー | 予期せぬエラー |
| 502 | Bad Gateway | ゲートウェイエラー | プロキシ/ロードバランサーエラー |
| 503 | Service Unavailable | サービス利用不可 | メンテナンス、過負荷 |

#### 400 vs 422 の使い分け

```typescript
// 400 Bad Request - リクエストの形式が不正
// JSON構文エラー、必須フィールドの欠落
// 例: { "name": } ← JSON構文エラー

// 422 Unprocessable Entity - 形式は正しいがビジネスロジックで処理不可
// 例: メールアドレスが既に登録済み
{
  "error": "Unprocessable Entity",
  "details": {
    "email": "このメールアドレスは既に登録されています"
  }
}
```

#### 401 vs 403 の使い分け

```typescript
// 401 Unauthorized - 認証が必要（誰か分からない）
// → ログインページへリダイレクト

// 403 Forbidden - 認証済みだが権限がない（誰か分かるが拒否）
// → エラーメッセージを表示
```

#### レスポンス処理の実装

```typescript
async function fetchUser(id: string) {
  const response = await fetch(`/api/users/${id}`);

  switch (response.status) {
    case 200:
      return await response.json();
    case 404:
      throw new Error('ユーザーが見つかりません');
    case 401:
      // 認証エラー → ログインページへ
      window.location.href = '/login';
      break;
    case 403:
      throw new Error('このユーザーへのアクセス権限がありません');
    case 500:
      throw new Error('サーバーエラーが発生しました。しばらく後に再試行してください');
    default:
      throw new Error(`予期せぬエラー: ${response.status}`);
  }
}
```

#### 学習目標

- [ ] ステータスコードの分類（1xx〜5xx）を説明できる
- [ ] 主要なステータスコードの意味を理解している
- [ ] 400と422、401と403の違いを説明できる
- [ ] ステータスコードに応じた処理を実装できる

---

### 1.5 HTTPヘッダー

#### ヘッダーの種類

| 種類 | 説明 | 例 |
|------|------|-----|
| 一般ヘッダー | リクエスト/レスポンス共通 | `Date`, `Connection`, `Cache-Control` |
| リクエストヘッダー | クライアントからの情報 | `Host`, `User-Agent`, `Accept` |
| レスポンスヘッダー | サーバーからの情報 | `Server`, `Set-Cookie`, `Location` |
| エンティティヘッダー | ボディに関する情報 | `Content-Type`, `Content-Length` |

#### 重要なリクエストヘッダー

```http
# ホスト名（必須）
Host: api.example.com

# 受け入れ可能なコンテンツタイプ
Accept: application/json, text/plain

# 受け入れ可能な言語
Accept-Language: ja, en;q=0.8

# 受け入れ可能なエンコーディング
Accept-Encoding: gzip, deflate, br

# クライアント情報
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)

# 認証情報
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...

# リクエストボディの形式
Content-Type: application/json

# リクエストボディのサイズ
Content-Length: 128

# クッキー
Cookie: session_id=abc123; user_id=456

# リファラー（参照元URL）
Referer: https://example.com/page
```

#### 重要なレスポンスヘッダー

```http
# コンテンツタイプ
Content-Type: application/json; charset=utf-8

# コンテンツサイズ
Content-Length: 1234

# キャッシュ制御
Cache-Control: max-age=3600, public

# クッキー設定
Set-Cookie: session_id=abc123; HttpOnly; Secure; SameSite=Strict

# リダイレクト先
Location: https://example.com/new-page

# CORS設定
Access-Control-Allow-Origin: https://example.com
```

#### Content-Typeの主な値

| Content-Type | 説明 | 用途 |
|--------------|------|------|
| `application/json` | JSON形式 | APIレスポンス |
| `application/x-www-form-urlencoded` | フォームデータ | HTMLフォーム送信 |
| `multipart/form-data` | マルチパートデータ | ファイルアップロード |
| `text/html` | HTML | Webページ |
| `text/plain` | プレーンテキスト | テキストファイル |
| `application/octet-stream` | バイナリデータ | ファイルダウンロード |

#### ヘッダーの操作（JavaScript）

```typescript
// リクエストヘッダーの設定
const response = await fetch('/api/users', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
    'Accept-Language': 'ja',
    'X-Custom-Header': 'custom-value', // カスタムヘッダー
  },
  body: JSON.stringify(data),
});

// レスポンスヘッダーの取得
const contentType = response.headers.get('Content-Type');
const cacheControl = response.headers.get('Cache-Control');
const customHeader = response.headers.get('X-Custom-Header');

// すべてのヘッダーを列挙
response.headers.forEach((value, key) => {
  console.log(`${key}: ${value}`);
});
```

#### 学習目標

- [ ] ヘッダーの種類を理解している
- [ ] 主要なリクエスト/レスポンスヘッダーを説明できる
- [ ] Content-Typeの使い分けを理解している
- [ ] JavaScriptでヘッダーを操作できる

---

## Phase 2: 実践的な通信（中級）

より実践的なHTTP通信のトピックを習得する。

### 2.1 コンテンツネゴシエーション

#### コンテンツネゴシエーションとは

クライアントとサーバーが、やり取りするコンテンツの形式を交渉する仕組み。

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant Server as サーバー

    Client->>Server: Accept: application/json, text/html;q=0.9
    Note over Server: JSONを優先、HTMLも可
    Server-->>Client: Content-Type: application/json
```

#### Acceptヘッダーの品質値（q値）

```http
Accept: application/json, text/html;q=0.9, text/plain;q=0.8, */*;q=0.1
```

| MIME Type | q値 | 優先度 |
|-----------|-----|--------|
| application/json | 1.0（デフォルト） | 最高 |
| text/html | 0.9 | 高 |
| text/plain | 0.8 | 中 |
| \*/\* | 0.1 | 最低 |

#### 言語ネゴシエーション

```http
Accept-Language: ja, en-US;q=0.9, en;q=0.8
```

```typescript
// サーバー側の実装例（Express.js）
app.get('/api/greeting', (req, res) => {
  const acceptLanguage = req.headers['accept-language'];
  const preferredLang = acceptLanguage?.split(',')[0]?.split(';')[0] || 'en';

  const greetings: Record<string, string> = {
    ja: 'こんにちは',
    en: 'Hello',
    es: 'Hola',
  };

  res.json({ greeting: greetings[preferredLang] || greetings.en });
});
```

#### 文字エンコーディング

```http
# リクエスト
Accept-Charset: utf-8, iso-8859-1;q=0.5

# レスポンス
Content-Type: text/html; charset=utf-8
```

#### 圧縮エンコーディング

```http
# リクエスト - クライアントが対応している圧縮形式
Accept-Encoding: gzip, deflate, br

# レスポンス - 実際に使用した圧縮形式
Content-Encoding: gzip
```

| エンコーディング | 説明 | 圧縮率 |
|------------------|------|--------|
| gzip | 広くサポート | 良好 |
| deflate | 古い形式 | 良好 |
| br（Brotli） | 最新、高圧縮 | 最高 |

#### 学習目標

- [ ] コンテンツネゴシエーションの仕組みを説明できる
- [ ] q値による優先度を理解している
- [ ] Accept系ヘッダーの種類を理解している

---

### 2.2 認証・認可

#### 認証方式の比較

| 方式 | 特徴 | 用途 |
|------|------|------|
| Basic認証 | シンプル、Base64エンコード | 社内ツール、開発環境 |
| Bearer Token | トークンベース | API認証 |
| OAuth 2.0 | 標準化された認可フレームワーク | サードパーティ連携 |
| API Key | 固定キー | 外部サービス連携 |

#### Basic認証

```http
Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
```

```typescript
// Base64エンコード: "username:password"
const credentials = btoa('username:password');

const response = await fetch('/api/protected', {
  headers: {
    Authorization: `Basic ${credentials}`,
  },
});
```

なぜBasic認証は限定的に使うべきか：

- パスワードがBase64でエンコードされるだけ（暗号化ではない）
- HTTPSなしでは平文同然
- ログアウト機能がない

#### Bearer Token（JWT）

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

```typescript
// ログイン時にトークンを取得
const loginResponse = await fetch('/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, password }),
});

const { token } = await loginResponse.json();

// トークンを使用してAPIにアクセス
const response = await fetch('/api/users/me', {
  headers: {
    Authorization: `Bearer ${token}`,
  },
});
```

#### JWTの構造

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.    ← ヘッダー（Base64）
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6...   ← ペイロード（Base64）
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c ← 署名
```

```typescript
// JWTのデコード（署名検証なし）
function decodeJwt(token: string) {
  const [header, payload, signature] = token.split('.');
  return {
    header: JSON.parse(atob(header)),
    payload: JSON.parse(atob(payload)),
  };
}
```

#### OAuth 2.0フロー

```mermaid
sequenceDiagram
    participant User as ユーザー
    participant Client as クライアントアプリ
    participant AuthServer as 認可サーバー
    participant Resource as リソースサーバー

    User->>Client: ログインリクエスト
    Client->>AuthServer: 認可リクエスト
    AuthServer->>User: ログイン画面
    User->>AuthServer: 認証情報入力
    AuthServer->>Client: 認可コード
    Client->>AuthServer: トークンリクエスト（認可コード）
    AuthServer->>Client: アクセストークン
    Client->>Resource: APIリクエスト（トークン付き）
    Resource->>Client: レスポンス
```

#### トークンのリフレッシュ

```typescript
class ApiClient {
  private accessToken: string;
  private refreshToken: string;

  async fetch(url: string, options: RequestInit = {}) {
    const response = await fetch(url, {
      ...options,
      headers: {
        ...options.headers,
        Authorization: `Bearer ${this.accessToken}`,
      },
    });

    // トークン期限切れの場合
    if (response.status === 401) {
      await this.refreshAccessToken();
      // リトライ
      return this.fetch(url, options);
    }

    return response;
  }

  private async refreshAccessToken() {
    const response = await fetch('/api/auth/refresh', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refreshToken: this.refreshToken }),
    });

    if (!response.ok) {
      // リフレッシュトークンも期限切れ → 再ログインが必要
      throw new Error('Session expired. Please login again.');
    }

    const { accessToken, refreshToken } = await response.json();
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
```

#### 学習目標

- [ ] 各認証方式の特徴を説明できる
- [ ] Bearer Tokenを使った認証を実装できる
- [ ] JWTの構造を理解している
- [ ] トークンリフレッシュの仕組みを実装できる

---

### 2.3 Cookie・セッション

#### Cookieの仕組み

```mermaid
sequenceDiagram
    participant Browser as ブラウザ
    participant Server as サーバー

    Browser->>Server: 初回リクエスト
    Server-->>Browser: Set-Cookie: session_id=abc123
    Note over Browser: Cookieを保存
    Browser->>Server: 次回リクエスト<br/>Cookie: session_id=abc123
    Note over Server: セッション情報を取得
    Server-->>Browser: レスポンス（ユーザー情報付き）
```

#### Set-Cookieヘッダーの属性

```http
Set-Cookie: session_id=abc123; Path=/; Domain=example.com; Max-Age=3600; HttpOnly; Secure; SameSite=Strict
```

| 属性 | 説明 | セキュリティ |
|------|------|-------------|
| `Path` | Cookieが送信されるパス | - |
| `Domain` | Cookieが送信されるドメイン | - |
| `Max-Age` | 有効期限（秒） | - |
| `Expires` | 有効期限（日時） | - |
| `HttpOnly` | JavaScriptからアクセス不可 | XSS対策 |
| `Secure` | HTTPS通信時のみ送信 | 盗聴対策 |
| `SameSite` | クロスサイトリクエスト制御 | CSRF対策 |

#### SameSite属性

| 値 | 説明 | 使用場面 |
|-----|------|---------|
| `Strict` | 同一サイトのみ | 高セキュリティが必要 |
| `Lax` | GETは許可、POSTは同一サイトのみ | デフォルト推奨 |
| `None` | クロスサイトも許可（Secure必須） | サードパーティCookie |

#### セキュアなCookie設定（サーバー側）

```typescript
// Express.jsでのCookie設定
app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,      // JavaScriptからアクセス不可
    secure: true,        // HTTPSのみ
    sameSite: 'strict',  // 同一サイトのみ
    maxAge: 24 * 60 * 60 * 1000, // 24時間
  },
}));
```

#### JavaScriptでのCookie操作

```typescript
// Cookieの読み取り（HttpOnlyでないもののみ）
function getCookie(name: string): string | null {
  const match = document.cookie.match(new RegExp(`(^| )${name}=([^;]+)`));
  return match ? match[2] : null;
}

// Cookieの設定
function setCookie(name: string, value: string, days: number) {
  const expires = new Date(Date.now() + days * 864e5).toUTCString();
  document.cookie = `${name}=${encodeURIComponent(value)}; expires=${expires}; path=/; SameSite=Lax`;
}

// Cookieの削除
function deleteCookie(name: string) {
  document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/`;
}
```

#### Cookie vs LocalStorage vs SessionStorage

| 特性 | Cookie | LocalStorage | SessionStorage |
|------|--------|--------------|----------------|
| サーバーへ自動送信 | Yes | No | No |
| 容量 | 4KB | 5MB | 5MB |
| 有効期限 | 設定可能 | なし | タブを閉じるまで |
| HttpOnly対応 | Yes | No | No |

#### 学習目標

- [ ] Cookieの仕組みを説明できる
- [ ] Set-Cookieの各属性を理解している
- [ ] セキュアなCookie設定ができる
- [ ] Cookie/LocalStorage/SessionStorageの使い分けを判断できる

---

### 2.4 キャッシュ制御

#### キャッシュの種類

```mermaid
flowchart LR
    Browser[ブラウザ] --> BrowserCache[ブラウザキャッシュ]
    BrowserCache --> CDN[CDN/プロキシ]
    CDN --> Origin[オリジンサーバー]
```

| キャッシュ | 場所 | 制御方法 |
|-----------|------|---------|
| ブラウザキャッシュ | クライアント | Cache-Control |
| プロキシキャッシュ | 中間サーバー | Cache-Control, Vary |
| CDNキャッシュ | エッジサーバー | Cache-Control, Surrogate-Control |

#### Cache-Controlディレクティブ

```http
# レスポンス
Cache-Control: public, max-age=3600
Cache-Control: private, no-cache
Cache-Control: no-store
```

| ディレクティブ | 説明 |
|---------------|------|
| `public` | 共有キャッシュ（CDN等）に保存可能 |
| `private` | ブラウザキャッシュのみ |
| `max-age=秒` | キャッシュ有効期間 |
| `s-maxage=秒` | 共有キャッシュの有効期間 |
| `no-cache` | キャッシュ前に再検証が必要 |
| `no-store` | キャッシュ禁止 |
| `must-revalidate` | 期限切れ後は必ず再検証 |
| `immutable` | 変更されない（再検証不要） |

#### ETagと条件付きリクエスト

```mermaid
sequenceDiagram
    participant Browser as ブラウザ
    participant Server as サーバー

    Browser->>Server: GET /api/users/123
    Server-->>Browser: 200 OK<br/>ETag: "abc123"<br/>Cache-Control: max-age=60

    Note over Browser: 60秒後...

    Browser->>Server: GET /api/users/123<br/>If-None-Match: "abc123"

    alt データ未変更
        Server-->>Browser: 304 Not Modified
        Note over Browser: キャッシュを使用
    else データ変更あり
        Server-->>Browser: 200 OK<br/>ETag: "xyz789"<br/>新しいデータ
    end
```

```typescript
// サーバー側の実装例
app.get('/api/users/:id', async (req, res) => {
  const user = await getUser(req.params.id);
  const etag = generateETag(user);

  // If-None-Matchヘッダーをチェック
  if (req.headers['if-none-match'] === etag) {
    return res.status(304).end();
  }

  res.setHeader('ETag', etag);
  res.setHeader('Cache-Control', 'private, max-age=60');
  res.json(user);
});

function generateETag(data: any): string {
  const hash = crypto
    .createHash('md5')
    .update(JSON.stringify(data))
    .digest('hex');
  return `"${hash}"`;
}
```

#### Last-Modifiedと条件付きリクエスト

```http
# 初回レスポンス
Last-Modified: Mon, 01 Jan 2024 00:00:00 GMT

# 再検証リクエスト
If-Modified-Since: Mon, 01 Jan 2024 00:00:00 GMT

# 未変更の場合
HTTP/1.1 304 Not Modified
```

#### キャッシュ戦略の選択

```mermaid
flowchart TD
    Start[リソースの種類] --> Q1{変更される?}
    Q1 -->|No| Immutable[Cache-Control: public, max-age=31536000, immutable<br/>静的アセット（ハッシュ付きファイル名）]
    Q1 -->|Yes| Q2{ユーザー固有?}
    Q2 -->|Yes| Private[Cache-Control: private, max-age=60<br/>ユーザーデータ]
    Q2 -->|No| Q3{頻繁に更新?}
    Q3 -->|Yes| NoCache[Cache-Control: no-cache<br/>または短いmax-age<br/>ニュースフィード等]
    Q3 -->|No| Public[Cache-Control: public, max-age=3600<br/>商品情報等]
```

#### 学習目標

- [ ] キャッシュの種類と役割を説明できる
- [ ] Cache-Controlディレクティブを使い分けられる
- [ ] ETagによる条件付きリクエストを実装できる
- [ ] 適切なキャッシュ戦略を選択できる

---

### 2.5 CORS（Cross-Origin Resource Sharing）

#### 同一オリジンポリシー

ブラウザのセキュリティ機能で、異なるオリジンへのリクエストを制限する。

```
オリジン = スキーム + ホスト + ポート
```

| URL | オリジン |
|-----|---------|
| `https://example.com/page` | `https://example.com` |
| `https://example.com:443/api` | `https://example.com` |
| `https://api.example.com/` | `https://api.example.com`（異なるオリジン） |
| `http://example.com/` | `http://example.com`（異なるオリジン） |

#### CORSの仕組み

```mermaid
sequenceDiagram
    participant Browser as ブラウザ<br/>https://app.example.com
    participant API as APIサーバー<br/>https://api.example.com

    Note over Browser,API: 単純リクエスト（GET, 特定のヘッダーのみ）

    Browser->>API: GET /api/users<br/>Origin: https://app.example.com
    API-->>Browser: Access-Control-Allow-Origin: https://app.example.com<br/>データ
```

#### プリフライトリクエスト

```mermaid
sequenceDiagram
    participant Browser as ブラウザ
    participant API as APIサーバー

    Note over Browser,API: プリフライト（事前確認）

    Browser->>API: OPTIONS /api/users<br/>Origin: https://app.example.com<br/>Access-Control-Request-Method: POST<br/>Access-Control-Request-Headers: Content-Type
    API-->>Browser: Access-Control-Allow-Origin: https://app.example.com<br/>Access-Control-Allow-Methods: GET, POST, PUT, DELETE<br/>Access-Control-Allow-Headers: Content-Type<br/>Access-Control-Max-Age: 86400

    Note over Browser,API: 実際のリクエスト

    Browser->>API: POST /api/users<br/>Origin: https://app.example.com<br/>Content-Type: application/json
    API-->>Browser: Access-Control-Allow-Origin: https://app.example.com<br/>データ
```

#### プリフライトが発生する条件

- HTTPメソッドがGET, HEAD, POST以外
- Content-Typeが以下以外
  - `application/x-www-form-urlencoded`
  - `multipart/form-data`
  - `text/plain`
- カスタムヘッダーを使用

#### CORSヘッダー

| ヘッダー | 説明 |
|---------|------|
| `Access-Control-Allow-Origin` | 許可するオリジン |
| `Access-Control-Allow-Methods` | 許可するメソッド |
| `Access-Control-Allow-Headers` | 許可するヘッダー |
| `Access-Control-Allow-Credentials` | 認証情報の送信を許可 |
| `Access-Control-Max-Age` | プリフライト結果のキャッシュ時間 |
| `Access-Control-Expose-Headers` | JSからアクセス可能なヘッダー |

#### サーバー側の設定（Express.js）

```typescript
import cors from 'cors';

// すべてのオリジンを許可（開発環境向け）
app.use(cors());

// 特定のオリジンのみ許可（本番環境向け）
app.use(cors({
  origin: ['https://app.example.com', 'https://admin.example.com'],
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true, // Cookie/認証情報を含むリクエストを許可
  maxAge: 86400, // プリフライトのキャッシュ（秒）
}));

// 動的にオリジンを検証
app.use(cors({
  origin: (origin, callback) => {
    const allowedOrigins = ['https://app.example.com'];
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
}));
```

#### クライアント側での認証情報の送信

```typescript
// credentials: 'include' でCookieを送信
const response = await fetch('https://api.example.com/users', {
  credentials: 'include', // Cookie/認証情報を含める
  headers: {
    'Content-Type': 'application/json',
  },
});
```

#### CORSエラーのデバッグ

```typescript
// よくあるCORSエラー
// 1. Access-Control-Allow-Origin がない
// 2. credentials: 'include' 時に Access-Control-Allow-Origin が * になっている
// 3. プリフライトでAccess-Control-Allow-Headersが不足

// デバッグ方法
// 1. ブラウザの開発者ツール > Network > Headersを確認
// 2. curlでプリフライトを模倣
curl -X OPTIONS https://api.example.com/users \
  -H "Origin: https://app.example.com" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: Content-Type" \
  -v
```

#### 学習目標

- [ ] 同一オリジンポリシーを説明できる
- [ ] CORSの仕組みを理解している
- [ ] プリフライトリクエストが発生する条件を説明できる
- [ ] サーバー側でCORSを設定できる

---

## Phase 3: セキュリティと最適化（上級）

HTTPSやセキュリティヘッダー、パフォーマンス最適化を習得する。

### 3.1 HTTPS/TLS

#### HTTPSとは

HTTP over TLS（Transport Layer Security）。通信を暗号化し、盗聴・改ざん・なりすましを防ぐ。

```mermaid
flowchart LR
    subgraph HTTP["HTTP"]
        Plain[平文通信<br/>盗聴可能]
    end

    subgraph HTTPS["HTTPS"]
        Encrypted[暗号化通信<br/>安全]
    end

    HTTP -->|TLS| HTTPS
```

#### TLSハンドシェイク

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant Server as サーバー

    Client->>Server: ClientHello<br/>対応するTLSバージョン、暗号スイート
    Server-->>Client: ServerHello<br/>選択したTLSバージョン、暗号スイート
    Server-->>Client: Certificate<br/>サーバー証明書
    Server-->>Client: ServerHelloDone

    Note over Client: 証明書を検証

    Client->>Server: ClientKeyExchange<br/>プリマスターシークレット（公開鍵で暗号化）
    Client->>Server: ChangeCipherSpec
    Client->>Server: Finished（暗号化）

    Server-->>Client: ChangeCipherSpec
    Server-->>Client: Finished（暗号化）

    Note over Client,Server: 以降、暗号化通信
```

#### 証明書の種類

| 種類 | 検証レベル | 用途 | 取得時間 |
|------|-----------|------|---------|
| DV（Domain Validation） | ドメイン所有確認 | 個人サイト、ブログ | 数分 |
| OV（Organization Validation） | 組織の実在確認 | 企業サイト | 数日 |
| EV（Extended Validation） | 厳格な組織確認 | 金融機関、EC | 数週間 |

#### Let's Encryptでの証明書取得

```bash
# Certbotのインストール（Ubuntu）
sudo apt install certbot

# 証明書の取得
sudo certbot certonly --standalone -d example.com

# 自動更新の設定
sudo certbot renew --dry-run
```

#### HSTS（HTTP Strict Transport Security）

ブラウザにHTTPS接続を強制する仕組み。

```http
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

| ディレクティブ | 説明 |
|---------------|------|
| `max-age` | HSTSを有効にする期間（秒） |
| `includeSubDomains` | サブドメインにも適用 |
| `preload` | ブラウザのプリロードリストに登録 |

```typescript
// Express.jsでのHSTS設定
import helmet from 'helmet';

app.use(helmet.hsts({
  maxAge: 31536000, // 1年
  includeSubDomains: true,
  preload: true,
}));
```

#### 証明書ピンニング（参考）

特定の証明書のみを信頼する仕組み。現在は非推奨で、Certificate Transparencyが主流。

#### 学習目標

- [ ] HTTPSが必要な理由を説明できる
- [ ] TLSハンドシェイクの概要を理解している
- [ ] 証明書の種類を理解している
- [ ] HSTSを設定できる

---

### 3.2 セキュリティヘッダー

#### 主要なセキュリティヘッダー

```http
# Content Security Policy - XSS対策
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'

# クリックジャッキング対策
X-Frame-Options: DENY

# MIMEタイプスニッフィング対策
X-Content-Type-Options: nosniff

# XSSフィルター（レガシー）
X-XSS-Protection: 1; mode=block

# Referrer制御
Referrer-Policy: strict-origin-when-cross-origin

# 機能制御
Permissions-Policy: geolocation=(), camera=()
```

#### Content Security Policy（CSP）

```http
Content-Security-Policy:
  default-src 'self';
  script-src 'self' https://cdn.example.com;
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  font-src 'self' https://fonts.googleapis.com;
  connect-src 'self' https://api.example.com;
  frame-ancestors 'none';
  base-uri 'self';
  form-action 'self';
```

| ディレクティブ | 説明 |
|---------------|------|
| `default-src` | デフォルトのソース |
| `script-src` | JavaScriptのソース |
| `style-src` | CSSのソース |
| `img-src` | 画像のソース |
| `connect-src` | fetch/XHRの接続先 |
| `frame-ancestors` | iframeでの埋め込み元 |
| `'self'` | 同一オリジン |
| `'unsafe-inline'` | インラインスクリプト/スタイル許可 |
| `'unsafe-eval'` | eval()許可 |
| `'nonce-xxx'` | 特定のnonceを持つ要素のみ許可 |

#### Helmetを使った設定（Express.js）

```typescript
import helmet from 'helmet';

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "https://cdn.example.com"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'", "https://api.example.com"],
      frameAncestors: ["'none'"],
    },
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
  },
  frameguard: { action: 'deny' },
  referrerPolicy: { policy: 'strict-origin-when-cross-origin' },
}));
```

#### 学習目標

- [ ] 主要なセキュリティヘッダーを説明できる
- [ ] CSPを設定できる
- [ ] Helmetを使ってセキュリティヘッダーを設定できる

---

### 3.3 パフォーマンス最適化

#### Keep-Alive（持続的接続）

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant Server as サーバー

    Note over Client,Server: Keep-Aliveなし
    Client->>Server: TCP接続
    Client->>Server: リクエスト1
    Server-->>Client: レスポンス1
    Client->>Server: TCP切断
    Client->>Server: TCP接続
    Client->>Server: リクエスト2
    Server-->>Client: レスポンス2
    Client->>Server: TCP切断

    Note over Client,Server: Keep-Aliveあり
    Client->>Server: TCP接続
    Client->>Server: リクエスト1
    Server-->>Client: レスポンス1
    Client->>Server: リクエスト2
    Server-->>Client: レスポンス2
    Client->>Server: リクエスト3
    Server-->>Client: レスポンス3
    Client->>Server: TCP切断
```

```http
# HTTP/1.1ではデフォルトで有効
Connection: keep-alive
Keep-Alive: timeout=5, max=100
```

#### 圧縮

```typescript
// Express.jsでの圧縮設定
import compression from 'compression';

app.use(compression({
  filter: (req, res) => {
    if (req.headers['x-no-compression']) {
      return false;
    }
    return compression.filter(req, res);
  },
  level: 6, // 圧縮レベル（1-9）
  threshold: 1024, // 1KB以上のレスポンスを圧縮
}));
```

```bash
# 圧縮効果の確認
curl -H "Accept-Encoding: gzip" -I https://example.com/api/data
# Content-Encoding: gzip が返ってくれば圧縮されている
```

#### HTTP/1.1のパイプライニング

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant Server as サーバー

    Note over Client,Server: パイプラインなし
    Client->>Server: リクエスト1
    Server-->>Client: レスポンス1
    Client->>Server: リクエスト2
    Server-->>Client: レスポンス2

    Note over Client,Server: パイプラインあり
    Client->>Server: リクエスト1
    Client->>Server: リクエスト2
    Client->>Server: リクエスト3
    Server-->>Client: レスポンス1
    Server-->>Client: レスポンス2
    Server-->>Client: レスポンス3
```

パイプライニングの問題点（Head-of-Line Blocking）：

- レスポンスは順番通りに返す必要がある
- 1つ目のレスポンスが遅いと後続もブロックされる
- HTTP/2で解決された

#### リソースヒント

```html
<!-- DNS事前解決 -->
<link rel="dns-prefetch" href="https://api.example.com">

<!-- TCP接続事前確立 -->
<link rel="preconnect" href="https://api.example.com">

<!-- リソース事前読み込み -->
<link rel="preload" href="/fonts/main.woff2" as="font" crossorigin>

<!-- 次ページ事前読み込み -->
<link rel="prefetch" href="/next-page.html">
```

#### 学習目標

- [ ] Keep-Aliveの効果を説明できる
- [ ] レスポンス圧縮を設定できる
- [ ] パイプライニングとHoL Blockingを理解している
- [ ] リソースヒントを適切に使用できる

---

### 3.4 ストリーミング

#### Chunked Transfer Encoding

```http
HTTP/1.1 200 OK
Transfer-Encoding: chunked
Content-Type: text/plain

7\r\n
Hello, \r\n
6\r\n
World!\r\n
0\r\n
\r\n
```

```typescript
// Express.jsでのチャンク転送
app.get('/api/stream', (req, res) => {
  res.setHeader('Content-Type', 'text/plain');
  res.setHeader('Transfer-Encoding', 'chunked');

  let count = 0;
  const interval = setInterval(() => {
    res.write(`Chunk ${count}\n`);
    count++;

    if (count >= 10) {
      clearInterval(interval);
      res.end();
    }
  }, 1000);
});
```

#### Range リクエスト

大きなファイルの一部だけを取得する。動画のシーク再生などに使用。

```http
# リクエスト - バイト範囲を指定
Range: bytes=0-1023

# レスポンス - 部分コンテンツ
HTTP/1.1 206 Partial Content
Content-Range: bytes 0-1023/10000
Content-Length: 1024
```

```typescript
// Range リクエストの処理（Express.js）
app.get('/api/video/:id', (req, res) => {
  const videoPath = `/videos/${req.params.id}.mp4`;
  const stat = fs.statSync(videoPath);
  const fileSize = stat.size;
  const range = req.headers.range;

  if (range) {
    const parts = range.replace(/bytes=/, '').split('-');
    const start = parseInt(parts[0], 10);
    const end = parts[1] ? parseInt(parts[1], 10) : fileSize - 1;
    const chunkSize = end - start + 1;

    const stream = fs.createReadStream(videoPath, { start, end });
    res.writeHead(206, {
      'Content-Range': `bytes ${start}-${end}/${fileSize}`,
      'Accept-Ranges': 'bytes',
      'Content-Length': chunkSize,
      'Content-Type': 'video/mp4',
    });
    stream.pipe(res);
  } else {
    res.writeHead(200, {
      'Content-Length': fileSize,
      'Content-Type': 'video/mp4',
    });
    fs.createReadStream(videoPath).pipe(res);
  }
});
```

#### 学習目標

- [ ] Chunked Transfer Encodingを理解している
- [ ] Rangeリクエストの用途を説明できる
- [ ] ストリーミングレスポンスを実装できる

---

## Phase 4: 発展的なトピック（エキスパート）

HTTP/2、HTTP/3、WebSocketなど最新の技術を習得する。

### 4.1 HTTP/2・HTTP/3

#### HTTP/1.1 vs HTTP/2 vs HTTP/3

```mermaid
flowchart LR
    subgraph HTTP1["HTTP/1.1"]
        Text[テキストベース]
        HOL1[HoL Blocking]
        Multi1[複数TCP接続]
    end

    subgraph HTTP2["HTTP/2"]
        Binary[バイナリプロトコル]
        Multiplex[多重化]
        ServerPush[サーバープッシュ]
        HeaderComp[ヘッダー圧縮]
    end

    subgraph HTTP3["HTTP/3"]
        QUIC[QUIC（UDP）]
        ZeroRTT[0-RTT]
        NoHOL[HoL Blocking解消]
    end

    HTTP1 --> HTTP2
    HTTP2 --> HTTP3
```

| 特性 | HTTP/1.1 | HTTP/2 | HTTP/3 |
|------|----------|--------|--------|
| プロトコル | テキスト | バイナリ | バイナリ |
| トランスポート | TCP | TCP | QUIC（UDP） |
| 多重化 | × | ○ | ○ |
| ヘッダー圧縮 | × | HPACK | QPACK |
| サーバープッシュ | × | ○ | ○ |
| 接続確立 | 1-RTT + TLS 2-RTT | 1-RTT + TLS 2-RTT | 0-RTT または 1-RTT |

#### HTTP/2の多重化

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant Server as サーバー

    Note over Client,Server: HTTP/2 多重化

    Client->>Server: Stream 1: GET /index.html
    Client->>Server: Stream 3: GET /style.css
    Client->>Server: Stream 5: GET /script.js
    Server-->>Client: Stream 3: style.css（小さいので先に完了）
    Server-->>Client: Stream 1: index.html
    Server-->>Client: Stream 5: script.js
```

#### HTTP/2の有効化（Nginx）

```nginx
server {
    listen 443 ssl http2;
    server_name example.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    # その他の設定...
}
```

#### HTTP/3の有効化（Nginx）

```nginx
server {
    listen 443 ssl http2;
    listen 443 quic reuseport;  # HTTP/3

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    # HTTP/3のAlt-Svcヘッダー
    add_header Alt-Svc 'h3=":443"; ma=86400';
}
```

#### HTTP/2の確認

```bash
# curlでHTTP/2を使用
curl --http2 -I https://example.com

# HTTP/2が使用されているか確認
# レスポンスに "HTTP/2" が含まれていればOK
```

#### 学習目標

- [ ] HTTP/1.1、HTTP/2、HTTP/3の違いを説明できる
- [ ] HTTP/2の多重化の利点を理解している
- [ ] HTTP/3（QUIC）の特徴を理解している

---

### 4.2 WebSocket

#### WebSocketとは

HTTPとは異なる、双方向通信プロトコル。一度接続を確立すると、サーバーからもクライアントへプッシュできる。

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant Server as サーバー

    Client->>Server: HTTP Upgrade リクエスト
    Server-->>Client: 101 Switching Protocols

    Note over Client,Server: WebSocket接続確立

    Client->>Server: メッセージ
    Server-->>Client: メッセージ
    Server-->>Client: サーバーからプッシュ
    Client->>Server: メッセージ
```

#### WebSocketハンドシェイク

```http
# リクエスト
GET /chat HTTP/1.1
Host: example.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13

# レスポンス
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
```

#### クライアント側の実装

```typescript
class WebSocketClient {
  private ws: WebSocket | null = null;
  private reconnectAttempts = 0;
  private maxReconnectAttempts = 5;

  connect(url: string) {
    this.ws = new WebSocket(url);

    this.ws.onopen = () => {
      console.log('WebSocket connected');
      this.reconnectAttempts = 0;
    };

    this.ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      console.log('Received:', data);
    };

    this.ws.onclose = (event) => {
      console.log('WebSocket closed:', event.code, event.reason);
      this.attemptReconnect(url);
    };

    this.ws.onerror = (error) => {
      console.error('WebSocket error:', error);
    };
  }

  send(data: any) {
    if (this.ws?.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(data));
    }
  }

  private attemptReconnect(url: string) {
    if (this.reconnectAttempts < this.maxReconnectAttempts) {
      this.reconnectAttempts++;
      const delay = Math.min(1000 * Math.pow(2, this.reconnectAttempts), 30000);
      console.log(`Reconnecting in ${delay}ms...`);
      setTimeout(() => this.connect(url), delay);
    }
  }

  close() {
    this.ws?.close();
  }
}

// 使用例
const client = new WebSocketClient();
client.connect('wss://example.com/ws');
client.send({ type: 'chat', message: 'Hello!' });
```

#### サーバー側の実装（Node.js + ws）

```typescript
import { WebSocketServer, WebSocket } from 'ws';

const wss = new WebSocketServer({ port: 8080 });

const clients = new Set<WebSocket>();

wss.on('connection', (ws) => {
  clients.add(ws);
  console.log('Client connected');

  ws.on('message', (data) => {
    const message = JSON.parse(data.toString());
    console.log('Received:', message);

    // 全クライアントにブロードキャスト
    clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify(message));
      }
    });
  });

  ws.on('close', () => {
    clients.delete(ws);
    console.log('Client disconnected');
  });

  // 接続時にウェルカムメッセージ
  ws.send(JSON.stringify({ type: 'welcome', message: 'Connected!' }));
});
```

#### 学習目標

- [ ] WebSocketの用途を説明できる
- [ ] HTTPとWebSocketの違いを理解している
- [ ] クライアント/サーバー側のWebSocket実装ができる

---

### 4.3 Server-Sent Events（SSE）

#### SSEとは

サーバーからクライアントへの一方向プッシュ通信。WebSocketより軽量。

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant Server as サーバー

    Client->>Server: GET /events
    Note over Server: text/event-stream

    Server-->>Client: event: message\ndata: Hello
    Server-->>Client: event: update\ndata: {"count": 1}
    Server-->>Client: event: update\ndata: {"count": 2}
```

#### WebSocket vs SSE

| 特性 | WebSocket | SSE |
|------|-----------|-----|
| 通信方向 | 双方向 | サーバー→クライアント |
| プロトコル | 独自 | HTTP |
| 再接続 | 手動実装 | 自動 |
| バイナリ | 対応 | テキストのみ |
| 用途 | チャット、ゲーム | 通知、フィード |

#### クライアント側の実装

```typescript
const eventSource = new EventSource('/api/events');

eventSource.onopen = () => {
  console.log('SSE connected');
};

eventSource.onmessage = (event) => {
  console.log('Message:', event.data);
};

// カスタムイベント
eventSource.addEventListener('notification', (event) => {
  const data = JSON.parse(event.data);
  console.log('Notification:', data);
});

eventSource.onerror = (error) => {
  console.error('SSE error:', error);
};

// 接続を閉じる
// eventSource.close();
```

#### サーバー側の実装（Express.js）

```typescript
app.get('/api/events', (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');

  // 定期的にイベントを送信
  const intervalId = setInterval(() => {
    const data = { timestamp: new Date().toISOString(), count: Math.random() };
    res.write(`event: update\n`);
    res.write(`data: ${JSON.stringify(data)}\n\n`);
  }, 1000);

  // クライアント切断時にクリーンアップ
  req.on('close', () => {
    clearInterval(intervalId);
    res.end();
  });
});
```

#### 学習目標

- [ ] SSEの用途を説明できる
- [ ] WebSocketとSSEの使い分けを判断できる
- [ ] SSEを実装できる

---

### 4.4 APIデザインパターン

#### REST vs GraphQL vs gRPC

```mermaid
flowchart LR
    subgraph REST
        R1[GET /users]
        R2[GET /users/123]
        R3[POST /users]
    end

    subgraph GraphQL
        G1["query { users { id name } }"]
        G2["mutation { createUser }"]
    end

    subgraph gRPC
        P1[GetUser RPC]
        P2[CreateUser RPC]
        P3[Protobuf]
    end
```

| 特性 | REST | GraphQL | gRPC |
|------|------|---------|------|
| データ形式 | JSON | JSON | Protocol Buffers |
| クエリ柔軟性 | 低 | 高 | 低 |
| タイピング | 手動/OpenAPI | スキーマ | 強い型付け |
| オーバーフェッチ | あり | なし | なし |
| キャッシュ | HTTP標準 | 複雑 | 独自実装 |
| 学習コスト | 低 | 中 | 高 |

#### RESTful API設計の原則

```
# リソースベースのURL設計
GET    /users              # ユーザー一覧
GET    /users/123          # ユーザー詳細
POST   /users              # ユーザー作成
PUT    /users/123          # ユーザー更新（全体）
PATCH  /users/123          # ユーザー更新（部分）
DELETE /users/123          # ユーザー削除

# ネストしたリソース
GET    /users/123/posts    # ユーザー123の投稿一覧
POST   /users/123/posts    # ユーザー123の投稿作成

# クエリパラメータでフィルタリング
GET    /users?role=admin&status=active
GET    /users?sort=createdAt&order=desc
GET    /users?page=1&limit=20
```

#### エラーレスポンス（RFC 7807 Problem Details）

```typescript
// RFC 7807準拠のエラーレスポンス
interface ProblemDetails {
  type: string;        // エラータイプを識別するURI
  title: string;       // 人間が読めるエラータイトル
  status: number;      // HTTPステータスコード
  detail?: string;     // 詳細な説明
  instance?: string;   // 問題が発生したリソースのURI
  [key: string]: any;  // 拡張フィールド
}

// 例
{
  "type": "https://api.example.com/errors/validation",
  "title": "Validation Error",
  "status": 422,
  "detail": "入力値に問題があります",
  "instance": "/api/users",
  "errors": {
    "email": ["メールアドレスの形式が不正です"],
    "name": ["名前は必須です"]
  }
}
```

#### 学習目標

- [ ] REST、GraphQL、gRPCの違いを説明できる
- [ ] RESTful APIの設計原則を理解している
- [ ] RFC 7807に準拠したエラーレスポンスを設計できる

---

### 4.5 トラブルシューティング

#### curlでのデバッグ

```bash
# 詳細な通信内容を表示
curl -v https://api.example.com/users

# ヘッダーのみ表示
curl -I https://api.example.com/users

# リクエストヘッダーを指定
curl -H "Authorization: Bearer token" \
     -H "Content-Type: application/json" \
     https://api.example.com/users

# POSTリクエスト
curl -X POST https://api.example.com/users \
     -H "Content-Type: application/json" \
     -d '{"name": "田中"}'

# レスポンスタイムを計測
curl -w "@curl-format.txt" -o /dev/null -s https://api.example.com/users

# curl-format.txt の内容
#     time_namelookup:  %{time_namelookup}s\n
#        time_connect:  %{time_connect}s\n
#     time_appconnect:  %{time_appconnect}s\n
#    time_pretransfer:  %{time_pretransfer}s\n
#       time_redirect:  %{time_redirect}s\n
#  time_starttransfer:  %{time_starttransfer}s\n
#                     ----------\n
#          time_total:  %{time_total}s\n

# TLS情報を表示
curl -v --tlsv1.3 https://api.example.com 2>&1 | grep -i ssl
```

#### ブラウザ開発者ツール

| タブ | 確認内容 |
|------|---------|
| Network | リクエスト/レスポンス、タイミング、ヘッダー |
| Console | JavaScriptエラー、CORSエラー |
| Application | Cookie、LocalStorage、ServiceWorker |
| Security | 証明書情報、混在コンテンツ |

#### よくある問題と解決策

| 問題 | 原因 | 解決策 |
|------|------|--------|
| CORSエラー | オリジンが許可されていない | サーバー側でAccess-Control-Allow-Originを設定 |
| 401 Unauthorized | 認証トークンが無効/期限切れ | トークンを再取得 |
| 403 Forbidden | 権限がない | ユーザー権限を確認 |
| 混在コンテンツ | HTTPSページからHTTPリソースを読み込み | すべてHTTPSに統一 |
| 証明書エラー | 証明書の期限切れ/不一致 | 証明書を更新 |

#### Wiresharkでのパケット解析

```bash
# HTTPトラフィックのフィルタ
http

# 特定ホストへのリクエスト
http.host == "api.example.com"

# POSTリクエストのみ
http.request.method == "POST"

# ステータスコードでフィルタ
http.response.code >= 400
```

#### 学習目標

- [ ] curlで詳細なデバッグができる
- [ ] ブラウザ開発者ツールで通信を分析できる
- [ ] 一般的なHTTPエラーの原因を特定できる

---

## ベストプラクティス

### HTTPメソッドの正しい使い分け

```typescript
// ✅ 正しい使用
GET /api/users          // 取得（副作用なし）
POST /api/users         // 作成（新規リソース）
PUT /api/users/123      // 完全更新
PATCH /api/users/123    // 部分更新
DELETE /api/users/123   // 削除

// ❌ 間違った使用
GET /api/users/delete/123   // GETで削除
POST /api/users/123/update  // URLにアクションを含める
```

### 適切なステータスコードの選択

```typescript
// ✅ 適切なステータスコード
201 Created         // リソース作成成功
204 No Content      // 削除成功（レスポンスボディなし）
400 Bad Request     // リクエスト形式エラー
422 Unprocessable   // バリデーションエラー

// ❌ 不適切な使用
200 OK + { "error": "..." }  // エラーなのに200
500 Internal Server Error    // バリデーションエラーに500
```

### セキュリティヘッダーの設定

```typescript
// 必須のセキュリティヘッダー
const securityHeaders = {
  'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
  'X-Content-Type-Options': 'nosniff',
  'X-Frame-Options': 'DENY',
  'Content-Security-Policy': "default-src 'self'",
  'Referrer-Policy': 'strict-origin-when-cross-origin',
};
```

### CORS設定

```typescript
// ✅ 本番環境
cors({
  origin: ['https://app.example.com'],
  credentials: true,
})

// ❌ 本番環境で避けるべき
cors({ origin: '*' })  // すべてのオリジンを許可
```

### キャッシュ戦略

```typescript
// 静的アセット（ハッシュ付きファイル名）
'Cache-Control': 'public, max-age=31536000, immutable'

// APIレスポンス（ユーザー固有）
'Cache-Control': 'private, max-age=60'

// 機密データ
'Cache-Control': 'no-store'
```

### タイムアウト・リトライ設定

```typescript
async function fetchWithRetry(
  url: string,
  options: RequestInit = {},
  retries = 3,
  timeout = 5000
): Promise<Response> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeout);

  try {
    const response = await fetch(url, {
      ...options,
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    // 5xxエラーの場合はリトライ
    if (response.status >= 500 && retries > 0) {
      await delay(1000 * (4 - retries)); // 指数バックオフ
      return fetchWithRetry(url, options, retries - 1, timeout);
    }

    return response;
  } catch (error) {
    clearTimeout(timeoutId);

    if (error instanceof Error && error.name === 'AbortError') {
      if (retries > 0) {
        await delay(1000 * (4 - retries));
        return fetchWithRetry(url, options, retries - 1, timeout);
      }
      throw new Error('Request timeout');
    }

    throw error;
  }
}

function delay(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}
```

### エラーハンドリング

```typescript
class ApiError extends Error {
  constructor(
    public status: number,
    public statusText: string,
    public body?: any
  ) {
    super(`${status} ${statusText}`);
    this.name = 'ApiError';
  }
}

async function apiRequest<T>(url: string, options?: RequestInit): Promise<T> {
  const response = await fetch(url, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options?.headers,
    },
  });

  if (!response.ok) {
    const body = await response.json().catch(() => null);
    throw new ApiError(response.status, response.statusText, body);
  }

  return response.json();
}

// 使用例
try {
  const user = await apiRequest<User>('/api/users/123');
} catch (error) {
  if (error instanceof ApiError) {
    switch (error.status) {
      case 401:
        // 認証エラー処理
        break;
      case 404:
        // リソース未発見処理
        break;
      default:
        // その他のエラー処理
    }
  }
}
```

---

## 学習リソース

### 公式ドキュメント・仕様

- [MDN Web Docs - HTTP](https://developer.mozilla.org/ja/docs/Web/HTTP) - 包括的なHTTPリファレンス
- [RFC 7230-7235](https://www.rfc-editor.org/rfc/rfc7230) - HTTP/1.1仕様
- [RFC 7540](https://www.rfc-editor.org/rfc/rfc7540) - HTTP/2仕様
- [RFC 9000](https://www.rfc-editor.org/rfc/rfc9000) - QUIC仕様

### 書籍

- 『Real World HTTP 第2版』- 渋川よしき
- 『Webを支える技術』- 山本陽平
- 『HTTP/2 in Action』- Barry Pollard（英語）

### オンラインツール

- [Postman](https://www.postman.com/) - API開発・テストツール
- [HTTPie](https://httpie.io/) - モダンなHTTPクライアント
- [curl](https://curl.se/) - コマンドラインHTTPクライアント
- [Wireshark](https://www.wireshark.org/) - パケット解析ツール

### 実践的学習

- ブラウザの開発者ツールでHTTP通信を観察
- curlで様々なAPIを叩いてみる
- 簡単なREST APIサーバーを実装
- HTTPSを設定（Let's Encrypt）

---

## 学習のコツ

### 1. 開発者ツールを常に開く

ブラウザの開発者ツールのNetworkタブを常に確認する習慣をつける。実際の通信を見ることで理解が深まる。

### 2. curlを使いこなす

GUIツールも便利だが、curlを使えるようになると、スクリプト化や自動化、ドキュメントへの記載が容易になる。

### 3. 実際に実装する

読むだけでなく、実際にAPIサーバーとクライアントを実装してみる。認証、キャッシュ、CORSなど、実装して初めて理解できることが多い。

### 4. エラーを恐れない

CORSエラー、認証エラーなど、エラーに遭遇したら詳しく調べる。エラーの原因を理解することが最も効果的な学習。

### 5. セキュリティを意識する

HTTPを学ぶ際は、常にセキュリティの観点を持つ。「なぜHTTPSが必要か」「なぜCORSがあるか」を理解する。

---

## チェックリスト活用法

各セクションの「学習目標」チェックボックスを活用して進捗を管理。すべてにチェックが入ったら次のPhaseへ進む目安とする。

---

*このロードマップは継続的にアップデートしていくことを推奨します。HTTP/3の普及やWebTransportなど、Web技術は進化し続けています。最新情報を常にキャッチアップしてください。*
