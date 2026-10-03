# Dokumen Kebutuhan Data - Klinik Sehat RNJ

## 1. Latar belakang dan aktivitas organisasi
Klinik Sehat RNJ adalah klinik fiktif yang melayani pemeriksaan kesehatan dasar. Aktivitasnya meliputi pendaftaran pasien, pencatatan kunjungan, pemeriksaan oleh dokter, pencatatan resep, pelayanan obat, dan pembayaran. Petugas pendaftaran mengelola data pasien, tenaga kesehatan mencatat pemeriksaan, sedangkan kasir mencatat pembayaran.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan pasien | Petugas pendaftaran | Pasien datang ke klinik |
| PB-02 | Mencatat kunjungan dan pemeriksaan | Dokter | Pasien datang untuk diperiksa |
| PB-03 | Membuat resep obat | Dokter | Pasien membutuhkan obat |
| PB-04 | Mencatat pembayaran | Kasir | Layanan pasien selesai |
| PB-05 | Mengelola data tenaga kesehatan | Admin klinik | Ada tenaga kesehatan baru atau datanya berubah |
| PB-06 | Mengelola data obat dan stok | Petugas farmasi | Obat baru diterima atau stok diperbarui |

## 3. Dokumen sumber yang dianalisis

Sumber: Formulir pendaftaran pasien.
Formulir pendaftaran memuat nomor rekam medis, NIK, nama pasien, tanggal lahir, jenis kelamin, alamat, nomor HP, dan tanggal pendaftaran. Elemen-elemen tersebut menjadi data pasien yang perlu dicatat. NIK, alamat, dan nomor HP termasuk data pribadi, sehingga aksesnya perlu dibatasi.

## 4. Entitas kandidat dan elemen data

- Pasien: nomor rekam medis, NIK, nama, tanggal lahir, jenis kelamin, nomor HP, alamat, tanggal pendaftaran.
- Tenaga kesehatan: ID tenaga kesehatan, nama, peran, nomor HP.
- Kunjungan: ID kunjungan, tanggal dan waktu, keluhan awal, nomor rekam medis, ID tenaga kesehatan.
- Pemeriksaan: ID pemeriksaan, tanggal dan waktu pemeriksaan, diagnosis, tindakan, hasil pemeriksaan, ID kunjungan.
- Obat: ID obat, nama obat, satuan, harga, jumlah stok, batas minimum stok.
- Resep: ID resep, tanggal resep, ID pemeriksaan, ID obat, jumlah, dosis, status resep.   
- Pembayaran: ID pembayaran, ID kunjungan, tanggal pembayaran, jumlah, metode pembayaran.

## 5. Aturan bisnis

- AB-01: Nomor rekam medis setiap pasien harus unik.
- AB-02: Setiap kunjungan harus tercatat untuk satu pasien.
- AB-03: Setiap pemeriksaan harus terhubung dengan satu kunjungan.
- AB-04: Pemeriksaan dicatat oleh tenaga kesehatan yang bertugas.
- AB-05: Resep hanya dibuat setelah pasien diperiksa.
- AB-06: Setiap resep harus mencatat obat dan jumlah yang diberikan.
- AB-07: Stok obat tidak boleh negatif; obat hanya diberikan jika stok mencukupi.
- AB-08: Pembayaran harus terhubung dengan kunjungan pasien dan mencatat jumlah yang dibayar.
- AB-09: Pasien terdaftar mendapat potongan 6% dari biaya layanan.

## 6. Kebutuhan informasi

- KI-01: Jumlah kunjungan pasien per hari dan per bulan. Data: kunjungan dan tanggal kunjungan.
- KI-02: Jumlah pasien baru setiap bulan. Data: pasien dan tanggal pendaftaran.
- KI-03: Daftar obat yang stoknya menipis. Data: obat, jumlah stok, dan batas minimum stok.
- KI-04: Total pembayaran yang diterima setiap bulan. Data: pembayaran, jumlah, dan tanggal pembayaran.
- KI-05: Diagnosis yang paling sering muncul setiap bulan. Data: pemeriksaan, diagnosis, dan tanggal pemeriksaan.

## 7. Matriks CRUD

| Proses | Pasien | Tenaga kesehatan | Kunjungan | Pemeriksaan | Obat | Resep | Pembayaran |
|---|---|---|---|---|---|---|---|
| PB-01 Mendaftarkan pasien | C | - | - | - | - | - | - |
| PB-02 Mencatat kunjungan dan pemeriksaan | R | R | C | C | - | - | - |
| PB-03 Membuat resep obat | - | R | - | R | R | C | - |
| PB-04 Mencatat pembayaran | - | - | R | - | - | R | C |
| PB-05 Mengelola data tenaga kesehatan | - | C, R, U | - | - | - | - | - |
| PB-06 Mengelola data obat dan stok | - | - | - | - | C, R, U | - | - |

## 8. Kamus data awal

| Elemen | Arti | Contoh fiktif | Aturan | Penanggung jawab data |
|---|---|---|---|---|
| Nomor rekam medis | Identitas unik pasien | RM-0001 | Wajib dan unik | Petugas pendaftaran |
| NIK | Nomor identitas pasien | NIK fiktif 16 digit | Wajib, unik, akses terbatas | Petugas pendaftaran |
| Nama pasien | Nama pasien | Pasien Contoh | Wajib diisi | Petugas pendaftaran |
| Tanggal lahir | Tanggal lahir pasien | 2000-01-01 | Format tanggal | Petugas pendaftaran |
| Jenis kelamin | Jenis kelamin pasien | P | Pilihan L atau P | Petugas pendaftaran |
| Nomor HP | Kontak pasien | 08xx-xxxx | Data pribadi, akses terbatas | Petugas pendaftaran |
| Alamat | Alamat pasien | Alamat fiktif | Data pribadi, akses terbatas | Petugas pendaftaran |
| Tanggal pendaftaran | Tanggal pasien didaftarkan | 2026-10-03 | Wajib diisi | Petugas pendaftaran |
| ID tenaga kesehatan | Identitas tenaga kesehatan | NK-001 | Wajib dan unik | Admin klinik |
| Nama tenaga kesehatan | Nama petugas klinik | Tenaga Kesehatan Contoh | Wajib diisi | Admin klinik |
| Peran | Tugas petugas klinik | Dokter | Diisi sesuai peran | Admin klinik |
| ID kunjungan | Identitas kunjungan | KJ-0001 | Wajib dan unik | Petugas pendaftaran |
| Waktu kunjungan | Tanggal dan waktu kunjungan | 2026-10-03 09:00 | Wajib diisi | Petugas pendaftaran |
| Keluhan awal | Keluhan pasien saat datang | Pusing | Akses tenaga kesehatan | Dokter |
| ID pemeriksaan | Identitas pemeriksaan | PM-0001 | Wajib dan unik | Dokter |
| Waktu pemeriksaan | Tanggal dan waktu pemeriksaan | 2026-10-03 09:15 | Wajib diisi | Dokter |
| Diagnosis | Hasil diagnosis pasien | Contoh diagnosis | Informasi kesehatan, akses terbatas | Dokter |
| ID obat | Identitas obat | OB-001 | Wajib dan unik | Petugas farmasi |
| Nama obat | Nama obat | Obat Contoh | Wajib diisi | Petugas farmasi |
| Jumlah stok | Jumlah obat tersedia | 20 | Bilangan bulat, minimal 0 | Petugas farmasi |
| Batas minimum stok | Batas untuk menandai stok menipis | 5 | Bilangan bulat, minimal 0 | Petugas farmasi |
| ID resep | Identitas resep | RP-0001 | Wajib dan unik | Dokter |
| ID obat pada resep | Obat yang diresepkan | OB-001 | Harus terdaftar di data obat | Dokter |
| Jumlah obat | Jumlah obat yang diresepkan | 10 | Bilangan bulat lebih dari 0 | Dokter |
| Dosis | Aturan penggunaan obat | 3 kali sehari | Wajib jika resep dibuat | Dokter |
| ID pembayaran | Identitas pembayaran | BY-0001 | Wajib dan unik | Kasir |
| Jumlah pembayaran | Nilai pembayaran | Rp15.000 | Nilai tidak boleh negatif | Kasir |
| Metode pembayaran | Cara pasien membayar | Tunai | Pilih metode yang tersedia | Kasir |

## 9. Kebutuhan non-fungsional data

Perhitungan parameter pribadi: P = (32 mod 9) + 1 = 6.

- Batas maksimal obat dalam satu transaksi: P + 2 = 8 item.
- Potongan biaya untuk pasien terdaftar: P = 6%.
- Perkiraan volume: 40 + (5 × P) = 70 transaksi per hari.
- Data kunjungan dan pembayaran dirancang untuk disimpan minimal 5 tahun.
- NIK, alamat, dan nomor HP hanya dapat dilihat petugas pendaftaran dan admin klinik yang berwenang.
- Diagnosis, hasil pemeriksaan, dan resep hanya dapat dilihat tenaga kesehatan yang berwenang.

## 10. Isu kualitas data yang diantisipasi

- Data pasien ganda atau salah dapat membuat riwayat pasien tertukar. Nomor rekam medis dan NIK perlu diperiksa saat pendaftaran.
- Diagnosis atau resep yang tidak lengkap dapat mengganggu pelayanan. Kolom pemeriksaan dan resep perlu diisi oleh tenaga kesehatan yang berwenang.
- Jumlah stok obat yang tidak diperbarui dapat menyebabkan selisih stok. Stok perlu diperbarui setiap kali obat diterima atau diberikan.
- Pembayaran yang salah atau tidak terhubung ke kunjungan dapat membuat laporan omzet tidak akurat. Kasir perlu memeriksa jumlah pembayaran dan nomor kunjungan.