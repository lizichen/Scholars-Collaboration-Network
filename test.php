<?php

// test function call to listCoauthors.php
include 'listCoauthors.php';
$id = "7202909704";

$j = 2;
$coauthors_list = listCoauthors($j);

print_r($coauthors_list);


/*function listCoauthors($j){
    $arr = array();
    for($i = 0;$i<3;$i++)
        $arr[] = $i+$j;
    return $arr;
}*/


?>