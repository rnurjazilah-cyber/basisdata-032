-- ============================================================
-- MODUL 05: Membangun Struktur dengan DDL dan Constraint
-- Proyek Mandiri: Klinik Sehat RNJ
-- Nama  : Riska Nur Jazilah
-- NPM   : 25430032
-- ============================================================

-- 1. Pembuatan dan Penggunaan Database
CREATE DATABASE IF NOT EXISTS klinik_032;
USE klinik_032;

-- ============================================================
-- 2. Pembuatan Tabel Master (Sesuai 3NF Modul 4)
-- ============================================================

-- Tabel 1: PASIEN
CREATE TABLE IF NOT EXISTS pasien (
    no_rekam_medis VARCHAR(20) PRIMARY KEY,
    NIK VARCHAR(16) NOT NULL UNIQUE,
    nama VARCHAR(100) NOT NULL,
    tanggal_lahir DATE NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    no_Hp VARCHAR(15) UNIQUE,
    alamat TEXT,
    tanggal_pendaftaran DATE NOT NULL
) ENGINE=InnoDB;

-- Tabel 2: TENAGA_KESEHATAN
CREATE TABLE IF NOT EXISTS tenaga_kesehatan (
    id_tenaga_kesehatan INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    peran VARCHAR(50) NOT NULL,
    no_Hp VARCHAR(15) UNIQUE
) ENGINE=InnoDB;

-- Tabel 3: OBAT
CREATE TABLE IF NOT EXISTS obat (
    id_obat INT AUTO_INCREMENT PRIMARY KEY,
    nama_obat VARCHAR(100) NOT NULL,
    satuan VARCHAR(20) NOT NULL,
    harga DECIMAL(10, 2) NOT NULL,
    jumlah_stok INT NOT NULL DEFAULT 0,
    batas_minimumstok INT NOT NULL DEFAULT 5,
    CONSTRAINT ck_obat_harga CHECK (harga >= 0),
    CONSTRAINT ck_obat_stok CHECK (jumlah_stok >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- 3. Pembuatan Tabel Transaksi (Sesuai 3NF Modul 4)
-- ============================================================

-- Tabel 4: KUNJUNGAN
CREATE TABLE IF NOT EXISTS kunjungan (
    id_kunjungan INT AUTO_INCREMENT PRIMARY KEY,
    tanggal_waktu DATETIME NOT NULL,
    keluhan_awal TEXT,
    no_rekam_medis VARCHAR(20) NOT NULL,
    id_tenaga_kesehatan INT NOT NULL,
    CONSTRAINT fk_kunjungan_pasien FOREIGN KEY (no_rekam_medis) REFERENCES pasien (no_rekam_medis) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_kunjungan_nakes FOREIGN KEY (id_tenaga_kesehatan) REFERENCES tenaga_kesehatan (id_tenaga_kesehatan) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabel 5: PEMERIKSAAN
CREATE TABLE IF NOT EXISTS pemeriksaan (
    id_pemeriksaan INT AUTO_INCREMENT PRIMARY KEY,
    tanggal_waktu_pemeriksaan DATETIME NOT NULL,
    diagnosis TEXT NOT NULL,
    tindakan TEXT,
    hasil_pemeriksaan TEXT,
    id_kunjungan INT NOT NULL,
    CONSTRAINT fk_pemeriksaan_kunjungan FOREIGN KEY (id_kunjungan) REFERENCES kunjungan (id_kunjungan) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabel 6: RESEP
CREATE TABLE IF NOT EXISTS resep (
    id_resep INT AUTO_INCREMENT PRIMARY KEY,
    tanggal_resep DATETIME NOT NULL,
    status_resep VARCHAR(30) NOT NULL DEFAULT 'Diproses',
    id_pemeriksaan INT NOT NULL,
    CONSTRAINT fk_resep_pemeriksaan FOREIGN KEY (id_pemeriksaan) REFERENCES pemeriksaan (id_pemeriksaan) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabel 7: DETAIL_RESEP
CREATE TABLE IF NOT EXISTS detail_resep (
    id_resep INT NOT NULL,
    id_obat INT NOT NULL,
    jumlah INT NOT NULL,
    dosis VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_resep, id_obat),
    CONSTRAINT fk_dresep_resep FOREIGN KEY (id_resep) REFERENCES resep (id_resep) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_dresep_obat FOREIGN KEY (id_obat) REFERENCES obat (id_obat) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_dresep_jumlah CHECK (jumlah > 0)
) ENGINE=InnoDB;