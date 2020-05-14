# 背景・目的

前回書いた記事の[Raspberry Pi 3 Model B+に Nginx と uWSGI を使って Flask を動かしてみた]()で実装した内容を Docker を使ってコード化を行った。

# 実装

実装した手順は以下である。

1. `Dockerfile` に設定を実装
2. `conf/default` に Nginx の設定を実装
3. `conf/supervisord.conf` に Docker コンテナ内に複数プロセスを起動させるプロセスの設定を実装
4. `docker-entrypoint.sh` を作成しコンテナ起動時に実行させたいシェルを実行

前回の記事で 2 を説明しているので、本記事では取り扱わない。

## ディレクトリ構成

```
.
├── Dockerfile
├── README.md
├── conf
│   ├── default
│   ├── supervisord.conf
│   └── uwsgi.ini
├── docker-entrypoint.sh
├── requirements.txt
└── src
    └── main.py
```

## 実装内容

- 上の手順をコード化したのが以下になる。

```
FROM python:3.7

RUN apt-get update
RUN apt-get install -y nginx && apt-get install -y vim && apt-get install -y curl && apt-get install -y supervisor

RUN mkdir /app
WORKDIR /app
ADD . /app

# install python packages.
ADD requirements.txt /app
RUN pip install -r requirements.txt

# copy configuration files.
COPY ./conf/default /etc/nginx/sites-enabled/default
COPY ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

ENTRYPOINT ["bash", "./docker-entrypoint.sh"]
```

実際にサーバーの上で設定をする際と違う点が 2 点ある。

1 点目は`Supervisor` を使用していることである。Docker コンテナは伝統的に起動時に 1 つのプロセスを実行する。しかし、1 コンテナに複数のプロセスを起動したいときがある。その際には、プロセス管理ツールの`Supervisor`を使ってコンテナ内で複数のプロセスを起動させる。今回のケースでは、コンテナを立ち上げた時に Nginx も立ち上げたかった。また、それと同時に uWSGI のプロセスも立ち上げたかった。これらの設定を最低限実装したのが、`./conf/supervisord.conf`に記述されている。この設定をコンテナ内の `/etc/supervisor/conf.d/` にマウントする。

```
[supervisord]
nodaemon=true

[program:nginx]
command=nginx -g "daemon off;"

[program:uwsgi]
directory=/app/conf
command=/usr/local/bin/uwsgi --ini uwsgi.ini
```

2 点目は、`docker-entrypoint.sh`を使用していることである。コンテナを立ち上げる際に、実行するコマンドを指定している。今回のケースでは、 `supervisord` のプロセスを立ち上げる設定を記述している。

# 参考

- [Supervisor を Docker で使う](http://docs.docker.jp/engine/admin/using_supervisord.html)
- [Supervisor で簡単にデーモン化](https://qiita.com/yushin/items/15f4f90c5663710dbd56)
- [nginx を docker で動かす時の Tips 3 選 ](https://heartbeats.jp/hbblog/2014/07/3-tips-for-nginx-on-docker.html)
- [DeployFlask](https://github.com/dilmnqvovpnmlib/DeployFlask)
