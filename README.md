# My dotfiles - 私的ドットファイル（設定ファイル）

## github 認証で躓いたところ

token を入力って言われて素直に設定した token を入力していたが、生成されたトークンを入力しないとダメ

## GitHubで認証時の個人アクセストークンを記憶させる
### はじめに
 いちいち毎回トークンを手打ちしたくない
### 入力した認証情報を保存する
#### 常駐プロセスに一時記憶 (cache)
cache 方式は標準で付属しています。
以下のコマンドで cache 方式が使用できます。
```
git config --global credential.helper cache
```
初回にトークン入力時にgit-credential-cache--daemon プロセスが常駐して、タイムアウト時間が過ぎるまでトークンを記憶します。

タイムアウトは、デフォルトで900秒(15分)です。変更するには、次のようにタイムアウト時間(例では3,600秒)を指定します。
```
git config --global credential.helper 'cache --timeout=3600'
```

#### ファイルに保存 (平文)
```
git config --global credential.helper store
```

保存先は指定できるが無指定だと`~/.git-credentials`に保存される。

```
git config --global credential.helper 'store --file ~/.gitr_credentials'
```
上記のように保存先を指定することも出来る。

#### Git Credential Manager Core を使って認証情報を管理する
##### Git Credentail Manager Core をインストール
と、いうことで[Git Credential Manager Core](https://github.com/GitCredentialManager/git-credential-manager)をインストールする。

1. Linuxの場合<br>
  最新の[debパッケージ](https://github.com/GitCredentialManager/git-credential-manager/releases/latest)をダウンロードして、以下を実行します。
```
sudo dpkg -i <path-to-package>
git-credential-manager-core configure		# 認証情報を登録
```
アンインストールするには以下の通り:
```
git-credential-manager-core unconfigure
sudo dpkg -r gcmcore
```
2. Windows の場合 (scoop使用)<br>
scoop で git-credential-manager-core をインストール
```
scop install git-credential-manager-core
```
MSYS2 で使用するために /usr/local/bin にコピー
```
cp ${USERPROFILE}/scoop/shims/git-credential-manager-core.* /usr/local/bin/
git-credential-manager-core configure		# 認証情報を登録
```

git-credential-manager-core をインストール
上記の[GCM Core](https://github.com/GitCredentialManager/git-credential-manager)
を使用する設定
##### Git Credentail Manager Core を使うように設定

```
git config --global credential.helper manager
```


