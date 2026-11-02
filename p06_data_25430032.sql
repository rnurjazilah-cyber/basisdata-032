-- p06_data_25430032.sql | Milestone Proyek 6: data klinik
-- Nama: Riska Nur Jazilah | NPM: 25430032 | P = 6 -> minimal 60 baris kunjungan
USE klinik_032;

-- 0. Reset isi tabel agar skrip bisa dijalankan ulang dengan hasil sama
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE detail_resep; TRUNCATE resep; TRUNCATE pemeriksaan; TRUNCATE kunjungan;
TRUNCATE obat; TRUNCATE tenaga_kesehatan; TRUNCATE pasien;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Tabel induk
INSERT INTO pasien (no_rekam_medis, NIK, nama, tanggal_lahir, jenis_kelamin, no_Hp, alamat, tanggal_pendaftaran) VALUES
 ('RM-2610-001','1871016503900001','Siti Aminah','1990-03-25','P','081210000001','Jl. Melati No. 4, Metro','2025-01-12'),
 ('RM-2610-002','1871011207850002','Budi Santoso','1985-07-12','L','081210000002','Jl. Kenanga No. 11, Metro','2025-02-03'),
 ('RM-2610-003','1871014211980003','Rahmawati Dewi','1998-11-02','P','081210000003','Jl. Mawar No. 7, Metro','2025-03-18'),
 ('RM-2610-004','1871013005760004','Agus Setiawan','1976-05-30','L','081210000004','Jl. Cempaka No. 22, Metro','2025-04-09'),
 ('RM-2610-005','1871015409020005','Dewi Lestari','2002-09-14','P',NULL,'Jl. Anggrek No. 3, Metro','2025-06-21'),
 ('RM-2610-006','1871010801690006','Hendra Gunawan','1969-01-08','L','081210000006','Jl. Dahlia No. 15, Metro','2025-07-05'),
 ('RM-2610-007','1871015912950007','Nur Aisyah','1995-12-19','P','081210000007','Jl. Flamboyan No. 9, Metro','2025-08-16'),
 ('RM-2610-008','1871012704050008','Rizki Maulana','2005-04-27','L','081210000008','Jl. Teratai No. 18, Metro','2025-09-01'),
 ('RM-2610-009','1871014808880009','Lestari Wulandari','1988-08-08','P','081210000009','Jl. Seruni No. 6, Metro','2025-09-23'),
 ('RM-2610-010','1871011702920010','Fauzan Hakim','1992-02-17','L','081210000010','Jl. Sedap Malam No. 2, Metro','2025-10-10'),
 ('RM-2610-011','1871014506800011','Maya Sari','1980-06-05','P','081210000011','Jl. Bougenville No. 30, Metro','2026-01-14'),
 ('RM-2610-012','1871013110000012','Dimas Prakoso','2000-10-31','L','081210000012','Jl. Kamboja No. 12, Metro','2026-03-02');

INSERT INTO tenaga_kesehatan (id_tenaga_kesehatan, nama, peran, no_Hp) VALUES
 (1,'dr. Andini Prameswari','Dokter Umum','081220000001'),
 (2,'drg. Fajar Nugroho','Dokter Gigi','081220000002'),
 (3,'Bd. Larasati Putri','Bidan','081220000003'),
 (4,'Ns. Yoga Pratama','Perawat','081220000004'),
 (5,'Apt. Mira Kusuma','Apoteker','081220000005'),
 (6,'dr. Hendra Wibowo','Dokter Umum','081220000006');

INSERT INTO obat (id_obat, nama_obat, satuan, harga, jumlah_stok, batas_minimumstok) VALUES
 (1,'Paracetamol 500 mg','tablet',500.00,500,100),
 (2,'Amoksisilin 500 mg','kapsul',1500.00,300,60),
 (3,'Antasida DOEN','tablet',400.00,400,80),
 (4,'Ibuprofen 400 mg','tablet',800.00,250,50),
 (5,'Cetirizine 10 mg','tablet',700.00,200,40),
 (6,'Vitamin C 500 mg','tablet',300.00,600,100),
 (7,'Salep Hidrokortison 1%','tube',12000.00,40,10),
 (8,'Oralit','sachet',1500.00,80,20);

-- 2. Transaksi utama: 60 kunjungan, 5 tanggal (26-30 Okt 2026), 12 per hari
INSERT INTO kunjungan (id_kunjungan, tanggal_waktu, keluhan_awal, no_rekam_medis, id_tenaga_kesehatan)
SELECT n + 1,
  TIMESTAMP(DATE_ADD('2026-10-26', INTERVAL (n MOD 5) DAY), SEC_TO_TIME(28800 + (n DIV 5) * 1200)),
  ELT(1 + (n MOD 8), 'Demam dan batuk sejak dua hari','Sakit kepala berulang sejak pagi',
      'Nyeri ulu hati setelah makan','Gigi berlubang terasa ngilu','Kontrol kesehatan rutin',
      'Pilek dan bersin-bersin','Nyeri otot setelah bekerja','Gatal dan ruam pada lengan'),
  CONCAT('RM-2610-', LPAD(1 + (n MOD 12), 3, '0')),
  ELT(1 + (n MOD 8), 1,6,1,2,3,6,1,6)
FROM (SELECT t.d * 10 + u.d AS n
      FROM (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) t
      CROSS JOIN (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
                  UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) u) x;

-- 3. Satu pemeriksaan untuk setiap kunjungan
INSERT INTO pemeriksaan (id_pemeriksaan, tanggal_waktu_pemeriksaan, diagnosis, tindakan, hasil_pemeriksaan, id_kunjungan)
SELECT k.id_kunjungan, DATE_ADD(k.tanggal_waktu, INTERVAL 10 MINUTE),
  ELT(1 + ((k.id_kunjungan - 1) MOD 8), 'Infeksi saluran pernapasan akut','Sakit kepala tegang','Dispepsia',
      'Karies gigi','Kondisi sehat, kontrol rutin','Rinitis alergi','Nyeri otot (mialgia)','Dermatitis kontak'),
  ELT(1 + ((k.id_kunjungan - 1) MOD 8), 'Istirahat cukup dan banyak minum','Istirahat dan kompres hangat',
      'Atur pola makan teratur','Penambalan gigi','Konseling gizi','Hindari pemicu alergi',
      'Peregangan dan istirahat','Hindari bahan pemicu iritasi'),
  ELT(1 + ((k.id_kunjungan - 1) MOD 8), 'Suhu 37,8 C, tenggorokan merah','Tekanan darah 120/80 mmHg',
      'Nyeri tekan ulu hati ringan','Karies pada gigi geraham bawah','Tekanan darah 110/70 mmHg, berat badan normal',
      'Mukosa hidung pucat, bersin berulang','Nyeri tekan pada otot bahu','Ruam kemerahan pada lengan'),
  k.id_kunjungan
FROM kunjungan k;

-- 4. Resep untuk semua pemeriksaan kecuali kontrol rutin
INSERT INTO resep (id_resep, tanggal_resep, status_resep, id_pemeriksaan)
SELECT p.id_pemeriksaan, DATE_ADD(p.tanggal_waktu_pemeriksaan, INTERVAL 15 MINUTE),
  IF(p.id_pemeriksaan MOD 6 = 0, 'Menunggu', 'Selesai'), p.id_pemeriksaan
FROM pemeriksaan p
WHERE ((p.id_pemeriksaan - 1) MOD 8) <> 4;

-- 5. Detail resep: obat utama, lalu vitamin C untuk keluhan demam/batuk dan pilek
INSERT INTO detail_resep (id_resep, id_obat, jumlah, dosis)
SELECT r.id_resep,
  ELT(1 + ((r.id_resep - 1) MOD 8), 1,4,3,4,1,5,4,7),
  ELT(1 + ((r.id_resep - 1) MOD 8), 9,10,15,10,10,10,10,1),
  ELT(1 + ((r.id_resep - 1) MOD 8), '3 x 1 tablet sesudah makan','2 x 1 tablet sesudah makan',
      '3 x 1 tablet sebelum makan','2 x 1 tablet bila nyeri','-','1 x 1 tablet malam hari',
      '2 x 1 tablet sesudah makan','2 x oles tipis pada area gatal')
FROM resep r;

INSERT INTO detail_resep (id_resep, id_obat, jumlah, dosis)
SELECT r.id_resep, 6, 10, '1 x 1 tablet pagi hari'
FROM resep r
WHERE ((r.id_resep - 1) MOD 8) IN (0, 5);

-- 6. Bukti jumlah baris per tabel
SELECT 'pasien' t, COUNT(*) n FROM pasien UNION ALL SELECT 'tenaga_kesehatan', COUNT(*) FROM tenaga_kesehatan
UNION ALL SELECT 'obat', COUNT(*) FROM obat UNION ALL SELECT 'kunjungan', COUNT(*) FROM kunjungan
UNION ALL SELECT 'pemeriksaan', COUNT(*) FROM pemeriksaan UNION ALL SELECT 'resep', COUNT(*) FROM resep
UNION ALL SELECT 'detail_resep', COUNT(*) FROM detail_resep;