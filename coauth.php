<?php
    include 'dbconnect.php';
    include 'listCoauthors.php';
    set_time_limit(0);
    error_reporting(E_ERROR | E_PARSE);

    $filename = "coauth.txt";
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
                $coawardeesList[] = $row;
            }
            echo "Author count : " . count($coawardeesList);
            echo '<br />';
        }
        $conn->close();
    }

    //echo "Printing coawardeesList :" . print_r($coawardeesList);
    echo '<br /><br />';

    // TODO: optimize the search in the coawardeesList, HashMap Data Structure!
    $modifiedCoawardeesList = array(); // firstname_lastname => emailaddress

    /* Go through each auth, find all matched co-authors */
    /*Using ob_start() allows you to keep the content in a servier-side buffer until you are ready to display it*/
    $mcount = 0;
    for ($j = 0; $j < count($coawardeesList); $j++) {
        $currentCoawardee = $coawardeesList[$j];

        /*Build Scopus Author Search query*/
        $currentCoawardee_url = 'https://api.elsevier.com/content/search/author?query=authlast(' . urlencode($currentCoawardee["LastName"]) . ')%20and%20authfirst(' . urlencode($currentCoawardee["FirstName"]) . ')&insttoken=' . $insttoken . '&apiKey=' . $apiKey . '&httpAccept=application/json';
        echo 'auth_url ---- ' . $currentCoawardee_url . '<br /><br />';
        $opts = array('http' => array('header' => "User-Agent:MyAgent/1.0\r\n"));
        $context = stream_context_create($opts);
        $authorres = file_get_contents($currentCoawardee_url, false, $context);
        $author_json = json_decode($authorres, true);

        if (!empty($author_json)) {

                    $maxRelations = 0;
                    $realCoawardeeID = 0;

                    foreach ($author_json['search-results']['entry'] as $author) {

                        list($a, $b, $coawardee_id) = explode('-', $author['eid']);
                        // Build Scopus co-author search query
                        echo ' #### GET A NEW POSSIBLE ID: ' . $coawardee_id . '<br />';
                        $coauthors_list = listCoauthors($coawardee_id);
                        //echo 'CurrentCoawardee -- LastName:' . print_r($currentCoawardee["LastName"]) . ' FirstName:' . print_r($currentCoawardee["FirstName"]) . '<br /><br />';
                        $hasRelation = 0;
                        for($i=0;$i<count($coauthors_list);$i++) {
                            //echo $coauthors_list[$i]->plaintext;
                            $anAuthor = $coauthors_list[$i]->plaintext;
                            // if $anAuthor is one of the coawardeesList, then relationship weight increment

                            for($k=0; $k < count($coawardeesList); $k++){
                                if(strripos($anAuthor, $coawardeesList[$k]["LastName"]) > 0
                                    && strripos($anAuthor, $coawardeesList[$k]["FirstName"]) > 0 ){
                                    $hasRelation++;
                                    //echo '     Related Co-Author :' . $anAuthor . '<br />';
                                }
                            }
                        }

                        if($hasRelation > $maxRelations){ // meaning we found one authentic coawardee in the coawardeesList.
                            $realCoawardeeID = $coawardee_id;
                            $maxRelations = $hasRelation;
                        }

                    }

                    if($maxRelations > 0){
                        $url = "https://www.scopus.com/author/coauthordetails.uri?authorId=".$realCoawardeeID;
                        echo 'Real Co-awardee ID = ' . $realCoawardeeID . '   ' . $currentCoawardee["FirstName"] . ' ' . $currentCoawardee["LastName"] . '  ';
                        echo '<a href="' . $url . '">' . 'Scopus URL' . '</a><br />';
                        $name = $currentCoawardee["FirstName"] . '_' . $currentCoawardee["LastName"];
                        $modifiedCoawardeesList[$name] = $realCoawardeeID;
                    }
        }

//        // fetch author affiliation and location
//        $awa1 = $currentCoawardee["FK_Award"];
//        $conn1 = dbconnect();
//        $citysql1 = 'SELECT * FROM institution WHERE FK_Award = ' . $awa1;
//        $cresult1 = $conn1->query($citysql1);
//        $crow1 = $cresult1->fetch_assoc();
//
//        if ($match != 'No Match') {
//            $mcount++;
//        }
//        echo 'NSF Author Name : ' . $currentCoawardee["FirstName"] . " " . $currentCoawardee["LastName"];
//        echo '<br />';
//        echo 'Scopus Author ID : ' . $match;
//        echo '<br />';
//        echo 'Affiliation : ' . $crow1["Name"]; /*$Affiliation[] = $crow1["Name"];*/
//        echo '<br />';
//        echo 'Location : ' . $crow1["CityName"];
//        echo '<br />';

    }

    echo '<br /><br />';
    echo 'Generating Author, Publication, Co-author Relational Map....';
    echo '<br /><br /><br />';

    // now, we have all coawardee's real author id
    foreach($modifiedCoawardeesList as $name => $id){
        echo $name . ' '. $id . '<br />';
        echo 'Each of the following authors has been collaborated with '.$name.' on a publication. <br />';

        $currentCoawardee_url = 'https://api.elsevier.com/content/search/scopus?query=AU-ID('.$id.')&field=dc:identifier&count=20&httpAccept=application/json&apikey='.$apiKey;
        //echo $currentCoawardee_url.'<br />';
        $opts = array('http' => array('header' => "User-Agent:MyAgent/1.0\r\n"));
        $context = stream_context_create($opts);

        $documents = file_get_contents($currentCoawardee_url, false, $context);
        $document_json = json_decode($documents, true);

        foreach($document_json['search-results']['entry'] as $doc) {
            list($scopus_id_label, $scopus_id) = explode(':', $doc["dc:identifier"]);
            $doc_url = 'https://api.elsevier.com/content/abstract/scopus_id/'
                .$scopus_id.'?httpAccept=application/json&apikey='.$apiKey;
            //echo $doc_url.'<br />';
            $doc_detail = file_get_contents($doc_url, false, $context);
            $doc_json = json_decode($doc_detail, true);

            $doc_title = $doc_json['abstracts-retrieval-response']['coredata']['dc:title'];
            $doc_author_firstName = $doc_json['abstracts-retrieval-response']['coredata']['dc:creator']['author'][0]['preferred-name']['ce:given-name'];
            $doc_author_lastName = $doc_json['abstracts-retrieval-response']['coredata']['dc:creator']['author'][0]['preferred-name']['ce:surname'];

            //echo 'Publication Title: '.$doc_title . '<br />   '
            echo $doc_author_firstName.' '.$doc_author_lastName.'<br />';
        }

        // for each $name, get all documents
        // we have:
        //      $name => $id
        // we need:
        //      $name => $document => [a list of authors]
        //      $name => $document => [a list of authors]
        //      $name => $document => [a list of authors]
        echo '<br /><br />';
    }


?>


