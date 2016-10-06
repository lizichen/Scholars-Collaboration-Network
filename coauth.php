<?php
    include 'dbconnect.php';
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
                $auth[] = $row;
            }
            echo "Author count : " . count($auth);
            echo "\r\n\r\n";
        }
        $conn->close();
    }

    /* Go through each auth, find all matched co-authors */
    /*Using ob_start() allows you to keep the content in a servier-side buffer until you are ready to display it*/
    $mcount = 0;
    for ($j = 0; $j < count($auth); $j++) {
        $arow = $auth[$j];
        $match = 'No Match';

        $coautharr = [];
        /*Build co-author array for current author*/
        foreach ($auth as $coarray) {
            if ($coarray["FK_Award"] == $arow["FK_Award"]) {
                $coautharr[] = $coarray; /* TODO: ANY PROBLEM?*/
            }
        }
    
        /*Build Scopus Author Search query*/
        $auth_url = 'https://api.elsevier.com/content/search/author?query=authlast(' . urlencode($arow["LastName"]) . ')%20and%20authfirst(' . urlencode($arow["FirstName"]) . ')&insttoken=' . $insttoken . '&apiKey=' . $apiKey . '&httpAccept=application/json';
        echo 'auth_url ---- ' . $auth_url; echo "\r\n";
        $opts = array('http' => array('header' => "User-Agent:MyAgent/1.0\r\n"));
        $context = stream_context_create($opts);
        $authorres = file_get_contents($auth_url, false, $context);
        $author_json = json_decode($authorres, true);

        if (!empty($author_json)) {
                    // James Kurose
                    foreach ($author_json['search-results']['entry'] as $author) {
                        list($a, $b, $auid) = explode('-', $author['eid']);
            //              Build Scopus co-author search query
                        $coauthurl = 'https://api.elsevier.com/content/search/author?co-author=' . urlencode($auid) . '&insttoken=' . $insttoken . '&apiKey=' . $apiKey . '&httpAccept=application/json';
                        echo 'coauthurl ---- ' . $coauthurl;
                        echo "\r\n";
                        $opts = array('http' => array('header' => "User-Agent:MyAgent/1.0\r\n"));
                        $context = stream_context_create($opts);
                        $coauthorres = file_get_contents($coauthurl, false, $context);
                        $coauthor_json = json_decode($coauthorres, true);

                        /* if there is only one entry returned, then this must be the only author */
                        if (count($author_json['search-results']['entry']) == 1) {
                            $match = $auid . ' - Single Result Match';
                        }
                        /* THIS IS NON_SENSE, TODO: REMOVE */
                        if (!empty($coautharr)) {
                            for ($i = 0; $i < count($coautharr); $i++) {
            //                      Concat NSF co-author FirstName and LastName for levenshtein
                                $cofullnsf = $coautharr[$i]['FirstName'] . " " . $coautharr[$i]['LastName'];

                                if (!empty($coauthor_json)) {
                                    foreach ($coauthor_json['search-results']['entry'] as $coauthor) {
            //                              Concat Scopus co-author FirstName and LastName for lev
                                        $cofull = $coauthor['preferred-name']['given-name'] . " " . $coauthor['preferred-name']['surname'];
            //                              Fetch similarity between NSF co-author and Scopus co-author
                                        $similarity = lev(strtolower($cofullnsf), strtolower($cofull));
            //                              Similarity threshold = 0.4 (Good results)
                                        if ($similarity < 0.4) {
                                            $match = $auid . ' - Co-Author Match';
                                        }
            //                                        echo '<br/>NSF co full : ' . $cofullnsf . '<br/>Scopus co full : ' . $cofull . '<br/>Similarity : ' . $similarity;
                                    }
                                }
                            }
                        }

            //              Compare affiliation cities if still no match found
                        if ($match == 'No Match') {
                            //                          echo '-- In No Match if --';
                            $awa = $arow["FK_Award"];
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
                                    $match = $auid . ' - Affiliation City Match';
                                }
                            }
                            mysqli_close($conn);
                        }
                    }
        }
        // fetch author affiliation and location
        $awa1 = $arow["FK_Award"];
        $conn1 = dbconnect();
        $citysql1 = 'SELECT * FROM institution WHERE FK_Award = ' . $awa1;
        $cresult1 = $conn1->query($citysql1);
        $crow1 = $cresult1->fetch_assoc();

        if ($match != 'No Match') {
            $mcount++;
        }
        echo 'NSF Author Name : ' . $arow["FirstName"] . " " . $arow["LastName"];
        echo "\r\n";
        echo 'Scopus Author ID : ' . $match;
        echo "\r\n";
        echo 'Affiliation : ' . $crow1["Name"]; /*$Affiliation[] = $crow1["Name"];*/
        echo "\r\n";
        echo 'Location : ' . $crow1["CityName"];
        echo "\r\n";
    }
?>



https://api.elsevier.com/content/search/author?query=authlast(Kurose)%20and%20authfirst(James)&insttoken=06d854b13701f22287228210264ee7b2&apiKey=7216db0161f82c6337c5f6ae7d96d05a&httpAccept=application/json

https://api.elsevier.com:80/content/search/scidir?start=0&count=5&query=specific-authkey(James Kurose)&view=COMPLETE&ver=new&insttoken=06d854b13701f22287228210264ee7b2&apiKey=7216db0161f82c6337c5f6ae7d96d05a&httpAccept=application/json

https://api.elsevier.com/content/search/scidir?start=0&count=5&query=aus(James%20Kurose)+eid(9-s2.0-56976084800)&view=COMPLETE&ver=new&insttoken=06d854b13701f22287228210264ee7b2&apiKey=7216db0161f82c6337c5f6ae7d96d05a&httpAccept=application/json