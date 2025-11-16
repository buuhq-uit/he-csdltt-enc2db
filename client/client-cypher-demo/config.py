# config.py

DB_CONFIG = {
    "dbname": "enc2db_lab",
    "user": "postgres",
    "password": "",
    "host": "localhost",
    "port": 5432,
}

AES_KEY = b"0123456789abcdef0123456789abcdef"

# ORE numeric
ORE_A = 7919
ORE_B = 123456789123
ORE_SCALE = 100  # 2 decimals

# AHE numeric (toy)
AHE_K = 987654321
AHE_SCALE = 100

# MHE numeric (toy): c = x_scaled * MHE_K
MHE_K = 123457        # prime-ish secret
MHE_SCALE = 100       # dùng chung 2 decimals cho dễ
