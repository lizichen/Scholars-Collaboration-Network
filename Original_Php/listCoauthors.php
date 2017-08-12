<?php
//http://simplehtmldom.sourceforge.net/manual.htm
include 'simple_html_dom.php';

function listCoauthors($Id){

    //echo $Id;

    $scopsUsername = "lc3397@nyu.edu";
    $scopsPassword = "phdINusa!)15";
    $curl_postfields = "username-input=".$scopsUsername."&password-input=".$scopsPassword;

    $authorId = $Id; //"7202909704";
    $coauthor_list = array();

    $ch = curl_init();
    $url = 'https://www.scopus.com/customer/authenticate/loginfull.uri';
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_URL, $url);
    $cookieFile = 'cookie.txt';
    $timeout = 30;
    curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_TIMEOUT,         10);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT,  $timeout);
    curl_setopt($ch, CURLOPT_COOKIEJAR,       $cookieFile);
    curl_setopt($ch, CURLOPT_COOKIEFILE,      $cookieFile);
    curl_setopt ($ch, CURLOPT_POST, 1);
    curl_setopt ($ch,CURLOPT_POSTFIELDS, $curl_postfields);

//Redirect to another page after login
    $url_coauthor = "https://www.scopus.com/author/coauthordetails.uri?authorId=".$authorId;
    curl_setopt ($ch, CURLOPT_POST, 0);
    curl_setopt($ch, CURLOPT_URL, $url_coauthor);

    $output = curl_exec($ch);

    $scrapped = str_get_html($output);
    foreach($scrapped->find("div.coAuthorName div span a") as $element){
        $coauthor_list[] = $element;// . '<br>';
        //echo $element;
    }

    curl_close($ch);
    // need to return a list names;
    return $coauthor_list;
}

?>


