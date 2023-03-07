-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 07 Mar 2023 pada 04.14
-- Versi server: 10.4.18-MariaDB
-- Versi PHP: 8.0.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `spp`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_siswa` ()  NO SQL
BEGIN
	SELECT `tbl_siswa`.*, `tbl_kelas`.`NAMA_KELAS`, `tbl_spp`.`TAHUN`
                FROM `tbl_siswa` JOIN `tbl_kelas`
                ON `tbl_siswa`.`id_kelas` = `tbl_kelas`.`id_kelas`
                JOIN `tbl_spp` ON `tbl_siswa` .`id_spp` = `tbl_spp`.`id_spp` ORDER BY `tbl_siswa`.`NISN`, `tbl_siswa`.`id_kelas` ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `kelas_get` ()  NO SQL
BEGIN
	SELECT `tbl_kelas`.*, `tbl_jurusan`.`jurusan` FROM `tbl_kelas` JOIN `tbl_jurusan` ON `tbl_kelas`.`id_jurusan` = `tbl_jurusan`.`id_jurusan` ORDER BY `tbl_kelas`.`id_jurusan` ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `level_get` (IN `level` INT)  NO SQL
BEGIN
	SELECT * FROM tbl_level WHERE level = id_level;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_check` (IN `user` VARCHAR(100), IN `pass` VARCHAR(225))  NO SQL
BEGIN
	SELECT * FROM tbl_petugas WHERE user = username AND pass = password_petugas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `siswa_check` (IN `user` VARCHAR(10), IN `pass` VARCHAR(225))  NO SQL
BEGIN
	SELECT * FROM tbl_siswa WHERE user = nisn AND pass = nis;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_jurusan`
--

CREATE TABLE `tbl_jurusan` (
  `ID_JURUSAN` int(11) NOT NULL,
  `JURUSAN` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tbl_jurusan`
--

INSERT INTO `tbl_jurusan` (`ID_JURUSAN`, `JURUSAN`) VALUES
(1, 'Rekayasa Perangkat Lunak kk'),
(2, 'Teknik Jaringan Dan Komputer'),
(3, 'ppt'),
(4, 'multimedia'),
(5, 'aph'),
(6, 'Teknik Sepedah Motor');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_kelas`
--

CREATE TABLE `tbl_kelas` (
  `ID_KELAS` int(11) NOT NULL,
  `ID_JURUSAN` int(11) DEFAULT NULL,
  `NAMA_KELAS` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tbl_kelas`
--

INSERT INTO `tbl_kelas` (`ID_KELAS`, `ID_JURUSAN`, `NAMA_KELAS`) VALUES
(1, 1, 'XII RPL 2'),
(2, 2, 'XII TKJ 2'),
(3, 1, 'XII RPL 2'),
(4, 3, 'ppt 1'),
(5, 4, 'mm'),
(7, 1, 'XII RPL 1');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_level`
--

CREATE TABLE `tbl_level` (
  `ID_LEVEL` int(11) NOT NULL,
  `LEVEL` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tbl_level`
--

INSERT INTO `tbl_level` (`ID_LEVEL`, `LEVEL`) VALUES
(1, 'Admin'),
(2, 'Petugas'),
(3, 'Siswa');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_log`
--

CREATE TABLE `tbl_log` (
  `log_id` int(11) NOT NULL,
  `log_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `log_user` varchar(50) NOT NULL,
  `log_tipe` varchar(50) NOT NULL,
  `log_aksi` varchar(50) NOT NULL,
  `log_assign_to` varchar(50) NOT NULL,
  `log_assign_type` enum('petugas','siswa','spp','kelas','jurusan','transaksi','cetak') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tbl_log`
--

INSERT INTO `tbl_log` (`log_id`, `log_time`, `log_user`, `log_tipe`, `log_aksi`, `log_assign_to`, `log_assign_type`) VALUES
(9, '2020-02-23 13:07:42', 'Administrator', 'petugas', 'menambah data petugas', '', ''),
(10, '2020-02-23 13:08:06', 'Administrator', 'petugas', 'menambah data petugas', '', ''),
(11, '2020-02-23 13:15:11', 'Administrator', 'petugas', 'Menghapus data petugas', '', ''),
(12, '2020-02-23 13:15:16', 'Administrator', 'petugas', 'Menghapus data petugas', '', ''),
(13, '2020-02-23 13:15:19', 'Administrator', 'petugas', 'Menghapus data petugas', '', ''),
(14, '2020-02-23 13:15:27', 'Administrator', 'petugas', 'Mengedit data petugas', '', ''),
(15, '2020-02-23 14:06:44', 'Administrator', 'jurusan', 'Menambah data jurusan', '', ''),
(16, '2020-02-23 14:07:22', 'Administrator', 'kelas', 'Menambah data kelas', '', ''),
(17, '2020-02-23 14:07:36', 'Administrator', 'kelas', 'Mengedit data kelas', '', ''),
(18, '2020-02-23 14:08:13', 'Administrator', 'spp', 'Menambah data spp', '', ''),
(19, '2020-02-24 12:38:04', 'Administrator', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(20, '2020-02-24 12:44:24', 'Petugas', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(21, '2020-02-25 12:00:19', 'Administrator', 'siswa', 'Mengedit data siswa', '', ''),
(22, '2020-02-26 10:52:37', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(23, '2020-02-26 10:54:51', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(24, '2020-02-26 10:55:23', 'Administrator', 'siswa', 'Menambah data siswa', '', ''),
(25, '2020-02-26 10:56:25', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(26, '2020-02-26 10:58:30', 'Administrator', 'siswa', 'Menambah data siswa', '', ''),
(27, '2020-02-26 11:01:44', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(28, '2020-02-26 11:02:05', 'Administrator', 'siswa', 'Menambah data siswa', '', ''),
(29, '2020-02-26 11:41:33', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(30, '2020-02-26 11:41:37', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(31, '2020-02-26 11:41:41', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(32, '2020-02-26 11:43:40', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(33, '2020-02-26 12:03:14', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(34, '2020-02-26 12:07:03', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(35, '2020-02-26 12:07:53', 'Administrator', 'siswa', 'Menambah data siswa', '', ''),
(36, '2020-02-26 15:22:58', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(37, '2020-02-26 15:23:43', 'Administrator', 'siswa', 'Menambah data siswa', '', ''),
(38, '2020-02-26 15:33:49', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(39, '2020-02-26 15:35:29', 'Administrator', 'siswa', 'Menambah data siswa', '', ''),
(40, '2020-02-26 16:26:12', 'Administrator', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(41, '2020-02-26 16:30:38', 'Administrator', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(42, '2020-02-26 16:36:52', 'Administrator', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(43, '2020-02-26 16:37:34', 'Administrator', 'pembayaran', 'Menghapus data transaksi pembayaran', '', ''),
(44, '2020-02-26 16:39:35', 'Petugas', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(45, '2020-02-26 17:21:22', 'Petugas', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(46, '2020-02-27 12:05:28', 'Administrator', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(47, '2020-02-27 12:05:50', 'Administrator', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(48, '2020-02-27 12:56:21', 'Administrator', 'petugas', 'Merubah password petugas', '', ''),
(49, '2020-02-28 06:53:56', 'Administrator', 'petugas', 'Menghapus data petugas', '', ''),
(50, '2020-02-28 07:16:29', 'Administrator', 'cetak', 'Mencetak laporan data petugas', '', ''),
(51, '2020-02-28 07:29:44', 'Administrator', 'petugas', 'Menambah data petugas', '', ''),
(52, '2020-02-28 07:30:56', 'Administrator', 'petugas', 'Menghapus data petugas', '', ''),
(53, '2020-02-28 07:31:15', 'Administrator', 'petugas', 'Menambah data petugas', '', ''),
(54, '2020-02-28 07:50:13', 'Administrator', 'cetak', 'Mencetak laporan data siswa', '', ''),
(55, '2020-02-28 08:29:01', 'Administrator', 'cetak', 'Mencetak laporan data petugas', '', ''),
(56, '2020-02-28 08:30:11', 'Administrator', 'cetak', 'Mencetak laporan data petugas', '', ''),
(57, '2020-02-28 08:31:13', 'Administrator', 'cetak', 'Mencetak laporan data petugas', '', ''),
(58, '2020-02-28 08:31:34', 'Administrator', 'cetak', 'Mencetak laporan data siswa', '', ''),
(59, '2020-02-28 08:32:08', 'Administrator', 'cetak', 'Mencetak laporan data transaksi pembayaran', '', ''),
(60, '2020-02-28 08:35:07', 'Administrator', 'cetak', 'Mencetak laporan data siswa', '', ''),
(61, '2020-02-28 08:35:20', 'Administrator', 'cetak', 'Mencetak laporan data siswa', '', ''),
(62, '2020-02-28 08:35:34', 'Administrator', 'cetak', 'Mencetak laporan data siswa', '', ''),
(63, '2020-02-28 08:36:10', 'Administrator', 'cetak', 'Mencetak laporan data siswa', '', ''),
(64, '2020-02-28 08:36:21', 'Administrator', 'cetak', 'Mencetak laporan data petugas', '', ''),
(65, '2020-02-28 08:36:37', 'Administrator', 'cetak', 'Mencetak laporan data petugas', '', ''),
(66, '2020-02-28 08:37:18', 'Administrator', 'cetak', 'Mencetak laporan data transaksi pembayaran', '', ''),
(67, '2020-02-28 08:37:33', 'Administrator', 'cetak', 'Mencetak laporan data petugas', '', ''),
(68, '2020-02-28 08:38:12', 'Administrator', 'cetak', 'Mencetak laporan data transaksi pembayaran', '', ''),
(69, '2020-02-28 08:38:18', 'Administrator', 'cetak', 'Mencetak laporan data petugas', '', ''),
(70, '2020-02-28 09:21:03', 'Administrator', 'siswa', 'Menambah data siswa', '', ''),
(71, '2020-02-28 09:21:34', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(72, '2023-02-13 03:50:14', 'Administrator', 'petugas', 'Mengedit data petugas', '', ''),
(73, '2023-02-13 03:50:39', 'Administrator', 'petugas', 'Menambah data petugas', '', ''),
(74, '2023-02-13 03:53:17', 'Administrator', 'kelas', 'Menambah data kelas', '', ''),
(75, '2023-02-13 03:54:00', 'Administrator', 'spp', 'Menambah data spp', '', ''),
(76, '2023-02-13 03:56:43', 'Administrator', 'siswa', 'Menambah data siswa', '', ''),
(77, '2023-02-13 03:59:04', 'Administrator', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(78, '2023-02-13 04:10:47', 'Administrator', 'siswa', 'Menghapus data siswa', '', ''),
(79, '2023-02-13 04:11:02', 'Administrator', 'petugas', 'Mengedit data petugas', '', ''),
(80, '2023-02-13 04:13:43', 'Administrator', 'spp', 'Mengedit data spp', '', ''),
(81, '2023-02-13 04:13:56', 'Administrator', 'kelas', 'Mengedit data kelas', '', ''),
(82, '2023-02-13 04:14:05', 'Administrator', 'jurusan', 'Mengedit data jurusan', '', ''),
(83, '2023-02-13 04:18:59', 'Administrator', 'jurusan', 'Menambah data jurusan', '', ''),
(84, '2023-02-13 04:19:15', 'Administrator', 'kelas', 'Menambah data kelas', '', ''),
(85, '2023-02-14 00:13:31', 'balqis', 'siswa', 'Menambah data siswa', '', ''),
(86, '2023-02-14 00:14:34', 'balqis', 'petugas', 'Menambah data petugas', '', ''),
(87, '2023-02-14 00:16:03', 'balqiss', 'jurusan', 'Menambah data jurusan', '', ''),
(88, '2023-02-14 00:16:16', 'balqiss', 'kelas', 'Menambah data kelas', '', ''),
(89, '2023-02-14 00:16:30', 'balqiss', 'spp', 'Mengedit data spp', '', ''),
(90, '2023-02-14 00:16:53', 'balqiss', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(91, '2023-02-14 00:28:39', 'balqiss', 'siswa', 'Mengedit data siswa', '', ''),
(92, '2023-02-14 00:29:39', 'balqiss', 'siswa', 'Mengedit data siswa', '', ''),
(93, '2023-02-14 00:29:56', 'balqiss', 'siswa', 'Menghapus data siswa', '', ''),
(94, '2023-02-14 00:30:56', 'balqiss', 'siswa', 'Menambah data siswa', '', ''),
(95, '2023-02-14 01:57:39', 'balqiss', 'petugas', 'Merubah password petugas', '', ''),
(96, '2023-02-14 07:15:56', 'balqiss', 'jurusan', 'Menambah data jurusan', '', ''),
(97, '2023-02-14 07:16:14', 'balqiss', 'kelas', 'Menambah data kelas', '', ''),
(98, '2023-02-14 07:16:24', 'balqiss', 'kelas', 'Menghapus data kelas', '', ''),
(99, '2023-02-14 07:19:13', 'balqiss', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(100, '2023-02-14 07:22:02', 'balqiss', 'kelas', 'Menambah data kelas', '', ''),
(101, '2023-02-16 00:12:17', 'balqiss', 'siswa', 'Mengedit data siswa', '', ''),
(102, '2023-02-16 00:49:17', 'balqiss', 'cetak', 'Mencetak Struk pembayaran', '', ''),
(103, '2023-02-16 00:51:03', 'balqiss', 'cetak', 'Mencetak Struk pembayaran', '', ''),
(104, '2023-02-16 00:51:30', 'balqiss', 'cetak', 'Mencetak Struk pembayaran', '', ''),
(105, '2023-02-16 00:52:26', 'balqiss', 'cetak', 'Mencetak Struk pembayaran', '', ''),
(106, '2023-02-16 00:54:43', 'balqiss', 'cetak', 'Mencetak Struk pembayaran', '', ''),
(107, '2023-02-16 00:54:55', 'balqiss', 'cetak', 'Mencetak Struk pembayaran', '', ''),
(108, '2023-02-16 00:55:15', 'balqiss', 'cetak', 'Mencetak Struk pembayaran', '', ''),
(109, '2023-02-16 00:56:13', 'balqiss', 'pembayaran', 'Menghapus data transaksi pembayaran', '', ''),
(110, '2023-02-16 00:56:23', 'balqiss', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(111, '2023-02-16 00:56:26', 'balqiss', 'pembayaran', 'Menghapus data transaksi pembayaran', '', ''),
(112, '2023-02-16 01:00:04', 'balqiss', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(113, '2023-02-16 01:00:05', 'balqiss', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(114, '2023-02-16 01:00:08', 'balqiss', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(115, '2023-02-16 01:00:09', 'balqiss', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(116, '2023-02-16 01:00:11', 'balqiss', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(117, '2023-02-16 01:00:20', 'balqiss', 'cetak', 'Mencetak laporan data transaksi pembayaran', '', ''),
(118, '2023-02-16 01:10:44', 'balqiss', 'cetak', 'Mencetak laporan data transaksi pembayaran', '', ''),
(119, '2023-02-16 01:11:11', 'balqiss', 'cetak', 'Mencetak laporan data transaksi pembayaran', '', ''),
(120, '2023-02-16 02:00:00', 'balqiss', 'cetak', 'Mencetak laporan data transaksi pembayaran', '', ''),
(121, '2023-02-16 02:01:51', 'balqiss', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(122, '2023-02-16 06:08:25', 'balqiss', 'cetak', 'Mencetak laporan data transaksi pembayaran', '', ''),
(123, '2023-02-16 06:33:56', 'balqiss', 'pembayaran', 'Menambah data transaksi pembayaran', '', ''),
(124, '2023-02-16 06:33:58', 'balqiss', 'cetak', 'Mencetak Struk pembayaran', '', ''),
(125, '2023-02-18 01:56:49', 'balqiss', 'cetak', 'Mencetak Struk pembayaran', '', ''),
(126, '2023-03-06 00:22:20', 'balqiss', 'siswa', 'Menambah data siswa', '', ''),
(127, '2023-03-06 00:23:24', 'balqiss', 'spp', 'Menambah data spp', '', ''),
(128, '2023-03-06 00:34:44', 'balqiss', 'spp', 'Menambah data spp', '', ''),
(129, '2023-03-06 00:39:35', 'balqiss', 'spp', 'Menambah data spp', '', ''),
(130, '2023-03-06 00:40:21', 'balqiss', 'spp', 'Menambah data spp', '', ''),
(131, '2023-03-06 00:40:33', 'balqiss', 'spp', 'Menambah data spp', '', ''),
(132, '2023-03-06 04:04:38', 'balqiss', 'petugas', 'Mengedit data petugas', '', ''),
(133, '2023-03-06 04:05:32', 'balqiss', 'petugas', 'Mengedit data petugas', '', ''),
(134, '2023-03-07 01:21:52', 'balqiss', 'siswa', 'Mengedit data siswa', '', ''),
(135, '2023-03-07 01:59:46', 'balqiss', 'siswa', 'Mengedit data siswa', '', ''),
(136, '2023-03-07 02:23:51', 'balqiss', 'jurusan', 'Menambah data jurusan', '', ''),
(137, '2023-03-07 02:32:07', 'balqiss', 'cetak', 'Mencetak Struk pembayaran', '', ''),
(138, '2023-03-07 02:39:14', 'balqiss', 'cetak', 'Mencetak laporan data transaksi pembayaran', '', '');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_pembayaran`
--

CREATE TABLE `tbl_pembayaran` (
  `ID_PEMBAYARAN` int(11) NOT NULL,
  `ID_PETUGAS` int(11) DEFAULT NULL,
  `NISN` char(10) DEFAULT NULL,
  `TGL_BAYAR` date DEFAULT NULL,
  `JATUH_TEMPO` date NOT NULL,
  `BULAN_DIBAYAR` varchar(9) DEFAULT NULL,
  `TAHUN_DIBAYAR` varchar(4) DEFAULT NULL,
  `ID_SPP` int(11) NOT NULL,
  `JUMLAH_BAYAR` int(11) NOT NULL,
  `KET` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tbl_pembayaran`
--

INSERT INTO `tbl_pembayaran` (`ID_PEMBAYARAN`, `ID_PETUGAS`, `NISN`, `TGL_BAYAR`, `JATUH_TEMPO`, `BULAN_DIBAYAR`, `TAHUN_DIBAYAR`, `ID_SPP`, `JUMLAH_BAYAR`, `KET`) VALUES
(68, 1, '0020719053', '2020-02-26', '2017-07-20', 'Juli', '2017', 1, 135000, 'LUNAS'),
(69, 1, '0020719053', '2020-02-26', '2017-08-20', 'Agustus', '2017', 1, 135000, 'LUNAS'),
(70, 1, '0020719053', NULL, '2017-09-20', 'September', '2017', 1, 135000, ''),
(71, 1, '0020719053', NULL, '2017-10-20', 'Oktober', '2017', 1, 135000, ''),
(72, 1, '0020719053', NULL, '2017-11-20', 'November', '2017', 1, 135000, ''),
(73, 1, '0020719053', NULL, '2017-12-20', 'Desember', '2017', 1, 135000, ''),
(74, 1, '0020719053', NULL, '2018-01-20', 'Januari', '2018', 1, 135000, ''),
(75, 1, '0020719053', NULL, '2018-02-20', 'Februari', '2018', 1, 135000, ''),
(76, 1, '0020719053', NULL, '2018-03-20', 'Maret', '2018', 1, 135000, ''),
(77, 1, '0020719053', NULL, '2018-04-20', 'April', '2018', 1, 135000, ''),
(78, 1, '0020719053', NULL, '2018-05-20', 'Mei', '2018', 1, 135000, ''),
(79, 1, '0020719053', NULL, '2018-06-20', 'Juni', '2018', 1, 135000, ''),
(129, 19, '5555555555', '2023-02-16', '2023-02-14', 'Februari', '2023', 3, 150000, 'LUNAS'),
(130, 19, '5555555555', '2023-02-16', '2023-03-14', 'Maret', '2023', 3, 150000, 'LUNAS'),
(131, 19, '5555555555', '2023-02-16', '2023-04-14', 'April', '2023', 3, 150000, 'LUNAS'),
(132, 19, '5555555555', '2023-02-16', '2023-05-14', 'Mei', '2023', 3, 150000, 'LUNAS'),
(133, 19, '5555555555', '2023-02-16', '2023-06-14', 'Juni', '2023', 3, 150000, 'LUNAS'),
(134, 19, '5555555555', '2023-02-16', '2023-07-14', 'Juli', '2023', 3, 150000, 'LUNAS'),
(135, 18, '5555555555', NULL, '2023-08-14', 'Agustus', '2023', 3, 150000, ''),
(136, 18, '5555555555', NULL, '2023-09-14', 'September', '2023', 3, 150000, ''),
(137, 18, '5555555555', NULL, '2023-10-14', 'Oktober', '2023', 3, 150000, ''),
(138, 18, '5555555555', NULL, '2023-11-14', 'November', '2023', 3, 150000, ''),
(139, 18, '5555555555', NULL, '2023-12-14', 'Desember', '2023', 3, 150000, ''),
(140, 18, '5555555555', NULL, '2024-01-14', 'Januari', '2024', 3, 150000, ''),
(141, 19, '9999999999', '2023-02-16', '2023-02-21', 'Februari', '2023', 3, 1200000, 'LUNAS'),
(142, 19, '9999999999', NULL, '2023-03-21', 'Maret', '2023', 3, 1200000, ''),
(143, 19, '9999999999', NULL, '2023-04-21', 'April', '2023', 3, 1200000, ''),
(144, 19, '9999999999', NULL, '2023-05-21', 'Mei', '2023', 3, 1200000, ''),
(145, 19, '9999999999', NULL, '2023-06-21', 'Juni', '2023', 3, 1200000, ''),
(146, 19, '9999999999', NULL, '2023-07-21', 'Juli', '2023', 3, 1200000, ''),
(147, 19, '9999999999', NULL, '2023-08-21', 'Agustus', '2023', 3, 1200000, ''),
(148, 19, '9999999999', NULL, '2023-09-21', 'September', '2023', 3, 1200000, ''),
(149, 19, '9999999999', NULL, '2023-10-21', 'Oktober', '2023', 3, 1200000, ''),
(150, 19, '9999999999', NULL, '2023-11-21', 'November', '2023', 3, 1200000, ''),
(151, 19, '9999999999', NULL, '2023-12-21', 'Desember', '2023', 3, 1200000, ''),
(152, 19, '9999999999', NULL, '2024-01-21', 'Januari', '2024', 3, 1200000, ''),
(153, 19, '6666666666', NULL, '2017-12-22', 'Desember', '2017', 3, 1200000, ''),
(154, 19, '6666666666', NULL, '2018-01-22', 'Januari', '2018', 3, 1200000, ''),
(155, 19, '6666666666', NULL, '2018-02-22', 'Februari', '2018', 3, 1200000, ''),
(156, 19, '6666666666', NULL, '2018-03-22', 'Maret', '2018', 3, 1200000, ''),
(157, 19, '6666666666', NULL, '2018-04-22', 'April', '2018', 3, 1200000, ''),
(158, 19, '6666666666', NULL, '2018-05-22', 'Mei', '2018', 3, 1200000, ''),
(159, 19, '6666666666', NULL, '2018-06-22', 'Juni', '2018', 3, 1200000, ''),
(160, 19, '6666666666', NULL, '2018-07-22', 'Juli', '2018', 3, 1200000, ''),
(161, 19, '6666666666', NULL, '2018-08-22', 'Agustus', '2018', 3, 1200000, ''),
(162, 19, '6666666666', NULL, '2018-09-22', 'September', '2018', 3, 1200000, ''),
(163, 19, '6666666666', NULL, '2018-10-22', 'Oktober', '2018', 3, 1200000, ''),
(164, 19, '6666666666', NULL, '2018-11-22', 'November', '2018', 3, 1200000, '');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_petugas`
--

CREATE TABLE `tbl_petugas` (
  `ID_PETUGAS` int(11) NOT NULL,
  `ID_LEVEL` int(11) DEFAULT NULL,
  `USERNAME` varchar(100) DEFAULT NULL,
  `PASSWORD_PETUGAS` varchar(225) DEFAULT NULL,
  `NAMA_PETUGAS` varchar(50) DEFAULT NULL,
  `DESKRIPSI` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tbl_petugas`
--

INSERT INTO `tbl_petugas` (`ID_PETUGAS`, `ID_LEVEL`, `USERNAME`, `PASSWORD_PETUGAS`, `NAMA_PETUGAS`, `DESKRIPSI`) VALUES
(1, 1, 'admin', '21232f297a57a5a743894a0e4a801fc3', 'Administrator', 'admin'),
(3, 2, 'petugas', 'b53fe7751b37e40ff34d012c7774d65f', 'Petugas', 'petugas1'),
(17, 2, 'petugas2', '602ad683250ae3b5f4ed3a8d499b576e', 'edi', 'sriadi'),
(18, 2, 'dwi', '25d55ad283aa400af464c76d713c07ad', 'balqis', '12345678'),
(19, 1, 'balqis', '827ccb0eea8a706c4c34a16891f84e7b', 'balqiss', '12345');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_siswa`
--

CREATE TABLE `tbl_siswa` (
  `NISN` char(10) NOT NULL,
  `ID_KELAS` int(11) DEFAULT NULL,
  `ID_SPP` int(11) DEFAULT NULL,
  `NIS` char(8) DEFAULT NULL,
  `NAMA` varchar(100) DEFAULT NULL,
  `ALAMAT` text DEFAULT NULL,
  `NO_TELP` varchar(13) DEFAULT NULL,
  `TIMESTAMP` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tbl_siswa`
--

INSERT INTO `tbl_siswa` (`NISN`, `ID_KELAS`, `ID_SPP`, `NIS`, `NAMA`, `ALAMAT`, `NO_TELP`, `TIMESTAMP`) VALUES
('0020719053', 1, 1, '12345678', 'Sri Adi Cahyono', 'Jl.Kahayan No 25', '085655514570', '2020-02-26 12:07:52'),
('5555555555', 1, 3, '11111111', 'balqis', 'paleran,umbulsari', '0857123456789', '2023-02-16 00:12:16'),
('6666666666', 7, 3, '99999999', 'hilya', 'paleran', '085712345678', '2023-03-06 00:22:19'),
('9999999999', 1, 3, '88888888', 'elga', 'gadingrejo', '0857123456789', '2023-03-07 01:59:46');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_spp`
--

CREATE TABLE `tbl_spp` (
  `ID_SPP` int(11) NOT NULL,
  `TAHUN` varchar(16) DEFAULT NULL,
  `NOMINAL` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tbl_spp`
--

INSERT INTO `tbl_spp` (`ID_SPP`, `TAHUN`, `NOMINAL`) VALUES
(1, '2017/2018', 130000),
(2, '2018/2019', 170000),
(3, '2022/2023', 1200000),
(7, '2022/2023', 500000000),
(8, '2021/2022', 7000000);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `tbl_jurusan`
--
ALTER TABLE `tbl_jurusan`
  ADD PRIMARY KEY (`ID_JURUSAN`);

--
-- Indeks untuk tabel `tbl_kelas`
--
ALTER TABLE `tbl_kelas`
  ADD PRIMARY KEY (`ID_KELAS`),
  ADD KEY `FK_JURUSAN` (`ID_JURUSAN`);

--
-- Indeks untuk tabel `tbl_level`
--
ALTER TABLE `tbl_level`
  ADD PRIMARY KEY (`ID_LEVEL`);

--
-- Indeks untuk tabel `tbl_log`
--
ALTER TABLE `tbl_log`
  ADD PRIMARY KEY (`log_id`);

--
-- Indeks untuk tabel `tbl_pembayaran`
--
ALTER TABLE `tbl_pembayaran`
  ADD PRIMARY KEY (`ID_PEMBAYARAN`),
  ADD KEY `FK_PETUGAS` (`ID_PETUGAS`),
  ADD KEY `FK_SISWA` (`NISN`);

--
-- Indeks untuk tabel `tbl_petugas`
--
ALTER TABLE `tbl_petugas`
  ADD PRIMARY KEY (`ID_PETUGAS`),
  ADD KEY `FK_LEVEL` (`ID_LEVEL`);

--
-- Indeks untuk tabel `tbl_siswa`
--
ALTER TABLE `tbl_siswa`
  ADD PRIMARY KEY (`NISN`),
  ADD KEY `FK_KELAS` (`ID_KELAS`),
  ADD KEY `FK_SPP` (`ID_SPP`);

--
-- Indeks untuk tabel `tbl_spp`
--
ALTER TABLE `tbl_spp`
  ADD PRIMARY KEY (`ID_SPP`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `tbl_jurusan`
--
ALTER TABLE `tbl_jurusan`
  MODIFY `ID_JURUSAN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `tbl_kelas`
--
ALTER TABLE `tbl_kelas`
  MODIFY `ID_KELAS` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `tbl_level`
--
ALTER TABLE `tbl_level`
  MODIFY `ID_LEVEL` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `tbl_log`
--
ALTER TABLE `tbl_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=139;

--
-- AUTO_INCREMENT untuk tabel `tbl_pembayaran`
--
ALTER TABLE `tbl_pembayaran`
  MODIFY `ID_PEMBAYARAN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- AUTO_INCREMENT untuk tabel `tbl_petugas`
--
ALTER TABLE `tbl_petugas`
  MODIFY `ID_PETUGAS` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT untuk tabel `tbl_spp`
--
ALTER TABLE `tbl_spp`
  MODIFY `ID_SPP` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `tbl_kelas`
--
ALTER TABLE `tbl_kelas`
  ADD CONSTRAINT `FK_JURUSAN` FOREIGN KEY (`ID_JURUSAN`) REFERENCES `tbl_jurusan` (`ID_JURUSAN`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `tbl_pembayaran`
--
ALTER TABLE `tbl_pembayaran`
  ADD CONSTRAINT `FK_PETUGAS` FOREIGN KEY (`ID_PETUGAS`) REFERENCES `tbl_petugas` (`ID_PETUGAS`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_SISWA` FOREIGN KEY (`NISN`) REFERENCES `tbl_siswa` (`NISN`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `tbl_petugas`
--
ALTER TABLE `tbl_petugas`
  ADD CONSTRAINT `FK_LEVEL` FOREIGN KEY (`ID_LEVEL`) REFERENCES `tbl_level` (`ID_LEVEL`);

--
-- Ketidakleluasaan untuk tabel `tbl_siswa`
--
ALTER TABLE `tbl_siswa`
  ADD CONSTRAINT `FK_KELAS` FOREIGN KEY (`ID_KELAS`) REFERENCES `tbl_kelas` (`ID_KELAS`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_SPP` FOREIGN KEY (`ID_SPP`) REFERENCES `tbl_spp` (`ID_SPP`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
