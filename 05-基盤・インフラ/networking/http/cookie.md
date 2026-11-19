# Cookie 学習ロードマップ

## 目次

1. Cookieの基本概念
2. CookieとHTTP通信
3. Cookieの保存と管理
4. Cookieの属性
5. Cookieの送信条件
6. Cookieとセッション管理
7. CookieとWebセキュリティ
8. CookieとFE・BE連携
9. Cookieの実装・デバッグ
10. Cookieの発展知識
11. 学習の到達目標
12. 関連ドキュメント

---

## 1. Cookieの基本概念

**目的：Cookieとは何か、何のために存在するのかを理解する。**

- Cookieとは
- Cookieの役割と用途
- HTTPのステートレス性
- ステートフルとステートレス
- Cookieとセッションの違い
- CookieとWeb Storage（localStorage・sessionStorage）の違い

## 2. CookieとHTTP通信

**目的：ブラウザとサーバー間でCookieがやり取りされる仕組みを理解する。**

- ブラウザとWebサーバーの関係
- HTTPリクエストとレスポンス
- `Set-Cookie`レスポンスヘッダー
- `Cookie`リクエストヘッダー
- Cookieの発行・保存・送信の流れ
- ブラウザによるCookieの自動送信

## 3. Cookieの保存と管理

**目的：Cookieがどこに保存され、どのように管理されるかを理解する。**

- ブラウザのCookieストア
- Cookieの名前と値（Name・Value）
- セッションCookieと永続Cookie
- Cookieの有効期限と削除
- Cookieの容量・個数制限
- JavaScriptによるCookie操作（`document.cookie`）
- Cookie Store API

## 4. Cookieの属性

**目的：Cookieの保存期間・送信範囲・アクセス制限を理解する。**

- `Domain`
- `Path`
- `Expires`
- `Max-Age`
- `Secure`
- `HttpOnly`
- `SameSite`（Strict・Lax・None）
- Cookieプレフィックス（`__Host-`・`__Secure-`）
- `Partitioned`

## 5. Cookieの送信条件

**目的：どのリクエストでCookieが送信されるかを理解する。**

- URLの構造（Scheme・Host・Port・Path）
- Origin（オリジン）
- Site（サイト）
- Same-OriginとCross-Origin
- Same-SiteとCross-Site
- ファーストパーティCookie
- サードパーティCookie
- Domain・Pathによる送信範囲
- Secure・SameSiteによる送信制限
- Fetch APIとcredentials
- CORSとCookieの関係

## 6. Cookieとセッション管理

**目的：Cookieを使用したログイン認証の仕組みを理解する。**

- 認証（Authentication）と認可（Authorization）
- セッションとは
- セッションIDとは
- CookieによるセッションIDの管理
- サーバーサイドセッション
- Redisによるセッション保存
- セッションの有効期限とTTL
- ログイン・ログアウト処理
- セッションIDの再生成と無効化
- Cookie認証とJWT認証
- セッション管理とトークン管理の違い

## 7. CookieとWebセキュリティ

**目的：Cookieを安全に利用するための脅威と対策を理解する。**

- HTTPSとTLS
- XSS（クロスサイトスクリプティング）
- CSRF（クロスサイトリクエストフォージェリ）
- セッションハイジャック
- セッション固定攻撃
- Cookieの盗難・漏洩リスク
- HttpOnly・Secure・SameSiteによる保護
- CSRFトークン
- セッションIDの安全な生成・管理
- Cookieのセキュリティベストプラクティス

## 8. CookieとFE・BE連携

**目的：現代的なWebアプリケーションでのCookieの扱いを理解する。**

- ブラウザ・FEサーバー・BEサーバーの役割
- CSR（Client-Side Rendering）
- SSR（Server-Side Rendering）
- ブラウザからBEへのAPI通信
- FEサーバーからBEへのAPI通信
- Cookieの転送と伝播
- CORSとcredentialsの設定
- 同一ドメインとサブドメイン構成
- リバースプロキシとCookie
- BFF（Backend for Frontend）パターン
- Next.js・NestJSでのCookie管理

## 9. Cookieの実装・デバッグ

**目的：Cookieを実装し、ブラウザ上で動作を確認できるようになる。**

- Chrome DevToolsのApplicationタブ
- Chrome DevToolsのNetworkタブ
- Set-Cookie・Cookieヘッダーの確認
- ブラウザによるCookieのブロック理由
- Cookieの発行・更新・削除
- JavaScriptのfetchによる通信
- Postman・curlでのCookie確認
- Next.jsでのCookie操作
- NestJSでのCookie操作
- Redisを利用したセッション認証の実装

## 10. Cookieの発展知識

**目的：ブラウザのプライバシー保護とCookieの新しい仕様を把握する。**

- サードパーティCookieの制限
- ブラウザごとのCookieポリシー
- Cookie Partitioning
- CHIPS（Cookies Having Independent Partitioned State）
- Storage Access API
- トラッキング防止技術（ITP・ETP）
- Cookie同意管理（CMP）
- Cookie関連のプライバシー規制

## 11. 学習の到達目標


| STEP | 学習領域    | 到達目標                       |
| ---- | ------- | -------------------------- |
| 1    | 基本概念    | Cookieの役割を説明できる            |
| 2    | HTTP通信  | Cookieの発行・保存・送信を説明できる      |
| 3    | 保存と管理   | Cookieの保存先・寿命・削除を理解する      |
| 4    | 属性      | 各属性の役割を説明できる               |
| 5    | 送信条件    | Cookieが送信される条件を判断できる       |
| 6    | セッション管理 | ログイン認証の仕組みを説明できる           |
| 7    | セキュリティ  | 主な攻撃と対策を説明できる              |
| 8    | FE・BE連携 | WebシステムにおけるCookieの流れを説明できる |
| 9    | 実装・デバッグ | Cookieを実装し、問題を調査できる        |
| 10   | 発展知識    | Cookieの最新仕様・制限を把握できる       |


**推奨学習順序：** STEP 1〜5でCookieそのものを理解し、STEP 6〜8で認証・Webシステムとの関係を学習する。その後、STEP 9で実装し、STEP 10で発展知識を学ぶ。

## 12. 関連ドキュメント

### HTTP・Cookieの基本仕様

- [MDN — HTTP Cookieの使用](https://developer.mozilla.org/ja/docs/Web/HTTP/Guides/Cookies)
- [MDN — Set-Cookie](https://developer.mozilla.org/ja/docs/Web/HTTP/Reference/Headers/Set-Cookie)
- [MDN — HTTPの概要](https://developer.mozilla.org/ja/docs/Web/HTTP/Guides/Overview)
- [RFC 6265 — HTTP State Management Mechanism](https://www.rfc-editor.org/rfc/rfc6265)

### ブラウザ・通信

- [MDN — Same-origin policy](https://developer.mozilla.org/ja/docs/Web/Security/Same-origin_policy)
- [MDN — CORS](https://developer.mozilla.org/ja/docs/Web/HTTP/Guides/CORS)
- [MDN — Fetch API](https://developer.mozilla.org/ja/docs/Web/API/Fetch_API)

### 認証・セキュリティ

- [OWASP — Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
- [OWASP — Cross-Site Request Forgery Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)

### フレームワーク

- [Next.js — cookies API](https://nextjs.org/docs/app/api-reference/functions/cookies)
- [NestJS — Session](https://docs.nestjs.com/techniques/session)
- [NestJS — Cookies](https://docs.nestjs.com/techniques/cookies)
