<?php

// write and print an array with non-sequenced digit keys. 
$arr = array();
for($i = 0; $i < 5; $i++){
    $key = 'key'.$i;
    $value = 'value_'.$i;
    $arr[$key] = $value;
}

echo print_r($arr);
echo '<br /><br />';

foreach ($arr as $key => $value) {
    echo $key . ' '. $value . '<br />';
}

?>