# AWS SERVICE

- iam
  権限 user,ec2 がルートユーザ近い権限を持たない
  ```
  Service = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
  ```
- vpc
  アドレス空間
  VPC

  - subnet1
  - private-db1
  - private-db2

  internet gate way

- ec2
  key_pairw で ssh の設定など
  ubuntu vm

  - eip
    固定グローバル ip

- rds

  マネッジド database
  使用する db を定義する
  postgres をホストしていて、k8s の etcd の情報を保持する

- security group (sg)

```
  20 TCP,UDP ftp 　データ転送ポート
  21 TCP,UDP ftp 　コントロールポート
#  22 TCP ssh, scp, sftp
  25 TCP smtp
  53 TCP,UDP dns
#  80 TCP http
  88 TCP kerberos
  110 TCP pop3
  111 TCP,UDP sunrpc
  123 TCP,UDP ntp
  137 TCP,UDP NetBIOS Name Service
  138 TCP,UDP NetBIOS Datagram Service
  139 TCP,UDP NetBIOS Session Service
  177 TCP X Display Manager Control Protocol (XDMCP)
  220 TCP imap3
  389 TCP ldap
#  443 TCP https
  445 TCP,UDP MS ファイル共有/プリンタ共有
  465 TCP smtps

  その他　1000以降をデバッグ用に使用

  db sg
    3306 TCP mysql
    5432 TCP postgres

  同一subnet内はすべてのポートを使用可能
```

- TF variable
  使用する変数と種類を variables.tf で定義する
  aws_secret_key :AWS 認証用
  aws_access_key
