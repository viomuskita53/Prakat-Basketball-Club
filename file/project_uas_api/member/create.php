<?php
header("Content-Type: application/json");
require_once 'db.php';

if (
    !isset($_POST['nama_anggota'], $_POST['status_anggota']) ||
    empty($_FILES['foto_anggota']['name'])
) {
    echo json_encode(['status'=>false,'message'=>'Data tidak lengkap']);
    exit;
}

$nama   = $_POST['nama_anggota'];
$status = $_POST['status_anggota'];
$foto   = $_FILES['foto_anggota'];

$folder = "../../uploads/";
if (!is_dir($folder)) mkdir($folder, 0777, true);

$ext = pathinfo($foto['name'], PATHINFO_EXTENSION);
$fileName = uniqid().'.'.$ext;

if (!move_uploaded_file($foto['tmp_name'], $folder.$fileName)) {
    echo json_encode(['status'=>false,'message'=>'Upload gagal']);
    exit;
}

$query = $koneksi->query(
    "INSERT INTO tb_anggota (nama_anggota,status_anggota,foto_anggota)
     VALUES ('$nama','$status','$fileName')"
);

echo json_encode([
    'status' => $query ? true : false,
    'message' => $query ? 'Success' : 'Failed'
]);
