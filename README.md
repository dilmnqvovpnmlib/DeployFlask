# DeployFlask

# Build

- `docker build -t app .`
- `docker run --name app -p 80:80 app`

# 注意点

## コンテナを立ち上げた時に複数プロセスを起動させたい

- コンテナを立ち上げた時に Nginx も立ち上げたかった。コマンド的には、`/etc/init.d/nginx start`を実行したかった。また、それと同時に uWSGI のプロセスも立ち上げたかった。

- Docker コンテナは伝統的に 起動時に１つのプロセスを実行する。しかし、1 コンテナに複数のプロセスを起動したいときがある。その際には、プロセス管理ツールの`Supervisor`を使ってコンテナ内で複数のプロセスを起動させる。

# 参考

- [Supervisor を Docker で使う](http://docs.docker.jp/engine/admin/using_supervisord.html)
- [Supervisor で簡単にデーモン化](https://qiita.com/yushin/items/15f4f90c5663710dbd56)
- [nginx を docker で動かす時の Tips 3 選 ](https://heartbeats.jp/hbblog/2014/07/3-tips-for-nginx-on-docker.html)
