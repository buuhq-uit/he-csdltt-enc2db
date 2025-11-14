CREATE DATABASE enc2db_lab;

CREATE TABLE tbl_encrypt_aes (
    id              SERIAL PRIMARY KEY,
    username        TEXT NOT NULL,   -- lưu plain cho dễ xem
    email_cipher    BYTEA NOT NULL,  -- email đã mã hóa AES
    phone_cipher    BYTEA NOT NULL   -- phone đã mã hóa AES
);

CREATE TABLE tbl_enc_numeric (
    id           SERIAL PRIMARY KEY,
    plain_value  NUMERIC(18,2),   -- giá trị gốc (cho debug / research)
    ahe_cipher   BIGINT,          -- để dành cho AHE (sau này)
    mhe_cipher   BIGINT,          -- để dành cho MHE (sau này)
    ore_cipher   BIGINT NOT NULL  -- ORE ciphertext (A*x + B)
);

CREATE TABLE tbl_enc_numeric2 (
    id          SERIAL PRIMARY KEY,
    plain_value NUMERIC(18,2),
    ore_cipher  ore_en NOT NULL
);


-- Tạo index cipher:
CREATE INDEX idx_enc_numeric_ore
ON tbl_enc_numeric2 USING btree (ore_cipher);

\c enc2db_lab;
DROP EXTENSION encdb CASCADE;
CREATE EXTENSION encdb;