## Install Postgres 16 on Ubuntu Server

```shell
sudo apt install wget ca-certificates lsb-release
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
sudo apt update

sudo apt install postgresql-16 postgresql-contrib-16

```

```shell
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl status postgresql
sudo systemctl restart postgresql
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