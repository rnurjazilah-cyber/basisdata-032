# Laporan Perancangan ERD Fisik Sistem Informasi Kopma

**Nama:** Riska Nur Jazilah  
**NPM:** 25430032  
**Kelas:** A

---

## 1. Pendahuluan

Laporan ini mendokumentasikan ERD fisik basis data Kopma (Koperasi Mahasiswa), yaitu rancangan sembilan tabel yang mencatat penjualan, pembelian barang, keanggotaan, dan poin anggota.

**Tujuan.** Rancangan ini dibuat agar setiap kolom memiliki tipe data dan constraint yang jelas, sehingga bisa langsung dipakai sebagai acuan penulisan DDL pada Modul 5.

**Ruang lingkup.** ERD mencakup sembilan tabel: `petugas`, `anggota`, `pemasok`, `barang`, `penjualan`, `detail_penjualan`, `pembelian`, `detail_pembelian`, dan `transaksi_poin`. Tabel-tabel ini disusun untuk menjawab enam kebutuhan informasi (KI-01 sampai KI-06) yang dijelaskan pada bagian berikutnya.

## 2. Kebutuhan Informasi

Enam kebutuhan informasi (KI) menentukan tabel yang dibutuhkan, dan setiap KI dapat ditelusuri ke jalur tabel tertentu pada ERD.

| Kode | Kebutuhan informasi | Jalur tabel |
| --- | --- | --- |
| KI-01 | Omzet dan jumlah nota per hari/bulan | penjualan → detail_penjualan |
| KI-02 | Lima barang terlaris per bulan | barang → detail_penjualan → penjualan |
| KI-03 | Barang di bawah stok minimum | barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar | anggota → penjualan → detail_penjualan |
| KI-05 | Poin diperoleh dan ditukar per bulan | anggota → penjualan → transaksi_poin |
| KI-06 | Sepuluh anggota dengan poin terbanyak | anggota → penjualan → transaksi_poin |

Tabel `transaksi_poin` dibutuhkan khusus untuk KI-05 dan KI-06, karena hanya tabel ini yang mencatat poin yang diperoleh dan ditukar.

## 3. Entitas dan Atribut

Setiap tabel berikut menjelaskan kolom, tipe data, dan constraint-nya sebagai acuan DDL. Kolom ENUM dan kolom kunci selalu NOT NULL.

Singkatan: PK (kunci primer), FK (kunci tamu), AUTO_INCREMENT (nomor otomatis), DEFAULT (nilai bawaan).

### 3.1 petugas

Menyimpan petugas Kopma beserta perannya.

| Kolom | Tipe | Constraint | Keterangan |
| --- | --- | --- | --- |
| id_petugas | SMALLINT | PK, AUTO_INCREMENT | Nomor unik petugas |
| kode_petugas | CHAR(3) | UNIQUE | Kode singkat petugas |
| nama_petugas | VARCHAR(100) | NOT NULL | Nama petugas |
| peran_petugas | ENUM | NOT NULL | kasir, gudang, atau ketua |

### 3.2 anggota

Menyimpan data anggota Kopma.

| Kolom | Tipe | Constraint | Keterangan |
| --- | --- | --- | --- |
| id_anggota | INT | PK, AUTO_INCREMENT | Nomor unik anggota |
| no_anggota | CHAR(6) | UNIQUE | Nomor keanggotaan |
| nim_anggota | CHAR(10) | UNIQUE | NIM anggota |
| nama_anggota | VARCHAR(100) | NOT NULL | Nama anggota |
| prodi_anggota | VARCHAR(60) | NOT NULL | Program studi |
| no_hp_anggota | VARCHAR(15) | NULL | Data pribadi, boleh kosong |
| status_anggota | ENUM | NOT NULL | aktif atau nonaktif |
| tgl_daftar_anggota | DATE | NOT NULL | Tanggal mendaftar |

### 3.3 pemasok

Menyimpan pemasok barang.

| Kolom | Tipe | Constraint | Keterangan |
| --- | --- | --- | --- |
| id_pemasok | INT | PK, AUTO_INCREMENT | Nomor unik pemasok |
| nama_pemasok | VARCHAR(100) | NOT NULL | Nama pemasok |
| telepon_pemasok | VARCHAR(15) | NULL | Telepon, boleh kosong |
| alamat_pemasok | VARCHAR(200) | NULL | Alamat, boleh kosong |

### 3.4 barang

Menyimpan barang yang dijual beserta stoknya.

| Kolom | Tipe | Constraint | Keterangan |
| --- | --- | --- | --- |
| id_barang | INT | PK, AUTO_INCREMENT | Nomor unik barang |
| kode_barang | VARCHAR(10) | UNIQUE | Kode barang |
| nama_barang | VARCHAR(100) | NOT NULL | Nama barang |
| kategori_barang | ENUM | NOT NULL | ATK, makanan, atau minuman |
| harga_jual_barang | DECIMAL(12,2) | CHECK ≥ 0 | Harga jual |
| stok_barang | INT | CHECK ≥ 0 | Jumlah stok saat ini |
| stok_min_barang | INT | DEFAULT 5 | Batas stok minimum (dipakai KI-03) |

### 3.5 penjualan

Menyimpan satu nota penjualan. Kolom `id_anggota` boleh kosong karena pembeli yang bukan anggota tetap bisa dilayani.

| Kolom | Tipe | Constraint | Keterangan |
| --- | --- | --- | --- |
| id_penjualan | INT | PK, AUTO_INCREMENT | Nomor unik penjualan |
| no_nota_penjualan | CHAR(12) | UNIQUE | Nomor nota |
| tgl_penjualan | DATETIME | NOT NULL | Waktu transaksi |
| id_petugas | SMALLINT | FK → petugas | Petugas yang melayani |
| id_anggota | INT | FK → anggota, NULL | Anggota pembeli, boleh kosong |
| bayar_penjualan | DECIMAL(12,2) | NOT NULL | Jumlah dibayar |

### 3.6 detail_penjualan

Menyimpan barang-barang pada satu nota. Kunci primernya gabungan `id_penjualan` dan `id_barang`.

| Kolom | Tipe | Constraint | Keterangan |
| --- | --- | --- | --- |
| id_penjualan | INT | PK, FK → penjualan | Nota yang memuat barang |
| id_barang | INT | PK, FK → barang | Barang yang terjual |
| qty_detail_penjualan | SMALLINT | CHECK > 0 | Jumlah barang terjual |
| harga_satuan_detail_penjualan | DECIMAL(12,2) | NOT NULL | Harga per unit saat terjual |

### 3.7 pembelian

Menyimpan pembelian barang dari pemasok beserta petugas yang menangani.

| Kolom | Tipe | Constraint | Keterangan |
| --- | --- | --- | --- |
| id_pembelian | INT | PK, AUTO_INCREMENT | Nomor unik pembelian |
| no_faktur_pembelian | VARCHAR(20) | NOT NULL | Nomor faktur pemasok |
| tgl_pembelian | DATE | NOT NULL | Tanggal pembelian |
| id_pemasok | INT | FK → pemasok | Pemasok barang |
| id_petugas | SMALLINT | FK → petugas | Petugas yang menangani |
| status_pembelian | ENUM | NOT NULL | dipesan atau diterima |

### 3.8 detail_pembelian

Menyimpan barang-barang pada satu pembelian. Kunci primernya gabungan `id_pembelian` dan `id_barang`.

| Kolom | Tipe | Constraint | Keterangan |
| --- | --- | --- | --- |
| id_pembelian | INT | PK, FK → pembelian | Pembelian yang memuat barang |
| id_barang | INT | PK, FK → barang | Barang yang dibeli |
| qty_detail_pembelian | INT | CHECK > 0 | Jumlah barang dibeli |
| harga_beli_detail_pembelian | DECIMAL(12,2) | NOT NULL | Harga beli per unit |

### 3.9 transaksi_poin

Menyimpan catatan poin anggota yang diperoleh dari belanja atau ditukar. Poin terhubung ke anggota lewat nota penjualan.

| Kolom | Tipe | Constraint | Keterangan |
| --- | --- | --- | --- |
| id_transaksi_poin | INT | PK, AUTO_INCREMENT | Nomor unik catatan poin |
| id_penjualan | INT | FK → penjualan | Nota asal poin |
| jenis_transaksi_poin | ENUM | NOT NULL | diperoleh atau ditukar |
| jumlah_transaksi_poin | INT | NOT NULL | Banyaknya poin |

## 4. Kesimpulan

ERD fisik Kopma terdiri dari sembilan tabel yang cukup untuk menjawab enam kebutuhan informasi, dari omzet dan barang terlaris sampai stok minimum dan poin anggota.

Setiap kolom sudah memiliki tipe data dan constraint, sehingga rancangan ini bisa langsung diterjemahkan menjadi perintah DDL pada Modul 5.
