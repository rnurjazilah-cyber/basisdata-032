# Praktikum 4 - Normalisasi Proyek Klinik Sehat RNJ

- Nama		: Riska Nur Jazilah
- Kelas		: A
- NPM		: 25430032
- Mata Kuliah 	: Basis Data
- Tema Proyek 	: Klinik Sehat RNJ

## F.1 Dokumen Sumber

Dokumen sumber: lembar resep obat (hasil proses PB-03, Membuat resep obat).
Satu resep dibuat setelah pasien diperiksa (AB-05) dan dapat memuat beberapa obat
(AB-06). Karena itu lembar resep memuat grup berulang obat. Formulir pendaftaran
pasien tidak dipakai sebagai titik awal karena hanya memuat satu baris data pasien
tanpa grup berulang.

## F.2 Dari UNF ke 1NF

UNF (grup berulang obat ditandai dengan tanda kurung kurawal). Pada bentuk gabungan
ini nama atribut diberi awalan (nama_pasien, nama_tenaga_kesehatan, dan seterusnya)
agar tidak tertukar.

```
RESEP_UNF (id_resep, tgl_resep, status_resep, id_pemeriksaan, diagnosis,
           id_kunjungan, no_rekam_medis, nama_pasien,
           id_tenaga_kesehatan, nama_tenaga_kesehatan, peran,
           { id_obat, nama_obat, satuan, harga_obat, jumlah_obat, dosis,
             subtotal_obat },
           total_obat)
```

1NF: grup berulang dihilangkan, satu baris untuk setiap obat di setiap resep.
Kunci primer menjadi komposit (id_resep, id_obat).

```
RESEP_1NF (id_resep, id_obat, tgl_resep, status_resep, id_pemeriksaan, diagnosis,
           id_kunjungan, no_rekam_medis, nama_pasien,
           id_tenaga_kesehatan, nama_tenaga_kesehatan, peran,
           nama_obat, satuan, harga_obat, jumlah_obat, dosis,
           subtotal_obat, total_obat)
```

## F.3 Dependensi Fungsional

Dependensi fungsional diturunkan dari aturan bisnis dokumen kebutuhan data (Pertemuan 2),
bukan dari isi contoh data.

FD1: id_resep -> tgl_resep, status_resep, id_pemeriksaan   (AB-05)
FD2: id_pemeriksaan -> diagnosis, id_kunjungan   (AB-03)
FD3: id_kunjungan -> no_rekam_medis, id_tenaga_kesehatan   (AB-02, AB-04)
FD4: no_rekam_medis -> nama_pasien   (AB-01)
FD5: id_tenaga_kesehatan -> nama_tenaga_kesehatan, peran   (ID tenaga kesehatan wajib unik, kamus data)
FD6: id_obat -> nama_obat, satuan, harga_obat   (ID obat wajib unik, entitas Obat)
FD7: (id_resep, id_obat) -> jumlah_obat, dosis   (AB-06)
FD8: jumlah_obat, harga_obat -> subtotal_obat   (nilai turunan)
FD9: id_resep -> total_obat   (nilai turunan: jumlah semua subtotal_obat dalam satu resep)

## F.4 Menuju 2NF

Kunci 1NF adalah (id_resep, id_obat). Atribut yang cukup ditentukan oleh sebagian kunci
dipisahkan (ketergantungan parsial):
- FD1 sampai FD5 dan FD9 hanya bergantung pada id_resep, sehingga menjadi relasi resep.
- FD6 hanya bergantung pada id_obat, sehingga menjadi relasi obat.
- FD7 bergantung pada seluruh kunci, sehingga menjadi detail resep.

```
RESEP_2NF (id_resep, tgl_resep, status_resep, id_pemeriksaan, diagnosis,
           id_kunjungan, no_rekam_medis, nama_pasien,
           id_tenaga_kesehatan, nama_tenaga_kesehatan, peran, total_obat)

DETAIL_RESEP (id_resep*, id_obat*, jumlah_obat, dosis, subtotal_obat)

OBAT (id_obat, nama_obat, satuan, harga_obat, jumlah_stok, batas_minimum_stok)
```

## F.5 Menuju 3NF

Pada RESEP_2NF terdapat rantai ketergantungan transitif:
- id_resep -> id_pemeriksaan -> diagnosis, id_kunjungan (FD1, FD2)
- id_kunjungan -> no_rekam_medis, id_tenaga_kesehatan (FD3)
- no_rekam_medis -> nama_pasien (FD4)
- id_tenaga_kesehatan -> nama_tenaga_kesehatan, peran (FD5)

Maka pemeriksaan, kunjungan, pasien, dan tenaga kesehatan dipisahkan menjadi relasi
sendiri.

### Keputusan nilai turunan

| Nilai turunan | Disimpan? | Alasan |
|---------------|-----------|--------|
| subtotal_obat | Tidak | Dapat dihitung dari jumlah_obat x harga_obat (FD8) |
| total_obat | Tidak | Dapat dihitung dari jumlah seluruh subtotal_obat dalam satu resep (FD9) |

Jika disimpan, nilainya bisa tidak cocok dengan jumlah atau harga setelah salah satunya
diubah, sehingga lebih aman dihitung saat dibutuhkan. Catatan: karena harga diambil dari
tabel obat, perubahan harga akan mengubah nilai resep lama. Dokumen kebutuhan data
belum memuat aturan bisnis yang mewajibkan harga dibekukan per resep, sehingga harga
tetap di tabel obat. Jika aturan itu ditambahkan, harga dipindah ke detail_resep.

### Hasil 3NF

Kunci primer di posisi pertama, tanda * adalah kunci tamu. Nama atribut pada hasil
akhir mengikuti ERD Pertemuan 3 (misalnya nama_pasien menjadi nama pada tabel pasien,
harga_obat menjadi harga pada tabel obat, jumlah_obat menjadi jumlah pada detail_resep).

```
RESEP (id_resep, tanggal_resep, status_resep, id_pemeriksaan*)
DETAIL_RESEP (id_resep*, id_obat*, jumlah, dosis)
OBAT (id_obat, nama_obat, satuan, harga, jumlah_stok, batas_minimumstok)
PEMERIKSAAN (id_pemeriksaan, tanggal_waktu_pemeriksaan, diagnosis, tindakan,
             hasil_pemeriksaan, id_kunjungan*)
KUNJUNGAN (id_kunjungan, tanggal_waktu, keluhan_awal, no_rekam_medis*,
           id_tenaga_kesehatan*)
PASIEN (no_rekam_medis, NIK, nama, tanggal_lahir, jenis_kelamin, no_Hp,
        alamat, tanggal_pendaftaran)
TENAGA_KESEHATAN (id_tenaga_kesehatan, nama, peran, no_Hp)
```

### Tabel Tahapan Normalisasi

| Tahap | Masalah yang ditemukan | Tindakan | Hasil relasi |
|-------|------------------------|----------|--------------|
| UNF | Ada grup berulang obat di dalam satu resep | - | RESEP_UNF |
| 1NF | Banyak atribut non-kunci hanya bergantung pada sebagian kunci (id_resep atau id_obat) | Satu baris per obat per resep, kunci komposit (id_resep, id_obat) | RESEP_1NF |
| 2NF | Ketergantungan parsial (FD1 sampai FD6) | Pisahkan resep, detail_resep, dan obat | RESEP_2NF, DETAIL_RESEP, OBAT |
| 3NF | Rantai transitif resep -> pemeriksaan -> kunjungan -> pasien dan tenaga kesehatan; nilai turunan dapat dihitung | Pisahkan pemeriksaan, kunjungan, pasien, tenaga kesehatan; nilai turunan tidak disimpan | RESEP, DETAIL_RESEP, OBAT, PEMERIKSAAN, KUNJUNGAN, PASIEN, TENAGA_KESEHATAN |

## F.6 Pemeriksaan BCNF

Syarat BCNF: setiap penentu (ruas kiri dependensi) harus kunci kandidat.

| Tabel | Penentu | Kunci kandidat? | Hasil |
|-------|---------|-----------------|-------|
| resep | id_resep | Ya | BCNF |
| detail_resep | (id_resep, id_obat) | Ya | BCNF |
| obat | id_obat | Ya | BCNF |
| pemeriksaan | id_pemeriksaan | Ya | BCNF |
| kunjungan | id_kunjungan | Ya | BCNF |
| pasien | no_rekam_medis, NIK | Ya, keduanya kunci kandidat (AB-01, NIK wajib unik) | BCNF |
| tenaga_kesehatan | id_tenaga_kesehatan | Ya | BCNF |

Tidak ditemukan penentu yang bukan kunci kandidat, sehingga semua tabel memenuhi BCNF.

## F.7 Perubahan ERD Proyek

Tidak ada perubahan pada ERD proyek (Pertemuan 3). Hasil normalisasi sudah sesuai
dengan ERD yang ada, dengan alasan berikut:
1. ERD sudah memisahkan Resep dan Detail_Resep dengan kunci gabungan (id_resep, id_obat),
   dan relasi satu resep ke satu atau banyak detail sesuai AB-06.
2. Obat dihubungkan ke Detail_Resep, sehingga satu obat dapat tercantum pada banyak resep.
3. Pemeriksaan, Kunjungan, Pasien, dan Tenaga_Kesehatan sudah berupa entitas sendiri
   (tidak ada rantai transitif di dalam satu entitas), dan Kunjungan memuat
   no_rekam_medis serta id_tenaga_kesehatan sesuai FD3.
4. ERD tidak memuat atribut subtotal atau total, sesuai keputusan bahwa nilai turunan
   tidak disimpan.
Perbedaan yang ada hanya pada penamaan atribut di dokumen normalisasi (diberi awalan
agar jelas pada bentuk UNF dan 1NF); pada hasil akhir 3NF penamaan sudah mengikuti ERD.