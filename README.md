# My dotfiles - 私的ドットファイル（設定ファイル）

## github 認証で躓いたところ

token を入力って言われて素直に設定した token を入力していたが、生成されたトークンを入力しないとダメ


scoop で git-credential-manager-core をインストール
```
> scoop insall git-credential-manager-core
```

MSYS2 で使用するために /usr/local/bin にコピー
```
$ cp ${USERPROFILE}/scoop/shims/git-credential-manager-core.* /usr/local/bin/
```

MSYS2で使用できるか以下のコマンドで確認。
```
$ git credential-manager-core version
```


git-credential-manager-core をインストール
上記のGCMを使用する設定
```
$ git config --global credential.helper manager
$ git credential-manager-core configure	 # 最初だけ？
```


