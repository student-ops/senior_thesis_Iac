```
export DATASTORE_ENDPOINT="mysql://test:password@tcp(test-db.cpgzeygehxvp.ap-northeast-1.rds.amazonaws.com:3306)/testdb"

export INSTALL_K3S_VERSION="v1.24.10+k3s1"


curl -sfL https://get.k3s.io |  INSTALL_K3S_VERSION=$INSTALL_K3S_VERSION sh -s - server \
  --datastore-endpoint=$DATASTORE_ENDPOINT
```
