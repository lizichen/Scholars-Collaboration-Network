<?php
include 'dbconnect.php';
//Set unlimited script execution time
set_time_limit(0);
//Supress warnings
error_reporting(E_ERROR | E_PARSE);
if (!empty($_GET['pcode'])) {
    if ($_GET['dbtable'] == 'award') { /*Award Database*/
        setcookie(prcode, $_GET['pcode']);

        header("Location: awards.php");
        exit;
    }
    if ($_GET['dbtable'] == 'coauth') { /*Co-Author Database*/
        setcookie(prcode, $_GET['pcode']);
        header("Location: coauth.php");
        exit;
    }
    if ($_GET['dbtable'] == 'coawardlink') { /*Co-Award Link Database*/
        setcookie(prcode, $_GET['pcode']);
        header("Location: coawardlink.php");
        exit;
    }    
    if ($_GET['dbtable'] == 'pub') { /*Publication Database*/
        setcookie(prcode, $_GET['pcode']);
        header("Location: publication.php");
        exit;
    }
    if ($_GET['dbtable'] == 'coauthlink') { /*Co-Author Link Database*/
        setcookie(prcode, $_GET['pcode']);
        header("Location: coauth.php");
        exit;
    }
    if ($_GET['dbtable'] == 'disaff') { /*Disciplinary Affiliation Database*/
        setcookie(prcode, $_GET['pcode']);
        header("Location: coauth.php");
        exit;
    }
}
?>



