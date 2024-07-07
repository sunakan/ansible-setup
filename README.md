ansible-setup
====

色々試す時にsetupを楽にするためのリポジトリ

対応OS
----

- Ubuntu

実行
----

```shell
cp .env.sample .env
vim .env
direnv allow
make ping
make ansible.all-in-one
```
