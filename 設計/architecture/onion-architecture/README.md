# オニオンアーキテクチャ（Onion Architecture）
システムの中心にビジネスロジック（ドメイン層）を据え、その周囲にアプリケーション固有のロジックやインフラ層を配置することで、依存関係を内側（ビジネスロジック側）に向けるアーキテクチャパターンのこと。

## メリット
* とにかくシンプル
* 図１枚で説明できる

## 主な構成
### ◽️ドメイン層（Domain Layer）
* ビジネスルール(ドメイン)を定義する層  
* 他のレイヤーに依存しない（最も重要）
* エンティティ、値オブジェクト、リポジトリのインターフェースを定義

```dart
// domain/entities/user.dart
class User {
  final String id;
  final String name;
  
  User({required this.id, required this.name});
}

// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<User?> getUserById(String id);
}
```
#### 👉 ポイント
* User はドメインエンティティで、データを表す
* UserRepository はインターフェース（実装はしない）


### ◽️アプリケーション層（Application Layer）
* ユースケース（UseCase）を定義
* ドメイン層のロジックを組み合わせてアプリの処理を実装
* リポジトリのインターフェースを利用するが、具体的な実装には依存しない

```dart
// application/usecases/get_user.dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class GetUser {
  final UserRepository repository;

  GetUser(this.repository);

  Future<User?> execute(String id) {
    return repository.getUserById(id);
  }
}
```
#### 👉 ポイント
* GetUser はユースケース（アプリの処理）
* ビジネスロジックはここに書かず、ドメイン層を活用
* UserRepository のインターフェースを利用し、具体的な実装には依存しない


### ◽️インフラストラクチャ層（Infrastructure Layer）　/ データ層
* データベースやAPIとの通信を実装
* アプリケーション層で定義したリポジトリのインターフェースを実装

```dart
// infrastructure/repositories/user_repository_impl.dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User?> getUserById(String id) async {
    // ここでAPIやデータベースとやり取りする
    await Future.delayed(Duration(seconds: 1)); // ダミー処理
    return User(id: id, name: "John Doe");
  }
}
```
#### 👉 ポイント
* UserRepositoryImpl はリポジトリの具象クラス
* APIやデータベースとのやり取りを実装する


### ◽️プレゼンテーション層（Presentation Layer）
* UI（FlutterのWidget）
* 状態管理（例えば Riverpod, Provider, Bloc など）
* アプリケーション層のユースケースを利用してデータを取得・表示

#### 状態管理
```dart
// presentation/providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/usecases/get_user.dart';
import '../../infrastructure/repositories/user_repository_impl.dart';

// ユースケースを提供するプロバイダー
final getUserUseCaseProvider = Provider<GetUser>((ref) {
  return GetUser(UserRepositoryImpl());
});

// ユーザー情報を管理するプロバイダー
final userProvider = FutureProvider.family<User?, String>((ref, id) {
  final getUser = ref.watch(getUserUseCaseProvider);
  return getUser.execute(id);
});
```
#### 👉 ポイント
* getUserUseCaseProvider で GetUser のインスタンスを作成
* userProvider で GetUser.execute(id) を実行し、結果を保持

#### UI
```dart
// presentation/pages/user_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

class UserPage extends ConsumerWidget {
  final String userId;

  const UserPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));

    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: userAsync.when(
        data: (user) => user != null
            ? Center(child: Text("User: ${user.name}"))
            : Center(child: Text("User not found")),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
```
#### 👉 ポイント
* userProvider を watch して非同期データを取得
* 状態ごとに loading / error / data を適切に表示


## 依存関係
* プレゼンテーション層 -> アプリケーション層 -> ドメイン層 -> インフラ層
* インフラ層 -> アプリケーション層 -> ドメイン層 -> インフラ層

## 参考サイト
* [Flutter Project Structure: Feature-first or Layer-first?](https://codewithandrea.com/articles/flutter-project-structure/)
* [クリーンアーキテクチャはおすすめしません。10分でわかるDDDのアーキテクチャ - ドメイン駆動設計](https://www.youtube.com/watch?v=80NeuPXs2J0&list=PLXMIJq1G-_66F9woQpidJfe4HHCFxdXaA&index=5)