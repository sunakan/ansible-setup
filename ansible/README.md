Ansible
====


ディレクトリ構成
----

Ansibleのベストプラクティス

| 名前                                                                                                   | 採用  |
| :--------------------------------------------------------------------------------------------------- | :-- |
| [Sample directory layout](https://docs.ansible.com/ansible/7/tips_tricks/sample_setup.html#id1)      |     |
| [Alternative directory layout](https://docs.ansible.com/ansible/7/tips_tricks/sample_setup.html#id2) | 採用  |

### 後者の採用理由

- 環境毎に明示的に設定しやすいため
	- たまたま同じ設定になって冗長になることは許容

### Ansible 基礎

```shell
# 構文
ansible-playbook -i <インベントリ> <プレイブック>

# 例
ansible-playbook -i inventories/all-in-one/hosts.yaml playbook.yml
```

#### Ansibleの実行順序

1. インベントリからターゲットノードのリストアップ
2. インベントリとプレイブックからPythonの実行コードに変換
3. Pythonプラグラムを転送(SFTP)
4. Pythonプログラムを実行
5. Pythonプログラムを削除