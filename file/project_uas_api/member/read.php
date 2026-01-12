<?php
header("Content-Type: application/json");
require_once 'db.php';

$data = [];
$query = $koneksi->query("SELECT * FROM tb_anggota ORDER BY id DESC");

while ($row = $query->fetch_assoc()) {
    $row['foto_url'] = "http://localhost/uploads/".$row['foto_anggota'];
    $data[] = $row;
}

echo json_encode($data);
