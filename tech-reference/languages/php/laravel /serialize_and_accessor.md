# 結論（要点）

「シリアライズ」とは Eloquent のモデル（User インスタンス）を配列や JSON に変換する処理のことです（例：`toArray()` / `toJson()` / `response()->json(['user' => $user])` が呼ばれると発生します）。

「アクセサが評価される」とは、モデルのアクセサーメソッド（今回だと `getIsActiveAttribute()`）が呼ばれて、その戻り値がシリアライズされた配列／JSON に含まれることを指します。アクセサはシリアライズのタイミングで実行され、その時点の状態（関連モデルやプロパティ）を使って値を計算します。

つまりログインレスポンスで `response()->json(['user' => $user])` を返すときに `User::toArray()` が走り、そのなかで `getIsActiveAttribute()` が実行されて `is_active` が出力されます。

## 「シリアライズ時」とは具体的に何をするか？

Laravel/Eloquent ではモデルを配列・JSON に変換するために下記のような処理が使われます。

- `Model::toArray()`
	- 属性（DB カラム）とリレーション、アクセサ（`getXxxAttribute`）などを組み合わせて配列を返す。
- `response()->json(['user' => $user])` を呼ぶと内部で `toArray()` が使われます。
- `Model::toJson()` / `json_encode($model)` は `toArray()` を元に JSON を作成します。

あなたの User モデルでは `toArray()` をオーバーライドしており、`parent::toArray()` に加えて明示的に

```php
'is_active' => $this->is_active,
```

を merge しています。ここで `$this->is_active` はアクセサ（`getIsActiveAttribute()`）を呼びます。

## 「アクセサが評価される」とは何か？（技術説明）

Eloquent のアクセサは `getFooAttribute()` の形式で定義します。プロパティアクセス `$user->foo` を行うとアクセサが自動で呼ばれます。

シリアライズ（`toArray()`）の際、Eloquent は出力すべき属性を収集します。その収集過程で `$this->is_active` のようなアクセサ呼び出しが起こり、戻り値が配列の値になります。

つまり「評価される＝アクセサ関数が実行されて値が計算される」という意味です。

アクセサの特性：

- 動的に計算される（DB に保存されている固定値ではない）。
- 実行タイミングは呼び出し側（ここでは `toArray()` / JSON 変換）による。
- 関連リレーション（`currentSubscription` など）に依存する場合、リレーションが未ロードだとアクセサがクエリを発行する可能性があります（遅延ローディング）。逆に eager-load されていれば追加クエリは発生しません。

今回のログイン処理で何が起きるのか（具体フロー）

- `Auth::attempt($credentials)` 成功 → Laravel が現在のリクエストに対する認証ユーザーをセット。
- `$user = Auth::user();` で Eloquent インスタンスを取得。
- `User::booted()` 内の global scope 'with' があるため、`currentSubscription`（と `adminUser`, `plan`）はデフォルトで eager-load されます。つまりアクセサが参照する関連は既にメモリ上にある可能性が高いです。
- コントローラで `response()->json(['user' => $user, ...])` を返す。
- レスポンス作成で `toArray()` が呼ばれ、`toArray()` 内の `'is_active' => $this->is_active` により `getIsActiveAttribute()` が実行される。
- `getIsActiveAttribute()` は `currentSubscription` や `adminUser` 等を使って `true/false` を計算 → その結果が JSON の `user.is_active` としてクライアントに返る。

重要：アクセサは「その moment（`toArray` 呼び出し時）」の情報で計算するため、直前に DB が更新されていれば最新が反映されます。逆に DB 更新が遅れていれば古い結果が返ります。

## 補足・実務的注意点

### リレーションのロード

アクセサがリレーション（`currentSubscription`）を参照する場合、アクセサが実行されるとリレーションが未ロードなら追加の DB クエリが走ります（遅延ロード）。global scope 'with' により eager-load されていれば余計なクエリは発生しません。

### アクセサは副作用を持たせない

アクセサは「読み取り専用の計算」に使うべきです。アクセサ内で DB を更新したり外部副作用を起こすと、シリアライズ時（レスポンス作成時）に意図しない副作用が発生します。

### 即時反映させたい場合

ログイン直後に必ず最新判定したいなら、`Auth::user()->refresh()` や `Auth::user()->load('currentSubscription')` を呼ぶことで最新の関連と属性を強制ロードできます。

### JSON に含めたくない属性は $hidden、自動的に付けたいアクセサは $appends を使う

例：`protected $appends = ['is_active'];` とすると `toArray()` に自動で追加される（ただし今回 `toArray()` で明示的に追加しているので同等の扱い）。

## まとめ（短く）

- 「シリアライズ時」＝モデルを配列/JSON に変換するその瞬間（`toArray()` / `response()->json()` 等）です。
- 「アクセサが評価される」＝そのシリアライズの過程で `getIsActiveAttribute()` が実行され、計算結果が `is_active` として配列／JSON に含まれる、という意味です。
- ログインレスポンスはまさにそのケースで、`Auth::user()` の `toArray()` が呼ばれるタイミングでアクセサが実行されるため、レスポンスに `is_active` が含まれます。