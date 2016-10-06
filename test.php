<?php

include 'dbconnect.php';
set_time_limit(0);
$arow = 6468;
$match = 'No Match';
$prcode = 'O233';
$conn= dbconnect();
$sql = "SELECT * FROM investigator i where i.FK_Award in (SELECT a.FK_rootTag FROM programelement pe ,award a WHERE pe.FK_award = a.FK_rootTag and pe.code = '" . $prcode . "')";
$result = $conn->query($sql);
$citysql = 'SELECT * FROM institution WHERE FK_Award = ' . $arow;
$cresult = $conn->query($citysql);
$crowcount = mysqli_num_rows($cresult);
$row = $cresult->fetch_assoc();
$citysim = lev($row["CityName"], 'Urbana');
if ($citysim < 0.4) {
    $match = $row["CityName"] . ' Affiliation City match';
}

echo $match;


