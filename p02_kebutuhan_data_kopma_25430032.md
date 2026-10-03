# Dokumen Kebutuhan Data - Kopma Sejahtera

## 1\. Latar belakang dan aktivitas organisasi

Koperasi Mahasiswa Sejahtera (Kopma) adalah koperasi fiktif di lingkungan kampus yang menjual alat tulis, makanan ringan, dan minuman. Pembelinya dapat berupa anggota atau umum. Anggota mendaftar menggunakan NIM, nama, program studi, dan nomor HP; anggota aktif mendapat diskon 5%. Kasir mencatat penjualan, petugas gudang memeriksa stok dan memesan barang saat stok menipis, sedangkan ketua menerima laporan bulanan.

## 2\. Aktor dan proses bisnis

|Kode|Proses bisnis|Aktor|Pemicu|
|-|-|-|-|
|PB-01|Mendaftarkan anggota|Kasir|Mahasiswa ingin menjadi anggota|
|PB-02|Mencatat penjualan|Kasir|Pembeli membayar di kasir|
|PB-03|Memesan barang ke pemasok|Petugas gudang|Stok di bawah batas minimum|
|PB-04|Menerima barang dari pemasok|Petugas gudang|Barang datang bersama faktur|
|PB-05|Menyusun laporan bulanan|Ketua koperasi|Awal bulan|

## 3\. Dokumen sumber yang dianalisis

* Formulir pendaftaran anggota: nomor anggota, NIM, nama, program studi, dan nomor HP.
* Nota penjualan: nomor nota, tanggal dan waktu, kasir, barang, jumlah, harga saat transaksi, serta diskon.
* Faktur pemasok: nomor dan tanggal faktur, pemasok, barang, jumlah, dan harga beli.
* Catatan stok: kode barang, jumlah stok, dan batas minimum stok.

Subtotal dan total pada nota merupakan nilai yang dapat dihitung dari jumlah, harga, dan diskon.

## 4\. Entitas kandidat dan elemen data

* Anggota: nomor anggota, NIM, nama, program studi, nomor HP, status aktif, saldo poin.
* Barang: kode barang, nama, kategori, harga jual, jumlah stok, batas minimum stok.
* Penjualan: nomor nota, tanggal dan waktu, kasir, anggota (opsional), metode pembayaran, poin diperoleh, poin ditukar.
* Detail penjualan: nomor nota, kode barang, jumlah, harga saat transaksi.
* Petugas: kode petugas, nama, peran.
* Pemasok: kode pemasok, nama, nomor telepon, alamat.
* Pembelian: nomor faktur, tanggal, pemasok, barang, jumlah, harga beli.

## 5\. Aturan bisnis

* AB-01: Setiap nota memiliki nomor unik dan minimal satu baris barang.
* AB-02: Penjualan boleh tanpa anggota. Jika pembeli adalah anggota, ia harus berstatus aktif untuk mendapat diskon 5%.
* AB-03: Stok barang tidak boleh negatif; penjualan ditolak jika jumlah yang dibeli melebihi stok.
* AB-04: Harga pada setiap baris nota disimpan sesuai harga saat transaksi.
* AB-05: NIM anggota harus unik; anggota dapat dicari melalui nomor anggota atau NIM.
* AB-06: Pesanan pembelian dibuat jika stok barang di bawah batas minimum.
* AB-07: Setiap kelipatan Rp10.000 dari belanja anggota menghasilkan 1 poin.
* AB-08: Anggota dapat menukar 50 poin dengan potongan Rp5.000; poin dikurangi setelah penukaran berhasil.

## 6\. Kebutuhan informasi

* KI-01: Omzet dan jumlah nota per hari dan per bulan. Data: penjualan dan detail penjualan.
* KI-02: Lima barang terlaris per bulan berdasarkan jumlah terjual. Data: detail penjualan dan barang.
* KI-03: Barang yang stoknya di bawah batas minimum. Data: barang, jumlah stok, dan batas minimum stok.
* KI-04: Sepuluh anggota dengan belanja terbesar per bulan. Data: penjualan, detail penjualan, dan anggota.
* KI-05: Saldo poin setiap anggota. Data: anggota, penjualan, poin diperoleh, dan poin ditukar.

## 7\. Matriks CRUD

|Proses|Anggota|Barang|Penjualan|Detail penjualan|Pemasok|Pembelian|
|-|-|-|-|-|-|-|
|PB-01 Mendaftarkan anggota|C|-|-|-|-|-|
|PB-02 Mencatat penjualan|R,U|R, U|C|C|-|-|
|PB-03 Memesan barang ke pemasok|-|R|-|-|R|C|
|PB-04 Menerima barang dari pemasok|-|U|-|-|R|U|
|PB-05 Menyusun laporan bulanan|R|R|R|R|-|R|

## 8\. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab data |

|---|---|---|---|---|

| no\_anggota | Nomor unik anggota | A-0457 | Unik, format A- diikuti 4 digit | Ketua koperasi |

| nim\_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua koperasi |

| no\_hp\_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua koperasi |

| no\_nota\_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik untuk setiap nota | Kasir |

| harga\_satuan\_detail\_penjualan | Harga barang saat transaksi | 4000 | Bilangan bulat, minimal 0 | Kasir |

| stok\_barang | Jumlah barang yang tersedia | 35 | Bilangan bulat, tidak boleh negatif | Petugas gudang |

| saldo\_poin\_anggota | Jumlah poin anggota saat ini | 12 | Bilangan bulat, minimal 0 | Ketua koperasi |

| poin\_diperoleh | Poin dari transaksi penjualan | 2 | Bilangan bulat, minimal 0 | Kasir |

| poin\_ditukar | Poin yang digunakan untuk diskon | 50 | Tidak boleh melebihi saldo poin | Kasir |

## 9\. Kebutuhan non-fungsional data

* Volume penjualan diperkirakan sekitar 150 nota per hari.
* Data transaksi dirancang untuk disimpan minimal 5 tahun.
* Nomor HP anggota merupakan data pribadi dan hanya dapat dilihat oleh ketua koperasi.

## 10\. Isu kualitas data yang diantisipasi

* NIM anggota yang salah atau tercatat ganda dapat membuat anggota sulit ditemukan. NIM perlu diperiksa dan harus unik.
* Stok yang tidak diperbarui saat penjualan atau penerimaan barang dapat menjadi tidak akurat. Petugas gudang perlu memperbarui stok setiap kali ada perubahan.
* Harga barang yang berubah dapat membuat nota lama menampilkan harga yang salah. Harga saat transaksi perlu disimpan pada detail penjualan.

