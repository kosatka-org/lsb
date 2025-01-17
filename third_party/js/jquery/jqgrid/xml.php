<?php

$page = $_GET['page']; // get the requested page 
$limit = $_GET['rows']; // get how many rows we want to have into the grid 
$sidx = $_GET['sidx']; // get index row - i.e. user click to sort 
$sord = $_GET['sord']; // get the direction 
$searchField = $_GET['searchField'];
$searchString = $_GET['searchString'];

if(!$sidx) $sidx =1; // connect to the database 
$dbhost = "p50mysql213.secureserver.net";
$dbuser = "musicsurvey";
$dbpassword = "Alohario1005";
$database = "musicsurvey";
$db = mysql_connect($dbhost, $dbuser, $dbpassword) or die("Connection Error: " . mysql_error()); 
mysql_select_db($database) or die("Error conecting to db."); 


if (isset($searchField)) {
$result = mysql_query("SELECT COUNT(*) AS count FROM jqgrid where $searchField = '$searchString'"); 
} else {
$result = mysql_query("SELECT COUNT(*) AS count FROM jqgrid"); 
}
//$result = mysql_query("SELECT COUNT(*) AS count FROM invheader a, clients b WHERE a.client_id=b.client_id"); 
//$result = mysql_query("SELECT COUNT(*) AS count FROM jqgrid"); 
$row = mysql_fetch_array($result,MYSQL_ASSOC); 
// print_r($row);
$count = $row['count']; 
if( $count >0 ) { $total_pages = ceil($count/$limit); } else { $total_pages = 0; } 
if ($page > $total_pages) $page=$total_pages; 
$start = $limit*$page - $limit; // do not put $limit*($page - 1) 

if (isset($searchField)) {
$SQL = "SELECT * FROM jqgrid WHERE $searchField = '$searchString' ORDER BY $sidx $sord LIMIT $start , $limit";  
} else {
$SQL = "SELECT * FROM jqgrid ORDER BY $sidx $sord LIMIT $start , $limit";  
}

$result = mysql_query( $SQL ) or die("Couldn't execute query.".mysql_error()); 

if ( stristr($_SERVER["HTTP_ACCEPT"],"application/xhtml+xml") ) { 
header("Content-type: application/xhtml+xml;charset=utf-8"); 
} else { 
header("Content-type: text/xml;charset=utf-8"); 
} 
$et = ">"; 

echo "<?xml version='1.0' encoding='utf-8'?$et\n"; 
echo "<rows>"; echo "<page>".$page."</page>"; 
echo "<total>".$total_pages."</total>"; 
echo "<records>".$count."</records>"; // be sure to put text data in CDATA 
while($row = mysql_fetch_array($result,MYSQL_ASSOC)) { 
echo "<row id='". $row[id]."'>"; 
echo "<cell>". $row[title]."</cell>"; 
echo "<cell>". $row[director]."</cell>"; 
echo "<cell>". $row[year]."</cell>"; 
echo "<cell>". $row[bond]."</cell>"; 
echo "<cell>". $row[budget]."</cell>"; 
echo "</row>"; } 
echo "</rows>"; 
?>