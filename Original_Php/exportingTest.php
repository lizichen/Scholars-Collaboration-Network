<?php

/* Export with octet-stream. Get all print-out content into a downloadable file */
$filename = "document.txt";
header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename=' . $filename);
echo "Hello!";

?>