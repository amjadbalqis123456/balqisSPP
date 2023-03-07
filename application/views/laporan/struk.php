<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Data Petugas</title>
    <link rel="stylesheet" href="<?= $_SERVER['DOCUMENT_ROOT'] ?>/spp3/assets/css/bootstrap.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
        }

        header img {
            position: absolute;
            top: 10px;
        }

        header h2 {
            position: absolute;
            top: -15px;
            left: 50px;
            font-size: 18px;
            line-height: 25px;
            text-transform: uppercase;
        }

        header h2 span {
            font-size: 12px;
            font-style: regular;
            line-height: 15px;
            text-transform: capitalize;
        }

        section#konten {
            position: absolute;
            top: 125px;
        }

        span.email {
            text-transform: lowercase;
        }

        .hr1 {
            margin-top: 15px;
            border-color: grey;
        }


        .hr2 {
            border: 1px solid black;
            margin-top: -15px;
        }

        .ttd p {
            position: relative;
            left: 70%;
        }
    </style>
</head>

<body>
    <header class="p-0">
        
        <!-- <h2 class="ml-5 text-center">BUKTI PEMBAYARAN SPP<br></h2> -->
    </header>
    <h2 class="ml-5 text-center">BUKTI PEMBAYARAN SPP<br></h2>

    <!-- <section id="konten"> -->
        <hr class="hr1">
        <hr class="hr2">

        <div class="data">
        <p>Nama <?= $transaksi['NAMA']; ?></p>
        <p>Nisn <?= $transaksi['NISN']; ?></p>
        <p>Kelas  <?= $transaksi['nama_kelas']; ?></p>
        <p>Tahun Ajaran<?= $transaksi['TAHUN']; ?></p>
        <p>Tanggal Bayar <?= $transaksi['TGL_BAYAR']; ?></p>
        <p>Jurusan <?= $transaksi['jurusan']; ?></p>
        <p>Pembayaran Bulan  <?= $transaksi['BULAN_DIBAYAR']; ?></p>
        <p>Nominal  <?= $transaksi['NOMINAL']; ?></p>
        </div>
        
    </section>
</body>

</html> 

<script>
window.print();
</script>