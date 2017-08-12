<?php
include 'dbconnect.php';
global $data;

$filename = "award.txt";
header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename=' . $filename);

if (!empty($_COOKIE['prcode'])) {
    $prcode = $_COOKIE['prcode'];
    $conn = dbconnect();
    //$sql = "SELECT a.FK_rootTag FROM programelement pe ,award a WHERE pe.FK_award = a.FK_rootTag and pe.code = '" . $prcode . "'";
    $sql = "SELECT a.FK_rootTag, a.AwardTitle, a.AwardEffectiveDate, a.AwardExpirationDate, a.AwardAmount, a.AbstractNarration FROM programelement pe, award a WHERE pe.FK_award = a.FK_rootTag and pe.code = '" . $prcode . "'";
    $result = $conn->query($sql);  // $result is a result set type object
    $rowcount = mysqli_num_rows($result); // number of awards
    
	echo "FK_rootTag,\tAwardTitle,\t\t\tAwardEffectiveDate,\tAwardExpirationDate,\tAwardAmount,\tAbstractNarration";
	echo "\r\n";
    
    while($row = $result->fetch_assoc()) {
    	$FKRootTag = $row['FK_rootTag'];
    	$AwardTitle = $row['AwardTitle'];
    	$AwardEffectiveDate = $row['AwardExpirationDate'];
    	$AwardExpirationDate = $row['AwardExpirationDate'];
    	$AwardAmount = $row['AwardAmount'];
    	$AbstractNarration = $row['AbstractNarration'];
    	
    	if(strlen($FKRootTag) > 10)
    		$FKRootTag = substr($FKRootTag, 0, 10);
    	if(strlen($AwardTitle) > 30)
    		$AwardTitle = substr($AwardTitle, 0, 30);
    	if(strlen($AwardEffectiveDate) > 10)
    		$AwardEffectiveDate = substr($AwardEffectiveDate, 0, 10);
    	if(strlen($AwardExpirationDate) > 10)
    		$AwardExpirationDate = substr($AwardExpirationDate, 0, 10);
    	if(strlen($AwardAmount) > 10)
    		$AwardAmount = substr($AwardAmount, 0, 10);
    	if(strlen($AbstractNarration) > 30)
    		$AbstractNarration = substr($AbstractNarration, 0, 30);
    	
//    	print "<tr><td>$FKRootTag</td> <td>$AwardTitle</td> <td>$AwardEffectiveDate</td> <td>$AwardExpirationDate</td> <td>$AwardAmount</td> <td>$AbstractNarration</td> </tr>";
		echo $FKRootTag . ",\t\t" . $AwardTitle . ",\t" . $AwardEffectiveDate . ",\t\t" . $AwardExpirationDate . ",\t\t" . $AwardAmount . ",\t\t" . $AbstractNarration;
		echo "\r\n\r\n";
    }
	
	//    printf("</table>");
    
    //Lillian's code ends here

    $conn->close();
}

?>