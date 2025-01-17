<?php

function clearDir( $dir, $level = 0 ) {
	if ($objs = glob($dir."/*")) {
		foreach($objs as $obj) {
			if ( is_dir($obj) ) { 
			    clearDir($obj, $level+1);
			}
			else {
				if ($level>0) {
					echo 'Delete ' . $obj . '<br>';
					unlink($obj);
				}
			}
		}
	}
}

clearDir('.');