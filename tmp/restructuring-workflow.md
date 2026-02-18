# フォルダ構成変更 実行手順書

## 概要

本手順書は、`tmp/restructuring-plan.md`（変更計画書）に基づき、フォルダ構成の変更を安全に実行するための作業ガイドです。

- **計画書**: 何を・なぜ変更するか（仕様）
- **本手順書**: いつ・どう実行し・どう確認するか（作業ガイド）

---

## 目次

- [前提条件](#前提条件)
- [フェーズ 1: 事前準備](#フェーズ-1-事前準備)
- [フェーズ 2: ディレクトリ作成とファイル移動](#フェーズ-2-ディレクトリ作成とファイル移動)
- [フェーズ 3: クリーンアップ](#フェーズ-3-クリーンアップ)
- [フェーズ 4: README.md の更新](#フェーズ-4-readmemd-の更新)
- [フェーズ 5: 最終確認](#フェーズ-5-最終確認)
- [ロールバック手順](#ロールバック手順)
- [対象ファイル一覧（19件）](#対象ファイル一覧19件)

---

## 前提条件

作業開始前に、以下をすべて確認すること。

- [ ] `main` ブランチから作業ブランチを作成済み（例: `refactor/restructure-folders`）
- [ ] ワーキングツリーがクリーン（未コミットの変更がない）
- [ ] `tmp/restructuring-plan.md`（変更計画書）を読了済み

```bash
# ブランチ確認
git branch --show-current

# ワーキングツリーがクリーンであることを確認
git status
```

---

## フェーズ 1: 事前準備

### 1-1. ファイル数のベースラインを記録する

移動前のファイル数を記録し、フェーズ 5 で一致を確認する。

- [ ] 全ファイル数を記録する

```bash
# 全ファイル数を記録（.git, tmp, .claude, .github を除外）
echo "=== 全ファイル数（変更前）==="
find . -not -path "./.git/*" -not -path "./tmp/*" -not -path "./.claude/*" -not -path "./.github/*" -not -type d | wc -l
# 期待値: 91

echo "=== .md ファイル数（変更前）==="
find . -name "*.md" -not -path "./.git/*" -not -path "./tmp/*" -not -path "./.claude/*" -not -path "./.github/*" | wc -l
```

> 出力された数値をメモしておくこと。フェーズ 5 で照合に使用する。

### 1-2. 現在のディレクトリ構成を保存する

- [ ] 変更前のツリーをファイルに保存する

```bash
# 変更前のツリーを保存
find . -not -path "./.git/*" -not -path "./tmp/*" -not -path "./.claude/*" -not -path "./.github/*" | sort > tmp/tree-before.txt
```

---

## フェーズ 2: ディレクトリ作成とファイル移動

計画書の Step 1〜6 に対応する。各ステップの実行後に確認コマンドを実行すること。

### 2-1. トップレベルに新ディレクトリを作成する（Step 1）

- [ ] `languages/`, `frameworks/`, `infrastructure/` を作成する

```bash
mkdir languages/ frameworks/ infrastructure/
```

**確認:**

```bash
ls -d languages/ frameworks/ infrastructure/
# 3つのディレクトリが表示されること
```

### 2-2. `tech-reference/frameworks/` → `frameworks/` に移動する（Step 2）

- [ ] `laravel/` を移動する
- [ ] `vuejs/` を移動する
- [ ] `nextjs/` を移動する
- [ ] `fastapi/` を移動する
- [ ] `flutter/` を移動する
- [ ] `README.md` を移動する

```bash
mv tech-reference/frameworks/laravel frameworks/laravel
mv tech-reference/frameworks/vuejs frameworks/vuejs
mv tech-reference/frameworks/nextjs frameworks/nextjs
mv tech-reference/frameworks/fastapi frameworks/fastapi
mv tech-reference/frameworks/flutter frameworks/flutter
mv tech-reference/frameworks/README.md frameworks/README.md
```

**確認:**

```bash
echo "=== frameworks/ の内容 ==="
ls frameworks/
# fastapi  flutter  laravel  nextjs  README.md  vuejs が表示されること

echo "=== tech-reference/frameworks/ が空であること ==="
ls tech-reference/frameworks/ 2>&1
# 空または「No such file or directory」が表示されること
```

### 2-3. `tech-reference/languages/` → `languages/` に移動する（Step 3）

- [ ] `dart/` を移動する
- [ ] `java/` を移動する
- [ ] `javascript/` を移動する
- [ ] `vba/` を移動する
- [ ] `php/laravel /serialize_and_accessor.md` を `frameworks/laravel/` に統合する（リネームあり）
- [ ] `languages/php/` を空ディレクトリとして作成する
- [ ] 旧 `tech-reference/languages/php/` 配下を削除する

```bash
# 言語フォルダの移動
mv tech-reference/languages/dart languages/dart
mv tech-reference/languages/java languages/java
mv tech-reference/languages/javascript languages/javascript
mv tech-reference/languages/vba languages/vba

# Laravel ドキュメントを frameworks に統合（末尾スペースに注意）
mv "tech-reference/languages/php/laravel /serialize_and_accessor.md" \
   frameworks/laravel/serialize-and-accessor.md

# PHP フォルダを空で作成（将来用）
mkdir -p languages/php

# 旧 php 配下のクリーンアップ
rmdir "tech-reference/languages/php/laravel "
rmdir tech-reference/languages/php
```

**確認:**

```bash
echo "=== languages/ の内容 ==="
ls languages/
# dart  java  javascript  php  vba が表示されること

echo "=== Laravel 統合の確認 ==="
ls frameworks/laravel/serialize-and-accessor.md
# ファイルが存在すること

echo "=== languages/php/ が空であること ==="
ls languages/php/
# 空であること（将来用）
```

### 2-4. `tech-reference/tools/` + `networking/` → `infrastructure/` に移動する（Step 4）

- [ ] `git/` を移動する
- [ ] `networking/` を移動する

```bash
mv tech-reference/tools/git infrastructure/git
mv tech-reference/networking infrastructure/networking
```

**確認:**

```bash
echo "=== infrastructure/ の内容 ==="
ls infrastructure/
# git  networking が表示されること
```

### 2-5. `learning/` → 既存カテゴリに分散する（Step 5）

- [ ] `aws-infrastructure-roadmap.md` → `infrastructure/aws/roadmap.md`
- [ ] `api-development-roadmap.md` → `methodology/api-development/roadmap.md`
- [ ] `code-reading-roadmap.md` → `methodology/code-reading/roadmap.md`
- [ ] `ui-ux-design-roadmap.md` → `design/ui-ux/roadmap.md`

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

**確認:**

```bash
echo "=== ロードマップの移動確認 ==="
ls infrastructure/aws/roadmap.md
ls methodology/api-development/roadmap.md
ls methodology/code-reading/roadmap.md
ls design/ui-ux/roadmap.md
# すべて存在すること

echo "=== learning/ が空であること ==="
ls learning/ 2>&1
# 空であること
```

### 2-6. `misc/` → `infrastructure/` に移動する（Step 6）

- [ ] `youtube-dl/` を移動する

```bash
mv misc/youtube-dl infrastructure/youtube-dl
```

**確認:**

```bash
echo "=== infrastructure/ の最終内容 ==="
ls infrastructure/
# aws  git  networking  youtube-dl が表示されること

echo "=== misc/ が空であること ==="
ls misc/ 2>&1
# 空であること
```

---

## フェーズ 3: クリーンアップ

計画書の Step 7 に対応する。旧ディレクトリを削除する。

### 3-1. `tech-reference/` を削除する

- [ ] `tech-reference/` 配下の残りを葉から根へ順に削除する

```bash
# 葉から根の順に削除
rmdir tech-reference/tools
rmdir tech-reference/frameworks
rmdir tech-reference/languages
rm tech-reference/README.md
rmdir tech-reference
```

**確認:**

```bash
ls tech-reference/ 2>&1
# "No such file or directory" が表示されること
```

### 3-2. `learning/` を削除する

- [ ] `learning/` を削除する

```bash
rmdir learning
```

**確認:**

```bash
ls learning/ 2>&1
# "No such file or directory" が表示されること
```

### 3-3. `misc/` を削除する

- [ ] `misc/` を削除する

```bash
rmdir misc
```

**確認:**

```bash
ls misc/ 2>&1
# "No such file or directory" が表示されること
```

---

## フェーズ 4: README.md の更新

計画書の Step 8〜9 に対応する。

### 4-1. カテゴリ別 README.md を作成・更新する

- [ ] `languages/README.md` を新規作成する
- [ ] `frameworks/README.md` を更新する（Laravel 統合を反映）
- [ ] `infrastructure/README.md` を新規作成する
- [ ] `design/README.md` を新規作成する（ui-ux 追加を反映）
- [ ] `methodology/README.md` を新規作成する（api-development, code-reading 追加を反映）

> 各 README.md の具体的な内容は、計画書の「README.md の更新方針」セクションに従うこと。

### 4-2. ルート `README.md` を更新する

- [ ] 目次を新しい6カテゴリ構成（`languages/`, `frameworks/`, `infrastructure/`, `design/`, `methodology/`, `ai/`）に合わせて全面更新する

### 4-3. `CLAUDE.md` を確認する（Step 9）

- [ ] `CLAUDE.md` のドメイン追加ルール（`{domain}/*/{任意のファイル名}.md`）のパスに変更が必要かチェックする
- [ ] 変更が必要であれば修正する

**確認:**

```bash
echo "=== README.md 内のリンク確認 ==="
# 各 README.md 内のリンクが実在するか確認
grep -roh '\[.*\](.*\.md)' README.md | grep -oP '\(.*?\)' | tr -d '()' | while read -r link; do
  if [ ! -f "$link" ]; then
    echo "BROKEN: $link"
  fi
done
# "BROKEN" が表示されないこと
```

---

## フェーズ 5: 最終確認

計画書の Step 9 および検証方法に対応する。

### 5-1. ファイル数の一致を確認する

- [ ] 全ファイル数がフェーズ 1 の記録と一致することを確認する

```bash
echo "=== 全ファイル数（変更後）==="
find . -not -path "./.git/*" -not -path "./tmp/*" -not -path "./.claude/*" -not -path "./.github/*" -not -type d | wc -l
# フェーズ 1 で記録した値と一致すること（期待値: 91）

echo "=== .md ファイル数（変更後）==="
find . -name "*.md" -not -path "./.git/*" -not -path "./tmp/*" -not -path "./.claude/*" -not -path "./.github/*" | wc -l
# フェーズ 1 で記録した値と一致すること
```

### 5-2. 変更後のディレクトリ構成を確認する

- [ ] 期待通りのトップレベル構成になっていることを確認する

```bash
echo "=== トップレベルのディレクトリ一覧 ==="
ls -d */
# ai/  design/  frameworks/  infrastructure/  languages/  methodology/  tmp/ が表示されること
# tech-reference/  learning/  misc/ が表示されないこと
```

### 5-3. 不要な空ディレクトリが残っていないことを確認する

- [ ] 意図しない空ディレクトリがないことを確認する

```bash
echo "=== 空ディレクトリの一覧 ==="
find . -type d -empty -not -path "./.git/*" -not -path "./tmp/*" -not -path "./.claude/*" -not -path "./.github/*"
# design/patterns/ と languages/php/ のみが表示されること
# design/patterns/: 将来用に意図的に残す
# languages/php/: 将来のPHP言語メモ用に意図的に残す
```

### 5-4. 対象ファイル 19 件の移動を個別確認する

- [ ] 移動対象の全ファイルが正しい場所に存在することを確認する

```bash
echo "=== 対象ファイル 19 件の存在確認 ==="

# 1〜4: languages/ に移動したもの
test -d languages/dart && echo "OK: languages/dart/" || echo "NG: languages/dart/"
test -d languages/java && echo "OK: languages/java/" || echo "NG: languages/java/"
test -d languages/javascript && echo "OK: languages/javascript/" || echo "NG: languages/javascript/"
test -d languages/vba && echo "OK: languages/vba/" || echo "NG: languages/vba/"

# 5: Laravel 統合
test -f frameworks/laravel/serialize-and-accessor.md && echo "OK: frameworks/laravel/serialize-and-accessor.md" || echo "NG: frameworks/laravel/serialize-and-accessor.md"

# 6〜11: frameworks/ に移動したもの
test -d frameworks/laravel && echo "OK: frameworks/laravel/" || echo "NG: frameworks/laravel/"
test -d frameworks/vuejs && echo "OK: frameworks/vuejs/" || echo "NG: frameworks/vuejs/"
test -d frameworks/nextjs && echo "OK: frameworks/nextjs/" || echo "NG: frameworks/nextjs/"
test -d frameworks/fastapi && echo "OK: frameworks/fastapi/" || echo "NG: frameworks/fastapi/"
test -d frameworks/flutter && echo "OK: frameworks/flutter/" || echo "NG: frameworks/flutter/"
test -f frameworks/README.md && echo "OK: frameworks/README.md" || echo "NG: frameworks/README.md"

# 12〜13: infrastructure/ に移動したもの
test -d infrastructure/git && echo "OK: infrastructure/git/" || echo "NG: infrastructure/git/"
test -d infrastructure/networking && echo "OK: infrastructure/networking/" || echo "NG: infrastructure/networking/"

# 14〜17: ロードマップ分散
test -f infrastructure/aws/roadmap.md && echo "OK: infrastructure/aws/roadmap.md" || echo "NG: infrastructure/aws/roadmap.md"
test -f methodology/api-development/roadmap.md && echo "OK: methodology/api-development/roadmap.md" || echo "NG: methodology/api-development/roadmap.md"
test -f methodology/code-reading/roadmap.md && echo "OK: methodology/code-reading/roadmap.md" || echo "NG: methodology/code-reading/roadmap.md"
test -f design/ui-ux/roadmap.md && echo "OK: design/ui-ux/roadmap.md" || echo "NG: design/ui-ux/roadmap.md"

# 18: misc → infrastructure
test -d infrastructure/youtube-dl && echo "OK: infrastructure/youtube-dl/" || echo "NG: infrastructure/youtube-dl/"

# 19: tech-reference/README.md は削除済み
test ! -f tech-reference/README.md && echo "OK: tech-reference/README.md 削除済み" || echo "NG: tech-reference/README.md がまだ存在"
```

### 5-5. 旧ディレクトリが削除されていることを確認する

- [ ] `tech-reference/`, `learning/`, `misc/` が存在しないことを確認する

```bash
echo "=== 旧ディレクトリの削除確認 ==="
test ! -d tech-reference && echo "OK: tech-reference/ 削除済み" || echo "NG: tech-reference/ がまだ存在"
test ! -d learning && echo "OK: learning/ 削除済み" || echo "NG: learning/ がまだ存在"
test ! -d misc && echo "OK: misc/ 削除済み" || echo "NG: misc/ がまだ存在"
```

### 5-6. コミットする

- [ ] すべての確認が OK であれば、変更をコミットする

```bash
git add -A
git status
# 想定通りの変更内容であることを確認してからコミット
git commit -m "refactor: フォルダ構成を変更（tech-reference 解体、learning/misc 廃止）"
```

---

## ロールバック手順

いずれかのフェーズで問題が発生した場合、以下の手順で変更前の状態に復元する。

### コミット前の場合

作業ブランチで未コミットの変更をすべて破棄する。

```bash
# 全変更を破棄（追跡中のファイルを復元）
git checkout -- .

# 新規作成されたディレクトリを削除
git clean -fd

# 復元の確認
git status
# "nothing to commit, working tree clean" が表示されること
```

### コミット後の場合

作業ブランチのコミットを取り消す。

```bash
# 直前のコミットを取り消し（変更は残る）
git reset --soft HEAD~1

# 変更を破棄
git checkout -- .
git clean -fd

# 復元の確認
git status
```

> **注意**: `main` ブランチに直接コミットしている場合は、`git reset` の影響範囲を十分に確認してから実行すること。

---

## 対象ファイル一覧（19件）

計画書の「対象ファイル一覧」と完全に対応する。手順書内での登場箇所を併記する。

| # | 元パス | 移動先 | 手順書の該当ステップ |
|---|--------|--------|---------------------|
| 1 | `tech-reference/languages/dart/` | `languages/dart/` | 2-3 |
| 2 | `tech-reference/languages/java/` | `languages/java/` | 2-3 |
| 3 | `tech-reference/languages/javascript/` | `languages/javascript/` | 2-3 |
| 4 | `tech-reference/languages/vba/` | `languages/vba/` | 2-3 |
| 5 | `tech-reference/languages/php/laravel /serialize_and_accessor.md` | `frameworks/laravel/serialize-and-accessor.md` | 2-3 |
| 6 | `tech-reference/frameworks/laravel/` | `frameworks/laravel/` | 2-2 |
| 7 | `tech-reference/frameworks/vuejs/` | `frameworks/vuejs/` | 2-2 |
| 8 | `tech-reference/frameworks/nextjs/` | `frameworks/nextjs/` | 2-2 |
| 9 | `tech-reference/frameworks/fastapi/` | `frameworks/fastapi/` | 2-2 |
| 10 | `tech-reference/frameworks/flutter/` | `frameworks/flutter/` | 2-2 |
| 11 | `tech-reference/frameworks/README.md` | `frameworks/README.md` | 2-2 |
| 12 | `tech-reference/tools/git/` | `infrastructure/git/` | 2-4 |
| 13 | `tech-reference/networking/` | `infrastructure/networking/` | 2-4 |
| 14 | `learning/aws-infrastructure-roadmap.md` | `infrastructure/aws/roadmap.md` | 2-5 |
| 15 | `learning/api-development-roadmap.md` | `methodology/api-development/roadmap.md` | 2-5 |
| 16 | `learning/code-reading-roadmap.md` | `methodology/code-reading/roadmap.md` | 2-5 |
| 17 | `learning/ui-ux-design-roadmap.md` | `design/ui-ux/roadmap.md` | 2-5 |
| 18 | `misc/youtube-dl/` | `infrastructure/youtube-dl/` | 2-6 |
| 19 | `tech-reference/README.md` | 削除 | 3-1 |
