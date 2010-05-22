<?php
$l2i=dirname(__FILE__);

$input=$_GET['latex'];
$hash=sha1($input);
$tmpdir=$l2i.'/tmp/'.$hash;
$template=$l2i.'/template.tex';
$filename=$hash.'.png';
$output=$l2i.'/cache/'.$filename;

if (!file_exists($output)) {
    mkdir($tmpdir);
    $echocmd='echo';
    $echocmd.=' '.escapeshellarg($input);
    $l2icmd=escapeshellarg($l2i.'/latex2image');
    $l2icmd.=' -T '.escapeshellarg($tmpdir);
    $l2icmd.=' -t '.escapeshellarg($template);
    $l2icmd.=' -o '.escapeshellarg($output);
    exec($echocmd.' | '.$l2icmd);
    rmdir($tmpdir);
}

header('Content-type: image/png');
echo file_get_contents($l2i.'/cache/'.$filename);
?>
