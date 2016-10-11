<?php
/**
 * Created by PhpStorm.
 * User: lizichen1
 * Date: 10/10/16
 * Time: 8:54 PM
 */
include 'simple_html_dom.php';

$html = file_get_html('./simpleHtmlTest.html');

// Find all images
foreach($html->find('img') as $element)
    echo $element->src . '<br>';

// Find all links
foreach($html->find('a') as $element)
    echo $element->href . '<br>';

?>