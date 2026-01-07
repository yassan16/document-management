# SuperClaude Framework

Claude Codeを構造化された開発プラットフォームに変換するメタプログラミング設定フレームワーク。

---

## 1. SuperClaudeとは

### 概要

SuperClaude Frameworkは、Anthropic Claude Agent SDKに基づく統合コマンドセンターです。行動命令の注入とコンポーネントの統合を通じて、体系的なワークフロー自動化と強力なツール、インテリジェントエージェントを提供します。

**対応領域:**
- アプリ / GAS開発
- 統計・データ分析
- 大規模HTMLサイト制作

### 主な機能

| カテゴリ | 数量 | 内容 |
|---------|------|------|
| スラッシュコマンド | 30個 | 企画から展開まで完全な開発ライフサイクルをカバー |
| 特化型エージェント | 16個 | PM、セキュリティエンジニア、フロントエンドアーキテクトなど |
| 行動モード | 7個 | ブレインストーミング、Deep Research、トークン効率化など |
| MCPサーバー | 8個 | Tavily、Context7、Sequential、Serenなど |

---

## 2. インストール方法

### 推奨方法（pipx）

```bash
pipx install superclaude
superclaude install
superclaude mcp --list  # MCP サーバーオプション確認
```

### 代替方法（git clone）

```bash
git clone https://github.com/SuperClaude-Org/SuperClaude_Framework.git
cd SuperClaude_Framework
./install.sh
```

---

## 3. 基本的な使い方

### セッション開始時の設定

セッション開始時に `/add-dir` でプロジェクトフォルダを登録し、そのディレクトリ配下のファイルを前提に動作させます。

### コマンド構造

| 層 | 用途 | 主なコマンド |
|----|------|-------------|
| メタ層 | ハブ・ヘルプ | `/sc:sc`（相談）, `/sc:help`（全一覧） |
| 企画・設計層 | ブレストから仕様レビュー | `/sc:brainstorm`, `/sc:design` |
| 実装層 | 実装・最適化 | `/sc:implement`, `/sc:build` |
| 分析層 | 深層分析・リサーチ | `/sc:research`, `/sc:analyze` |

### 主要コマンド一覧

| コマンド | 説明 |
|---------|------|
| `/sc` | 全30コマンド表示 |
| `/sc:sc` | 何をしたいかわからないときに相談 |
| `/sc:help` | コマンド一覧とヘルプ表示 |
| `/sc:brainstorm` | 構造化ブレインストーミング |
| `/sc:design` | 設計モード |
| `/sc:implement` | コード実装 |
| `/sc:test` | テストワークフロー |
| `/sc:research` | Deep Web研究（Tavily MCP連携） |
| `/sc:pm` | プロジェクト管理 |
| `/sc:workflow` | ワークフロー統括 |

---

## 4. 使用例

### GAS開発

スプレッドシートベースのタスク管理アプリ制作：

```
/sc:brainstorm → /sc:design → 実装タスク分解 → /sc:implement
```

### データ分析

1000万行CSVの解析：

```
要件定義 → 特徴量作成 → 分析 → レポート作成
```

一連のワークフローで対応可能。

### サイト制作

大規模ドキュメントサイトのIA設計から実装、文書化まで `/sc:workflow` で統括。

---

## 5. 設定ファイル

開発者向け重要ファイル（プロジェクトルートに配置）：

| ファイル | 役割 |
|---------|------|
| `PLANNING.md` | アーキテクチャ・設計原則・絶対ルール |
| `TASK.md` | 現在のタスク・優先度・バックログ |
| `KNOWLEDGE.md` | 蓄積された知見・ベストプラクティス・トラブルシューティング |
| `CONTRIBUTING.md` | 貢献ガイドラインとワークフロー |

### ディレクトリ構成

```
SuperClaude_Framework/
├── .claude/           # Claude設定
├── docs/              # ドキュメント
├── plugins/superclaude/  # プラグイン
├── src/superclaude/   # ソースコード
├── skills/            # スキルモジュール
└── tests/             # テストスイート
```

---

## 6. メリット・デメリット

### メリット

- 段階的なワークフロー設計で抜け漏れ削減
- 複数分野（開発、分析、デザイン）に対応
- 仕様レビューやビジネス分析も統合
- テスト・改善・リファクタリング支援

### デメリット

- 初期学習コストが高い（コマンド数が多い）
- 前提ファイル構造の正確な登録が必須
- セッション間での状態管理が必要

### 注意点

- **ファイル登録の厳密性**: セッション開始時の `/add-dir` 登録は必須
- **コマンド名の正確性**: `/sc:command-name` 形式を厳守
- **定義ファイル参照**: 正確な定義は `~/.claude/commands/sc/*.md` に格納

---

## 7. 参考リンク

- [SuperClaude Framework（GitHub）](https://github.com/SuperClaude-Org/SuperClaude_Framework)
- [SuperClaude 解説記事](https://cleath.space/input/20251210c.html)
