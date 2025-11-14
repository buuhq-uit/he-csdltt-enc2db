## Step 1: Prepare Lab Environment

- Install Unbutu 22 server
- Install Postgres 16 on Ubuntu 22

## Step 2: ENCDB (Sofware Only)
### Step 2.1: Encryption and Decryption Engine (on Client)
- Using EAS Encryption Algorithm
- EAS (Advanced Encryption Standard) is Symmetric encryption. AES uses a single, shared secret key for both encrypting and decrypting data
- Create Db with name: enc2db_lab
- Create table with name tbl_encrypt_aes and some colunm store encrypted data
- Use python connect to enc2db_lab
- Write some functions encrypt and decrypt data as Encryption and Decryption Engine

### Step 2.2: Query rewite (on client)
- Insert Query rewite
  rewite insert statement from blanktext to encrypted use aes
  Connect enc2db_lab and insert some encrypted data to tbl_encrypt_aes
- Insert Query rewite
  Rewite Select query to select from tbl_encrypt_aes using funcitons on Encryption and Decryption Engine to return blanktext data

### Step 2.3: Implement on Server Postgres extension C

```text
Mục tiêu: xây dựng các udf(user defined function) phía server dùng Postgres extension C
Dùng các thuật toán mã hóa AHE, MHE, ORE, and AES algorithm
2.3.1 AES - udf_aes_eq() — so sánh AES ciphertext
2.3.2 AHE - udf_ahe_add() — cộng AHE ciphertext
2.3.3 MHE - udf_mhe_mul() — nhân MHE ciphertext
2.3.4 ORE - udf_ore_cmp() — so sánh 2 ORE ciphertext
```

```shell
sudo apt install build-essential postgresql-server-dev-16
```

#### 2.3.1 AES

udf_aes_eq() — so sánh AES ciphertext

```text
Viết C funtion cho Posgres C Extension
Hàm add_one: test C compile with makefile
Hàm aes_eq: so sánh 2 cyphertext không cần decrypt
Compile C Posgres C Extension
Khai báo Postgres Extension từ thư viện C được compile
```

```shell
#Tạo thư mục: ~/enc2db_lab/server_extension
#Chép encdb.c, encdb.control, encdb--1.0.sql, Makefile vào thư mục này
cd ~/enc2db_lab/server_extension
vim encdb.c
vim encdb.control
vim Makefile
vim encdb--1.0.sql
```

```shell
make clean
make
sudo make install

sudo -u postgres psql
```

```sql
DROP EXTENSION IF EXISTS encdb CASCADE;
CREATE EXTENSION encdb;

SELECT add_one(41);                                      -- 42
SELECT aes_eq('\x112233'::bytea, '\x112233'::bytea);     -- t
SELECT aes_eq('\x112233'::bytea, '\xabcdef'::bytea);     -- f
```

#### 2.3.2 AHE

udf_ahe_add() — cộng AHE ciphertext

#### 2.3.3 MHE

udf_mhe_mul() — nhân MHE ciphertext

#### 2.3.4 ORE Done

udf_ore_cmp() — so sánh 2 ORE ciphertext