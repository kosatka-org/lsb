<?php
global $_CORE, $_REIMG;

# colour- & textvalues
$picBG = "66,66,66"; # RGB-value !
$picFG = "104,104,104"; # RGB-value !
//$copyright = "(c) land";
$font   = 1;
$xSpace = 9;
$ySpace = 3;
$nopicurl  = "/images/pic_none.jpg"; # starting in $imagepath!!!
$nofileurl = "/images/pic_none.jpg"; # starting in $imagepath!!!

include_once "reimg.conf.php";
$image = substr($_SERVER['REDIRECT_URL'], 6);

$pathes = explode('/', trim($image, '/'));
$path   = $_SERVER['DOCUMENT_ROOT'].DIRECTORY_SEPARATOR.'reimg';
$file   = array_pop($pathes);
$hw     = array_pop($pathes);
list($maxX,$maxY) = explode('x', $hw);
$image  = '/' . implode('/', $pathes) . '/' . $file;

if(!empty($hw)) {
    if(!substr_count(hw,'..')) {
        $pathes[] = $hw;
    }
}
$c = count($pathes);
for( $i=-1;$i<$c;$i++ )
{
    if($pathes[$i] != '..') {
        $path = $path.DIRECTORY_SEPARATOR.$pathes[$i];
        if(!file_exists($path)) {
            @mkdir($path,0777);
            if($i == -1) {
                @file_put_contents($path.'.htaccess',"RewriteEngine On\nRewriteBase /reimg\nRewriteCond %{REQUEST_FILENAME} !-f\nRewriteRule ^(.*)/([^/]*\.(jpg|png|gif))$ $1/%{QUERY_STRING}/$2 [NC]\nRewriteCond %{SCRIPT_FILENAME} !-f\nRewriteRule ^(.*)$ ../core_st.php [NC]");
            }
        }
    }
}

# minimal & maximum zoom
$minZoom = 1; # per cent related on orginal (!=0)
$maxZoom = 500; # per cent related on orginal (!=0)
# paths
$imgpath = $_SERVER['DOCUMENT_ROOT']."/"; # ending with "/" !

if ( empty($image) ) {
    $imageurl = $imgpath . $nopicurl;
} elseif( !file_exists($imgpath . trim($image)) && $_SERVER['SERVER_NAME'] == 'lsboutique.test' ) {
    header('Location: https://lsboutique.ru'.$_SERVER['REDIRECT_URL']);
    die();
} elseif( !file_exists($imgpath . trim($image))) {
    //die();
    $imageurl = $imgpath . $nofileurl;
} else {
    $imageurl = $imgpath . trim($image);
}
$images = $image;
# reading image
$image = getImageSize($imageurl, $info); # $info, only to handle problems with earlier php versions...
switch($image[2]) {
  case 1:
    # GIF image
    //$timg = imageCreateFromGIF($imageurl);
//    echo trim($images).'!!!';
//    die();
    header('Location: /'.trim($images));
    die();
    break;
case 2:
    # JPEG image
    $timg = imageCreateFromJPEG($imageurl);
    break;
case 3:
    # PNG image
    $timg = imageCreateFromPNG($imageurl);
    break;
}

# reading image sizes
$imgX = $image[0];
$imgY = $image[1];

if (empty($maxX)&&empty($maxY)) {
    $maxX = $imgX;
    $maxY = $imgY;
}

if ($maxX > $imgX && empty($maxY)){
    $maxX = $imgX;
    $maxY = $imgY;
}

if (empty($maxX)){
    # calculation zoom factor
    $_Y = $imgY/$maxY;
    $maxX = ceil($imgX / $_Y);
}

if (empty($maxY)){
    # calculation zoom factor
    $_X = $imgX/$maxX;
    $maxY = ceil($imgY / $_X);
}

# calculation zoom factor
$_X = $imgX/$maxX * 100;
$_Y = $imgY/$maxY * 100;

# selecting correct zoom factor, so that the image always keeps in the given format
# no matter if it is more higher than wider or the other way around
if((100-$_X) < (100-$_Y)) $_K = $_X;
else $_K = $_Y;

# zoom check to the original
if($_K > 10000/$minZoom) $_K = 10000/$minZoom;
if($_K < 10000/$maxZoom) $_K = 10000/$maxZoom;

# calculate new image sizes
$newX = $imgX/$_K * 100;
$newY = $imgY/$_K * 100;

# set start positoin of the image
# always centered
$posX = ($maxX-$newX) / 2;
$posY = ($maxY-$newY) / 2;

# creating new image with given sizes
$imgh = imageCreateTrueColor($newX, $newY); // maxX maxY
imagealphablending($imgh, FALSE);

# setting colours
$cols = explode(",", $picBG);
$bgcol = imageColorallocate($imgh, trim($cols[0]), trim($cols[1]), trim($cols[2]));
$cols = explode(",", $picFG);
$fgcol = imageColorallocate($imgh, trim($cols[0]), trim($cols[1]), trim($cols[2]));
# fill background
//imageFill($imgh, 0, 0, $bgcol);

# create small copy of the image
$width=$image[0];
$height=$image[1];

$new_width  = $newX;
$new_height = $newY;

if ($new_width > 0)               $x = $new_width / $width;
if ($new_height > 0)              $y = $new_height / $height;
if (($x > 0 && $y > $x) || $x==0) $x = $y;

$width_big  = $width * $x;
$height_big = $height * $x;
imagecopyresampled($imgh, $timg, 0, 0, 0, 0, $width_big, $height_big, imagesx($timg), imagesy($timg));
imageStringUp($imgh, $font, $newX-$xSpace, $newY-$ySpace, $copyright, $fgcol);

# output
switch($image[2]) {
  case 1:
    # GIF image
    header("Content-type: image/gif");
    imageGIF($imgh);
    break;
case 2:
    # JPEG image
    $quality = $width_big < 310 ? 85 : 95;
    imageJPEG($imgh, $path.DIRECTORY_SEPARATOR.$file, $quality);
//    header("Content-type: image/jpeg");
//    imageJPEG($imgh, '', $quality);
    break;
case 3:
    # PNG image
    header("Content-type: image/png");
    imagesavealpha($imgh, TRUE);
    @imagePNG($imgh, $path.DIRECTORY_SEPARATOR.$file);
//    imagePNG($imgh);
    break;
}

# cleaning cache
imageDestroy($timg);
imageDestroy($imgh);

$webpath = str_replace($_SERVER['DOCUMENT_ROOT'], 'https://lsboutique.ru', $path) . DIRECTORY_SEPARATOR . $file . '?nocache';
//echo $webpath;
header("Location: {$webpath}");

exit;
