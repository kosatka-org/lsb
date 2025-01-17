<?php

$page = $_POST['page']; // get the requested page 
$limit = $_POST['rows']; // get how many rows we want to have into the grid 
$sidx = $_POST['sidx']; // get index row - i.e. user click to sort 
$sord = $_POST['sord']; // get the direction 
$searchField = $_POST['searchField'];
$searchString = $_POST['searchString'];

if(!$sidx) $sidx =1; // connect to the database 

if(isset($_GET["title_mask"])) $title_mask = $_GET['title_mask']; 
else $person_mask = ""; 
if(isset($_GET["director_mask"])) $director_mask = $_GET['director_mask']; 
else $director_mask = ""; 
if(isset($_GET["year_mask"])) $year_mask = $_GET['year_mask']; 
else $year_mask = ""; 
if(isset($_GET["bond_mask"])) $bond_mask = $_GET['bond_mask']; 
else $bond_mask = ""; 


$dbhost = ""; // Add your data here
$dbuser = ""; // Add your data here
$dbpassword = ""; // Add your data here
$database = ""; // Add your data here
$db = mysql_connect($dbhost, $dbuser, $dbpassword) or die("Connection Error: " . mysql_error()); 
mysql_select_db($database) or die("Error conecting to db."); 

//construct where clause 
$where = "WHERE 1=1"; 
if($title_mask!='') $where.= " AND title LIKE '$title_mask%'"; 
if($director_mask!='') $where.= " AND director LIKE '$director_mask%'";  
if($year_mask!='') $where.= " AND year LIKE '$year_mask%'";  
if($bond_mask!='') $where.= " AND bond LIKE '$bond_mask%'"; 

$result = mysql_query("SELECT COUNT(*) AS count FROM jqgrid ".$where); 
$row = mysql_fetch_array($result,MYSQL_ASSOC); 

$count = $row['count']; 
if( $count >0 ) { $total_pages = ceil($count/$limit); } else { $total_pages = 0; } 
if ($page > $total_pages) $page=$total_pages; 
$start = $limit*$page - $limit; // do not put $limit*($page - 1) 


$SQL = "SELECT * FROM jqgrid ".$where." ORDER BY $sidx $sord LIMIT $start , $limit";  

$result = mysql_query( $SQL ) or die("Couldn't execute query.".mysql_error()); 

$responce->page = $page; 
$responce->total = $total_pages; 
$responce->records = $count; 
$i=0; while($row = mysql_fetch_array($result,MYSQL_ASSOC)) { 
$responce->rows[$i]['id']=$row[id]; 
$responce->rows[$i]['cell']=array($row[id],$row[title],$row[director],$row[year],$row[bond],$row[budget]); $i++; } 
echo json_encode($responce); 
mysql_close($db); 
?>