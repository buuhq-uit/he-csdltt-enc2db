

# aes_engine.py
import os
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

def aes_encrypt(plaintext: str) -> bytes:
    """
    Mã hóa AES-256-CBC với PKCS7 padding.
    Lưu trên DB dạng: iv || ciphertext
    """
    if plaintext is None:
        raise ValueError("plaintext is None")

    iv = os.urandom(16)  # 128-bit IV
    cipher = Cipher(algorithms.AES(AES_KEY), modes.CBC(iv))
    encryptor = cipher.encryptor()

    padder = padding.PKCS7(algorithms.AES.block_size).padder()
    padded_data = padder.update(plaintext.encode("utf-8")) + padder.finalize()

    ciphertext = encryptor.update(padded_data) + encryptor.finalize()
    return iv + ciphertext  # gộp iv + ciphertext để lưu vào 1 cột BYTEA

def aes_decrypt(cipher_blob: bytes) -> str:
    """
    Giải mã AES-256-CBC với PKCS7 padding.
    Đầu vào: iv || ciphertext (như aes_encrypt xuất ra)
    """
    if cipher_blob is None:
        raise ValueError("cipher_blob is None")

    iv = cipher_blob[:16]
    ciphertext = cipher_blob[16:]

    cipher = Cipher(algorithms.AES(AES_KEY), modes.CBC(iv))
    decryptor = cipher.decryptor()
    padded_plain = decryptor.update(ciphertext) + decryptor.finalize()

    unpadder = padding.PKCS7(algorithms.AES.block_size).unpadder()
    plaintext_bytes = unpadder.update(padded_plain) + unpadder.finalize()

    return plaintext_bytes.decode("utf-8")