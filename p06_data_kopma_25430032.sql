-- p06_data_kopma_25430032.sql | Modul 6: data sampel Kopma
-- Nama: Riska Nur Jazilah | NPM: 25430032
-- Kolom sudah dicocokkan dengan information_schema kopma_032.
USE kopma_032;

-- 0. Reset isi tabel agar hasil selalu sama saat dijalankan ulang ----------
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE detail_pembelian; TRUNCATE detail_penjualan;
TRUNCATE pembelian;        TRUNCATE penjualan;
TRUNCATE pemasok;          TRUNCATE barang;
TRUNCATE anggota;          TRUNCATE petugas;
SET FOREIGN_KEY_CHECKS = 1;

-- D.1 Data induk (induk dulu, anak kemudian) ------------------------------
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01','Dimas','kasir'), ('K02','Sari','kasir'), ('K03','Rina','kasir'),
  ('G01','Joko','gudang'), ('P01','Ketua Kopma','ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang,
                    harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001','Pulpen Gel 0.5','ATK',4000,120,20),
  ('ATK-002','Buku Tulis 58','ATK',6500,80,20),
  ('MNM-001','Air Mineral 600','minuman',4000,48,24),
  ('MKN-001','Roti Cokelat','makanan',5000,6,10);

-- 3 anggota, 1 nonaktif (AB-02)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota,
                     no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A-0457','2543010001','Nadia Putri','Ilmu Komputer','081300000201','aktif','2025-08-18'),
  ('A-0458','2543010002','Bayu Prasetyo','Ilmu Komputer',NULL,'aktif','2025-09-02'),
  ('A-0459','2443010003','Citra Lestari','Pendidikan Matematika','081300000203','nonaktif','2024-08-20');

INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('CV Sumber Tulis','072511122201','Jl. Ki Hajar Dewantara 10, Metro'),
  ('UD Segar Makmur','072533344402','Jl. Soekarno-Hatta 25, Metro');

-- D.2 Nota PJ-2609-0142 (kasir K03 Rina, anggota A-0457) -------------------
-- id dicari lewat kode alami, bukan ditebak (Troubleshooting Masalah 2)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0142', '2026-09-24 10:15:00', p.id_petugas, a.id_anggota, 30000
FROM petugas p, anggota a
WHERE p.kode_petugas = 'K03' AND a.no_anggota = 'A-0457';

-- harga satuan DISALIN dari barang (AB-04)
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT n.id_penjualan, b.id_barang, x.qty, b.harga_jual_barang
FROM penjualan n
JOIN (SELECT 'ATK-001' kode, 3 qty UNION ALL
      SELECT 'ATK-002', 2 UNION ALL
      SELECT 'MNM-001', 2) x
JOIN barang b ON b.kode_barang = x.kode
WHERE n.no_nota_penjualan = 'PJ-2609-0142';

UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MNM-001';

-- Nota uji kedua (pembeli umum, id_anggota NULL) -> dihapus untuk uji CASCADE
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0143', '2026-09-24 11:30:00', id_petugas, NULL, 10000
FROM petugas WHERE kode_petugas = 'K01';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT n.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan n, barang b
WHERE n.no_nota_penjualan = 'PJ-2609-0143' AND b.kode_barang = 'MKN-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MKN-001';

-- Bukti jumlah baris per tabel (untuk tangkapan layar)
SELECT 'petugas' t, COUNT(*) n FROM petugas UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'barang', COUNT(*) FROM barang UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan;

-- D.3 Mode aman dan hapus: dijalankan manual satu per satu di tab SQL ------
-- SET SESSION sql_safe_updates = 1;
-- UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1;           -- ERROR 1175
-- UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1
--   WHERE kategori_barang = 'ATK' AND id_barang > 0;                       -- diterima
-- SELECT COUNT(*) FROM detail_penjualan;                                   -- sebelum
-- DELETE FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0143';
-- SELECT COUNT(*) FROM detail_penjualan;                                   -- sesudah (berkurang 1)
-- DELETE FROM petugas WHERE kode_petugas = 'K03';                          -- ERROR 1451
-- Setelah D.3, jalankan ulang skrip ini dari atas agar data kembali bersih.