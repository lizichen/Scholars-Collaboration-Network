<?php

session_start(); // this NEEDS TO BE AT THE TOP of the page before any output etc

//Set unlimited script execution time
set_time_limit(0);

//Supress warnings
error_reporting(E_ERROR | E_PARSE);

if(isset($_POST['submit_docs'])){
    header("Content-Type: application/xls");
    header("content-disposition: attachment;filename=samplexcel.xls");
}

echo "<html>";
echo $_SESSION['superhero'];
echo "</html>";  

?>


