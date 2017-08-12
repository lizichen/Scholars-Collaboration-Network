<?php

    include 'dbconnect.php';
    global $data;

    $filename = "publication.txt";
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename=' . $filename);

    /*For a particular program code, pull all awards. For each award, pull all co-awardees. the $auth hold all co-awardees*/
    if (!empty($_COOKIE['prcode'])) {
        $prcode = $_COOKIE['prcode'];
        $conn = dbconnect();
        $sql = "SELECT * FROM investigator i where i.FK_Award in (SELECT a.FK_rootTag FROM programelement pe ,award a WHERE pe.FK_award = a.FK_rootTag and pe.code = '" . $prcode . "')";
        $result = $conn->query($sql);
        $rowcount = mysqli_num_rows($result);
        if ($rowcount > 0) {
            while ($row = $result->fetch_assoc()) {
                $auth[] = $row;
            }
            echo "Author count : " . count($auth);
            echo "\r\n\r\n";
        }
        $conn->close();
    }

    /*
     * Affiliation is changeable, so do not care about any return of affiliation
     */

    /* TRY Elsevier API CALL
     *   1 - https://api.elsevier.com/content/search/author?
     *           query=authlast(Kurose)%20and%20authfirst(James)
     *           &insttoken=06d854b13701f22287228210264ee7b2
     *           &apiKey=7216db0161f82c6337c5f6ae7d96d05a
     *           &httpAccept=application/json
     *      Return: author_id
     *              eid
     *
     */

    /*  $auth <-- List of all the co-awardees,
        foreach co-awardee C in $auth
            ListOfPublications_C <-- elsevierCall(C.firstname, C.lastname)
            for
     */






    if (!empty($_COOKIE['prcode'])) {
        $prcode = $_COOKIE['prcode'];
        $conn = dbconnect();
        //$sql = "SELECT a.FK_rootTag FROM programelement pe ,award a WHERE pe.FK_award = a.FK_rootTag and pe.code = '" . $prcode . "'";
        $sql = "SELECT a.FK_rootTag, a.AwardTitle, a.AwardEffectiveDate, a.AwardExpirationDate, a.AwardAmount, a.AbstractNarration FROM programelement pe, award a WHERE pe.FK_award = a.FK_rootTag and pe.code = '" . $prcode . "'";
        $result = $conn->query($sql);  // $result is a result set type object
        $rowcount = mysqli_num_rows($result);
//        if ($rowcount > 0) {
//            echo "Award count : " . $rowcount;
//        }

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
            echo $FKRootTag . ', ' . $AwardTitle . ', ' . $AwardEffectiveDate . ', ' . $AwardExpirationDate . ', ' . $AwardAmount . ', ' . $AbstractNarration;
            echo "\r\n\r\n";
        }

        $conn->close();
    }

?>