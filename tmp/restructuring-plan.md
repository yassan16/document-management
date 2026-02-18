# フォルダ構成 変更計画書

## 概要

本ドキュメントは、`document-management` リポジトリのフォルダ構成を見直し、探しやすさ・一貫性・拡張性を向上させるための変更計画です。

**注意: 本計画書はフォルダ移動の計画のみであり、ファイルの内容は一切変更しません。**

### 変更範囲

- **変更する**: フォルダ構成（ディレクトリの移動・リネーム・作成・削除）
- **変更しない**: 各ファイルの内容（ソースコード、設定ファイル、ドキュメント本文等の中身はそのまま維持）
- **例外**: `README.md` の内容は、フォルダ構成の変更に伴うリンク修正・目次更新のため変更する。
  また、新規カテゴリ用の `README.md`（`languages/`, `infrastructure/`, `design/`, `methodology/`）は新規作成する。

---

## 目次

- [現状の課題](#現状の課題)
- [方針](#方針)
- [現在のフォルダ構成](#現在のフォルダ構成)
- [変更後のフォルダ構成](#変更後のフォルダ構成)
- [変更内容の詳細](#変更内容の詳細)
- [README.md の更新方針](#readmemd-の更新方針)
- [移行手順](#移行手順)
- [検証方法](#検証方法)

---

## 現状の課題

### 1. `tech-reference/` が巨大で探しにくい

`tech-reference/` 配下に languages, frameworks, tools, networking が混在しており、目的のドキュメントにたどり着くまでに深い階層をたどる必要がある。

### 2. コンテンツの重複・分散

| 問題 | 詳細 |
|------|------|
| Laravel ドキュメントの分散 | `tech-reference/frameworks/laravel/` と `tech-reference/languages/php/laravel /`（末尾スペース）の2箇所に存在 |
| ロードマップの分散 | `learning/` にロードマップがあるが、各トピックとは分離している |

### 3. `learning/` のロードマップが各トピックから分離

横断的な学習ロードマップ（API開発、コードリーディング、UI/UXデザイン）が `learning/` フォルダにまとめられているが、それぞれの関連カテゴリ（`methodology/` や `design/`）に配置した方が発見しやすい。

### 4. `misc/` が曖昧なカテゴリ

youtube-dl のみが配置されており、CLIツールとしては `infrastructure/` に分類する方が適切。

### 5. 命名の不統一

| 問題 | 詳細 |
|------|------|
| フォルダ名にスペース | `tech-reference/languages/php/laravel /`（末尾にスペース） |
| ファイル命名の不統一 | `deepCopy`（camelCase）vs `sequence-diagrams`（kebab-case） |
| README の命名揺れ | `readme.md`（小文字）と `README.md`（大文字）が混在 |

> **スコープ**: 本計画では末尾スペースとスネークケース（`serialize_and_accessor.md`）のみ修正する。
> `deepCopy`（camelCase）や `readme.md`（小文字）の統一は、別途命名規則統一タスクとして実施する。

---

## 方針

プランモードでの議論により、以下の方針で合意済み。

- **`tech-reference/` を解体** → `languages/`, `frameworks/`, `infrastructure/` をトップレベルに昇格
- **`design/` と `methodology/` は分けて維持する**（設計思想 vs 開発手法は関心事が異なる）
- **`guides/` は作らず、横断的ロードマップは既存カテゴリに分散する**
- **`learning/` を廃止** → ロードマップを `methodology/`, `design/`, `infrastructure/` に分散
- **`misc/` を廃止** → `infrastructure/` に移動
- **ファイルの内容は一切変更しない**（フォルダの移動・リネームのみ）

---

## 現在のフォルダ構成

```
document-management/
├── ai/
│   ├── claude-md-writing-guide.md
│   ├── claude/
│   │   └── super-claude/
│   │       └── README.md
│   ├── prompt/
│   │   ├── README.md
│   │   └── feature-specification-template.md
│   └── token/
│       └── toon/
│           └── README.md
├── design/
│   ├── architecture/
│   │   ├── domain-driven-design/
│   │   └── onion-architecture/
│   ├── patterns/                        ← 空ディレクトリ
│   └── uml/
│       └── sequence-diagrams.md
├── learning/                            ← 廃止予定
│   ├── api-development-roadmap.md
│   ├── aws-infrastructure-roadmap.md
│   ├── code-reading-roadmap.md
│   └── ui-ux-design-roadmap.md
├── methodology/
│   ├── agile/
│   ├── batch/
│   └── spec-driven-development/
├── misc/                                ← 廃止予定
│   └── youtube-dl/
├── tech-reference/                      ← 解体予定
│   ├── frameworks/
│   │   ├── fastapi/
│   │   ├── flutter/
│   │   ├── laravel/
│   │   ├── nextjs/
│   │   └── vuejs/
│   ├── languages/
│   │   ├── dart/
│   │   ├── java/
│   │   ├── javascript/
│   │   ├── php/
│   │   │   └── laravel /                ← 末尾スペース & frameworks と重複
│   │   └── vba/
│   ├── networking/
│   │   ├── README.md
│   │   └── http/
│   │       ├── README.md
│   │       └── roadmap.md
│   └── tools/
│       └── git/
└── tmp/
```

---

## 変更後のフォルダ構成

```
document-management/
├── languages/                           ← tech-reference/languages/ から昇格
│   ├── dart/
│   ├── java/
│   ├── javascript/
│   ├── php/
│   └── vba/
├── frameworks/                          ← tech-reference/frameworks/ から昇格
│   ├── laravel/                         ← php/laravel の内容も統合
│   ├── vuejs/
│   ├── nextjs/
│   ├── fastapi/
│   └── flutter/
├── infrastructure/                      ← tech-reference/tools + networking を統合
│   ├── git/
│   ├── networking/
│   ├── aws/                             ← learning/aws-infrastructure-roadmap.md
│   └── youtube-dl/                      ← misc/youtube-dl/
├── design/                              ← 既存維持（設計思想・モデリング）
│   ├── architecture/
│   ├── patterns/                        ← 空ディレクトリ（将来用に維持）
│   ├── uml/
│   └── ui-ux/                           ← learning/ui-ux-design-roadmap.md
│       └── roadmap.md
├── methodology/                         ← 既存維持（開発手法・プロセス）
│   ├── agile/
│   ├── batch/
│   ├── spec-driven-development/
│   ├── api-development/                 ← learning/api-development-roadmap.md
│   │   └── roadmap.md
│   └── code-reading/                    ← learning/code-reading-roadmap.md
│       └── roadmap.md
├── ai/                                  ← 変更なし
│   ├── claude-md-writing-guide.md
│   ├── claude/
│   ├── prompt/
│   └── token/
└── README.md
```

---

## 変更内容の詳細

### 変更 1: `tech-reference/` の解体とトップレベル昇格

`tech-reference/` 配下の4カテゴリを個別のトップレベルフォルダに分割する。

| 元パス | 移動先 | 理由 |
|--------|--------|------|
| `tech-reference/languages/{dart,java,javascript,vba}/` | `languages/` 直下 | 言語リファレンスをトップレベルに昇格して探しやすくする |
| `tech-reference/frameworks/{laravel,vuejs,nextjs,fastapi,flutter}/` | `frameworks/` 直下 | フレームワークリファレンスをトップレベルに昇格 |
| `tech-reference/frameworks/README.md` | `frameworks/README.md` | README も一緒に移動 |
| `tech-reference/tools/git/` | `infrastructure/git/` | ツール・インフラ系を `infrastructure/` に統合 |
| `tech-reference/networking/` | `infrastructure/networking/` | ネットワーク系も `infrastructure/` に統合 |
| `tech-reference/README.md` | 削除 | 内容は `languages/README.md` と `frameworks/README.md` 新規作成時に参照 |

### 変更 2: Laravel ドキュメントの統合

| 項目 | 内容 |
|------|------|
| **対象** | `tech-reference/languages/php/laravel /serialize_and_accessor.md` |
| **移動先** | `frameworks/laravel/serialize-and-accessor.md` |
| **理由** | Laravel はフレームワークであり、`frameworks/laravel/` に一元化すべき。末尾スペースとファイル名のスネークケースも修正する |
| **追加作業** | `languages/php/` は空フォルダとして作成（将来のPHP言語メモ用） |

### 変更 3: `learning/` の廃止とロードマップの分散

横断的ロードマップを関連性の高いカテゴリに分散する。

| 元パス | 移動先 | 理由 |
|--------|--------|------|
| `learning/api-development-roadmap.md` | `methodology/api-development/roadmap.md` | API開発の**進め方**のロードマップ |
| `learning/code-reading-roadmap.md` | `methodology/code-reading/roadmap.md` | コードリーディングの**手法** |
| `learning/ui-ux-design-roadmap.md` | `design/ui-ux/roadmap.md` | UI/UXの**設計スキル** |
| `learning/aws-infrastructure-roadmap.md` | `infrastructure/aws/roadmap.md` | AWSは**インフラ** |

### 変更 4: `misc/` の廃止

| 元パス | 移動先 | 理由 |
|--------|--------|------|
| `misc/youtube-dl/README.md` | `infrastructure/youtube-dl/README.md` | CLIツールなので `infrastructure/` に分類 |

### 変更 5: 旧ディレクトリの削除

全ファイル移動後、以下の空ディレクトリを削除する。

| 対象 | 理由 |
|------|------|
| `tech-reference/` | 全ファイルを `languages/`, `frameworks/`, `infrastructure/` に移動済み |
| `learning/` | 全ファイルを `methodology/`, `design/`, `infrastructure/` に分散済み |
| `misc/` | 全ファイルを `infrastructure/` に移動済み |

---

## README.md の更新方針

各変更に伴い、以下の README.md を更新する必要がある。

| README.md | 更新内容 |
|-----------|----------|
| `README.md`（ルート） | 目次を新しい6カテゴリ構成に合わせて全面更新 |
| `languages/README.md` | 新規作成（旧 `tech-reference/README.md` の言語セクションを元に） |
| `frameworks/README.md` | 更新（旧 `tech-reference/frameworks/README.md` を元に、Laravel 統合を反映） |
| `infrastructure/README.md` | 新規作成（git, networking, aws, youtube-dl をまとめる） |
| `design/README.md` | 新規作成（ui-ux 追加を反映） |
| `methodology/README.md` | 新規作成（api-development, code-reading 追加を反映） |

---

## 移行手順

以下の順序で移行を実施する。

### Step 1: トップレベルに新フォルダを作成

```bash
mkdir languages/ frameworks/ infrastructure/
```

### Step 2: `tech-reference/frameworks/` → `frameworks/` に移動

```bash
mv tech-reference/frameworks/laravel frameworks/laravel
mv tech-reference/frameworks/vuejs frameworks/vuejs
mv tech-reference/frameworks/nextjs frameworks/nextjs
mv tech-reference/frameworks/fastapi frameworks/fastapi
mv tech-reference/frameworks/flutter frameworks/flutter
mv tech-reference/frameworks/README.md frameworks/README.md
```

### Step 3: `tech-reference/languages/` → `languages/` に移動

```bash
mv tech-reference/languages/dart languages/dart
mv tech-reference/languages/java languages/java
mv tech-reference/languages/javascript languages/javascript
mv tech-reference/languages/vba languages/vba

# PHP の Laravel ドキュメントを frameworks に統合（末尾スペースに注意）
# ※ Step 2 で frameworks/laravel/ が作成済みのため成功する
mv "tech-reference/languages/php/laravel /serialize_and_accessor.md" \
   frameworks/laravel/serialize-and-accessor.md

# PHP フォルダを languages に移動（空になるが将来用に残す）
mkdir -p languages/php
rmdir "tech-reference/languages/php/laravel "
rmdir tech-reference/languages/php
```

### Step 4: `tech-reference/tools` + `networking` → `infrastructure/` に移動

```bash
mv tech-reference/tools/git infrastructure/git
mv tech-reference/networking infrastructure/networking
```

### Step 5: `learning/` → 既存カテゴリに分散

```bash
mkdir -p infrastructure/aws
mv learning/aws-infrastructure-roadmap.md infrastructure/aws/roadmap.md

mkdir -p methodology/api-development
mv learning/api-development-roadmap.md methodology/api-development/roadmap.md

mkdir -p methodology/code-reading
mv learning/code-reading-roadmap.md methodology/code-reading/roadmap.md

mkdir -p design/ui-ux
mv learning/ui-ux-design-roadmap.md design/ui-ux/roadmap.md
```

### Step 6: `misc/` → `infrastructure/` に移動

```bash
mv misc/youtube-dl infrastructure/youtube-dl
```

### Step 7: 旧ディレクトリを削除

```bash
# tech-reference/ の残り（葉から根へ）
rmdir tech-reference/tools
rmdir tech-reference/frameworks
rmdir tech-reference/languages
rm tech-reference/README.md
rmdir tech-reference

# learning/ と misc/
rmdir learning
rmdir misc
```

### Step 8: README.md の更新

上記「README.md の更新方針」に従い、関連する README.md を更新・作成する。

### Step 9: CLAUDE.md の確認

ドメイン追加ルールのパスに変更が必要かチェックする。

---

## 対象ファイル一覧（移動対象）

| # | 元パス | 移動先 |
|---|--------|--------|
| 1 | `tech-reference/languages/dart/` | `languages/dart/` |
| 2 | `tech-reference/languages/java/` | `languages/java/` |
| 3 | `tech-reference/languages/javascript/` | `languages/javascript/` |
| 4 | `tech-reference/languages/vba/` | `languages/vba/` |
| 5 | `tech-reference/languages/php/laravel /serialize_and_accessor.md` | `frameworks/laravel/serialize-and-accessor.md` |
| 6 | `tech-reference/frameworks/laravel/` | `frameworks/laravel/` |
| 7 | `tech-reference/frameworks/vuejs/` | `frameworks/vuejs/` |
| 8 | `tech-reference/frameworks/nextjs/` | `frameworks/nextjs/` |
| 9 | `tech-reference/frameworks/fastapi/` | `frameworks/fastapi/` |
| 10 | `tech-reference/frameworks/flutter/` | `frameworks/flutter/` |
| 11 | `tech-reference/frameworks/README.md` | `frameworks/README.md` |
| 12 | `tech-reference/tools/git/` | `infrastructure/git/` |
| 13 | `tech-reference/networking/` | `infrastructure/networking/` |
| 14 | `learning/aws-infrastructure-roadmap.md` | `infrastructure/aws/roadmap.md` |
| 15 | `learning/api-development-roadmap.md` | `methodology/api-development/roadmap.md` |
| 16 | `learning/code-reading-roadmap.md` | `methodology/code-reading/roadmap.md` |
| 17 | `learning/ui-ux-design-roadmap.md` | `design/ui-ux/roadmap.md` |
| 18 | `misc/youtube-dl/` | `infrastructure/youtube-dl/` |
| 19 | `tech-reference/README.md` | 削除（`languages/README.md` 等の作成時に参照） |

---

## 検証方法

- `find . -not -path "./.git/*" -not -path "./tmp/*" -not -path "./.claude/*" -not -path "./.github/*" -not -type d | wc -l` で全ファイル数が変更前後で一致することを確認（現在: 91 ファイル）
- 各 README.md のリンクが正しいことを確認
- 空ディレクトリが残っていないことを確認（`design/patterns/` は将来用として意図的に残す）
- `find . -name "*.md" -not -path "./.git/*" -not -path "./tmp/*" | wc -l` で .md ファイル数を別途確認
