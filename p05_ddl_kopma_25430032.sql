-- ============================================================
-- MODUL 05: Membangun Struktur dengan DDL dan Constraint
-- Studi Kasus: Kopma
-- Nama  : Riska Nur Jazilah
-- NPM   : 25430032
-- ============================================================

-- 1. Pembuatan dan Penggunaan Database
CREATE DATABASE IF NOT EXISTS kopma;
USE kopma;

-- ============================================================
-- 2. Pembuatan Tabel-Tabel Utama (Tabel Master)
-- ============================================================

-- Tabel 1: Petugas
CREATE TABLE IF NOT EXISTS petugas (
    id_petugas INT AUTO_INCREMENT PRIMARY KEY,
    nama_petugas VARCHAR(100) NOT NULL,
    no_hp_petugas VARCHAR(15) UNIQUE,
    jabatan_petugas VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- Tabel 2: Anggota
CREATE TABLE IF NOT EXISTS anggota (
    id_anggota INT AUTO_INCREMENT PRIMARY KEY,
    nama_anggota VARCHAR(100) NOT NULL,
    no_hp_anggota VARCHAR(15) UNIQUE,
    alamat_anggota TEXT,
    tgl_bergabung DATE NOT NULL
) ENGINE=InnoDB;

-- Tabel 3: Pemasok
CREATE TABLE IF NOT EXISTS pemasok (
    id_pemasok INT AUTO_INCREMENT PRIMARY KEY,
    nama_pemasok VARCHAR(100) NOT NULL,
    no_hp_pemasok VARCHAR(15),
    alamat_pemasok TEXT
) ENGINE=InnoDB;

-- Tabel 4: Barang (Termasuk UNIQUE dan CHECK Constraint)
CREATE TABLE IF NOT EXISTS barang (
    id_barang INT AUTO_INCREMENT PRIMARY KEY,
    kode_barang VARCHAR(20) NOT NULL UNIQUE,
    nama_barang VARCHAR(100) NOT NULL,
    kategori_barang VARCHAR(50) NOT NULL,
    harga_jual_barang DECIMAL(10, 2) NOT NULL,
    stok_barang INT NOT NULL DEFAULT 0,
    stok_min_barang INT NOT NULL DEFAULT 5,
    CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0),
    CONSTRAINT ck_barang_stok CHECK (stok_barang >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- 3. Pembuatan Tabel Transaksi dan Relasi (Foreign Key)
-- ============================================================

-- Tabel 5: Pembelian (Header)
CREATE TABLE IF NOT EXISTS pembelian (
    id_pembelian INT AUTO_INCREMENT PRIMARY KEY,
    no_nota_pembelian VARCHAR(50) NOT NULL UNIQUE,
    tgl_pembelian DATETIME NOT NULL,
    id_pemasok INT NOT NULL,
    id_petugas INT NOT NULL,
    total_pembelian DECIMAL(10, 2) DEFAULT 0,
    CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok (id_pemasok) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pembelian_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabel 6: Detail Pembelian
CREATE TABLE IF NOT EXISTS detail_pembelian (
    id_detail_pembelian INT AUTO_INCREMENT PRIMARY KEY,
    id_pembelian INT NOT NULL,
    id_barang INT NOT NULL,
    jumlah_pembelian INT NOT NULL,
    harga_beli_satuan DECIMAL(10, 2) NOT NULL,
    subtotal_pembelian DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_dpembelian_pembelian FOREIGN KEY (id_pembelian) REFERENCES pembelian (id_pembelian) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_dpembelian_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_dpembelian_jumlah CHECK (jumlah_pembelian > 0)
) ENGINE=InnoDB;

-- Tabel 7: Penjualan (Header)
CREATE TABLE IF NOT EXISTS penjualan (
    id_penjualan INT AUTO_INCREMENT PRIMARY KEY,
    no_nota_penjualan VARCHAR(50) NOT NULL UNIQUE,
    tgl_penjualan DATETIME NOT NULL,
    id_petugas INT NOT NULL,
    id_anggota INT DEFAULT NULL,
    bayar_penjualan DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabel 8: Detail Penjualan
CREATE TABLE IF NOT EXISTS detail_penjualan (
    id_detail_penjualan INT AUTO_INCREMENT PRIMARY KEY,
    id_penjualan INT NOT NULL,
    id_barang INT NOT NULL,
    jumlah_penjualan INT NOT NULL,
    harga_jual_satuan DECIMAL(10, 2) NOT NULL,
    subtotal_penjualan DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_dpenjualan_penjualan FOREIGN KEY (id_penjualan) REFERENCES penjualan (id_penjualan) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_dpenjualan_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_dpenjualan_jumlah CHECK (jumlah_penjualan > 0)
) ENGINE=InnoDB;

-- ============================================================
-- 4. Perintah Uji Galat Constraint (Pengujian Error)
-- ============================================================

-- Uji Galat 1: Foreign Key Constraint Violation (Error #1452)
-- Menambahkan data penjualan dengan id_petugas (99) yang tidak ada di tabel petugas
-- INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
-- VALUES ('PJ-2609-0199', NOW(), 99, NULL, 5000);

-- Uji Galat 2: CHECK Constraint Violation (Error #4025)
-- Memperbarui stok_barang menjadi minus (-1)
-- UPDATE barang SET stok_barang = -1 WHERE id_barang = 1;

-- Uji Galat 3: UNIQUE Key Constraint Violation (Error #1062)
-- Memasukkan kode_barang 'BRG001' yang sudah ada di tabel barang
-- INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang) 
-- VALUES ('BRG001', 'Barang Duplikat', 'ATK', 5000, 10);