-- Skrip lingkungan Modul 1
-- Jangan menulis password asli di berkas yang diunggah ke GitHub.

CREATE DATABASE IF NOT EXISTS kopma_032
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'mhs_032'@'localhost'
  IDENTIFIED BY '<password_kerja>';

GRANT ALL PRIVILEGES ON kopma_032.* TO 'mhs_032'@'localhost';