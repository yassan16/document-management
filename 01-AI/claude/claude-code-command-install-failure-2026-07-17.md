# Claude Code コマンド実行失敗の調査結果

## 概要

2026年7月17日に、ローカル環境で `claude` コマンドが実行できない問題を調査した。
結論として、`@anthropic-ai/claude-code@2.1.212` の npm グローバルインストールが途中で中断され、`/opt/homebrew/bin/claude` のリンクとネイティブバイナリ配置が不完全な状態になっていたことが原因だった。

この問題は Claude Code 本体の使い方ではなく、npm のグローバルパッケージ更新が失敗した後のローカル環境破損である。再インストールにより復旧した。

## 目次

- [概要](#概要)
- [バグの詳細](#バグの詳細)
- [原因](#原因)
- [対処方法](#対処方法)
- [確認コマンド](#確認コマンド)
- [参考資料](#参考資料)

## バグの詳細

### 発生した症状

`claude` コマンドを実行しようとすると、シェル上でコマンドが見つからなかった。

```sh
which claude
# claude not found
```

ただし、npm のグローバルパッケージ一覧では Claude Code 自体はインストール済みだった。

```sh
npm list -g --depth=0
# /opt/homebrew/lib
# ├── @anthropic-ai/claude-code@2.1.212
# ├── npm@11.12.1
# └── pnpm@11.5.1
```

### 壊れていた状態

本来存在するべき `/opt/homebrew/bin/claude` が存在せず、npm の一時退避リンクだけが残っていた。

```sh
ls -la /opt/homebrew/bin/claude /opt/homebrew/bin/.claude-WV2akNWU
# ls: /opt/homebrew/bin/claude: No such file or directory
# /opt/homebrew/bin/.claude-WV2akNWU -> ../lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe
```

さらに、Claude Code の実行ファイルとして使われる `bin/claude.exe` はネイティブバイナリに置き換わっておらず、ASCII テキストの stub のままだった。

```sh
file /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe
# ASCII text
```

実行権限も付与されていなかったため、直接実行しても失敗した。

```sh
/opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe --version
# permission denied
```

### optional dependency の破損

macOS arm64 用の optional dependency はディレクトリ自体は存在していたが、`package.json` が存在しなかった。

```sh
sed -n '1,160p' /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/node_modules/@anthropic-ai/claude-code-darwin-arm64/package.json
# No such file or directory
```

また、ローカルの `claude-code-darwin-arm64` は約 8.4MB しかなく、正常なネイティブバイナリを含む状態ではなかった。

```sh
du -sh /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/node_modules/@anthropic-ai/claude-code-darwin-arm64
# 8.4M
```

退避されていた旧インストール `2.1.211` は約 231MB あり、`claude.exe` も Mach-O バイナリとして実行できた。

```sh
/opt/homebrew/lib/node_modules/@anthropic-ai/.claude-code-2DTsDk1V/bin/claude.exe --version
# 2.1.211 (Claude Code)
```

## 原因

直接原因は、`npm install -g @anthropic-ai/claude-code@2.1.212` の途中中断により、npm の reify 処理が完了しなかったことである。

npm のログには、既存の `claude-code` と `/opt/homebrew/bin/claude` を一時退避する処理までは記録されていた。

```txt
silly reify moves {
  '/opt/homebrew/lib/node_modules/@anthropic-ai/claude-code': '/opt/homebrew/lib/node_modules/@anthropic-ai/.claude-code-2DTsDk1V',
  '/opt/homebrew/bin/claude': '/opt/homebrew/bin/.claude-WV2akNWU'
}
```

しかし、その後のインストール完了ログがなく、以下の処理が不完全なまま残っていた。

| 本来の処理 | 実際の状態 |
| --- | --- |
| `/opt/homebrew/bin/claude` を作成する | 作成されていなかった |
| `bin/claude.exe` をネイティブバイナリへ置換する | ASCII stub のままだった |
| `bin/claude.exe` に実行権限を付ける | 実行権限がなかった |
| `claude-code-darwin-arm64/package.json` を展開する | 存在しなかった |

なお、npm registry 上の `@anthropic-ai/claude-code-darwin-arm64@2.1.212` tarball は正常だった。`npm pack --dry-run` では `LICENSE.md`、`README.md`、`claude`、`package.json` の4ファイルが含まれており、公開パッケージ自体の欠損ではなかった。

## 対処方法

壊れたグローバルインストールを同じバージョンで再インストールする。

```sh
npm install -g @anthropic-ai/claude-code@2.1.212
```

今回の環境では、再インストール後に以下のように復旧した。

```sh
which claude
# /opt/homebrew/bin/claude

claude --version
# 2.1.212 (Claude Code)
```

`/opt/homebrew/bin/claude` は正常に作成され、実体の `claude.exe` も Mach-O バイナリに置き換わった。

```sh
ls -la /opt/homebrew/bin/claude /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe
# /opt/homebrew/bin/claude -> ../lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe
# /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe

file /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe
# Mach-O 64-bit executable arm64
```

再インストールで一時ファイルの衝突や権限エラーが出る場合は、壊れた一時退避リンクや途中展開されたディレクトリが残っている可能性がある。その場合は削除対象を確認したうえで、`/opt/homebrew/bin/.claude-*` や `/opt/homebrew/lib/node_modules/@anthropic-ai/.claude-code-*` の扱いを判断する。

## 確認コマンド

同様の問題を切り分ける場合は、以下を順に確認する。

```sh
which claude
claude --version
npm list -g --depth=0
ls -la /opt/homebrew/bin/claude /opt/homebrew/bin/.claude-*
ls -la /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe
file /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe
ls -la /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/node_modules/@anthropic-ai/claude-code-darwin-arm64
```

確認観点は次の通り。

| 確認項目 | 正常な状態 |
| --- | --- |
| `which claude` | `/opt/homebrew/bin/claude` を返す |
| `claude --version` | Claude Code のバージョンを返す |
| `/opt/homebrew/bin/claude` | `bin/claude.exe` へのシンボリックリンク |
| `bin/claude.exe` | 実行権限付きの Mach-O バイナリ |
| `claude-code-darwin-arm64/package.json` | 存在する |

## 参考資料

- [@anthropic-ai/claude-code - npm](https://www.npmjs.com/package/@anthropic-ai/claude-code)
- [@anthropic-ai/claude-code-darwin-arm64 - npm](https://www.npmjs.com/package/@anthropic-ai/claude-code-darwin-arm64)
- [npm install - npm Docs](https://docs.npmjs.com/cli/commands/npm-install)
