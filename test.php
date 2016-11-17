<?php

include 'dbconnect.php';
include 'listCoauthors.php';
set_time_limit(0);
error_reporting(E_ERROR | E_PARSE);

//$filename = "coauth.txt";
//header('Content-Type: application/octet-stream');
//header('Content-Disposition: attachment; filename=' . $filename);

/*For a particular program code, pull all awards. For each award, pull all co-awardees. the $auth hold all co-awardees*/
if (!empty($_COOKIE['prcode'])) {
    $prcode = $_COOKIE['prcode'];
    $conn = dbconnect();
    $sql = "SELECT * FROM investigator i where i.FK_Award in (SELECT a.FK_rootTag FROM programelement pe ,award a WHERE pe.FK_award = a.FK_rootTag and pe.code = '" . $prcode . "')";
    $result = $conn->query($sql);
    $rowcount = mysqli_num_rows($result);
    if ($rowcount > 0) {
        while ($row = $result->fetch_assoc()) {
            $coawardeesList[] = $row;
        }
        echo "Author count : " . count($coawardeesList);
        echo '<br />';
    }
    $conn->close();
}

    echo "Printing coawardeesList :" . print_r($coawardeesList);
    echo '<br /><br />';

    echo "testing...";
    echo '<br /><br />';

    echo "count" . count($coawardeesList);
exit;
    $modifiedCoawardeesList = array(); // firstname, lastname, emailaddr

    for($i = 0; $i < count($coawardeesList) ; $i++){
        $name = $coawardeesList[$i]["FirstName"] . '_' . $coawardeesList[$i]["LastName"];
        echo $name . '<br />';
        $modifiedCoawardeesList[$name] = $coawardeesList[$i]["EmailAddress"];
    }

    echo print_r($modifiedCoawardeesList);
    echo '<br /><br />';

    echo '$modified size:' . count($modifiedCoawardeesList);
    echo '<br /><br />';

    if (array_key_exists("Kelvin_Droegemeier", $modifiedCoawardeesList))
    {
        echo "Key exists!";
    }
    else
    {
        echo "Key does not exist!";
    }




?>