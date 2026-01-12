<?php
header("Content-Type: application/json");
require_once 'db.php';

if (!isset($_POST['id'], $_POST['nama_anggota'], $_POST['status_anggota'])) {
    echo json_encode(['status'=>false,'message'=>'Data tidak lengkap']);
    exit;
}

$id     = $_POST['id'];
$nama   = $_POST['nama_anggota'];
$status = $_POST['status_anggota'];

if (!empty($_FILES['foto_anggota']['name'])) {

    // Ambil foto lama
    $old = $koneksi->query(
        "SELECT foto_anggota FROM tb_anggota WHERE id='$id'"
    )->fetch_assoc();

    if ($old && file_exists("../../uploads/".$old['foto_anggota'])) {
        unlink("../../uploads/".$old['foto_anggota']);
    }

    // Upload foto baru
    $ext = pathinfo($_FILES['foto_anggota']['name'], PATHINFO_EXTENSION);
    $newFile = uniqid().'.'.$ext;
    move_uploaded_file(
        $_FILES['foto_anggota']['tmp_name'],
        "../../uploads/".$newFile
    );

    $query = $koneksi->query(
        "UPDATE tb_anggota SET
        nama_anggota='$nama',
        status_anggota='$status',
        foto_anggota='$newFile'
        WHERE id='$id'"
    );
} else {
    $query = $koneksi->query(
        "UPDATE tb_anggota SET
        nama_anggota='$nama',
        status_anggota='$status'
        WHERE id='$id'"
    );
}

echo json_encode(['status'=>$query ? true : false]);
