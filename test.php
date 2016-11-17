<?php

// TESTING:
// For one specific author:
$currentCoawardee_url = 'https://api.elsevier.com/content/search/scopus?query=AU-ID(7006843462)&field=dc:identifier&count=10&httpAccept=application/json&apikey=7216db0161f82c6337c5f6ae7d96d05a';

$opts = array('http' => array('header' => "User-Agent:MyAgent/1.0\r\n"));
$context = stream_context_create($opts);
$documents = file_get_contents($currentCoawardee_url, false, $context);
$document_json = json_decode($documents, true);

foreach($document_json['search-results']['entry'] as $doc) {
    list($scopus_id_label, $scopus_id) = explode(':', $doc["dc:identifier"]);
    $doc_url = 'https://api.elsevier.com/content/abstract/scopus_id/'
        .$scopus_id.'?httpAccept=application/json&apikey=7216db0161f82c6337c5f6ae7d96d05a';
    $doc_detail = file_get_contents($doc_url, false, $context);
    $doc_json = json_decode($doc_detail, true);

    $doc_title = $doc_json['abstracts-retrieval-response']['coredata']['dc:title'];
    $doc_author_firstName = $doc_json['abstracts-retrieval-response']['coredata']['dc:creator']['author'][0]['preferred-name']['ce:given-name'];
    $doc_author_lastName = $doc_json['abstracts-retrieval-response']['coredata']['dc:creator']['author'][0]['preferred-name']['ce:surname'];

    echo $doc_title . '<br />   ' . 'Author: '.$doc_author_firstName.' '.$doc_author_lastName.'<br />';
}


?>