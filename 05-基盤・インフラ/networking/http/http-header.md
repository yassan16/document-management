# HTTP Header

## 概要

HTTP Header（HTTPヘッダー）は、**HTTPリクエスト・レスポンスに付ける追加情報（メタ情報）** です。  
本文（Body）の中身そのものではなく、「このBodyはJSONです」「認証トークンはこれです」「キャッシュしてよいです」「CORSを許可します」といった **通信のコンテキスト** を伝えます。

ヘッダーは `Header-Name: value` の形式で記述し、ヘッダー名は大文字・小文字を区別しません。

---

## 目次

| # | セクション | 概要 |
|---|-----------|------|
| 1 | [HTTP Headerとは](#1-http-headerとは) | リクエスト全体の構造と役割 |
| 2 | [Request HeaderとResponse Header](#2-request-headerとresponse-header) | 方向ごとのヘッダーの違い |
| 3 | [API開発で重要なHeader一覧](#3-api開発で重要なheader一覧) | NestJS開発でよく使うHeader |
| 4 | [Content-Type](#4-content-type) | 送信データの形式を表す |
| 5 | [Accept](#5-accept) | 受け取りたいレスポンス形式を指定 |
| 6 | [Authorization](#6-authorization) | 認証情報を送るHeader |
| 7 | [Cookie と Set-Cookie](#7-cookie-と-set-cookie) | Cookie送受信のHeader |
| 8 | [CORS関連Header](#8-cors関連header) | オリジン間リクエストの許可 |
| 9 | [Cache-Control](#9-cache-control) | キャッシュ制御の指示 |
| 10 | [ETag と If-None-Match](#10-etag-と-if-none-match) | キャッシュ再検証のHeader |
| 11 | [Location](#11-location) | 作成リソースやリダイレクト先を示す |
| 12 | [セキュリティ系Header](#12-セキュリティ系header) | ブラウザの保護機能を強化する |
| 13 | [NestJSでHeaderを読む方法](#13-nestjsでheaderを読む方法) | `@Headers()` の使い方 |
| 14 | [NestJSでHeaderを返す方法](#14-nestjsでheaderを返す方法) | `@Header()` vs `@Res` の使い分け |
| 15 | [実務での使い分けまとめ](#15-実務での使い分けまとめ) | 目的別Headerの早見表 |
| - | [まず覚えるべき結論](#まず覚えるべき結論) | 最優先で押さえるポイント |

---

## 1. HTTP Headerとは

HTTP通信は、**リクエスト（クライアント → サーバー）** と **レスポンス（サーバー → クライアント）** で構成されます。  
それぞれに「Header（ヘッダー）」と「Body（本文）」があります。

### HTTPリクエストの例

フロントエンドからNestJS APIへユーザー作成リクエストを送る場合、HTTPリクエスト全体はこのようになります。

```http
POST /users HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer xxxxx
Accept: application/json

{
  "name": "Taro",
  "email": "taro@example.com"
}
```

上記のうち、**Header** にあたる部分はこちらです。

```http
Host: api.example.com
Content-Type: application/json
Authorization: Bearer xxxxx
Accept: application/json
```

**Body** にあたる部分はこちらです。

```json
{
  "name": "Taro",
  "email": "taro@example.com"
}
```

### HTTPリクエストの構成要素

API開発では、次の5つに分けて考えると理解しやすいです。

| 構成要素 | 役割 | 例 |
|---------|------|----|
| **URL** | どのリソースにアクセスするか | `/users`, `/users/123` |
| **Method** | 何をしたいか | `GET`, `POST`, `PATCH`, `DELETE` |
| **Header** | 通信に関する追加情報（メタ情報） | `Content-Type: application/json` |
| **Body** | 実際に送るデータ | `{ "name": "Taro" }` |
| **Status Code** | 結果が成功か失敗か | `200 OK`, `201 Created`, `401 Unauthorized` |

> **なぜHeaderが必要か？**  
> BodyはAPIが扱うデータを運ぶ「荷物」ですが、その荷物を正しく処理するには「どんな形式か」「誰が送ってきたか」「どう扱ってよいか」といった情報も必要です。  
> Headerはその「配送ラベル」の役割を果たします。

---

## 2. Request HeaderとResponse Header

HTTP Headerには大きく分けて **Request Header** と **Response Header** があります。

```mermaid
sequenceDiagram
    participant Client as クライアント(ブラウザ/アプリ)
    participant Server as サーバー(NestJS API)

    Client->>Server: リクエスト + Request Header
    Note over Client,Server: Authorization: Bearer xxxxx<br/>Content-Type: application/json<br/>Accept: application/json
    Server-->>Client: レスポンス + Response Header
    Note over Client,Server: Content-Type: application/json<br/>Cache-Control: no-store<br/>Set-Cookie: access_token=xxxxx
```

### Request Header

クライアントからサーバーへ送られる情報です。「誰が・何を・どんな形式で送るか」を伝えます。

```http
Authorization: Bearer xxxxx
Content-Type: application/json
Accept: application/json
Origin: http://localhost:5173
```

### Response Header

サーバーからクライアントへ返される情報です。「何を返すか・どう扱ってよいか」を伝えます。

```http
Content-Type: application/json
Cache-Control: no-store
Set-Cookie: access_token=xxxxx; HttpOnly; Secure
Access-Control-Allow-Origin: http://localhost:5173
```

---

## 3. API開発で重要なHeader一覧

NestJSでAPIを作るなら、次のHeaderを優先して覚えましょう。

| Header | 種別 | 主な用途 |
|--------|------|---------|
| `Content-Type` | 両方 | 送信するBodyの形式を表す |
| `Accept` | Request | クライアントが受け取りたい形式を表す |
| `Authorization` | Request | 認証情報（JWTトークンなど）を送る |
| `Cookie` | Request | ブラウザが保存済みCookieを送る |
| `Set-Cookie` | Response | サーバーがブラウザにCookieを保存させる |
| `Origin` | Request | リクエスト元のオリジンを表す |
| `Access-Control-Allow-Origin` | Response | CORSで許可するオリジンを示す |
| `Cache-Control` | 両方 | キャッシュの制御指示 |
| `Location` | Response | 作成されたリソースやリダイレクト先のURL |
| `ETag` | Response | リソースのバージョン識別子 |
| `If-None-Match` | Request | キャッシュ再検証用のETag送信 |
| `User-Agent` | Request | ブラウザ・アプリなどのクライアント情報 |
| `X-Request-Id` | Request | リクエスト追跡用ID（独自ヘッダー） |

---

## 4. Content-Type

`Content-Type` は、**送っているデータの形式（メディアタイプ）** を表します。  
サーバー・クライアントともに「相手が送ってきたBodyをどう解釈すればよいか」を判断するために使います。

> **なぜ必要か？**  
> HTTPのBodyはただのバイト列です。それがJSONなのか、HTMLなのか、画像なのかを識別するために `Content-Type` が必要です。  
> 指定がないと、サーバーはBodyを正しくパースできません。

### APIでよく使う値

| 値 | 意味 |
|----|------|
| `application/json` | JSONデータ |
| `application/x-www-form-urlencoded` | HTMLフォームのデフォルト形式 |
| `multipart/form-data` | ファイルアップロード |
| `text/plain` | プレーンテキスト |
| `text/html` | HTMLコンテンツ |

### リクエスト側とレスポンス側での使い方

**リクエスト（クライアント → サーバー）：**

```http
Content-Type: application/json
```

「クライアントがJSONを送ります」という意味です。

**レスポンス（サーバー → クライアント）：**

```http
Content-Type: application/json; charset=utf-8
```

「サーバーがJSONを返します（文字コードはUTF-8）」という意味です。

### NestJSでの動作

NestJSのControllerでオブジェクトを返すと、自動的に `Content-Type: application/json` がレスポンスに付きます。

```ts
// @Post() でBodyを受け取る例
@Post()
create(@Body() body: CreateUserDto) {
  // Content-Type: application/json のリクエストなら、
  // NestJSが自動でBodyをオブジェクトにパースしてくれる
  return body;
}
```

クライアントは次のように送ります。

```http
POST /users
Content-Type: application/json

{
  "name": "Taro"
}
```

---

## 5. Accept

`Accept` は、**クライアントが受け取りたいレスポンスの形式** をサーバーに伝えるHeaderです。

```http
Accept: application/json
```

「JSONで返してください」という意味です。

> **なぜ必要か？**  
> 同じエンドポイントでも、クライアントの種類（ブラウザ・モバイルアプリ・外部システム）によって、HTMLが欲しい場合とJSONが欲しい場合があります。  
> `Accept` はその希望をサーバーに伝えるための仕組みです（コンテントネゴシエーション）。

### NestJSでの扱い

一般的なNestJS JSON APIでは、最初はそこまで意識しなくても大丈夫です。  
ControllerがJavaScriptオブジェクトや配列を返すと、NestJSが自動的にJSONへシリアライズして返します。

```ts
@Get(':id')
findOne(@Param('id') id: string) {
  // NestJSが自動でJSONにシリアライズして返す
  return {
    id,
    name: 'Taro',
  };
}
```

---

## 6. Authorization

`Authorization` は、**認証情報をサーバーへ送るためのRequest Header** です。  
保護されたAPIエンドポイントへアクセスするときに必要です。

> **なぜ必要か？**  
> APIの多くのエンドポイントは「ログイン済みのユーザーのみ」が利用できます。  
> サーバーは誰がリクエストしているかを確認するために、`Authorization` ヘッダーのトークンを検証します。

### JWT Bearer 形式

JWT認証では、次の形式で使います。

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

| 部分 | 意味 |
|------|------|
| `Authorization` | 認証情報を送るヘッダー名 |
| `Bearer` | トークンベースの認証方式（RFC 6750） |
| `eyJ...` | JWTなどのアクセストークン本体 |

### NestJSでの実装

**直接Controllerで読む場合（学習・デバッグ用）：**

```ts
import { Controller, Get, Headers } from '@nestjs/common';

@Controller('me')
export class MeController {
  @Get()
  findMe(@Headers('authorization') authorization: string) {
    return { authorization };
  }
}
```

**実務での推奨：Guard + Passport JWT Strategy**

実務では、ControllerでAuthorizationを直接解析するよりも、**Guard** や **Passport JWT Strategy** で認証処理を共通化するのが一般的です。

```ts
// auth.guard.ts（JwtAuthGuardでトークン検証）
@UseGuards(JwtAuthGuard)
@Get('profile')
getProfile(@Request() req) {
  return req.user;
}
```

---

## 7. Cookie と Set-Cookie

CookieはブラウザがサーバーとのセッションやユーザーIDなどを保持する仕組みです。  
HTTP Headerでは2種類のCookie関連ヘッダーがあります。

| Header | 種別 | 役割 |
|--------|------|------|
| `Cookie` | Request Header | ブラウザが保存済みCookieをサーバーに送る |
| `Set-Cookie` | Response Header | サーバーがブラウザにCookieを保存させる |

> **なぜCookieが使われるか？**  
> HTTPはステートレスなプロトコルのため、リクエストをまたいで状態を保持できません。  
> CookieはそのHTTPの制約を補い、「ログイン状態の維持」などを実現するために使われます。

### Cookieのやり取りの流れ

```mermaid
sequenceDiagram
    participant Browser as ブラウザ
    participant Server as NestJS API

    Browser->>Server: POST /login（ログインリクエスト）
    Server-->>Browser: 200 OK
    Note over Browser,Server: Set-Cookie: access_token=xxxxx<br/>HttpOnly, Secure, SameSite=Lax
    Note over Browser: CookieをブラウザのCookieストアに保存

    Browser->>Server: GET /profile<br/>Cookie: access_token=xxxxx
    Note over Browser,Server: 以降のリクエストにCookieを自動付与
    Server-->>Browser: 200 OK - name: Taro
```

### Set-Cookieの属性

```http
Set-Cookie: access_token=xxxxx; HttpOnly; Secure; SameSite=Lax
```

| 属性 | 意味 |
|------|------|
| `HttpOnly` | JavaScriptからアクセス不可（XSS対策） |
| `Secure` | HTTPS接続時のみ送信 |
| `SameSite=Lax` | クロスサイトリクエストには自動送信しない（CSRF対策） |

### NestJSでの実装

**Cookieを読む（`cookie-parser` 導入後）：**

```ts
// main.ts
import * as cookieParser from 'cookie-parser';

app.use(cookieParser());
```

```ts
@Get()
findAll(@Req() request: Request) {
  console.log(request.cookies); // { access_token: 'xxxxx' }
}
```

**Cookieをレスポンスに設定する：**

```ts
@Get('login')
login(@Res({ passthrough: true }) response: Response) {
  response.cookie('access_token', 'xxxxx', {
    httpOnly: true,
    secure: true,
    sameSite: 'lax',
  });

  return { message: 'ログインしました' };
}
```

---

## 8. CORS関連Header

CORS（Cross-Origin Resource Sharing）は、**ブラウザが異なるオリジンのAPIへアクセスするときの制御の仕組み** です。

> **なぜCORSが必要か？**  
> ブラウザには「同一オリジンポリシー」があり、デフォルトでは別オリジンへのリクエストをブロックします。  
> サーバーがCORSヘッダーを返すことで「このオリジンからのアクセスを許可する」とブラウザに伝えます。

### オリジンの違いの例

| 項目 | 値 |
|------|-----|
| フロントエンド | `http://localhost:5173` |
| NestJS API | `http://localhost:3000` |
| 判定 | **別オリジン**（ポート番号が異なる） |

### CORSのフロー

```mermaid
sequenceDiagram
    participant Browser as ブラウザ(localhost:5173)
    participant API as NestJS API(localhost:3000)

    Browser->>API: OPTIONS /users<br/>Origin: http://localhost:5173
    Note over Browser,API: プリフライトリクエスト
    API-->>Browser: 200 OK
    Note over Browser,API: Access-Control-Allow-Origin: http://localhost:5173<br/>Access-Control-Allow-Methods: GET, POST<br/>Access-Control-Allow-Headers: Content-Type, Authorization

    Browser->>API: POST /users<br/>Origin: http://localhost:5173
    Note over Browser,API: 本リクエスト
    API-->>Browser: 201 Created
```

### NestJSでの設定

```ts
// main.ts
const app = await NestFactory.create(AppModule);

app.enableCors({
  origin: ['http://localhost:5173'],
  methods: ['GET', 'POST', 'PATCH', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true, // Cookie送信を許可する場合
});

await app.listen(3000);
```

この設定で、レスポンスに次のHeaderが付きます。

```http
Access-Control-Allow-Origin: http://localhost:5173
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Allow-Credentials: true
```

---

## 9. Cache-Control

`Cache-Control` は、**ブラウザ・CDN・プロキシに対してキャッシュをどう扱うか** を伝えるHeaderです。

> **なぜ必要か？**  
> 適切なキャッシュ設定はパフォーマンス向上に直結します。一方、個人情報を含むレスポンスをキャッシュしてしまうとセキュリティリスクになります。  
> `Cache-Control` を正しく設定することで、「何をキャッシュしてよいか」「いつ無効化するか」をコントロールできます。

### よく使うディレクティブ

| ディレクティブ | 意味 | ユースケース |
|---------------|------|-------------|
| `no-store` | 保存しない | ログインユーザーの個人情報 |
| `no-cache` | 毎回再検証する | 最新性が重要なデータ |
| `public, max-age=60` | 共有キャッシュ可能・60秒有効 | マスタデータ・公開記事一覧 |
| `private, max-age=300` | ブラウザのみキャッシュ・300秒有効 | ユーザー固有データ |
| `immutable` | 変更されない（再検証しない） | ハッシュ付き静的ファイル |

### NestJSでの実装

**固定値を設定（`@Header()` デコレーター）：**

```ts
import { Controller, Get, Header } from '@nestjs/common';

@Controller('me')
export class MeController {
  @Get()
  @Header('Cache-Control', 'no-store')
  findMe() {
    return { id: 'user_1', name: 'Taro' };
  }
}
```

**動的に設定（`@Res({ passthrough: true })`）：**

```ts
@Get('articles')
findAll(
  @Query('category') category: string,
  @Res({ passthrough: true }) response: Response,
) {
  const maxAge = category === 'news' ? 60 : 3600;
  response.setHeader('Cache-Control', `public, max-age=${maxAge}`);
  return this.articlesService.findAll(category);
}
```

---

## 10. ETag と If-None-Match

`ETag` と `If-None-Match` は、**キャッシュの再検証** に使われるHeaderです。  
「データが変わっていなければBodyを省略して転送量を節約する」仕組みです。

> **なぜ必要か？**  
> `Cache-Control: max-age=60` のように期限を設けるキャッシュは、期限切れ後にデータが変わっていなくても必ず再取得します。  
> ETagを使うと「データが変わっていない場合は `304 Not Modified` を返すだけ」にでき、無駄な転送を避けられます。

### ETagのやり取りの流れ

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant Server as サーバー

    Client->>Server: GET /users
    Server-->>Client: 200 OK
    Note over Server,Client: ETag: user-list-v1<br/>Body: ユーザーデータ
    Note over Client: ETagをキャッシュに保存

    Client->>Server: GET /users<br/>If-None-Match: user-list-v1
    alt データが変わっていない場合
        Server-->>Client: 304 Not Modified（Bodyなし）
        Note over Client: キャッシュを引き続き使用
    else データが変わった場合
        Server-->>Client: 200 OK
        Note over Server,Client: ETag: user-list-v2<br/>Body: 新しいユーザーデータ
    end
```

### 適用場面

| 適用場面 | 理由 |
|---------|------|
| ユーザー一覧・商品一覧 | データが変わっていない場合の通信量を削減 |
| 静的リソース（画像・JS） | 変更がないファイルの再取得を防ぐ |
| APIレスポンスの最適化 | モバイルアプリなど通信量が気になる環境 |

> **最初のNestJS API学習では必須ではありませんが**、パフォーマンス改善やHTTPキャッシュを深く扱うときに重要になります。

---

## 11. Location

`Location` は、**作成されたリソースのURLやリダイレクト先** を示すResponse Headerです。

> **なぜ必要か？**  
> RESTful APIでは、POSTでリソースを作成した後、そのリソースのURLを返すのが慣例です（201 Created + Location）。  
> クライアントは `Location` を見て、作成したリソースに直接アクセスできます。

### よくある使い方

```http
HTTP/1.1 201 Created
Location: /users/123
```

「新しく作成されたユーザーは `/users/123` で参照できます」という意味です。

### NestJSでの実装

```ts
@Post()
create(
  @Body() body: CreateUserDto,
  @Res({ passthrough: true }) response: Response,
) {
  const user = {
    id: '123',
    ...body,
  };

  response.status(HttpStatus.CREATED);
  response.setHeader('Location', `/users/${user.id}`);

  return user;
}
```

> **`passthrough: true` のポイント**  
> `@Res()` のみだとNestJSのレスポンス処理を完全に乗っ取ることになり、`return` の値が無視されます。  
> `passthrough: true` を付けると、ヘッダーだけ操作しつつ `return` の値をNestJSが正常にシリアライズして返してくれます。

---

## 12. セキュリティ系Header

APIやWebアプリでは、攻撃を防ぐためのセキュリティ系Response Headerも重要です。

| Header | 役割 | 防ぐ脅威 |
|--------|------|---------|
| `Strict-Transport-Security` | HTTPS接続を強制する | HTTP平文通信の盗聴 |
| `X-Content-Type-Options: nosniff` | MIMEタイプの推測を抑制する | MIMEスニッフィング攻撃 |
| `Content-Security-Policy` | 読み込めるスクリプト・画像などを制限する | XSS攻撃 |
| `X-Frame-Options` | iframeへの埋め込みを制限する | クリックジャッキング攻撃 |
| `Referrer-Policy` | Referer情報の送信範囲を制御する | 機密URLの漏洩 |

### NestJSでの設定（`helmet` の利用）

実務では `helmet` を導入してセキュリティ系Headerをまとめて設定するのが一般的です。

```ts
// main.ts
import helmet from 'helmet';

const app = await NestFactory.create(AppModule);
app.use(helmet());
```

`helmet()` は次のHeaderを自動で設定します。

```http
Strict-Transport-Security: max-age=15552000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Referrer-Policy: no-referrer
Content-Security-Policy: default-src 'self'; ...
```

---

## 13. NestJSでHeaderを読む方法

NestJSでRequest Headerを読むには `@Headers()` デコレーターを使います。

```ts
import { Controller, Get, Headers } from '@nestjs/common';

@Controller('debug')
export class DebugController {
  // すべてのHeaderを取得
  @Get('headers')
  getHeaders(@Headers() headers: Record<string, string>) {
    return headers;
  }

  // 特定のHeaderのみ取得
  @Get('user-agent')
  getUserAgent(@Headers('user-agent') userAgent: string) {
    return { userAgent };
  }
}
```

### 注意点：ヘッダー名は小文字で扱われる

Node.js（Express）では、受信したHTTPヘッダーの名前が **すべて小文字に正規化** されます。

```ts
// NG: 'Authorization' で取得しようとしても undefined になる場合がある
@Headers('Authorization') auth: string

// OK: 小文字で取得する
@Headers('authorization') auth: string
```

| HTTPで送られてくる形 | Node.js内での扱い |
|---------------------|------------------|
| `Authorization: Bearer xxx` | `authorization: Bearer xxx` |
| `Content-Type: application/json` | `content-type: application/json` |
| `X-Request-Id: abc123` | `x-request-id: abc123` |

---

## 14. NestJSでHeaderを返す方法

NestJSでResponse Headerを設定するには、主に2つの方法があります。

| 方法 | 向いているケース |
|------|----------------|
| `@Header()` デコレーター | 固定値のHeaderを返すとき |
| `@Res({ passthrough: true })` | 動的にHeaderを設定するとき |

### `@Header()` デコレーター（固定値）

```ts
import { Controller, Get, Header } from '@nestjs/common';

@Controller('health')
export class HealthController {
  @Get()
  @Header('Cache-Control', 'no-store')
  @Header('X-Content-Type-Options', 'nosniff')
  check() {
    return { status: 'ok' };
  }
}
```

### `@Res({ passthrough: true })`（動的な値）

```ts
import { Controller, Get, Res } from '@nestjs/common';
import type { Response } from 'express';

@Controller('files')
export class FilesController {
  @Get('download')
  download(@Res({ passthrough: true }) response: Response) {
    // ファイル名を動的に設定
    const filename = `report_${Date.now()}.csv`;
    response.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    response.setHeader('Content-Type', 'text/csv');

    return 'id,name\n1,Taro';
  }
}
```

> **`@Res()` vs `@Res({ passthrough: true })` の違い**  
> `@Res()` のみ: NestJSのレスポンス処理が無効になり、`response.send()` / `response.json()` を手動で呼ぶ必要があります。  
> `@Res({ passthrough: true })`: HeaderやCookieだけ操作しつつ、`return` の値はNestJSが自動でシリアライズして返します。  
> **基本は `passthrough: true` を使う方が安全です。**

---

## 15. 実務での使い分けまとめ

API設計で「どんなHeaderを使うか」を目的別に整理した早見表です。

| 目的 | 使うHeader | 設定箇所 |
|------|-----------|---------|
| JSONを送る | `Content-Type: application/json` | クライアント側 |
| JSONで受け取りたい | `Accept: application/json` | クライアント側 |
| JWTで認証する | `Authorization: Bearer <token>` | クライアント側 |
| Cookie認証する | `Cookie` / `Set-Cookie` | ブラウザ自動 / サーバー側 |
| フロントエンドからAPIを呼ぶ | `Origin` / `Access-Control-Allow-Origin` | ブラウザ自動 / `enableCors()` |
| キャッシュさせたくない | `Cache-Control: no-store` | `@Header()` |
| キャッシュを活用する | `Cache-Control: public, max-age=60` | `@Header()` |
| 作成後のURLを伝える | `Location: /users/123` | `@Res({ passthrough: true })` |
| リクエストを追跡する | `X-Request-Id` | ミドルウェア / Interceptor |
| セキュリティを強化する | `Strict-Transport-Security` など | `helmet()` |

---

## まず覚えるべき結論

NestJSでAPIを作るなら、最初はこの理解で十分です。

```
HTTP Header = HTTP通信に付けるメタ情報（追加情報）
```

### 特に重要な5つのHeader

```http
Content-Type: application/json        # Bodyの形式を伝える
Accept: application/json              # レスポンスの希望形式を伝える
Authorization: Bearer <token>         # 認証トークンを送る
Cache-Control: no-store               # 個人情報をキャッシュさせない
Access-Control-Allow-Origin: http://localhost:5173  # CORSを許可する
```

### NestJSでのHeaderの操作パターン

| 操作 | 方法 | コード例 |
|------|------|---------|
| Request Headerを読む | `@Headers('名前')` | `@Headers('authorization') auth: string` |
| 固定のHeaderを返す | `@Header('名前', '値')` | `@Header('Cache-Control', 'no-store')` |
| 動的にHeaderを返す | `@Res({ passthrough: true })` | `response.setHeader('Location', url)` |

### 推奨する学習順

API開発の学習順としては、次の順番で理解すると実装に繋げやすいです。

```
Content-Type → Authorization → CORS関連Header → Cache-Control → Cookie関連Header
```

---

## 参考リソース

| リソース | URL |
|---------|-----|
| HTTP headers (MDN) | https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers |
| Authorization header (MDN) | https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Authorization |
| Content-Type header (MDN) | https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Type |
| Cache-Control header (MDN) | https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cache-Control |
| If-None-Match header (MDN) | https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/If-None-Match |
| Strict-Transport-Security (MDN) | https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Strict-Transport-Security |
| X-Content-Type-Options (MDN) | https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Content-Type-Options |
| Access-Control-Allow-Headers (MDN) | https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Access-Control-Allow-Headers |
| NestJS Controllers | https://docs.nestjs.com/controllers |
| NestJS Cookies | https://docs.nestjs.com/techniques/cookies |
| NestJS CORS | https://docs.nestjs.com/security/cors |
