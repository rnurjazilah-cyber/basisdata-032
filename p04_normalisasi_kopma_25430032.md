# Praktikum 4 - Normalisasi Kopma

- Nama : Riska Nur Jazilah
- Kelas : A
- NPM : 25430032

## D.1 Dari UNF ke 1NF

NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)

1NF: hilangkan grup berulang. Satu baris untuk setiap barang di setiap nota.
Kunci primer menjadi komposit (no_nota_penjualan, kode_barang).

NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas,
          nama_petugas, no_anggota, nama_anggota, nama_barang,
          qty_detail_penjualan, harga_satuan_detail_penjualan,
          subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan,
          total_penjualan)

## D.2 Dependensi Fungsional

FD1: no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota   (AB-01)
FD2: kode_petugas -> nama_petugas
FD3: no_anggota -> nama_anggota   (AB-05)
FD4: kode_barang -> nama_barang
FD5: (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan   (AB-04)
FD6: qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan   (turunan)

### Titik Analisis 1

Harga satuan ada di kunci (no_nota_penjualan, kode_barang), bukan kode_barang saja,
karena menurut AB-04 harga di nota disimpan per baris dan tidak berubah meski harga
barang naik. Barang yang sama bisa terjual dengan harga berbeda di nota berbeda.

Jika harga dipindah ke tabel barang, setiap kenaikan harga akan mengubah harga di semua
nota lama. Laporan omzet tahun lalu jadi salah karena dihitung dengan harga baru.

## D.3 Menuju 2NF dan 3NF

2NF: FD1 dan FD4 hanya bergantung pada sebagian kunci komposit. Pisahkan menjadi
relasi sendiri: penjualan (kunci no_nota_penjualan) dan barang (kunci kode_barang).
Sisanya menjadi detail penjualan.

3NF: di relasi penjualan ada rantai no_nota_penjualan -> kode_petugas -> nama_petugas
dan no_nota_penjualan -> no_anggota -> nama_anggota. Pisahkan petugas dan anggota
menjadi relasi sendiri.

Nilai turunan: subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, dan
total_penjualan dapat dihitung dari detail dan status anggota, sehingga tidak
disimpan di tabel operasional. Dengan begitu datanya tidak mungkin tidak konsisten.

Hasil 3NF (kunci primer di posisi pertama, tanda * = kunci tamu):

- PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)
- DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)
- BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
- PETUGAS (kode_petugas, nama_petugas, peran_petugas)
- ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)

### Tabel Tahapan Normalisasi

| Tahap | Masalah yang ditemukan | Tindakan | Hasil relasi |
|-------|------------------------|----------|--------------|
| UNF | Ada grup berulang barang di dalam satu nota | - | NOTA_UNF |
| 1NF | Atribut nota (FD1) dan nama barang (FD4) hanya bergantung pada sebagian kunci komposit | Satu baris per barang per nota, kunci komposit (no_nota_penjualan, kode_barang) | NOTA_1NF |
| 2NF | FD1 dan FD4 adalah ketergantungan parsial | Pisahkan menjadi penjualan, barang, dan detail_penjualan | PENJUALAN, BARANG, DETAIL_PENJUALAN |
| 3NF | Rantai no_nota -> kode_petugas -> nama_petugas dan no_nota -> no_anggota -> nama_anggota; nilai turunan dapat dihitung | Pisahkan petugas dan anggota; nilai turunan tidak disimpan | PENJUALAN, DETAIL_PENJUALAN, BARANG, PETUGAS, ANGGOTA |

### Titik Analisis 2

Tabel operasional masih bisa berubah (qty dikoreksi, status anggota berubah, harga
barang naik). Kalau total disimpan, nilainya bisa tidak cocok dengan datanya, jadi
lebih aman dihitung saat dibutuhkan.

Tabel arsip penjualan adalah potret historis pada saat periode ditutup dan tidak boleh
berubah lagi. Total yang disimpan di sana adalah fakta yang justru harus dibekukan,
dan karena sumbernya tidak berubah lagi, tidak ada risiko tidak konsisten. Jadi
keputusannya tetap konsisten: data yang masih berubah dihitung, data yang sudah final
disimpan.

## D.4 Mencocokkan dengan Skema Kanonik Kopma

Perbedaan utama dengan hasil 3NF di atas: skema kanonik memakai kunci pengganti
(surrogate key) id_* sebagai kunci primer, sedangkan kode alami seperti
no_nota_penjualan, kode_petugas, no_anggota, nim_anggota, dan kode_barang menjadi
kunci unik. Skema kanonik juga memuat tabel pemasok, pembelian, dan detail_pembelian.

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|-------|--------------|------------|------------|
| petugas | id_petugas | kode_petugas | - |
| anggota | id_anggota | no_anggota, nim_anggota | - |
| barang | id_barang | kode_barang | - |
| pemasok | id_pemasok | - | - |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang |
| pembelian | id_pembelian | - | id_pemasok |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang |

### Pemeriksaan BCNF

Syarat BCNF: setiap penentu (ruas kiri dependensi) harus kunci kandidat.

| Tabel | Penentu | Kunci kandidat? | Hasil |
|-------|---------|-----------------|-------|
| petugas | id_petugas, kode_petugas | Ya, keduanya | BCNF |
| anggota | id_anggota, no_anggota, nim_anggota | Ya, ketiganya | BCNF |
| barang | id_barang, kode_barang | Ya, keduanya | BCNF |
| pemasok | id_pemasok | Ya | BCNF |
| penjualan | id_penjualan, no_nota_penjualan | Ya, keduanya | BCNF |
| detail_penjualan | (id_penjualan, id_barang) | Ya | BCNF |
| pembelian | id_pembelian | Ya | BCNF |
| detail_pembelian | (id_pembelian, id_barang) | Ya | BCNF |

Catatan: nama_petugas, nama_anggota, dan nama_barang bukan penentu karena nama bisa
kembar. Kunci pengganti tidak otomatis membuat tabel normal, jadi pemeriksaan tetap
dilakukan juga terhadap kunci alami (misalnya nim_anggota di anggota).

### Titik Analisis 3

Informasi "barang ini dipasok oleh siapa" disimpan lewat jalur barang ->
detail_pembelian -> pembelian -> pemasok. Pemasok tercatat di tabel pembelian
(id_pemasok), dan barang yang dibeli tercatat di detail_pembelian.

Keuntungannya dibanding satu nama pemasok di tabel barang:
1. Satu barang bisa dipasok banyak pemasok dari waktu ke waktu, dan riwayatnya tercatat.
2. Nama pemasok disimpan sekali di tabel pemasok, sehingga ejaan yang berubah-ubah
   (anomali ubah) hilang.
3. Pemasok baru bisa dicatat meski belum ada barangnya (tidak ada anomali sisip), dan
   menghapus barang tidak ikut menghapus data pemasok (tidak ada anomali hapus).

## E. Latihan dan Modifikasi

### Latihan 1 - Banyak nomor telepon per pemasok

Satu pemasok dapat punya beberapa nomor telepon. Jika disimpan dalam satu kolom
("0812..., 0821...") atau dalam kolom telp1, telp2, dan seterusnya, relasi melanggar
1NF karena nilainya tidak atomik atau berupa grup berulang. Solusinya memisahkan nomor
telepon ke relasi sendiri:

```
PEMASOK (id_pemasok, nama_pemasok, ...)
PEMASOK_TELEPON (id_pemasok*, no_telepon, keterangan)
-- kunci primer: (id_pemasok, no_telepon); id_pemasok = kunci tamu ke PEMASOK
```

Dependensi fungsional: (id_pemasok, no_telepon) -> keterangan. Penentunya adalah kunci
primer, jadi relasi ini memenuhi 3NF dan BCNF.

### Latihan 2 - Pelanggaran 3NF jika nama_anggota disimpan di tabel penjualan

Rancangan yang salah:

```
PENJUALAN_SALAH (id_penjualan, no_nota_penjualan, tgl_penjualan, id_anggota, nama_anggota)
```

Ada rantai id_penjualan -> id_anggota -> nama_anggota (ketergantungan transitif),
sehingga melanggar 3NF.

Contoh data:

| id_penjualan | no_nota_penjualan | id_anggota | nama_anggota |
|--------------|-------------------|------------|--------------|
| 1 | PJ-2610-0001 | 7 | Budi Santoso |
| 2 | PJ-2610-0002 | 7 | Budi Santoso |
| 3 | PJ-2610-0003 | 7 | Budi Santoso |

Kueri ubah yang memperlihatkan anomali ubah (hanya satu baris yang diperbarui):

```sql
UPDATE penjualan_salah
SET nama_anggota = 'Budi S. Wijaya'
WHERE no_nota_penjualan = 'PJ-2610-0001';

-- Bukti: anggota yang sama kini punya dua nama
SELECT id_anggota, COUNT(DISTINCT nama_anggota) AS jumlah_nama
FROM penjualan_salah
GROUP BY id_anggota
HAVING COUNT(DISTINCT nama_anggota) > 1;
```

Hasilnya id_anggota = 7 dengan jumlah_nama = 2, sehingga data menjadi tidak konsisten.
Perbaikannya: simpan nama_anggota hanya di tabel anggota dan ambil lewat JOIN.