# memo_app
サンプルアプリです。Docker上にネットワークを構築して実験やデプロイを容易にしました。

1. 仮想化環境
    * Docker
2. フロントエンド
    * Elm
3. バックエンド
    * golang/gin
4. RDB
    * MySQL
5. KVS
    * Redis

## Requirements
* docker
* docker-compose

## Usage
### 開発用PC

```
$ make develop
```

を実行することで`http://localhost:8080/`でアプリが Listen します。
