-- p07_kueri_kopma_25430032.sql | Modul 7: kueri SELECT Kopma
-- Nama: Riska Nur Jazilah | NPM: 25430032
-- Hasil nyata tiap kueri terdokumentasi pada tangkapan layar di laporan (laporan/img/p07_kopma_*.png).
USE kopma_032;

-- ===== D.1 Penyaringan =====

-- [Q1] KI-03: barang di bawah stok minimum
-- Pertanyaan: Barang apa saja yang stoknya sudah di bawah batas minimum dan perlu dipesan ulang?
-- Harapan: 1 baris, yaitu MKN-001 Roti Cokelat: stok 5, minimum 10, kurang 5.
SELECT kode_barang, nama_barang, stok_barang, stok_min_barang,
       stok_min_barang - stok_barang AS kurang
FROM barang
WHERE stok_barang < stok_min_barang
ORDER BY kurang DESC;

-- [Q2] IN: barang kategori ATK atau minuman
-- Pertanyaan: Barang apa saja yang termasuk kategori ATK atau minuman?
-- Harapan: 3 baris (ATK-001, ATK-002, MNM-001); roti cokelat tidak muncul karena kategorinya makanan.
SELECT kode_barang, nama_barang, kategori_barang, harga_jual_barang
FROM barang
WHERE kategori_barang IN ('ATK', 'minuman')
ORDER BY kategori_barang, nama_barang;

-- [Q3] BETWEEN: nota pada rentang tanggal
-- Pertanyaan: Nota apa saja yang dibuat pada 24 September 2026?
-- Harapan: 2 nota, PJ-2609-0142 dan PJ-2609-0143, keduanya tanggal 24 September 2026.
SELECT no_nota_penjualan, tgl_penjualan, bayar_penjualan
FROM penjualan
WHERE tgl_penjualan BETWEEN '2026-09-24 00:00:00' AND '2026-09-24 23:59:59'
ORDER BY tgl_penjualan;

-- [Q4] IS NULL: anggota tanpa nomor HP
-- Pertanyaan: Anggota mana yang belum punya nomor HP tercatat?
-- Harapan: 1 baris, yaitu A-0458 Bayu Prasetyo, karena nomor HP-nya kosong (NULL).
SELECT no_anggota, nama_anggota, no_hp_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;

-- ===== Titik Analisis 1: alias di WHERE =====

-- [TA1-salah] alias dipakai di WHERE
-- Pertanyaan: Barang apa yang kurangnya lebih dari 0?
-- Harapan: galat, karena WHERE dievaluasi sebelum SELECT sehingga alias "kurang" belum ada.
-- Hasil: ERROR 1054 Unknown column 'kurang' in 'where clause'
-- (dijalankan manual; sengaja dibuat sebagai komentar agar berkas ini bisa dijalankan sekaligus)
-- SELECT kode_barang, nama_barang, stok_barang, stok_min_barang,
--        stok_min_barang - stok_barang AS kurang
-- FROM barang
-- WHERE kurang > 0;

-- [TA1-benar] ekspresi diulang di WHERE
-- Harapan: 1 baris, yaitu MKN-001 Roti Cokelat dengan kurang 5.
SELECT kode_barang, nama_barang, stok_barang, stok_min_barang,
       stok_min_barang - stok_barang AS kurang
FROM barang
WHERE stok_min_barang - stok_barang > 0;

-- ===== D.2 Pola teks dan nilai kosong =====

-- [Q5] LIKE, CONCAT, DATE_FORMAT, IFNULL, CASE
-- Pertanyaan: Anggota yang namanya mengandung huruf "a", dengan label, tanggal daftar, nomor HP, dan keterangan diskonnya.
-- Harapan: 3 baris, urut dari pendaftar terbaru: Bayu (nomor HP "-", Diskon 5%), Nadia (Diskon 5%), Citra (Tanpa diskon).
SELECT CONCAT(nama_anggota, ' (', no_anggota, ')')        AS anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y')         AS tgl_daftar,
       IFNULL(no_hp_anggota, '-')                          AS hp,
       CASE status_anggota WHEN 'aktif' THEN 'Diskon 5%'
                           ELSE 'Tanpa diskon' END         AS keterangan
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY tgl_daftar_anggota DESC
LIMIT 5;

-- ===== Titik Analisis 2: = NULL melawan IS NULL =====

-- [TA2-salah] membandingkan dengan NULL memakai =
-- Pertanyaan: Anggota mana yang nomor HP-nya kosong?
-- Harapan: 0 baris tanpa galat, karena perbandingan dengan NULL hasilnya UNKNOWN, bukan benar.
SELECT no_anggota, nama_anggota, no_hp_anggota
FROM anggota
WHERE no_hp_anggota = NULL;

-- [TA2-benar] memakai IS NULL: sama dengan Q4 di atas.

-- ===== D.3 Tanggal dan perhitungan per baris =====

-- [Q6] DATEDIFF, CURDATE, CASE: lama keanggotaan
-- Pertanyaan: Sudah berapa hari tiap anggota terdaftar, dan apakah termasuk "baru" (kurang dari 180 hari) atau "lama"?
-- Harapan: 3 baris, semuanya "lama" karena semua mendaftar lebih dari 400 hari lalu; angka pastinya mengikuti tanggal komputer.
SELECT no_anggota, nama_anggota, tgl_daftar_anggota,
       DATEDIFF(CURDATE(), tgl_daftar_anggota) AS hari_terdaftar,
       CASE WHEN DATEDIFF(CURDATE(), tgl_daftar_anggota) < 180 THEN 'baru'
            ELSE 'lama' END                    AS kategori
FROM anggota
ORDER BY tgl_daftar_anggota;

-- [Q7] subtotal tiap baris nota PJ-2609-0142
-- Pertanyaan: Barang apa saja di nota PJ-2609-0142, dan berapa subtotal tiap barisnya?
-- Harapan: 3 baris dengan subtotal 12000, 13000, dan 8000.
SELECT id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
       qty_detail_penjualan * harga_satuan_detail_penjualan AS subtotal
FROM detail_penjualan
WHERE id_penjualan = (SELECT id_penjualan FROM penjualan
                      WHERE no_nota_penjualan = 'PJ-2609-0142');

-- ===== E. Latihan dan modifikasi =====

-- [E1] UPPER, CONCAT, FORMAT
-- Pertanyaan: Tampilkan nama barang dalam huruf kapital dan harga dalam format Rupiah.
-- Harapan: 4 baris dengan nama huruf besar dan harga berformat Rp4.000, Rp6.500, Rp4.000, Rp5.000.
SELECT UPPER(nama_barang) AS nama,
       CONCAT('Rp', FORMAT(harga_jual_barang, 0, 'id_ID')) AS harga
FROM barang
ORDER BY nama_barang;

-- [E2-salah] OR tanpa tanda kurung (salah semantik, tetap berjalan)
-- Pertanyaan: Barang ATK atau minuman yang stoknya kurang dari 50.
-- Harapan: 3 baris (ATK-001, ATK-002, MNM-001); dua ATK ikut muncul padahal stoknya di atas 50, karena AND dievaluasi lebih dulu daripada OR.
SELECT kode_barang, nama_barang, kategori_barang, stok_barang
FROM barang
WHERE kategori_barang = 'ATK' OR kategori_barang = 'minuman' AND stok_barang < 50;

-- [E2-benar] dengan tanda kurung
-- Harapan: 1 baris, yaitu MNM-001 Air Mineral 600 (stok 46).
SELECT kode_barang, nama_barang, kategori_barang, stok_barang
FROM barang
WHERE (kategori_barang = 'ATK' OR kategori_barang = 'minuman') AND stok_barang < 50;