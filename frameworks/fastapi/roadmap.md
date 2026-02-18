# FastAPI 学習ロードマップ

Pythonの高速WebフレームワークFastAPIを体系的に学習するためのガイド。型ヒントを活用した自動バリデーション・自動ドキュメント生成を中心に、基礎から実践的な開発スキルまで段階的に習得していく。

---

## 目次

1. [全体像：FastAPIの学習フロー](#全体像fastapiの学習フロー)
1. [Phase 1: 基礎準備と前提知識（1〜2週間）](#phase-1-基礎準備と前提知識12週間)
1. [Phase 2: FastAPIコア基礎（3〜4週間）](#phase-2-fastapiコア基礎34週間)
1. [Phase 3: 中級トピック（4〜5週間）](#phase-3-中級トピック45週間)
1. [Phase 4: 上級トピック（3〜4週間）](#phase-4-上級トピック34週間)
1. [学習リソース](#学習リソース)
1. [学習のコツ](#学習のコツ)
1. [チェックリスト活用法](#チェックリスト活用法)

---

## 全体像：FastAPIの学習フロー

```mermaid
flowchart TD
    subgraph Phase1["Phase 1: 前提知識"]
        Python[Python基礎・型ヒント]
        Async[async/await]
        HTTP[HTTP & REST基礎]
        Env[環境構築]
    end

    subgraph Phase2["Phase 2: コア基礎"]
        Endpoint[エンドポイント定義]
        Pydantic[Pydanticモデル]
        Validation[バリデーション]
        Response[レスポンス]
        FormFile[フォーム・ファイル]
        ErrorHandling[エラーハンドリング]
    end

    subgraph Phase3["Phase 3: 中級"]
        DI[依存性注入]
        Auth[認証・認可 OAuth2/JWT]
        DB[DB統合 SQLAlchemy/SQLModel]
        Middleware[ミドルウェア]
        Background[バックグラウンドタスク]
        Structure[大規模構成]
    end

    subgraph Phase4["Phase 4: 上級"]
        WebSocket[WebSocket]
        Testing[テスト pytest]
        Settings[設定管理]
        CustomResponse[カスタムレスポンス]
        Deploy[デプロイ Docker/Uvicorn]
        OpenAPI[OpenAPIカスタマイズ]
    end

    Phase1 --> Phase2
    Phase2 --> Phase3
    Phase3 --> Phase4
```

### FastAPIリクエストライフサイクル

FastAPIがリクエストを処理する流れを理解することで、各コンポーネントの役割が明確になる。

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant ASGI as ASGI Server (Uvicorn)
    participant MW as ミドルウェア
    participant Router as Router
    participant Deps as 依存性注入
    participant Endpoint as エンドポイント関数
    participant Pydantic as Pydanticモデル
    participant DB as データベース

    Client->>ASGI: HTTPリクエスト
    ASGI->>MW: リクエスト処理
    MW->>Router: ルートマッチング
    Router->>Deps: 依存関係の解決
    Deps->>Endpoint: パラメータ注入
    Endpoint->>Pydantic: リクエストボディのバリデーション
    Pydantic-->>Endpoint: バリデーション済みデータ
    Endpoint->>DB: データ操作
    DB-->>Endpoint: 結果
    Endpoint->>Pydantic: レスポンスモデルでシリアライズ
    Pydantic-->>MW: JSONレスポンス
    MW-->>Client: HTTPレスポンス
```

---

## Phase 1: 基礎準備と前提知識（1〜2週間）

FastAPIを効果的に学ぶために必要な前提知識を固める。

### 1.1 Python基礎と型ヒント

FastAPIは型ヒントをフル活用してバリデーションやドキュメント生成を自動化する。型ヒントの理解が最重要。

#### 基本的な型ヒント

```python
# プリミティブ型
name: str = "田中太郎"
age: int = 30
is_active: bool = True
price: float = 1980.5

# 関数の引数と戻り値
def greet(name: str) -> str:
    return f"こんにちは、{name}さん！"

# Optional（Noneを許容）
from typing import Optional

def find_user(user_id: int) -> Optional[str]:
    if user_id == 1:
        return "田中太郎"
    return None
```

#### コレクション型

```python
from typing import List, Dict, Set, Tuple

# リスト
def get_names() -> List[str]:
    return ["田中", "山田", "佐藤"]

# 辞書
def get_scores() -> Dict[str, int]:
    return {"田中": 90, "山田": 85}

# Python 3.9以降はビルトイン型をそのまま使える
def get_names() -> list[str]:
    return ["田中", "山田", "佐藤"]

def get_scores() -> dict[str, int]:
    return {"田中": 90, "山田": 85}
```

#### Union型

```python
from typing import Union

# 複数の型を許容
def process_id(id: Union[int, str]) -> str:
    return str(id)

# Python 3.10以降はパイプ演算子が使える
def process_id(id: int | str) -> str:
    return str(id)
```

#### なぜ型ヒントが重要か

- **FastAPIの自動バリデーション**: 型ヒントに基づいてリクエストデータを自動検証
- **ドキュメント自動生成**: OpenAPI（Swagger）ドキュメントに型情報が反映
- **エディタ補完**: IDEの自動補完が効くようになる
- **バグの早期発見**: 型チェッカー（mypy等）で静的解析が可能

#### 学習目標

- [ ] 基本的な型ヒント（str, int, bool, float）を書ける
- [ ] Optional, Union, List, Dict を使える
- [ ] 関数の引数と戻り値に型ヒントを付けられる
- [ ] 型ヒントがFastAPIでどう活用されるか説明できる

---

### 1.2 デコレータ

FastAPIではデコレータでルーティングやDIを定義する。

#### 基本的なデコレータ

```python
import time

# 関数デコレータ
def timer(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__}: {end - start:.3f}秒")
        return result
    return wrapper

@timer
def slow_function():
    time.sleep(1)
    return "完了"

slow_function()  # slow_function: 1.003秒
```

#### 引数付きデコレータ

```python
def repeat(n: int):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for _ in range(n):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(3)
def say_hello():
    print("Hello!")

say_hello()  # Hello! が3回出力
```

#### FastAPIでのデコレータ活用例

```python
from fastapi import FastAPI

app = FastAPI()

# @app.get() がデコレータ
@app.get("/")
def read_root():
    return {"message": "Hello World"}

# HTTPメソッドに対応するデコレータ
@app.get("/items/{item_id}")
@app.post("/items")
@app.put("/items/{item_id}")
@app.delete("/items/{item_id}")
```

#### 学習目標

- [ ] デコレータの仕組みを説明できる
- [ ] FastAPIのルーティングデコレータを理解している
- [ ] 引数付きデコレータの構造を理解している

---

### 1.3 async/awaitと非同期処理

FastAPIは非同期処理に対応しており、I/O待ちの多い処理を効率的に実行できる。

#### async/awaitの基本

```python
import asyncio

# 同期関数
def sync_fetch_data():
    # I/O待ちでスレッドがブロックされる
    import time
    time.sleep(1)
    return {"data": "結果"}

# 非同期関数
async def async_fetch_data():
    # I/O待ち中に他の処理を実行可能
    await asyncio.sleep(1)
    return {"data": "結果"}

# 複数の非同期処理を並行実行
async def fetch_all():
    results = await asyncio.gather(
        async_fetch_data(),
        async_fetch_data(),
        async_fetch_data(),
    )
    return results  # 約1秒で3つの結果が返る
```

#### 同期 vs 非同期の比較

```mermaid
sequenceDiagram
    participant Main as メインスレッド

    Note over Main: 【同期処理】合計3秒
    Main->>Main: タスクA（1秒待ち）
    Main->>Main: タスクB（1秒待ち）
    Main->>Main: タスクC（1秒待ち）

    Note over Main: 【非同期処理】合計1秒
    Main->>Main: タスクA, B, C を同時開始
    Main->>Main: 全タスク完了待ち（1秒）
```

#### FastAPIでの使い分け

```python
from fastapi import FastAPI

app = FastAPI()

# 非同期エンドポイント（I/O処理が多い場合に推奨）
@app.get("/async-items")
async def get_items_async():
    items = await fetch_items_from_db()
    return items

# 同期エンドポイント（CPU処理やレガシーライブラリ使用時）
@app.get("/sync-items")
def get_items_sync():
    items = fetch_items_from_db_sync()
    return items
```

なぜFastAPIで非同期が重要か：

- **高スループット**: I/O待ち中に他のリクエストを処理
- **リソース効率**: スレッドを大量に作る必要がない
- **リアルタイム対応**: WebSocketなどに不可欠
- **互換性**: 同期関数もそのまま使えるので段階的に移行可能

#### 学習目標

- [ ] async/awaitの基本的な使い方がわかる
- [ ] 非同期処理のメリットを説明できる
- [ ] FastAPIで非同期/同期エンドポイントの使い分けを理解している
- [ ] asyncio.gatherで並行処理ができる

---

### 1.4 HTTP & REST基礎

#### HTTPメソッド

| メソッド | 用途 | 冪等性 | 安全性 |
|---------|------|--------|--------|
| GET | リソース取得 | Yes | Yes |
| POST | リソース作成 | No | No |
| PUT | リソース完全置換 | Yes | No |
| PATCH | リソース部分更新 | No | No |
| DELETE | リソース削除 | Yes | No |

#### ステータスコード

| コード | 意味 | 使用場面 |
|--------|------|---------|
| 200 | OK | 成功 |
| 201 | Created | リソース作成成功 |
| 204 | No Content | 成功（レスポンスボディなし） |
| 301 | Moved Permanently | 恒久的リダイレクト |
| 302 | Found | 一時的リダイレクト |
| 400 | Bad Request | リクエスト不正 |
| 401 | Unauthorized | 認証エラー |
| 403 | Forbidden | 権限エラー |
| 404 | Not Found | リソース未発見 |
| 422 | Unprocessable Entity | バリデーションエラー |
| 500 | Internal Server Error | サーバーエラー |

#### RESTful API設計

```
GET    /api/users          → ユーザー一覧
POST   /api/users          → ユーザー作成
GET    /api/users/{id}     → ユーザー詳細
PUT    /api/users/{id}     → ユーザー更新（全項目）
PATCH  /api/users/{id}     → ユーザー更新（一部項目）
DELETE /api/users/{id}     → ユーザー削除
GET    /api/users/{id}/posts → ユーザーの投稿一覧
```

#### 学習目標

- [ ] HTTPメソッドの使い分けを説明できる
- [ ] 主要なステータスコードの意味を理解している
- [ ] RESTful APIの設計原則を理解している

---

### 1.5 開発環境セットアップ

#### 推奨環境

| ツール | 説明 |
|--------|------|
| Python 3.10+ | FastAPIの推奨バージョン |
| pip / uv | パッケージ管理 |
| venv / Poetry | 仮想環境管理 |
| VS Code + Pylance | 推奨エディタ |
| Uvicorn | ASGIサーバー |

#### プロジェクト作成

```bash
# プロジェクトディレクトリ作成
mkdir my-fastapi-app && cd my-fastapi-app

# 仮想環境の作成・有効化
python -m venv .venv
source .venv/bin/activate  # macOS/Linux
# .venv\Scripts\activate   # Windows

# パッケージインストール
pip install fastapi uvicorn[standard]

# 開発用ツール
pip install ruff mypy pytest httpx
```

#### 最小限のアプリケーション

```python
# main.py
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, FastAPI!"}
```

```bash
# 開発サーバー起動
uvicorn main:app --reload

# http://127.0.0.1:8000 でアクセス可能
# http://127.0.0.1:8000/docs でSwagger UIが表示
# http://127.0.0.1:8000/redoc でReDocが表示
```

#### プロジェクト構造（シンプル版）

```
my-fastapi-app/
├── main.py            # エントリーポイント
├── requirements.txt   # 依存パッケージ
├── .venv/             # 仮想環境
└── .gitignore
```

#### なぜUvicornが必要か

FastAPIはASGI（Asynchronous Server Gateway Interface）フレームワーク。Uvicornはそのサーバー実装で、非同期処理を実行する基盤となる。

| サーバー | 説明 |
|---------|------|
| Uvicorn | 軽量ASGIサーバー（開発・本番） |
| Hypercorn | HTTP/2対応ASGIサーバー |
| Gunicorn + Uvicorn | 本番環境でのワーカー管理 |

#### 学習目標

- [ ] Python仮想環境を作成・管理できる
- [ ] FastAPIプロジェクトを作成・起動できる
- [ ] Swagger UI（/docs）にアクセスして確認できる
- [ ] Uvicornの役割を説明できる

---

## Phase 2: FastAPIコア基礎（3〜4週間）

FastAPIの基本的な機能を習得する。

### 2.1 エンドポイント定義とパスパラメータ

#### 基本的なエンドポイント

```python
from fastapi import FastAPI

app = FastAPI()

# GETメソッド
@app.get("/")
def root():
    return {"message": "Hello World"}

# POSTメソッド
@app.post("/items")
def create_item():
    return {"message": "Item created"}

# PUT, DELETE なども同様
@app.put("/items/{item_id}")
def update_item(item_id: int):
    return {"item_id": item_id, "message": "Updated"}

@app.delete("/items/{item_id}")
def delete_item(item_id: int):
    return {"message": "Deleted"}
```

#### パスパラメータ

```python
# 型指定あり（自動バリデーション）
@app.get("/users/{user_id}")
def get_user(user_id: int):
    return {"user_id": user_id}
# /users/42 → {"user_id": 42}
# /users/abc → 422 Unprocessable Entity（自動エラー）

# 文字列パラメータ
@app.get("/items/{item_name}")
def get_item(item_name: str):
    return {"item_name": item_name}
```

#### パスパラメータの順序に注意

```python
# 固定パスを先に定義する（順序が重要）
@app.get("/users/me")  # ← 先に定義
def get_current_user():
    return {"user": "current"}

@app.get("/users/{user_id}")  # ← 後に定義
def get_user(user_id: int):
    return {"user_id": user_id}
# /users/me → get_current_user が呼ばれる
```

#### Enumを使った制約

```python
from enum import Enum

class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"

@app.get("/models/{model_name}")
def get_model(model_name: ModelName):
    if model_name is ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}
    return {"model_name": model_name}
# /models/alexnet → OK
# /models/unknown → 422 エラー（選択肢が表示される）
```

#### 学習目標

- [ ] 各HTTPメソッドのエンドポイントを定義できる
- [ ] パスパラメータで型指定と自動バリデーションを利用できる
- [ ] パスの定義順序の重要性を理解している
- [ ] Enumで選択肢を制約できる

---

### 2.2 クエリパラメータ

#### 基本的なクエリパラメータ

```python
from typing import Optional

# クエリパラメータはパスに含まれないパラメータ
@app.get("/items")
def list_items(skip: int = 0, limit: int = 10):
    return {"skip": skip, "limit": limit}
# /items → {"skip": 0, "limit": 10}
# /items?skip=20&limit=50 → {"skip": 20, "limit": 50}

# Optional パラメータ
@app.get("/items/search")
def search_items(q: Optional[str] = None):
    if q:
        return {"results": f"'{q}' の検索結果"}
    return {"results": "全件表示"}
# /items/search → {"results": "全件表示"}
# /items/search?q=python → {"results": "'python' の検索結果"}
```

#### 必須クエリパラメータ

```python
# デフォルト値なし = 必須パラメータ
@app.get("/items/filter")
def filter_items(category: str, min_price: float):
    return {"category": category, "min_price": min_price}
# /items/filter → 422 エラー（categoryとmin_priceが必須）
# /items/filter?category=books&min_price=1000 → OK
```

#### パスパラメータとクエリパラメータの組み合わせ

```python
@app.get("/users/{user_id}/items")
def get_user_items(
    user_id: int,           # パスパラメータ
    skip: int = 0,          # クエリパラメータ（任意）
    limit: int = 10,        # クエリパラメータ（任意）
    q: Optional[str] = None # クエリパラメータ（任意）
):
    return {
        "user_id": user_id,
        "skip": skip,
        "limit": limit,
        "q": q,
    }
# /users/1/items?skip=5&q=test
```

#### 学習目標

- [ ] クエリパラメータを定義できる
- [ ] 必須/任意の使い分けができる
- [ ] パスパラメータとクエリパラメータを組み合わせられる

---

### 2.3 Pydanticモデルとリクエストボディ

FastAPIの最大の強みの一つ。Pydanticモデルでリクエストボディの定義とバリデーションを行う。

#### 基本的なPydanticモデル

```python
from pydantic import BaseModel
from typing import Optional

class ItemCreate(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None

@app.post("/items")
def create_item(item: ItemCreate):
    item_dict = item.model_dump()
    if item.tax:
        item_dict["price_with_tax"] = item.price + item.tax
    return item_dict
```

リクエスト例：

```json
{
    "name": "ノートパソコン",
    "description": "高性能ラップトップ",
    "price": 150000,
    "tax": 15000
}
```

#### ネストされたモデル

```python
from pydantic import BaseModel
from typing import List, Optional

class Address(BaseModel):
    street: str
    city: str
    zip_code: str

class UserCreate(BaseModel):
    name: str
    email: str
    age: Optional[int] = None
    addresses: List[Address] = []

@app.post("/users")
def create_user(user: UserCreate):
    return user
```

リクエスト例：

```json
{
    "name": "田中太郎",
    "email": "tanaka@example.com",
    "age": 30,
    "addresses": [
        {
            "street": "1-2-3 Shibuya",
            "city": "Tokyo",
            "zip_code": "150-0002"
        }
    ]
}
```

#### リクエストボディ + パスパラメータ + クエリパラメータ

```python
@app.put("/items/{item_id}")
def update_item(
    item_id: int,              # パスパラメータ
    item: ItemCreate,          # リクエストボディ
    q: Optional[str] = None    # クエリパラメータ
):
    result = {"item_id": item_id, **item.model_dump()}
    if q:
        result["q"] = q
    return result
```

なぜPydanticが強力か：

- **自動バリデーション**: 型が合わなければ422エラーを自動返却
- **自動変換**: 文字列"42"をintの42に変換
- **ドキュメント生成**: Swagger UIにスキーマが自動反映
- **シリアライズ**: `model_dump()`でdict化、`model_dump_json()`でJSON化

#### 学習目標

- [ ] Pydanticモデルを定義してリクエストボディを受け取れる
- [ ] ネストされたモデルを扱える
- [ ] パスパラメータ・クエリパラメータと組み合わせられる
- [ ] Pydanticの自動バリデーションの利点を説明できる

---

### 2.4 バリデーション

#### Fieldによるバリデーション

```python
from pydantic import BaseModel, Field

class Item(BaseModel):
    name: str = Field(
        ...,                           # 必須
        min_length=1,
        max_length=100,
        examples=["ノートパソコン"]
    )
    description: str | None = Field(
        default=None,
        max_length=500,
        title="商品説明"
    )
    price: float = Field(
        ...,
        gt=0,                          # 0より大きい
        le=1000000,                    # 100万以下
        description="商品価格（税抜）"
    )
    quantity: int = Field(
        default=1,
        ge=1,                          # 1以上
        le=100                         # 100以下
    )
```

#### よく使うFieldの制約

| パラメータ | 説明 | 型 |
|-----------|------|-----|
| `min_length` | 最小文字数 | str |
| `max_length` | 最大文字数 | str |
| `pattern` | 正規表現パターン | str |
| `gt` | より大きい（>） | 数値 |
| `ge` | 以上（>=） | 数値 |
| `lt` | より小さい（<） | 数値 |
| `le` | 以下（<=） | 数値 |
| `multiple_of` | 倍数 | 数値 |

#### クエリパラメータのバリデーション

```python
from fastapi import Query

@app.get("/items")
def list_items(
    q: str | None = Query(
        default=None,
        min_length=3,
        max_length=50,
        pattern="^[a-zA-Z0-9]+$",
        title="検索クエリ",
        description="商品名で検索（英数字のみ）",
    ),
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=10, ge=1, le=100),
):
    return {"q": q, "skip": skip, "limit": limit}
```

#### パスパラメータのバリデーション

```python
from fastapi import Path

@app.get("/items/{item_id}")
def get_item(
    item_id: int = Path(
        ...,
        title="商品ID",
        ge=1,
        le=1000000,
    )
):
    return {"item_id": item_id}
```

#### カスタムバリデータ

```python
from pydantic import BaseModel, field_validator, model_validator

class UserCreate(BaseModel):
    name: str
    email: str
    password: str
    password_confirm: str

    @field_validator("email")
    @classmethod
    def validate_email(cls, v: str) -> str:
        if "@" not in v:
            raise ValueError("有効なメールアドレスを入力してください")
        return v.lower()

    @model_validator(mode="after")
    def check_passwords_match(self):
        if self.password != self.password_confirm:
            raise ValueError("パスワードが一致しません")
        return self
```

#### 学習目標

- [ ] Fieldでモデルのバリデーションルールを設定できる
- [ ] QueryとPathでパラメータのバリデーションができる
- [ ] カスタムバリデータを作成できる
- [ ] バリデーションエラー時のレスポンス構造を理解している

---

### 2.5 レスポンスモデル

#### レスポンスモデルの定義

```python
from pydantic import BaseModel
from typing import List

class ItemResponse(BaseModel):
    id: int
    name: str
    price: float
    description: str | None = None

# response_model でレスポンスの型を指定
@app.get("/items/{item_id}", response_model=ItemResponse)
def get_item(item_id: int):
    # DBから取得した結果（パスワード等の不要なフィールドを含む可能性）
    return {
        "id": item_id,
        "name": "ノートPC",
        "price": 150000,
        "description": "高性能",
        "internal_code": "SECRET123"  # response_modelにないので除外される
    }
```

なぜresponse_modelが重要か：

- **データフィルタリング**: 不要なフィールド（パスワード等）を自動除外
- **ドキュメント生成**: レスポンスのスキーマがSwagger UIに反映
- **型チェック**: レスポンスデータの整合性を保証

#### 作成・更新・参照用のモデル分離

```python
from pydantic import BaseModel

# 共通の基底モデル
class ItemBase(BaseModel):
    name: str
    description: str | None = None
    price: float

# 作成用（IDなし）
class ItemCreate(ItemBase):
    pass

# 更新用（全フィールドOptional）
class ItemUpdate(BaseModel):
    name: str | None = None
    description: str | None = None
    price: float | None = None

# レスポンス用（ID付き）
class ItemResponse(ItemBase):
    id: int

    model_config = {"from_attributes": True}  # ORMモデルからの変換を許可


@app.post("/items", response_model=ItemResponse, status_code=201)
def create_item(item: ItemCreate):
    # DB保存処理
    return {"id": 1, **item.model_dump()}

@app.patch("/items/{item_id}", response_model=ItemResponse)
def update_item(item_id: int, item: ItemUpdate):
    # 部分更新処理
    stored = get_item_from_db(item_id)
    update_data = item.model_dump(exclude_unset=True)
    return {**stored, **update_data}

@app.get("/items", response_model=List[ItemResponse])
def list_items():
    return get_all_items_from_db()
```

#### ステータスコードの指定

```python
from fastapi import status

@app.post("/items", status_code=status.HTTP_201_CREATED)
def create_item(item: ItemCreate):
    return {"id": 1, **item.model_dump()}

@app.delete("/items/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_item(item_id: int):
    # 削除処理
    return None
```

#### 学習目標

- [ ] response_modelでレスポンスの型を指定できる
- [ ] 作成・更新・参照用のモデルを分離できる
- [ ] status_codeを適切に設定できる
- [ ] exclude_unsetを使った部分更新を理解している

---

### 2.6 フォームデータとファイルアップロード

#### フォームデータの受け取り

```python
from fastapi import Form

@app.post("/login")
def login(
    username: str = Form(...),
    password: str = Form(...),
):
    return {"username": username}
```

なぜFormを使うのか：
HTMLフォーム（`application/x-www-form-urlencoded`）はJSONとは異なるエンコーディングを使う。`Form`を使うことでFastAPIがこの形式を正しくパースする。

#### ファイルアップロード

```python
from fastapi import File, UploadFile

# シンプルなファイルアップロード
@app.post("/uploadfile")
async def upload_file(file: UploadFile):
    contents = await file.read()
    return {
        "filename": file.filename,
        "content_type": file.content_type,
        "size": len(contents),
    }

# 複数ファイルのアップロード
@app.post("/uploadfiles")
async def upload_files(files: list[UploadFile]):
    return {"filenames": [f.filename for f in files]}

# ファイル + フォームデータ
@app.post("/items/with-image")
async def create_item_with_image(
    name: str = Form(...),
    price: float = Form(...),
    image: UploadFile = File(...),
):
    return {
        "name": name,
        "price": price,
        "image_filename": image.filename,
    }
```

#### UploadFileの主要プロパティ・メソッド

| プロパティ/メソッド | 説明 |
|-------------------|------|
| `filename` | アップロードされたファイル名 |
| `content_type` | MIMEタイプ（例: image/png） |
| `read()` | ファイル内容を読み取り |
| `write(data)` | データを書き込み |
| `seek(offset)` | ファイルポインタを移動 |
| `close()` | ファイルを閉じる |

#### 学習目標

- [ ] フォームデータを受け取れる
- [ ] ファイルアップロードを実装できる
- [ ] UploadFileのプロパティを理解している

---

### 2.7 エラーハンドリング

#### HTTPExceptionの使用

```python
from fastapi import HTTPException, status

@app.get("/items/{item_id}")
def get_item(item_id: int):
    if item_id not in items_db:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="商品が見つかりません",
        )
    return items_db[item_id]

# カスタムヘッダー付き
@app.get("/protected")
def protected_route():
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="認証が必要です",
        headers={"WWW-Authenticate": "Bearer"},
    )
```

#### カスタム例外ハンドラ

```python
from fastapi import Request
from fastapi.responses import JSONResponse

# カスタム例外クラス
class ItemNotFoundException(Exception):
    def __init__(self, item_id: int):
        self.item_id = item_id

# 例外ハンドラを登録
@app.exception_handler(ItemNotFoundException)
async def item_not_found_handler(request: Request, exc: ItemNotFoundException):
    return JSONResponse(
        status_code=404,
        content={
            "error": "ItemNotFound",
            "message": f"商品ID {exc.item_id} は存在しません",
        },
    )

@app.get("/items/{item_id}")
def get_item(item_id: int):
    if item_id not in items_db:
        raise ItemNotFoundException(item_id)
    return items_db[item_id]
```

#### バリデーションエラーのカスタマイズ

```python
from fastapi.exceptions import RequestValidationError

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    errors = []
    for error in exc.errors():
        errors.append({
            "field": " -> ".join(str(loc) for loc in error["loc"]),
            "message": error["msg"],
            "type": error["type"],
        })
    return JSONResponse(
        status_code=422,
        content={"detail": "入力データにエラーがあります", "errors": errors},
    )
```

#### 学習目標

- [ ] HTTPExceptionで適切なエラーレスポンスを返せる
- [ ] カスタム例外ハンドラを登録できる
- [ ] バリデーションエラーのカスタマイズができる

---

## Phase 3: 中級トピック（4〜5週間）

より実践的な機能を習得する。

### 3.1 依存性注入（Dependency Injection）

FastAPIの最も強力な機能の一つ。コードの再利用性とテスト容易性を高める。

#### 基本的な依存性注入

```python
from fastapi import Depends

# 依存関数
def common_parameters(
    q: str | None = None,
    skip: int = 0,
    limit: int = 100,
):
    return {"q": q, "skip": skip, "limit": limit}

@app.get("/items")
def list_items(commons: dict = Depends(common_parameters)):
    return {"params": commons}

@app.get("/users")
def list_users(commons: dict = Depends(common_parameters)):
    return {"params": commons}
```

#### クラスベースの依存性

```python
class Pagination:
    def __init__(self, skip: int = 0, limit: int = 10):
        self.skip = skip
        self.limit = limit

@app.get("/items")
def list_items(pagination: Pagination = Depends()):
    return {"skip": pagination.skip, "limit": pagination.limit}
```

#### 依存関係のチェーン

```python
def get_db():
    db = SessionLocal()
    try:
        yield db  # yieldで依存関係を返し、処理後にクリーンアップ
    finally:
        db.close()

def get_current_user(db = Depends(get_db)):
    user = db.query(User).first()
    if not user:
        raise HTTPException(status_code=401, detail="認証エラー")
    return user

def get_current_active_user(user = Depends(get_current_user)):
    if not user.is_active:
        raise HTTPException(status_code=400, detail="無効なユーザー")
    return user

@app.get("/users/me")
def read_current_user(user = Depends(get_current_active_user)):
    return user
```

#### 依存関係のフロー

```mermaid
flowchart TD
    Request[リクエスト] --> DB[get_db]
    DB --> User[get_current_user]
    User --> Active[get_current_active_user]
    Active --> Endpoint[エンドポイント関数]
    Endpoint --> Response[レスポンス]
    Response --> Cleanup[DB接続クローズ yield後の処理]
```

#### ルーターレベルの依存性

```python
from fastapi import APIRouter

# ルーター全体に依存性を適用
router = APIRouter(
    prefix="/admin",
    dependencies=[Depends(get_current_active_user)],
)

@router.get("/dashboard")
def admin_dashboard():
    return {"message": "管理者ダッシュボード"}

@router.get("/users")
def admin_users():
    return {"message": "ユーザー管理"}
```

なぜ依存性注入が重要か：

- **コード再利用**: 共通処理を複数のエンドポイントで共有
- **関心の分離**: 認証・DB接続などをエンドポイントから分離
- **テスト容易性**: 依存関数をモックに差し替え可能
- **自動クリーンアップ**: `yield`でリソースの確実な解放

#### 学習目標

- [ ] Dependsで依存性を注入できる
- [ ] yieldを使ったリソース管理ができる
- [ ] 依存関係のチェーンを構築できる
- [ ] ルーターレベルの依存性を設定できる

---

### 3.2 認証・認可（OAuth2 / JWT）

#### OAuth2 パスワードフロー

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from passlib.context import CryptContext
from datetime import datetime, timedelta
from pydantic import BaseModel

# 設定
SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# パスワードハッシュ
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# OAuth2スキーム
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# モデル
class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: str | None = None

class User(BaseModel):
    username: str
    email: str
    is_active: bool = True
```

#### トークン生成

```python
def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)
```

#### 認証エンドポイントとユーザー取得

```python
async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="認証情報が無効です",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = get_user_from_db(username)
    if user is None:
        raise credentials_exception
    return user

@app.post("/token", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="ユーザー名またはパスワードが正しくありません",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = create_access_token(
        data={"sub": user.username},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES),
    )
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/users/me", response_model=User)
async def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user
```

#### 認証フロー

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant API as FastAPI
    participant DB as データベース

    Client->>API: POST /token (username, password)
    API->>DB: ユーザー検索
    DB-->>API: ユーザー情報
    API->>API: パスワード検証
    API->>API: JWTトークン生成
    API-->>Client: {"access_token": "xxx", "token_type": "bearer"}

    Client->>API: GET /users/me (Authorization: Bearer xxx)
    API->>API: JWTトークン検証
    API->>DB: ユーザー取得
    DB-->>API: ユーザー情報
    API-->>Client: ユーザー情報
```

#### スコープによる認可

```python
from fastapi.security import SecurityScopes

oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="token",
    scopes={
        "users:read": "ユーザー情報の読み取り",
        "users:write": "ユーザー情報の書き込み",
        "admin": "管理者権限",
    },
)

async def get_current_user(
    security_scopes: SecurityScopes,
    token: str = Depends(oauth2_scheme),
):
    # トークンからスコープを取得して検証
    payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    token_scopes = payload.get("scopes", [])

    for scope in security_scopes.scopes:
        if scope not in token_scopes:
            raise HTTPException(
                status_code=403,
                detail="権限が不足しています",
            )
    # ...

@app.get("/users/me", dependencies=[Security(get_current_user, scopes=["users:read"])])
async def read_users_me():
    pass
```

#### 学習目標

- [ ] OAuth2パスワードフローを実装できる
- [ ] JWTトークンの生成・検証ができる
- [ ] パスワードハッシュを使ったセキュアな認証ができる
- [ ] スコープベースの認可を理解している

---

### 3.3 データベース統合（SQLAlchemy / SQLModel）

#### SQLAlchemyとの統合

```python
# database.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, DeclarativeBase

SQLALCHEMY_DATABASE_URL = "sqlite:///./app.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},  # SQLite用
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

class Base(DeclarativeBase):
    pass
```

```python
# models.py
from sqlalchemy import Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=True)

    items = relationship("Item", back_populates="owner")

class Item(Base):
    __tablename__ = "items"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(String)
    owner_id = Column(Integer, ForeignKey("users.id"))

    owner = relationship("User", back_populates="items")
```

```python
# schemas.py（Pydanticモデル）
from pydantic import BaseModel

class ItemBase(BaseModel):
    title: str
    description: str | None = None

class ItemCreate(ItemBase):
    pass

class ItemResponse(ItemBase):
    id: int
    owner_id: int

    model_config = {"from_attributes": True}

class UserBase(BaseModel):
    email: str

class UserCreate(UserBase):
    password: str

class UserResponse(UserBase):
    id: int
    is_active: bool
    items: list[ItemResponse] = []

    model_config = {"from_attributes": True}
```

```python
# crud.py
from sqlalchemy.orm import Session
import models, schemas

def get_user(db: Session, user_id: int):
    return db.query(models.User).filter(models.User.id == user_id).first()

def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.User).offset(skip).limit(limit).all()

def create_user(db: Session, user: schemas.UserCreate):
    hashed_password = get_password_hash(user.password)
    db_user = models.User(email=user.email, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
```

```python
# main.py
from fastapi import Depends
from sqlalchemy.orm import Session
from database import SessionLocal, engine
import models

models.Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/users", response_model=schemas.UserResponse)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    return crud.create_user(db=db, user=user)

@app.get("/users", response_model=list[schemas.UserResponse])
def list_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return crud.get_users(db, skip=skip, limit=limit)
```

#### SQLModelとの統合

SQLModelはSQLAlchemyとPydanticを統合したライブラリ。モデル定義が一元化できる。

```python
from sqlmodel import SQLModel, Field, Relationship, Session, create_engine, select

# モデル定義（SQLAlchemy + Pydantic が統合）
class UserBase(SQLModel):
    email: str = Field(unique=True, index=True)
    is_active: bool = True

class User(UserBase, table=True):
    id: int | None = Field(default=None, primary_key=True)
    hashed_password: str
    items: list["Item"] = Relationship(back_populates="owner")

class UserCreate(UserBase):
    password: str

class UserPublic(UserBase):
    id: int

class Item(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    title: str = Field(index=True)
    description: str | None = None
    owner_id: int = Field(foreign_key="user.id")
    owner: User | None = Relationship(back_populates="items")

# エンドポイント
@app.get("/users", response_model=list[UserPublic])
def list_users(session: Session = Depends(get_session)):
    return session.exec(select(User)).all()
```

なぜSQLModelか：

- **一元管理**: SQLAlchemyモデルとPydanticスキーマを別々に定義する必要がない
- **型安全**: FastAPIとの統合がシームレス
- **学習コスト低**: Pydanticの書き方がそのまま使える

#### 学習目標

- [ ] SQLAlchemyでモデルを定義し、FastAPIと統合できる
- [ ] Dependsを使ったDBセッション管理ができる
- [ ] CRUD操作を実装できる
- [ ] SQLModelの利点を理解している

---

### 3.4 ミドルウェア

#### 基本的なミドルウェア

```python
import time
from fastapi import Request

@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)
    return response
```

#### CORSミドルウェア

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "https://example.com",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

なぜCORSが必要か：
ブラウザはセキュリティ上、異なるオリジン（ドメイン・ポート）へのリクエストを制限する。フロントエンドとバックエンドが別オリジンの場合、CORS設定が必須。

#### Trusted Hostミドルウェア

```python
from fastapi.middleware.trustedhost import TrustedHostMiddleware

app.add_middleware(
    TrustedHostMiddleware,
    allowed_hosts=["example.com", "*.example.com"],
)
```

#### GZipミドルウェア

```python
from fastapi.middleware.gzip import GZipMiddleware

app.add_middleware(GZipMiddleware, minimum_size=1000)
```

#### ミドルウェアの実行順序

```mermaid
flowchart TD
    Request[リクエスト] --> MW1[CORS]
    MW1 --> MW2[TrustedHost]
    MW2 --> MW3[GZip]
    MW3 --> MW4[カスタムミドルウェア]
    MW4 --> Endpoint[エンドポイント]
    Endpoint --> MW4b[カスタムミドルウェア]
    MW4b --> MW3b[GZip]
    MW3b --> MW2b[TrustedHost]
    MW2b --> MW1b[CORS]
    MW1b --> Response[レスポンス]
```

ミドルウェアは追加された順序の**逆順**で実行される（最後に追加されたものが最初に実行）。

#### 学習目標

- [ ] カスタムミドルウェアを作成できる
- [ ] CORSミドルウェアを適切に設定できる
- [ ] ミドルウェアの実行順序を理解している

---

### 3.5 バックグラウンドタスク

#### BackgroundTasksの使用

```python
from fastapi import BackgroundTasks

def send_email(email: str, message: str):
    # 時間のかかるメール送信処理
    import time
    time.sleep(3)
    print(f"メール送信完了: {email}")

@app.post("/send-notification")
async def send_notification(
    email: str,
    background_tasks: BackgroundTasks,
):
    background_tasks.add_task(send_email, email, "通知メッセージ")
    return {"message": "通知をバックグラウンドで送信中"}
```

#### 複数のバックグラウンドタスク

```python
def write_log(message: str):
    with open("log.txt", "a") as f:
        f.write(f"{message}\n")

@app.post("/items")
async def create_item(
    item: ItemCreate,
    background_tasks: BackgroundTasks,
):
    # 複数のバックグラウンドタスクを追加
    background_tasks.add_task(send_email, "admin@example.com", f"新商品: {item.name}")
    background_tasks.add_task(write_log, f"商品作成: {item.name}")
    return {"message": "商品を作成しました"}
```

#### 依存性注入でのバックグラウンドタスク

```python
def log_request(background_tasks: BackgroundTasks, q: str | None = None):
    if q:
        background_tasks.add_task(write_log, f"検索クエリ: {q}")

@app.get("/items")
async def list_items(commons: dict = Depends(log_request)):
    return {"items": []}
```

なぜBackgroundTasksを使うか：

- **レスポンスの高速化**: 重い処理を後回しにして即座にレスポンスを返す
- **シンプル**: Celeryなどの外部キューが不要な軽量タスク向き
- **統合**: FastAPIのDIシステムとシームレスに連携

#### 学習目標

- [ ] BackgroundTasksでバックグラウンド処理を実行できる
- [ ] 複数のタスクを登録できる
- [ ] BackgroundTasksとCeleryの使い分けを理解している

---

### 3.6 APIルーターと大規模構成

#### APIRouterの使用

```python
# routers/users.py
from fastapi import APIRouter, Depends

router = APIRouter(
    prefix="/users",
    tags=["users"],               # Swagger UIでグループ化
    responses={404: {"description": "Not Found"}},
)

@router.get("/")
def list_users():
    return [{"username": "tanaka"}, {"username": "yamada"}]

@router.get("/{user_id}")
def get_user(user_id: int):
    return {"user_id": user_id, "username": "tanaka"}

@router.post("/")
def create_user(user: UserCreate):
    return {"username": user.name}
```

```python
# routers/items.py
from fastapi import APIRouter

router = APIRouter(
    prefix="/items",
    tags=["items"],
)

@router.get("/")
def list_items():
    return [{"name": "Item 1"}, {"name": "Item 2"}]
```

```python
# main.py
from fastapi import FastAPI
from routers import users, items

app = FastAPI(title="My API", version="1.0.0")

app.include_router(users.router)
app.include_router(items.router)
```

#### 推奨プロジェクト構造

```
my-fastapi-app/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPIアプリケーション
│   ├── config.py             # 設定管理
│   ├── database.py           # DB接続
│   ├── dependencies.py       # 共通の依存性
│   ├── models/               # SQLAlchemyモデル
│   │   ├── __init__.py
│   │   ├── user.py
│   │   └── item.py
│   ├── schemas/              # Pydanticスキーマ
│   │   ├── __init__.py
│   │   ├── user.py
│   │   └── item.py
│   ├── routers/              # APIルーター
│   │   ├── __init__.py
│   │   ├── users.py
│   │   └── items.py
│   ├── services/             # ビジネスロジック
│   │   ├── __init__.py
│   │   ├── user_service.py
│   │   └── item_service.py
│   └── utils/                # ユーティリティ
│       ├── __init__.py
│       └── security.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   ├── test_users.py
│   └── test_items.py
├── alembic/                  # DBマイグレーション
│   ├── versions/
│   └── env.py
├── alembic.ini
├── requirements.txt
├── Dockerfile
└── docker-compose.yml
```

#### なぜこの構成が推奨されるか

- **関心の分離**: モデル、スキーマ、ルーター、サービスが分離
- **スケーラビリティ**: 新しい機能を追加しやすい
- **テスト容易性**: 各コンポーネントを独立してテスト可能
- **チーム開発**: 複数人での並行開発がしやすい

#### 学習目標

- [ ] APIRouterでエンドポイントを分割できる
- [ ] include_routerでルーターを統合できる
- [ ] 大規模プロジェクトの構成を理解している
- [ ] tagsを使ってSwagger UIでグループ化できる

---

## Phase 4: 上級トピック（3〜4週間）

実運用に向けた高度な機能を習得する。

### 4.1 WebSocket

#### 基本的なWebSocket

```python
from fastapi import WebSocket, WebSocketDisconnect

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            await websocket.send_text(f"受信: {data}")
    except WebSocketDisconnect:
        print("クライアント切断")
```

#### チャットルームの実装例

```python
from fastapi import WebSocket, WebSocketDisconnect
from typing import List

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)

manager = ConnectionManager()

@app.websocket("/ws/chat/{room_id}")
async def chat_endpoint(websocket: WebSocket, room_id: str):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(f"[{room_id}] {data}")
    except WebSocketDisconnect:
        manager.disconnect(websocket)
        await manager.broadcast(f"ユーザーが退出しました")
```

#### WebSocket通信フロー

```mermaid
sequenceDiagram
    participant Client1 as クライアント1
    participant Server as FastAPI Server
    participant Client2 as クライアント2

    Client1->>Server: WebSocket接続要求
    Server->>Client1: 接続承認

    Client2->>Server: WebSocket接続要求
    Server->>Client2: 接続承認

    Client1->>Server: メッセージ送信
    Server->>Client1: ブロードキャスト
    Server->>Client2: ブロードキャスト

    Client1->>Server: 切断
    Server->>Client2: "ユーザーが退出しました"
```

#### 学習目標

- [ ] WebSocketエンドポイントを作成できる
- [ ] 接続管理（accept/disconnect）ができる
- [ ] ブロードキャスト機能を実装できる

---

### 4.2 テスト（pytest）

#### テストのセットアップ

```python
# tests/conftest.py
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.main import app
from app.database import Base, get_db

# テスト用DB
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def override_get_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()

@pytest.fixture
def client():
    Base.metadata.create_all(bind=engine)
    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as c:
        yield c
    Base.metadata.drop_all(bind=engine)
    app.dependency_overrides.clear()
```

#### 基本的なテスト

```python
# tests/test_items.py
def test_create_item(client):
    response = client.post(
        "/items",
        json={"name": "テスト商品", "price": 1000, "description": "説明文"},
    )
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "テスト商品"
    assert data["price"] == 1000
    assert "id" in data

def test_list_items(client):
    # テストデータ作成
    client.post("/items", json={"name": "商品1", "price": 100})
    client.post("/items", json={"name": "商品2", "price": 200})

    response = client.get("/items")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2

def test_get_item_not_found(client):
    response = client.get("/items/999")
    assert response.status_code == 404

def test_create_item_validation_error(client):
    response = client.post(
        "/items",
        json={"name": "", "price": -100},  # バリデーションエラー
    )
    assert response.status_code == 422
```

#### 非同期テスト

```python
# httpxを使った非同期テスト
import pytest
from httpx import AsyncClient, ASGITransport
from app.main import app

@pytest.mark.anyio
async def test_async_root():
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test",
    ) as ac:
        response = await ac.get("/")
    assert response.status_code == 200
```

#### 認証付きテスト

```python
def test_protected_endpoint(client):
    # まずログイン
    login_response = client.post(
        "/token",
        data={"username": "testuser", "password": "testpass"},
    )
    token = login_response.json()["access_token"]

    # 認証付きリクエスト
    response = client.get(
        "/users/me",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert response.status_code == 200
    assert response.json()["username"] == "testuser"

def test_protected_endpoint_unauthorized(client):
    response = client.get("/users/me")
    assert response.status_code == 401
```

#### テスト実行

```bash
# すべてのテスト実行
pytest

# 詳細表示
pytest -v

# 特定のファイル
pytest tests/test_items.py

# 特定のテスト
pytest tests/test_items.py::test_create_item

# カバレッジ
pip install pytest-cov
pytest --cov=app --cov-report=html
```

#### 学習目標

- [ ] TestClientでAPIテストを書ける
- [ ] テスト用DBを設定できる
- [ ] dependency_overridesで依存性をモックできる
- [ ] 認証付きのテストができる

---

### 4.3 設定管理

#### Pydantic Settingsの使用

```python
# app/config.py
from pydantic_settings import BaseSettings
from functools import lru_cache

class Settings(BaseSettings):
    app_name: str = "My FastAPI App"
    debug: bool = False

    # データベース
    database_url: str = "sqlite:///./app.db"

    # 認証
    secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30

    # 外部サービス
    redis_url: str = "redis://localhost:6379"
    smtp_host: str = "smtp.gmail.com"
    smtp_port: int = 587

    model_config = {
        "env_file": ".env",      # .envファイルから読み込み
        "env_file_encoding": "utf-8",
        "case_sensitive": False,  # 環境変数名は大文字小文字を区別しない
    }

@lru_cache
def get_settings() -> Settings:
    return Settings()
```

```bash
# .env
SECRET_KEY=my-super-secret-key
DATABASE_URL=postgresql://user:pass@localhost/mydb
DEBUG=true
```

```python
# main.py
from fastapi import Depends
from app.config import Settings, get_settings

@app.get("/info")
def app_info(settings: Settings = Depends(get_settings)):
    return {
        "app_name": settings.app_name,
        "debug": settings.debug,
    }
```

なぜPydantic Settingsを使うか：

- **型安全**: 環境変数が正しい型か自動検証
- **一元管理**: 設定値を一箇所で管理
- **環境切り替え**: `.env`ファイルや環境変数で簡単に切り替え
- **デフォルト値**: 未設定時のフォールバック

#### 学習目標

- [ ] BaseSettingsで設定クラスを定義できる
- [ ] .envファイルから設定を読み込める
- [ ] Dependsで設定を注入できる
- [ ] lru_cacheで設定のキャッシュができる

---

### 4.4 カスタムレスポンス

#### 様々なレスポンスタイプ

```python
from fastapi.responses import (
    JSONResponse,
    HTMLResponse,
    PlainTextResponse,
    RedirectResponse,
    StreamingResponse,
    FileResponse,
)

# JSON（デフォルト）
@app.get("/json")
def get_json():
    return JSONResponse(
        content={"message": "Hello"},
        headers={"X-Custom": "value"},
    )

# HTML
@app.get("/html", response_class=HTMLResponse)
def get_html():
    return """
    <html>
        <body><h1>Hello HTML</h1></body>
    </html>
    """

# プレーンテキスト
@app.get("/text", response_class=PlainTextResponse)
def get_text():
    return "Hello, plain text!"

# リダイレクト
@app.get("/redirect")
def redirect():
    return RedirectResponse(url="/html")

# ファイルダウンロード
@app.get("/download")
def download_file():
    return FileResponse(
        path="./files/report.pdf",
        filename="report.pdf",
        media_type="application/pdf",
    )

# ストリーミング
@app.get("/stream")
def stream_data():
    def generate():
        for i in range(100):
            yield f"data: {i}\n\n"
    return StreamingResponse(generate(), media_type="text/event-stream")
```

#### ORJSONレスポンス（高速JSON）

```python
from fastapi.responses import ORJSONResponse

app = FastAPI(default_response_class=ORJSONResponse)

@app.get("/fast-json")
def fast_json():
    return {"large": "data"}  # ORJSONで高速にシリアライズ
```

| レスポンスクラス | 用途 |
|----------------|------|
| JSONResponse | 標準JSON |
| ORJSONResponse | 高速JSON（大規模データ向け） |
| HTMLResponse | HTML |
| PlainTextResponse | プレーンテキスト |
| RedirectResponse | リダイレクト |
| FileResponse | ファイルダウンロード |
| StreamingResponse | ストリーミング（SSE等） |

#### 学習目標

- [ ] 様々なレスポンスタイプを使い分けられる
- [ ] ストリーミングレスポンスを実装できる
- [ ] ORJSONResponseの利点を理解している

---

### 4.5 デプロイ（Docker / Uvicorn）

#### Uvicornの本番設定

```bash
# 開発環境
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# 本番環境（Gunicorn + Uvicorn workers）
pip install gunicorn
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000
```

| オプション | 説明 |
|-----------|------|
| `-w 4` | ワーカー数（CPUコア数 × 2 + 1 が目安） |
| `-k uvicorn.workers.UvicornWorker` | Uvicornワーカークラス |
| `-b 0.0.0.0:8000` | バインドアドレス |
| `--access-logfile -` | アクセスログを標準出力に |

#### Dockerfile

```dockerfile
FROM python:3.12-slim

WORKDIR /app

# 依存関係インストール
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# アプリケーションコード
COPY ./app ./app

# 非rootユーザーで実行
RUN adduser --disabled-password --gecos "" appuser
USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

#### docker-compose.yml

```yaml
version: "3.8"

services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/mydb
      - SECRET_KEY=your-secret-key
    depends_on:
      - db

  db:
    image: postgres:16
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=mydb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
```

#### デプロイフロー

```mermaid
flowchart LR
    Dev[開発] --> Test[テスト]
    Test --> Build[Docker Build]
    Build --> Push[レジストリにPush]
    Push --> Deploy[デプロイ]

    subgraph Deploy
        direction TB
        D1[コンテナ起動]
        D2[マイグレーション実行]
        D3[ヘルスチェック]
        D1 --> D2 --> D3
    end
```

#### 本番環境チェックリスト

| 項目 | 確認内容 |
|------|---------|
| 環境変数 | SECRET_KEY等が安全に管理されているか |
| CORS | 許可するオリジンが適切か |
| HTTPS | TLS/SSLが設定されているか |
| ワーカー数 | CPUコア数に応じた設定か |
| ログ | 適切なログレベルとフォーマットか |
| ヘルスチェック | /healthエンドポイントが用意されているか |
| DB接続 | コネクションプーリングが設定されているか |

#### 学習目標

- [ ] Gunicorn + Uvicornで本番サーバーを起動できる
- [ ] DockerでFastAPIアプリをコンテナ化できる
- [ ] docker-composeでDB連携ができる
- [ ] 本番環境のチェックリストを実行できる

---

### 4.6 OpenAPIカスタマイズ

#### アプリケーションのメタデータ

```python
app = FastAPI(
    title="My Awesome API",
    description="""
    ## 概要
    商品管理APIです。

    ## 機能
    * **商品管理** - CRUD操作
    * **ユーザー管理** - 認証・認可
    """,
    version="1.0.0",
    terms_of_service="https://example.com/terms/",
    contact={
        "name": "API サポート",
        "url": "https://example.com/contact/",
        "email": "support@example.com",
    },
    license_info={
        "name": "MIT",
        "url": "https://opensource.org/licenses/MIT",
    },
)
```

#### タグによるグループ化

```python
tags_metadata = [
    {
        "name": "users",
        "description": "ユーザー管理に関する操作",
    },
    {
        "name": "items",
        "description": "商品管理に関する操作。価格は税抜き。",
        "externalDocs": {
            "description": "商品APIの詳細",
            "url": "https://example.com/docs/items",
        },
    },
]

app = FastAPI(openapi_tags=tags_metadata)
```

#### エンドポイントのドキュメント

```python
@app.post(
    "/items",
    response_model=ItemResponse,
    status_code=201,
    summary="商品を作成",
    description="新しい商品を作成します。名前と価格は必須です。",
    response_description="作成された商品",
    tags=["items"],
    responses={
        201: {"description": "商品が正常に作成されました"},
        422: {"description": "バリデーションエラー"},
    },
)
def create_item(item: ItemCreate):
    """
    商品を新規作成します。

    - **name**: 商品名（必須、1〜100文字）
    - **price**: 価格（必須、0より大きい）
    - **description**: 説明（任意）
    """
    return {"id": 1, **item.model_dump()}
```

#### Swagger UIのカスタマイズ

```python
# Swagger UIを無効化して独自UIを使用
app = FastAPI(docs_url=None, redoc_url=None)

# または異なるパスに変更
app = FastAPI(docs_url="/api/docs", redoc_url="/api/redoc")

# OpenAPIスキーマのパス変更
app = FastAPI(openapi_url="/api/v1/openapi.json")
```

#### 学習目標

- [ ] APIのメタデータを設定できる
- [ ] タグでエンドポイントをグループ化できる
- [ ] エンドポイントに詳細なドキュメントを付けられる
- [ ] Swagger UI / ReDocのカスタマイズができる

---

## 学習リソース

### 公式ドキュメント

- [FastAPI公式ドキュメント](https://fastapi.tiangolo.com/) - 最も信頼できる情報源。チュートリアル形式で充実
- [Pydantic公式ドキュメント](https://docs.pydantic.dev/) - バリデーション・シリアライゼーション
- [Starlette公式ドキュメント](https://www.starlette.io/) - FastAPIの基盤となるASGIフレームワーク
- [SQLModel公式ドキュメント](https://sqlmodel.tiangolo.com/) - FastAPI作者によるORM

### 書籍

- 『Building Data Science Applications with FastAPI』 - Francois Voron
- 『FastAPI Modern Python Web Development』 - Bill Lubanovic
- 『Python Web Development with FastAPI』 - 実践的なプロジェクト例

### コミュニティ

- [FastAPI GitHub Discussions](https://github.com/fastapi/fastapi/discussions) - 公式フォーラム
- [FastAPI Discord](https://discord.com/invite/VQjSZaeJmf) - 公式Discordサーバー
- [Stack Overflow](https://stackoverflow.com/questions/tagged/fastapi) - Q&A

### 実践的学習

- FastAPI公式チュートリアル（ドキュメント内）
- 公式のサンプルプロジェクト（full-stack-fastapi-template）
- 個人プロジェクトでのAPI開発

---

## 学習のコツ

### 1. 公式ドキュメントを読む習慣

FastAPIの公式ドキュメントはチュートリアル形式で非常に丁寧。困ったらまずドキュメントを確認する。FastAPI作者のSebastián Ramírez氏が直接書いており、品質が高い。

### 2. 段階的に進める

Phase 1〜2を確実に理解してから中級に進む。特にPydanticモデルと依存性注入はFastAPIの核心なので、しっかり理解することが重要。

### 3. Swagger UIを活用する

`/docs`にアクセスすればSwagger UIで実際にAPIを叩ける。コードを書いたらすぐにブラウザで動作確認する習慣をつける。

### 4. 小さなプロジェクトで試す

TodoアプリAPI、ブログAPI、認証付きCRUDなど、シンプルなプロジェクトで各機能を試す。

### 5. 型ヒントを丁寧に書く

FastAPIは型ヒントから多くの機能を自動生成する。型を省略すると恩恵を受けられないので、常に型ヒントを書く習慣をつける。

### 6. テストを書く

TestClientを使えばテストが簡単に書ける。最初からテストを書く習慣をつけると、リファクタリング時の安心感が大きい。

---

## チェックリスト活用法

各セクションの「学習目標」チェックボックスを活用して進捗を管理。すべてにチェックが入ったら次のPhaseへ進む目安とする。

---

*このロードマップは継続的にアップデートしていくことを推奨します。FastAPIはアクティブに開発されており、新機能の追加や改善が頻繁に行われます。最新情報を常にキャッチアップしてください。*
