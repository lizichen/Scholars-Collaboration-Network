<?php
/**
 * Created by PhpStorm.
 * User: lizichen1
 * Date: 1/25/17
 * Time: 9:31 PM
 */

$scopsUsername = "lc3397@nyu.edu";
$scopsPassword = "phdINusa!)15";
//$curl_postfields = "username-input=".$scopsUsername."&password-input=".$scopsPassword;
$curl_postfields = "username=".$scopsUsername."&password=".$scopsPassword;

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
$url_coauthor = "https://www.scopus.com/onclick/export.uri?oneClickExport=%7b%22Format%22%3a%22CSV%22%2c%22View%22%3a%22CiteOnly%22%7d&origin=AuthorProfile&zone=resultsListHeader&dataCheckoutTest=false&sort=plf-f&tabSelected=docLi&authorId=26023359000&txGid=EDC2B2AFFD9E4AC24F0282233C3C7CCC.wsnAw8kcdt7IPYLO0V48gA%3a73";
curl_setopt ($ch, CURLOPT_POST, 0);
curl_setopt($ch, CURLOPT_URL, $url_coauthor);

$output = curl_exec($ch);

echo $output

?>


https://www.scopus.com/onclick/export.uri?oneClickExport=%7b%22Format%22%3a%22CSV%22%2c%22View%22%3a%22CiteOnly%22%7d&origin=AuthorProfile&zone=resultsListHeader&dataCheckoutTest=false&sort=plf-f&tabSelected=docLi&authorId=26023359000&txGid=EDC2B2AFFD9E4AC24F0282233C3C7CCC.wsnAw8kcdt7IPYLO0V48gA%3a73

https://www.scopus.com/onclick/export.uri?oneClickExport={"Format":"CSV","View":"CiteOnly"}&origin=AuthorProfile&zone=resultsListHeader&dataCheckoutTest=false&sort=plf-f&tabSelected=docLi&authorId=26023359000&txGid=EDC2B2AFFD9E4AC24F0282233C3C7CCC.wsnAw8kcdt7IPYLO0V48gA:73

All needed:
SCSessionID=452EF6EDDA3B9073318C5149E9ED9A95.wsnAw8kcdt7IPYLO0V48gA
AE_SESSION_COOKIE=1487906518789
CARS_COOKIE=00320077004A002B0048004B0067004A00730051002F002F00590067007100710037004500470033003000470078007800370076004E006200360075006A004D005000460073007100690054004B00440048002F004E0056007A003400380049006E007400760049007A0035004E007500580054004A0073004100550035007900410057006F006900410071005700460055004E0030004C00780037007600680031006E0068006B0049007300320049004B0061005800510057003000730052005A006C0038004700480053006E002F0037007A0065003400750042004D0048006D0037004900510050002B004A005100320036005200370036004400670063


cat url_scopus | xargs curl -c cookies.txt -I # -I just to verify the headers
cat url_scopus | xargs curl -b cookies.txt -I > author.csv # gets the data and outputs to file


