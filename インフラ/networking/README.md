# Networking

## 概要

ネットワーク通信に関するドキュメントを整理しています。Web開発に必要なプロトコルや通信技術を体系的に学習できます。

---

## 目次

### プロトコル

| プロトコル | 概要 |
|-----------|------|
| [HTTP](./http/) | HTTP通信の学習ロードマップ（基礎〜HTTP/3、WebSocket） |

### Web公開

| ドキュメント | 概要 |
|------------|------|
| [Webサイト公開の基礎知識](./web-publishing/basics.md) | レジストラ・ドメイン・DNS・ホスティング・SSL/TLS・CDN・デプロイ |
| [ドメイン移管・レジストラ変更](./web-publishing/domain-transfer.md) | ドメイン移管の仕組み・手順・DNS変更やホスティング変更との違い |

---

## ディレクトリ構造

```
networking/
├── http/                    # HTTP通信関連
│   └── roadmap.md           # HTTP学習ロードマップ
└── web-publishing/          # Web公開に必要な基礎知識
    ├── basics.md            # レジストラ、DNS、ホスティング等の解説
    └── domain-transfer.md   # ドメイン移管・レジストラ変更の解説
```

---

## 今後追加予定

- TCP/IP基礎
- WebRTC
