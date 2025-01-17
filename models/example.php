<?php

    $xml = '
	<root xmlns="http://spsr.ru/webapi/usermanagment/login/1.0">
		<p:Params Name="WALogin" Ver="1.0" xmlns:p="http://spsr.ru/webapi/WA/1.0" />
			<Login Login="test" Pass="test" UserAgent="Компания"/>
	</root>
    ';

    $result = send_xml( $xml );
 
    print_r( $result );
    
    
    function send_xml( $xml )
    {
		$addr = 'http://api.spsr.ru:8020/waExec/WAExec';
		$curl = curl_init();
	
		curl_setopt( $curl, CURLOPT_URL,  $addr);
		curl_setopt( $curl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1); 
		curl_setopt( $curl, CURLOPT_POST, 1);
		curl_setopt( $curl, CURLOPT_POSTFIELDS,   $xml );
	
		$header = array('Content-Type: application/xml');
	 
		curl_setopt( $curl, CURLOPT_HTTPHEADER, $header);
						      
	
		$result = curl_exec( $curl );
		$result = htmlspecialchars($result); 
		curl_close( $curl );
		return $result;
}


?>
</html>