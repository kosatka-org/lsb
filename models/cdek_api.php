<?php


class cdek_api {

    private $_url;
    private $_account;
    private $_secure;

    public function __construct($account, $secure, $url = 'https://integration.cdek.ru/')
    {
        $this->_url     = $url;
        $this->_account = $account;
        $this->_secure  = $secure;

        // Объект соединения с базой
        global $database_object;
        $this->db = $database_object;
    }


    protected function _getCityId($city, $region) {
        return (int)$this->db->get_var($sql="SELECT id FROM `cities_cdek` WHERE city = '{$this->db->escape($city)}' AND oblast = '{$this->db->escape($region)}';"); 
    }


    public function new_orders($order, &$message, $TariffTypeCode = 1)
    {
        $city_id = $this->_getCityId($order->city, $order->region);
        $prepaid = $order->payment_prepaid;
        $total = isset($order->discount_amount) ? $order->discount_amount : $order->total_amount;
        $xml = '<?xml version="1.0" encoding="UTF-8" ?>
        <DeliveryRequest Number="' . $order->order_id . '" Account="{ACCOUNT}" Secure="{SECURE}" Date="{DATE}" OrderCount="1">
            <Order Number="' . $order->order_id . '"
            DeliveryRecipientCost="' . $order->delivery_price . '"
            RecipientCurrency="RUB"
            SendCityCode="414"
            SellerName="Лакшери Стор"
            RecCityCode="' . $city_id . '"
            RecipientName="' . $order->name . '"
            Phone="' . $order->phone . '"
            Comment=""
            Address="' . $order->address . '"
            TariffTypeCode="' . $TariffTypeCode . '"
            RecientCurrency="RUB"
            ItemsCurrency="RUB">
            <Address Street="'. $order->address . '" House="-" Flat="" />
            <Package Number="1" BarCode="'. $order->barcode . '" Weight="' . (500*count($order->products)) . '">';
            foreach ( $order->products as $p ) {
                $price = $p->price;
                if ($prepaid >= $total){
                  if ($prepaid > 0 && $prepaid >= $price) { // Учитываем предоплату в заказе
                      $price = 0;
                      $prepaid -= $price;
                  } elseif ($prepaid > 0 && $prepaid < $price) {
                      $price -= $prepaid;
                      $prepaid = 0;
                  }
                }
                $xml .= '<Item WareKey="' . $p->id . '" Cost="' . ($p->price*0.3) . '" Payment="' . $price . '" Weight="2000" Amount="1" Comment="' . addslashes($p->product_name) . ' размер:' . $p->size . ' SKU:' . $p->sku . '"/>';
            }
        $xml .= '</Package>
            <AddService ServiceCode="30"></AddService>
            <AddService ServiceCode="36"></AddService>
            <AddService ServiceCode="37"></AddService>
            </Order>
        </DeliveryRequest>';

        $url = $this->_url . 'new_orders.php';
        $res = $this->_request($url, $xml);
        if ( $res->Order[0]['ErrorCode'] ) {
            $message = $res->Order[0]['ErrorCode'] . ' ' . $res->Order[0]['Msg'];
            $res     = false;
        }
        else {
            $invoice_number = $this->db->escape($res->Order[0]['DispatchNumber']);
            $this->db->query("UPDATE `orders` SET invoice_number = '{$invoice_number}', delivery_company_id = 5 WHERE order_id = '{$order->order_id}';"); 
        }
        return $res;
    }



    public function new_schedule($order, $date)
    {
      $TimeEnd = date('H:i:s', strtotime("+3 hours", strtotime($date)));
      $xml = '<?xml version="1.0" encoding="UTF-8"?>
      <schedulerequest Account="{ACCOUNT}" Secure="{SECURE}" Date="{DATE}" Ordercount="1">
          <order date="' .  date('c',strtotime($order->date)) . '" dispatchnumber="' . $order->invoice_number . '" number="' . $order->order_id . '">
             <attempt date="' . substr($date,0,10) . '" TimeBeg="'. substr($date,-8) .'" TimeEnd="'. $TimeEnd .'" id="1">
             </attempt>
          </order>
      </schedulerequest>';
      $url = $this->_url . 'new_schedule.php';
      $res = $this->_request($url, $xml);
      if ( $res->Order[0]['ErrorCode'] ) {
          $message = $res->Order[0]['ErrorCode'] . ' ' . $res->Order[0]['Msg'];
          if (isset($error)) mail('tirjen@gmail.com', $_SERVER['SERVER_NAME'] . ' - CDEK log1', $message);
          $res     = false;
      }
      return $res;
    }
    
    public function orders_statuses($date)
    {
        $xml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <StatusReport Account="{ACCOUNT}" Secure="{SECURE}" Date="{DATE}" ShowHistory="0">
            <ChangePeriod DateFirst="' . $date . '"/>
        </StatusReport>';
        
        $url = $this->_url . 'status_report_h.php';
        return $this->_request($url,$xml,true);
    }



    public function call_courier($order)
    {
        $data;
        $url = $this->_url . 'call_courier.php';
        return $this->_request($url);
    }



    public function delete_orders($order)
    {
        $data;
        $url = $this->_url . 'delete_orders.php';
        return $this->_request($url);
    }



    public function orders_print($order)
    {
        $data;
        $url = $this->_url . 'orders_print.php';
        return $this->_request($url);
    }



    protected function _request($url, $xml, $output=false)
    {
        if ( empty($url) || empty($xml) ) return false;

        $d = array (
            'account'  => $this->_account,
            'date'     => date('c'),
            'password' => $this->_secure,
        );
        $d['secure'] = md5($d['date'].'&'.$d['password']);

        $xml = str_replace(array('{ACCOUNT}', '{DATE}', '{SECURE}'), array($d['account'], $d['date'], $d['secure']), $xml);
        $data['xml_request'] = $xml;
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_POST, 1); // указываем, что у нас POST запрос
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data); // добавляем переменные
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10); // Ждем соединения 10 секунд
        $output = curl_exec($ch);
        if ($output === false) $error = curl_error($ch);
        curl_close($ch);  
        if (isset($error)) mail('tirjen@gmail.com', $_SERVER['SERVER_NAME'] . ' - CDEK log2', $error);
        if($output)return $output;
        else return simplexml_load_string($output);
    }
}