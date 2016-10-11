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
            echo "\r\n\r\n";
        }
        $conn->close();
    }

    /* Go through each auth, find all matched co-authors */
    /*Using ob_start() allows you to keep the content in a servier-side buffer until you are ready to display it*/
    $mcount = 0;
    for ($j = 0; $j < count($coawardeesList); $j++) {
        $currentCoawardee = $coawardeesList[$j];
        $match = 'No Match';

        $coauthorArray = [];
        /*Build co-author array for current author*/
        foreach ($auth as $coarray) {
            if ($coarray["FK_Award"] == $arow["FK_Award"]) {
                $coautharr[] = $coarray; /* TODO: ANY PROBLEM?*/
            }
        }
    
        /*Build Scopus Author Search query*/
        $currentCoawardee_url = 'https://api.elsevier.com/content/search/author?query=authlast(' . urlencode($currentCoawardee["LastName"]) . ')%20and%20authfirst(' . urlencode($currentCoawardee["FirstName"]) . ')&insttoken=' . $insttoken . '&apiKey=' . $apiKey . '&httpAccept=application/json';
        echo 'auth_url ---- ' . $currentCoawardee_url; echo "\r\n";
        $opts = array('http' => array('header' => "User-Agent:MyAgent/1.0\r\n"));
        $context = stream_context_create($opts);
        $authorres = file_get_contents($currentCoawardee_url, false, $context);
        $author_json = json_decode($authorres, true);

        if (!empty($author_json)) {             
                    foreach ($author_json['search-results']['entry'] as $author) {

                        list($a, $b, $coawardee_id) = explode('-', $author['eid']);
            //          Build Scopus co-author search query

                        $coauthors_list = listCoauthors($coawardee_id);
                        for($i=0;$i<count($coauthors_list);$i++) {
                            echo $coauthors_list[$i] . '<br>';
                        }
                        
                        $coauthors_list = listCoauthors($coawardee_id);

                        $coauthurl = 'https://api.elsevier.com/content/search/author?co-author=' . urlencode($coawardee_id) . '&insttoken=' . $insttoken . '&apiKey=' . $apiKey . '&httpAccept=application/json';
                        echo 'coauthurl ---- ' . $coauthurl;
                        echo "\r\n";
                        $opts = array('http' => array('header' => "User-Agent:MyAgent/1.0\r\n"));
                        $context = stream_context_create($opts);
                        $coauthorres = file_get_contents($coauthurl, false, $context);
                        $coauthor_json = json_decode($coauthorres, true);

                        /* if there is only one entry returned, then this must be the only author */
                        if (count($author_json['search-results']['entry']) == 1) {
                            $match = $coawardee_id . ' - Single Result Match';
                        }
                        /* THIS IS NON_SENSE, TODO: REMOVE */
                        if (!empty($coauthorArray)) {
                            for ($i = 0; $i < count($coauthorArray); $i++) {
            //                      Concat NSF co-author FirstName and LastName for levenshtein
                                $cofullnsf = $coauthorArray[$i]['FirstName'] . " " . $coauthorArray[$i]['LastName'];

                                if (!empty($coauthor_json)) {
                                    foreach ($coauthor_json['search-results']['entry'] as $coauthor) {
            //                              Concat Scopus co-author FirstName and LastName for lev
                                        $cofull = $coauthor['preferred-name']['given-name'] . " " . $coauthor['preferred-name']['surname'];
            //                              Fetch similarity between NSF co-author and Scopus co-author
                                        $similarity = lev(strtolower($cofullnsf), strtolower($cofull));
            //                              Similarity threshold = 0.4 (Good results)
                                        if ($similarity < 0.4) {
                                            $match = $coawardee_id . ' - Co-Author Match';
                                        }
            //                                        echo '<br/>NSF co full : ' . $cofullnsf . '<br/>Scopus co full : ' . $cofull . '<br/>Similarity : ' . $similarity;
                                    }
                                }
                            }
                        }

            //              Compare affiliation cities if still no match found
                        if ($match == 'No Match') {
                            //                          echo '-- In No Match if --';
                            $awa = $currentCoawardee["FK_Award"];
                            $conn = dbconnect();
                            $citysql = 'SELECT * FROM institution WHERE FK_Award = ' . $awa;
                            $cresult = $conn->query($citysql);
                            $crow = $cresult->fetch_assoc();
                            //                           echo $crow["Name"];
                            //                          echo $crow["CityName"];
                            //                           echo $author['affiliation-current']['affiliation-city'];
                            $cname = $crow["CityName"];
                            $cname_scopus = $author['affiliation-current']['affiliation-city'];
                            if (!empty($cname) && !empty($cname_scopus)) {
                                $citysim = lev(strtolower($cname), strtolower($cname_scopus));
                                if ($citysim < 0.4) {
                                    $match = $coawardee_id . ' - Affiliation City Match';
                                }
                            }
                            mysqli_close($conn);
                        }
                    }
        }
        // fetch author affiliation and location
        $awa1 = $currentCoawardee["FK_Award"];
        $conn1 = dbconnect();
        $citysql1 = 'SELECT * FROM institution WHERE FK_Award = ' . $awa1;
        $cresult1 = $conn1->query($citysql1);
        $crow1 = $cresult1->fetch_assoc();

        if ($match != 'No Match') {
            $mcount++;
        }
        echo 'NSF Author Name : ' . $currentCoawardee["FirstName"] . " " . $currentCoawardee["LastName"];
        echo "\r\n";
        echo 'Scopus Author ID : ' . $match;
        echo "\r\n";
        echo 'Affiliation : ' . $crow1["Name"]; /*$Affiliation[] = $crow1["Name"];*/
        echo "\r\n";
        echo 'Location : ' . $crow1["CityName"];
        echo "\r\n";
    }

?>


