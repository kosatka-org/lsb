<?php
$bond = $_POST['bond'];
$budget = $_POST['budget'];
$year = $_POST['year'];
$id = $_POST['id'];
$title = $_POST['title'];
$director = $_POST['director'];
$operation = $_POST['oper'];

// Insert these into your database

$dbhost = ""; // Add your data here
$dbuser = ""; // Add your data here
$dbpassword = ""; // Add your data here
$database = ""; // Add your data here
$db = mysql_connect($dbhost, $dbuser, $dbpassword) or die("Connection Error: " . mysql_error()); 
mysql_select_db($database) or die("Error conecting to db."); 

// Let's update the ID (it doesn't get passed)
if ($id == "_empty") {
$result = mysql_query("SELECT max(id) from jqgrid"); 
$row = mysql_fetch_row($result); 
$newid =  $row[0] + 1;
} else {
$newid = $id;
}

if ($operation == "edit") {
$result = mysql_query("UPDATE jqgrid SET title = '$title', director = '$director', year = '$year', bond = '$bond', budget = '$budget' WHERE id = '$newid'");
} else if ($operation == "add") {
$result = mysql_query("INSERT INTO jqgrid (id, title, director, year, bond, budget) VALUES ('$newid', '$title', '$director', '$year', '$bond', '$budget')"); 
}
mysql_close($db); 

?>