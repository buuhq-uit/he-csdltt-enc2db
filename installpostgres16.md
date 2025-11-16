## Install Postgres 16 on Ubuntu Server

```shell
sudo apt install wget ca-certificates lsb-release
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
sudo apt update

sudo apt install build-essential
sudo apt install postgresql-16 postgresql-contrib-16 postgresql-server-dev-16
```

```shell
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl status postgresql
sudo systemctl restart postgresql

# 1. Xem cluster hiện tại
pg_lsclusters

# 2. Drop cluster cũ (nó sẽ xóa luôn dữ liệu trong /var/lib/postgresql/16/main)
sudo pg_dropcluster --stop 16 main

# 3. Tạo lại cluster mới và start luôn
sudo pg_createcluster 16 main --start

# 4. Kiểm tra
pg_lsclusters

sudo pg_ctlcluster 16 main start
sudo systemctl status postgresql@16-main
sudo pg_ctlcluster 16 main restart
psql --version
```

## Enabling Remote Connections to PostgreSQL Server

```shell
vi /etc/postgresql/16/main/postgresql.conf
```

change listen_addresses = '*'

```shell
vi /etc/postgresql/16/main/pg_hba.conf
```
- add:

host    all             all             0.0.0.0/0                 scram-sha-256

```shell
sudo ufw allow 5342/tcp
sudo ufw reload
```

```shell
sudo -u postgres psql
```
```sql
ALTER USER postgres PASSWORD 'Password123';
\q
```