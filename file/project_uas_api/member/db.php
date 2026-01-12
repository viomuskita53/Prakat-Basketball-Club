<?php
$host = "localhost";
$user = "root";
$pass = "";
$db   = "db_prakat";

$koneksi = new mysqli($host, $user, $pass, $db);

if ($koneksi->connect_error) {
    header("Content-Type: application/json");
    echo json_encode([
        'status' => false,
        'message' => 'Koneksi database gagal'
    ]);
    exit;
}
