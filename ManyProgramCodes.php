<?php

include 'dbconnect.php';

set_time_limit(0);

$numberOfProgramCodes = 40;

$conn = dbconnect();
$sql = "SELECT * FROM programelement p LIMIT ".$numberOfProgramCodes;
$result = $conn->query($sql);
$rowcount = mysqli_num_rows($result);

if ($rowcount > 0) {
    while ($row = $result->fetch_assoc()) {
        $coawardeesList[] = $row;
    }
}

$coawardeeCountList = array();

for($k = 0; $k < $numberOfProgramCodes; $k++){
    $prcode = $coawardeesList[$k]["Code"];
    $sql = "SELECT * FROM investigator i where i.FK_Award in (SELECT a.FK_rootTag FROM programelement pe ,award a WHERE pe.FK_award = a.FK_rootTag and pe.code = '" . $prcode . "')";
    $numberOfCoawardees = $conn->query($sql);
    $rowcount = mysqli_num_rows($numberOfCoawardees);
    $coawardeeCountList[$k] = $rowcount;
}
$conn->close();

?>


<html>
    <header></header>
    <body>

    <h3>Top Program Codes in Our Database</h3>
    <table style="width:100%">
        <?php
             for($i = 0; $i < $numberOfProgramCodes; $i++){
        ?>
                <tr>
                    <th>
                        <?php echo ' PrCode: '.$coawardeesList[$i]["Code"]  .'  NumOfCoawardees: '.$coawardeeCountList[$i++] ?>
                    </th>
                    <th>
                        <?php echo ' PrCode: '.$coawardeesList[$i]["Code"].'  NumOfCoawardees: '.$coawardeeCountList[$i++] ?>
                    </th>
                    <th>
                        <?php echo ' PrCode: '.$coawardeesList[$i]["Code"].'  NumOfCoawardees: '.$coawardeeCountList[$i++] ?>
                    </th>
                    <th>
                        <?php echo ' PrCode: '.$coawardeesList[$i]["Code"].'  NumOfCoawardees: '.$coawardeeCountList[$i] ?>
                    </th>
                </tr>
        <?php
            }
        ?>

    </table>

    </body>
</html>
