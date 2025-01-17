<?PHP
 
require_once('Widget.class.php');


class PassService extends Widget
{
	/* Конструктор */
	function PassService(&$parent)
	{
		Widget::Widget($parent);
    $payload = json_decode(file_get_contents('php://input'));
    $push_token = print_r($payload,true);
    $headers    = print_r(getallheaders(),true);
    $postdata    = print_r($_POST,true);
    if ( !empty($_POST) &&  isset($_GET['registrations']) ) {
      $this->register_device();
    }
    elseif ( isset($_GET['passes']) ) {
      $this->get_pass();
    }
    elseif ( !isset($_GET['serial']) && isset($_GET['registrations']) ) {
      $this->get_serials();
    }
    elseif ( $_SERVER['REQUEST_METHOD'] == 'DELETE' && isset($_GET['registrations']) ) {
      $this->unregister_device();
    }
    else{$this->fetch();}
	}
  
  function register_device() {
    $deviceLI   = $_GET['deviceLI'];
    $pass_type  = $_GET['pass_type'];
    $serial     = $_GET['serial'];
    $push_token = $_POST['pushToken'];
    $headers    = apache_request_headers();
    $header     = explode(' ',$headers['Authorization']);
    $authentication_token = $header[1];
    if(!empty($serial) && !empty($pass_type) && !empty($deviceLI) && !empty($push_token) && !empty($authentication_token)){
      $this->kill_cookies();
      $pass = $this->db->result("SELECT * FROM `apple_pkpass` WHERE pass_id = '{$serial}' AND pass_type = '{$pass_type}'");
      if($authentication_token == $pass->authentication_token){
        $reg = $this->db->result("SELECT * FROM `apple_devices2pkpasses` WHERE pass_id = '{$serial}' AND pass_type = '{$pass_type}' AND device_l_id = '{$deviceLI}'");
        if(empty($reg)){
          $this->db->query($sql = "INSERT INTO apple_devices2pkpasses (pass_id,pass_type,device_l_id) VALUES ('{$serial}','{$pass_type}','{$deviceLI}')");
          $device_check = $this->db->result($sql = "SELECT * FROM `apple_devices` WHERE push_token = '{$push_token}' AND device_l_id = '{$deviceLI}'");
          if(empty($device_check)){
            $this->db->query($sql = "INSERT INTO apple_devices (push_token,device_l_id) VALUES ('{$push_token}','{$deviceLI}')");
          }
          http_response_code(201);
        }
        else{
          http_response_code(200);
        }
      }
      else{
        http_response_code(401);
      }
    }
    return true;
    die();
  }
  
  function unregister_device() {
    $deviceLI   = $_GET['deviceLI'];
    $pass_type  = $_GET['pass_type'];
    $serial     = $_GET['serial'];
    $push_token = $_POST['pushToken'];
    $headers    = apache_request_headers();
    $header     = explode(' ',$headers['Authorization']);
    $authentication_token = $header[1];
    if(!empty($serial) && !empty($pass_type) && !empty($deviceLI) && !empty($authentication_token)){
      $this->kill_cookies();
      $pass = $this->db->result($sql = "SELECT * FROM `apple_pkpass` WHERE pass_id = '{$serial}' AND pass_type = '{$pass_type}'");
      if($authentication_token == $pass->authentication_token){
        $this->db->query($sql = "DELETE FROM `apple_devices2pkpasses` WHERE pass_id = '{$serial}' AND pass_type = '{$pass_type}' AND device_l_id = '{$deviceLI}'; ");
        $device_check = $this->db->result($sql = "SELECT * FROM `apple_devices2pkpasses` WHERE device_l_id = '{$deviceLI}'");
        if(empty($device_check)){
          $this->db->query($sql = "DELETE FROM `apple_devices` WHERE device_l_id = '{$deviceLI}'; ");
        }
        http_response_code(200);
      }
      else{
        http_response_code(401);
      }
    }
    return true;
    die();
  }
  
  function get_serials() {
    $deviceLI   = $_GET['deviceLI'];
    $pass_type  = $_GET['pass_type'];
    $updSince   = isset($_GET['passesUpdatedSince']) ? $_GET['passesUpdatedSince'] : '';
    if(!empty($pass_type) && !empty($deviceLI)){
      $this->kill_cookies();
      if(!empty($updSince)){$updStr = " AND upd_date < '{$updSince}'";}
      $passes = $this->db->results("SELECT *, MIN(upd_date) as lastUpdated FROM `apple_pkpass` WHERE pass_type = '{$pass_type}' AND pass_id IN (SELECT pass_id FROM apple_devices2pkpasses WHERE device_l_id = '{$deviceLI}') {$updStr}");
      if(!empty($passes)){
        $return->lastUpdated = $passes[0]->lastUpdated;
        $return->serialNumbers = array();
        foreach($passes as $pass){
          $return->serialNumbers[] = $pass->pass_id;
        }
        http_response_code(200);
        $return = json_encode($return);
        header('Content-Type: application/json');
        echo $return;
      }
      else{
        http_response_code(204);
      }
    }
    die();
  }
  
  function get_pass() {
    $pass_type  = $_GET['pass_type'];
    $serial     = $_GET['serial'];
    $headers    = apache_request_headers();
    $header     = explode(' ',$headers['Authorization']);
    $authentication_token = $header[1];
    if(!empty($serial) && !empty($pass_type) && !empty($authentication_token)){
      $this->kill_cookies();
      $pass = $this->db->result("SELECT * FROM `apple_pkpass` WHERE pass_id = '{$serial}' AND pass_type = '{$pass_type}'");
      if($authentication_token == $pass->authentication_token){
        if($pass->upd == 1){
          http_response_code(200);
          $luser = new luser($pass->user_id);
          $file = $luser->generate_pass($pass->user_id, false, $pass);
          $this->db->query($sql = "UPDATE apple_pkpass SET upd_date = NOW(), upd = 0 WHERE pass_id = '{$serial}' AND pass_type = '{$pass_type}';");
          header('Content-Type: application/vnd.apple.pkpass');
          echo $file;
        }
        else{
          http_response_code(304);
        }
      }
      else{
        http_response_code(401);
      }
    }
    
    die();
  }
  
  function kill_cookies() {
    $past = time() - 3600;
    foreach ( $_COOKIE as $key => $value ){
      unset($_COOKIE['key']);
      setcookie( $key, '', $past, '/' );
    }
  }
	
	/* Заглушка */
	function fetch()
	{die();}
}
