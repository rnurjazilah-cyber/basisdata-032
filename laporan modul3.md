# Laporan Praktikum Basis Data - Pertemuan 3

**Pembuatan Tabel Database di MariaDB dengan phpMyAdmin**

**Nama:** Riska Nur Jazilah | **NPM:** 25430032 | **Kelas:** A

---

## 1. Tujuan Praktikum

1. Membuat database `kopma` di MariaDB melalui phpMyAdmin.
2. Membuat 8 tabel sesuai ERD fisik pada Gambar 3.2, lengkap dengan tipe data dan constraint.
3. Menerapkan Primary Key, Foreign Key, UNIQUE, NOT NULL, DEFAULT, dan CHECK.
4. Memahami hubungan antartabel pada database relasional.

## 2. Dasar Teori

Database relasional menyimpan data dalam tabel yang saling berhubungan. **Primary Key** adalah kolom yang membedakan setiap baris data, sedangkan **Foreign Key** adalah kolom yang merujuk Primary Key di tabel lain sehingga dua tabel terhubung. **Constraint** adalah aturan yang dijaga langsung oleh database, misalnya UNIQUE agar nilai tidak kembar, NOT NULL agar kolom wajib diisi, DEFAULT untuk nilai bawaan, dan CHECK untuk membatasi nilai yang boleh masuk.

Relasi banyak-ke-banyak, misalnya satu nota berisi banyak barang dan satu barang muncul di banyak nota, tidak bisa disimpan langsung dalam tabel. Relasi ini dipecah menjadi tabel rincian (`detail_penjualan` dan `detail_pembelian`) yang juga menyimpan jumlah dan harga saat transaksi.

## 3. Alat dan Bahan

- Sistem operasi Windows
- XAMPP (Apache dan MariaDB/MySQL)
- phpMyAdmin
- Bahasa SQL (DDL)
- Gambar ERD fisik Kopma (Gambar 3.2)

## 4. Langkah Pengerjaan

1. Membuka XAMPP Control Panel, lalu menyalakan **Apache** dan **MySQL** sampai keduanya berwarna hijau.
2. Membuka browser dan mengakses `localhost/phpmyadmin`.
3. Memilih database `kopma` di panel kiri, lalu membuka tab **SQL**.
4. Menulis dan menjalankan perintah `CREATE TABLE` untuk 8 tabel dengan urutan:
   - tabel induk: `petugas`, `anggota`, `pemasok`, `barang`;
   - tabel transaksi: `penjualan` dan `pembelian`;
   - tabel rincian: `detail_penjualan` dan `detail_pembelian`.

   Urutan ini perlu karena Foreign Key hanya bisa merujuk tabel yang sudah ada.
5. Memeriksa daftar tabel di panel kiri dan struktur kolom tiap tabel di menu **Structure**.
6. Memeriksa hubungan antartabel di menu **Designer**.

## 5. Hasil Praktikum

Database `kopma` berhasil dibuat dengan 8 tabel dan seluruhnya masih kosong (0 baris).

### 5.1 Kolom dan Constraint Tiap Tabel

**Tabel petugas**

| Kolom | Tipe | Keterangan |
|---|---|---|
| id_petugas | SMALLINT | Primary Key, AUTO_INCREMENT |
| kode_petugas | CHAR(3) | UNIQUE, NOT NULL |
| nama_petugas | VARCHAR(100) | NOT NULL |
| peran_petugas | ENUM | kasir, gudang, atau ketua |

**Tabel anggota**

| Kolom | Tipe | Keterangan |
|---|---|---|
| id_anggota | INT | Primary Key, AUTO_INCREMENT |
| no_anggota | CHAR(6) | UNIQUE, NOT NULL |
| nim_anggota | CHAR(10) | UNIQUE, NOT NULL |
| nama_anggota | VARCHAR(100) | NOT NULL |
| prodi_anggota | VARCHAR(60) | NOT NULL |
| no_hp_anggota | VARCHAR(15) | boleh NULL (data pribadi) |
| status_anggota | ENUM | aktif atau nonaktif |
| tgl_daftar_anggota | DATE | NOT NULL |

**Tabel pemasok**

| Kolom | Tipe | Keterangan |
|---|---|---|
| id_pemasok | INT | Primary Key, AUTO_INCREMENT |
| nama_pemasok | VARCHAR(100) | NOT NULL |
| telepon_pemasok | VARCHAR(15) | boleh NULL |
| alamat_pemasok | VARCHAR(200) | boleh NULL |

**Tabel barang**

| Kolom | Tipe | Keterangan |
|---|---|---|
| id_barang | INT | Primary Key, AUTO_INCREMENT |
| kode_barang | VARCHAR(10) | UNIQUE, NOT NULL |
| nama_barang | VARCHAR(100) | NOT NULL |
| kategori_barang | ENUM | ATK, makanan, atau minuman |
| harga_jual_barang | DECIMAL(12,2) | CHECK tidak negatif |
| stok_barang | INT | CHECK tidak negatif |
| stok_min_barang | INT | DEFAULT 5 |

**Tabel penjualan**

| Kolom | Tipe | Keterangan |
|---|---|---|
| id_penjualan | INT | Primary Key, AUTO_INCREMENT |
| no_nota_penjualan | CHAR(12) | UNIQUE, NOT NULL |
| tgl_penjualan | DATETIME | NOT NULL |
| id_petugas | SMALLINT | Foreign Key ke petugas |
| id_anggota | INT | Foreign Key ke anggota, boleh NULL |
| bayar_penjualan | DECIMAL(12,2) | NOT NULL |

**Tabel detail_penjualan**

| Kolom | Tipe | Keterangan |
|---|---|---|
| id_penjualan | INT | Primary Key (gabungan), Foreign Key ke penjualan |
| id_barang | INT | Primary Key (gabungan), Foreign Key ke barang |
| qty_detail_penjualan | SMALLINT | CHECK lebih dari 0 |
| harga_satuan_detail_penjualan | DECIMAL(12,2) | NOT NULL |

**Tabel pembelian**

| Kolom | Tipe | Keterangan |
|---|---|---|
| id_pembelian | INT | Primary Key, AUTO_INCREMENT |
| no_faktur_pembelian | VARCHAR(20) | NOT NULL |
| tgl_pembelian | DATE | NOT NULL |
| id_pemasok | INT | Foreign Key ke pemasok |
| status_pembelian | ENUM | dipesan atau diterima |

**Tabel detail_pembelian**

| Kolom | Tipe | Keterangan |
|---|---|---|
| id_pembelian | INT | Primary Key (gabungan), Foreign Key ke pembelian |
| id_barang | INT | Primary Key (gabungan), Foreign Key ke barang |
| qty_detail_pembelian | INT | CHECK lebih dari 0 |
| harga_beli_detail_pembelian | DECIMAL(12,2) | NOT NULL |

### 5.2 Relasi Antartabel

| Tabel induk | Tabel anak | Hubungan |
|---|---|---|
| petugas | penjualan | satu petugas melayani nol atau banyak penjualan |
| anggota | penjualan | satu anggota melakukan nol atau banyak penjualan; penjualan boleh tanpa anggota |
| penjualan | detail_penjualan | satu penjualan berisi satu atau banyak detail |
| barang | detail_penjualan | satu barang tercantum di nol atau banyak detail penjualan |
| pemasok | pembelian | satu pemasok menerima nol atau banyak pembelian |
| pembelian | detail_pembelian | satu pembelian berisi satu atau banyak detail |
| barang | detail_pembelian | satu barang tercantum di nol atau banyak detail pembelian |

Di menu Designer, garis penghubung antartabel muncul sesuai Foreign Key di atas.

## 6. Pembahasan

Dari hasil praktikum, tabel dikelompokkan menjadi tiga jenis. Tabel master (`petugas`, `anggota`, `pemasok`, `barang`) menyimpan data pokok yang jarang berubah. Tabel transaksi (`penjualan`, `pembelian`) mencatat satu kejadian, yaitu satu nota atau satu faktur. Tabel rincian mencatat isi tiap nota atau faktur per barang, sehingga harga dan jumlah saat transaksi tetap tersimpan walaupun harga barang berubah di kemudian hari.

Kolom `id_anggota` pada tabel `penjualan` dibuat boleh kosong karena pembeli tidak harus anggota koperasi. Kolom `no_hp_anggota` juga boleh kosong karena termasuk data pribadi. Constraint CHECK dipakai agar stok dan harga tidak bisa bernilai negatif, serta jumlah pada tabel rincian harus lebih dari 0, sehingga aturan tersebut dijaga langsung oleh database. Foreign Key memastikan nota tidak bisa dibuat untuk petugas yang tidak terdaftar.

## 7. Kesimpulan

Database `kopma` berhasil dibuat dengan 8 tabel sesuai ERD Gambar 3.2. Primary Key membedakan setiap data, Foreign Key menghubungkan tabel transaksi dengan tabel induknya, dan constraint seperti UNIQUE, CHECK, dan DEFAULT membuat aturan data dijaga langsung oleh database. Pembuatan tabel harus berurutan dari tabel induk ke tabel anak.

## 8. Lampiran

**Lampiran 1.** Daftar 8 tabel di database `kopma`

![Daftar tabel](img/daftar_tabel.png)

**Lampiran 2.** Struktur tabel `petugas`

![Struktur tabel petugas](img/struktur_petugas.png)

**Lampiran 3.** Relasi antartabel di Designer

![Relasi di Designer](img/designer.png)

## 9. Penggunaan AI

Saya memakai Claude (Anthropic) untuk membantu menyusun draf skrip SQL dan laporan ini. Skrip saya jalankan dan periksa sendiri, dan tangkapan layar berasal dari hasil saya.
