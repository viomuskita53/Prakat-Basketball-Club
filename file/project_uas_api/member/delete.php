<?php
header("Content-Type: application/json");
require_once 'db.php';

if (!isset($_POST['id'])) {
    echo json_encode(['status'=>false,'message'=>'ID tidak ada']);
    exit;
}

$id = $_POST['id'];

$foto = $koneksi->query(
    "SELECT foto_anggota FROM tb_anggota WHERE id='$id'"
)->fetch_assoc();

if ($foto && file_exists("../../uploads/".$foto['foto_anggota'])) {
    unlink("../../uploads/".$foto['foto_anggota']);
}

$query = $koneksi->query("DELETE FROM tb_anggota WHERE id='$id'");

echo json_encode(['status'=>$query ? true : false]);
