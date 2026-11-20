-- p07_kueri_25430032.sql | Milestone Proyek 7: kueri SELECT klinik
-- Nama: Riska Nur Jazilah | NPM: 25430032 | Basis data: klinik_032
-- Hasil nyata tiap kueri terdokumentasi pada tangkapan layar di laporan (laporan/img/p07_klinik_*.png).
-- KI yang belum bisa dijawab satu tabel: KI-01, KI-02, KI-05 (butuh agregasi, Pertemuan 9);
-- KI-04 (tabel pembayaran belum ada di klinik_032).
USE klinik_032;

-- [Q1] KI-03: obat yang stoknya menipis
-- Pertanyaan: Obat apa saja yang stoknya sudah di bawah batas minimum?
-- Harapan: 0 baris, karena semua obat stoknya masih di atas batas minimum.
SELECT id_obat, nama_obat, jumlah_stok, batas_minimumstok
FROM obat
WHERE jumlah_stok < batas_minimumstok;

-- [Q2] KI-03 (peringatan dini): stok kurang dari 5 kali batas minimum
-- Pertanyaan: Obat apa saja yang stoknya mulai mendekati batas minimum?
-- Harapan: 2 baris, Salep Hidrokortison 1% (stok 40, batas 10) dan Oralit (stok 80, batas 20).
SELECT id_obat, nama_obat, jumlah_stok, batas_minimumstok
FROM obat
WHERE jumlah_stok < batas_minimumstok * 5
ORDER BY jumlah_stok;

-- [Q3] KI-01 (daftar; jumlah butuh agregasi): BETWEEN dan DATE_FORMAT
-- Pertanyaan: Kunjungan apa saja yang terjadi pada 28 Oktober 2026?
-- Harapan: 12 baris, dari pukul 08:00 sampai 11:40.
SELECT id_kunjungan,
       DATE_FORMAT(tanggal_waktu, '%d-%m-%Y %H:%i') AS waktu,
       keluhan_awal
FROM kunjungan
WHERE tanggal_waktu BETWEEN '2026-10-28 00:00:00' AND '2026-10-28 23:59:59'
ORDER BY tanggal_waktu;

-- [Q4] KI-02 (daftar; jumlah butuh agregasi): BETWEEN pada kolom DATE
-- Pertanyaan: Pasien mana yang mendaftar pada September 2025?
-- Harapan: 2 baris, Rizki Maulana (1 Sep) dan Lestari Wulandari (23 Sep).
SELECT no_rekam_medis, nama, tanggal_pendaftaran
FROM pasien
WHERE tanggal_pendaftaran BETWEEN '2025-09-01' AND '2025-09-30'
ORDER BY tanggal_pendaftaran;

-- [Q5] KI-02 (daftar): fungsi tanggal YEAR
-- Pertanyaan: Pasien mana yang mendaftar pada tahun 2026?
-- Harapan: 2 baris, Maya Sari (14 Jan 2026) dan Dimas Prakoso (2 Mar 2026).
SELECT no_rekam_medis, nama, tanggal_pendaftaran
FROM pasien
WHERE YEAR(tanggal_pendaftaran) = 2026
ORDER BY tanggal_pendaftaran;

-- [Q6] LIKE: mencari pasien dari potongan nama
-- Pertanyaan: Pasien mana yang namanya mengandung "Dewi"?
-- Harapan: 2 baris, Dewi Lestari dan Rahmawati Dewi.
SELECT no_rekam_medis, nama
FROM pasien
WHERE nama LIKE '%Dewi%'
ORDER BY nama;

-- [Q7] IN: tenaga kesehatan berperan dokter
-- Pertanyaan: Siapa saja tenaga kesehatan yang berperan Dokter Umum atau Dokter Gigi?
-- Harapan: 3 baris (dr. Andini, drg. Fajar, dr. Hendra).
SELECT id_tenaga_kesehatan, nama, peran
FROM tenaga_kesehatan
WHERE peran IN ('Dokter Umum', 'Dokter Gigi')
ORDER BY id_tenaga_kesehatan;

-- [Q8] IS NULL: pasien tanpa nomor HP
-- Pertanyaan: Pasien mana yang belum punya nomor HP tercatat?
-- Harapan: 1 baris, yaitu Dewi Lestari (RM-2610-005).
SELECT no_rekam_medis, nama, no_Hp
FROM pasien
WHERE no_Hp IS NULL;

-- [Q9] CASE, TIMESTAMPDIFF, CONCAT, UPPER: label dan kategori usia pasien
-- Pertanyaan: Berapa umur tiap pasien, dan termasuk kategori muda (di bawah 30), dewasa (30-49), atau paruh baya (50 ke atas)?
-- Harapan: 12 baris; kira-kira 4 muda, 6 dewasa, 2 paruh baya (bergantung tanggal komputer).
SELECT CONCAT(UPPER(nama), ' (', no_rekam_medis, ')') AS pasien,
       CASE jenis_kelamin WHEN 'L' THEN 'Laki-laki' ELSE 'Perempuan' END AS jk,
       TIMESTAMPDIFF(YEAR, tanggal_lahir, CURDATE()) AS umur,
       CASE WHEN TIMESTAMPDIFF(YEAR, tanggal_lahir, CURDATE()) < 30 THEN 'muda'
            WHEN TIMESTAMPDIFF(YEAR, tanggal_lahir, CURDATE()) < 50 THEN 'dewasa'
            ELSE 'paruh baya' END AS kategori
FROM pasien
ORDER BY tanggal_lahir;

-- [Q10] LIKE pada keluhan
-- Pertanyaan: Kunjungan mana yang keluhan awalnya menyebut demam?
-- Harapan: 8 baris, semuanya "Demam dan batuk sejak dua hari".
SELECT id_kunjungan, tanggal_waktu, keluhan_awal
FROM kunjungan
WHERE keluhan_awal LIKE '%demam%'
ORDER BY id_kunjungan;

-- [Q11] KI-05 (daftar; "paling sering" butuh agregasi): IN dan rentang tanggal
-- Pertanyaan: Pemeriksaan mana yang diagnosisnya rinitis alergi atau dermatitis kontak antara 26 dan 28 Oktober 2026?
-- Harapan: 9 baris.
SELECT id_pemeriksaan, tanggal_waktu_pemeriksaan, diagnosis
FROM pemeriksaan
WHERE diagnosis IN ('Rinitis alergi', 'Dermatitis kontak')
  AND tanggal_waktu_pemeriksaan >= '2026-10-26'
  AND tanggal_waktu_pemeriksaan <  '2026-10-29'
ORDER BY tanggal_waktu_pemeriksaan;