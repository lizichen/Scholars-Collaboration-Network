<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Research Web Portal</title>
        <link rel="stylesheet" href="css/style.css" type="text/css" />
    </head>
    <body>
        <div id="centered">
            Enter program code to begin search.<br><br>
            <form action="results.php" method="get">

                <input type="text" name="pcode"><br><br>

                <input type="radio" name="dbtable" value="award"> Award Database.<br>
                <input type="radio" name="dbtable" value="coauth"> Co-Author Database.<br>
                <input type="radio" name="dbtable" value="coawardlink"> Co-Award Link Database.<br>
                <input type="radio" name="dbtable" value="pub"> Publication Database.<br>
                <input type="radio" name="dbtable" value="coauthlink"> Co-Author Link Database.<br>
                <input type="radio" name="dbtable" value="disaff"> Disciplinary Affiliation Database.<br><br>       

                <button type="submit" name="search">Get Results</button>

                <br /> <br />

                <a href="ManyProgramCodes.php">Find Program Code (Top 40 Program Codes) </a><br />
                <a href="prcodePreviousRun.html">Most Recent PrCode Query (400 Program Codes)</a>

            </form>
        </div>
        <div id="updateVersion">
            <p>Update: Sunday Nov 20, 2016</p>
        </div>  
    </body>
</html>
