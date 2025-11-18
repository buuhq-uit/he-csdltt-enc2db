CREATE DATABASE enc2db_lab;


-- Tạo index cipher:
CREATE INDEX idx_enc_numeric_ore
ON tbl_enc_numeric2 USING btree (ore_cipher);

CREATE TABLE IF NOT EXISTS tbl_enc_all (
    id             SERIAL PRIMARY KEY,

    plain_text     TEXT,
    plain_numeric  NUMERIC(18,2),

    aes_cipher     BYTEA,
    ore_cipher     ore_en,

    ahe_cipher     BIGINT,
    mhe_cipher     BIGINT
);

-- Cipher index cho ORE
CREATE INDEX IF NOT EXISTS idx_tbl_enc_all_ore
ON tbl_enc_all USING btree (ore_cipher);



\c enc2db_lab;
DROP EXTENSION encdb CASCADE;
CREATE EXTENSION encdb;