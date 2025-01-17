<?php
// require_once 'third_party/google-api-php-client/vendor/autoload.php';
if ( is_file($_SERVER['DOCUMENT_ROOT'] . '/vendor/autoload.php') ) {
    include_once $_SERVER['DOCUMENT_ROOT'] . '/vendor/autoload.php';
}
include_once $_SERVER['DOCUMENT_ROOT'] . '/models/google-api-template.php';

Class GoogleWorks {
    var $fileId = '';
    var $accessToken = '';

    function update($data) {
        $this->auth();
        $this->update_data($data);
    }

    private function auth(){
        $client = new Google_Client();
        putenv("GOOGLE_APPLICATION_CREDENTIALS=third_party/google-api-php-client/My_Project-c9609c3cf0f0.json");
        if ($credentials_file = checkServiceAccountCredentialsFile()) { // set the location manually
          $client->setAuthConfig($credentials_file);
        } elseif (getenv('GOOGLE_APPLICATION_CREDENTIALS')) { // use the application default credentials
          $client->useApplicationDefaultCredentials();
        } else {
          echo missingServiceAccountDetailsWarning();
          exit;
        }
        $client->setApplicationName("Sheets API Testing");
        $client->setScopes(['https://www.googleapis.com/auth/drive','https://spreadsheets.google.com/feeds']);
        $tokenArray = $client->fetchAccessTokenWithAssertion();

        global $fileId;
        global $accessToken;
        $fileId = '1_Umksi4JqdmITQqZAYHoaeoYy3LMW86WCNdAhCKqdOA';
        $accessToken = $tokenArray["access_token"];
    }

//Get list of worksheets
    function getLists(){
        global $fileId;
        global $accessToken;
        $url = "https://spreadsheets.google.com/feeds/worksheets/$fileId/private/full";
        $method = 'GET';
        $headers = ["Authorization" => "Bearer $accessToken"];
        $httpClient = new GuzzleHttp\Client(['headers' => $headers]);
        $resp = $httpClient->request($method, $url);
        $body = $resp->getBody()->getContents();
        $info = new SimpleXMLElement($body);
        $lists = array();
        foreach ($info->entry as $entry) {
           $lists["$entry->title"] = new stdClass();
           foreach ($entry->link as $link) {
             if ( (string)$link['rel'] == 'self' ){
             $url = (string)$link['href'];
             $wid = substr($url, strrpos($url, '/') + 1);
             $lists["$entry->title"]->wid = $wid;
            }
           }
        }
        return $lists;
    }
//Check if all managers got their own list
    function check_managers($managers){
        $lists = $this->getLists();
        foreach($managers as $manager){
            if ( !in_array($manager->title,array_keys($lists)) ){
                $wid = $this->add_list($manager->title);
                $data = array(
                    '_cn6ca'=>'date',
                    '_cokwr'=>'neworderscount',
                    '_cpzh4'=>'neworderssum',
                    '_cre1l'=>'delorderscount',
                    '_chk2m'=>'delorderssum',
                    '_ciyn3'=>'callscount'
                );
                $this->add_row($wid, $data);
            }
        }
    }
//
    function update_data($data){
        if ($data->g_flag){
            $wid = 'od6';
            unset($data->g_flag);
            $this->add_row($wid, $data);
        }
        else{
            $this->check_managers($data);
            $lists = $this->getLists();
            $data =  array_merge_recursive($data, $lists);
            foreach($data as $data_item){
                $data_item = (object)$data_item;
                if(!empty($data_item->wid) && !empty($data_item->date)){
                    $wid = $data_item->wid;
                    unset($data_item->wid, $data_item->title);
                    $this->add_row($wid, $data_item);
                }
            }
        }
    }

// Add a row to the sheet
    function add_row($wid, $data){
        global $fileId;
        global $accessToken;
        $method = 'POST';
        $headers = ["Authorization" => "Bearer $accessToken", 'Content-Type' => 'application/atom+xml'];
        $httpClient = new GuzzleHttp\Client(['headers' => $headers]);
        $url = "https://spreadsheets.google.com/feeds/list/$fileId/$wid/private/full";
        $postBody = '<entry xmlns="http://www.w3.org/2005/Atom" xmlns:gsx="http://schemas.google.com/spreadsheets/2006/extended">';
        foreach($data as $k=>$d){
            if($k != 'wid'){
                $postBody .= "<gsx:$k>$d</gsx:$k>";
            }
        }
        $postBody .= '</entry>';
        $resp = $httpClient->request($method, $url, ['body' => $postBody]);
    }

// Add a list to the sheet
    function add_list($title){
        global $fileId;
        global $accessToken;
        $url = "https://spreadsheets.google.com/feeds/worksheets/$fileId/private/full";
        $method = 'POST';
        $headers = ["Authorization" => "Bearer $accessToken", 'Content-Type' => 'application/atom+xml'];
        $postBody = '<entry xmlns="http://www.w3.org/2005/Atom" xmlns:gs="http://schemas.google.com/spreadsheets/2006"><title>' . $title . '</title><gs:rowCount>50</gs:rowCount><gs:colCount>10</gs:colCount></entry>';
        $httpClient = new GuzzleHttp\Client(['headers' => $headers]);
        $resp = $httpClient->request($method, $url, ['body' => $postBody]);
        $body = $resp->getBody()->getContents();
        $info = new SimpleXMLElement($body);
        $url = (string)$info->id;
        $wid = substr($url, strrpos($url, '/') + 1);
        return $wid;
    }
}
?>
