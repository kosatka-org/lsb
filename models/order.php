<?php
require_once "database_helper.php";
require_once "cdek_api.php";

class orders extends database_helper {
    protected $_SID = false;
    protected $_login = '';
    protected $_products = array();

    public function __construct($id = 0, $data = NULL) {
        database_helper::database_helper(NULL, 'orders', false);
        $this->id_name  = 'order_id';
        $this->table    = 'orders';
        if (!empty($data)) {
            $this->data = $data;
        }
        elseif ( !empty($id) ) {
            $this->load_data($id);
        }
        if ( $this->get('order_id') ) {
            if(isset($_GET['reverse'])) {
                $this->_products = $this->db->get_results("SELECT orders_products.*, products.large_image FROM orders_products LEFT JOIN products ON orders_products.product_id = products.product_id WHERE status = 4  AND orders_products.order_id = '" . $this->get('order_id') . "'");
            }
            else {
                $this->_products = $this->db->get_results("SELECT orders_products.*, products.season, products.large_image, products.offline_price, products.old_price, products.price AS site_price FROM orders_products LEFT JOIN products ON orders_products.product_id = products.product_id WHERE orders_products.order_id = '" . $this->get('order_id') . "'");
            }
            $this->_manager = $this->db->get_results("SELECT orders.manager_id, users.name FROM orders LEFT JOIN users ON orders.manager_id = users.user_id WHERE orders.order_id = '" . $this->get('order_id') . "'");
        }
    }

    // Проверяем может пользователь пришел с миксмаркета
    public function mixmarket_from() {
        // utm_source=mixmarket
        // $_SERVER['HTTP_REFERER'];
        // $_COOKIE['FROM_MIXMARKET'];
        // setcookie('SAVED_USER_NAME', $_POST['name'], time()+60*60*24*365, '/');
        return true;
    }

    // Включен ли миксмаркет
    public function mixmarket_enabled($config = false) {
        $config = !empty($config) ? $config : $this->config;
        // Тут можно проверить реферер на utm метку и проставить куку
        return isset($config->mixmarket_on) && $config->mixmarket_on && orders::mixmarket_from();
    }

    // Нотификация миксмаркета
    public function mixmarket_notify($order_id, $sum, $action = 'complete') {
        $params = "a1={$order_id}&id=";
        if ($action == 'complete') {
            $params = "a1={$order_id}&id=1294938494&a2={$sum}";
        }
        if ($action == 'order') {
            $params = "a1={$order_id}&id=1294938495&a2={$sum}";
        }
        if ($action == 'decline') {
            $params = "a1={$order_id}&id=1294938184";
        }
        $response = file_get_contents($url = "http://mixmarket.biz/uni/tev.php?{$params}");
        mail('shesternin@gmail.com', $_SERVER['SERVER_NAME'] . ' - MIXMARKET PUSH', "URL: {$url}\n\nRESPONSE:\n{$response}");
    }

    protected function get_checksum( $code = '' ) {
        $code = "{$code}"; $chet = $nechet = 0;
        for($i=0; $i<strlen($code); $i++) {
            if ( $i%2 == 0 ) { // Нечет
                $nechet += $code[$i];
            }
            else {
                $chet += $code[$i];
            }
        }
        return (10 - ($chet + $nechet*3)%10)%10;
    }



    public function gen_barcode4order( $order_id = 0 ) {
        if ( empty($order_id) ) return false;
        $code = '150020' . (10000 + $order_id);
        return $code;
    }



    public function get_barcode4order( $order_id = 0 ) {
        // 15002003001 - 15002005001
        if ( empty($order_id) ) return false;
        $code = '101500200' . (3000 + $order_id);
        return $code . self::get_checksum($code);
    }



    public function gen_barcode4product( $product_id = 0 ) {
        if ( empty($product_id) ) return false;
        $code = '1000' . substr(rand(1000, 9999) . '0' . $product_id, -10);
        return $code . self::get_checksum($code);
    }



    public function get_sizes4products( $product_id ) {
        $product_id = (int)$product_id; if (empty($product_id)) return false;
        $res = $this->db->get_results("
            SELECT DISTINCT items.size
              FROM items
            WHERE items.product_id = '{$product_id}' ORDER BY items.size");
        return $res;
    }


    public function copy_bc2dc() {
        if ( !$this->get('order_id') ) return false;
        $this->db->query($sql = "UPDATE orders SET delivery_code = barcode WHERE order_id = '" . $this->get('order_id') . "'");
        return true;
    }


    public function get_invoice_link() {
        if ( !$this->get('order_id') ) return false;
        return "https://{$_SERVER['SERVER_NAME']}/?module=Order&invoice&order_code=" . $this->get('code');
    }

    public function get_ponyinvoice_link() {
        if ( !$this->get('order_id') ) return false;
        return "https://{$_SERVER['SERVER_NAME']}/?module=Order&ponyinvoice&order_code=" . $this->get('code');
    }

    public function get_kasatkainvoice_link() {
        if ( !$this->get('order_id') ) return false;
        return "https://{$_SERVER['SERVER_NAME']}/?module=Order&kasatkainvoice&order_code=" . $this->get('code');
    }

    public function get_maximainvoice_link() {
        if ( !$this->get('order_id') ) return false;
        return "https://{$_SERVER['SERVER_NAME']}/?module=Order&maximainvoice&order_code=" . $this->get('code');
    }

    public function get_reversinvoice_link() {
        if ( !$this->get('order_id') ) return false;
        return "https://{$_SERVER['SERVER_NAME']}/?module=Order&invoice&reverse&order_code=" . $this->get('code');
    }


    public function get_labels_link() {
        if ( !$this->get('order_id') ) return false;
        return "http://{$_SERVER['SERVER_NAME']}/?module=Order&labels&order_code=" . $this->get('code');
    }



    public function get_labels() {
        if ( !$this->get('order_id') ) return false;
        $label = file_get_contents($_SERVER['DOCUMENT_ROOT'] . '/models/label.html');

        $labels = '';
        foreach ( $this->_products as $p ) {
            $label_tmp = str_replace(array('{ReceiverPhone}', '{ReceiverContactName}', '{ReceiverAddress}', '{ReceiverCity}', '{ReceiverRegion}', '{ReceiverCountry}'),
                                array($this->get('phone'), $this->get('name'), $this->get('address'), $this->get('city'), $this->get('region'), $this->get('country')), $label);
            $InvoiceDeliveryDate = strtotime($this->get('delivery_date')) > time() ? date('Y-m-d', strtotime($this->get('delivery_date'))) : '________';
            $label_tmp = str_replace(array('{OrderId}', '{InvoiceInsuranceSum}', '{InvoicePiecesCount}', '{InvoiceShipmentNumber}', '{ManagerName}', '{BarcodeInvoiceShipmentNumber}', '{InvoicePieces}', '{InvoiceDeliverySum}', '{InvoiceDeliveryReal}', '{InvoiceDeliveryDate}', '{InvoiceTotalSum}'),
                            array($this->get('order_id'), $total . '.00', count($this->_products),   $this->get('invoice_number'), $this->_manager[0]->name,$this->get_barcode4order($this->get('order_id')), $pieces, $this->get('delivery_price'), $this->get('real_delivery_price'), $InvoiceDeliveryDate, $total+$this->get('delivery_price') . '.00'), $label_tmp);
            $labels .= str_replace(array('{ProductBarcode}', '{ProductModel}', '{ProductSize}', '{ProductCost}', '{ProductSKU}', '{ProductImage}'),
                                   array($p->barcode, $p->product_name, $p->size, $p->price, $p->sku, $p->large_image), $label_tmp);
        }

        $file = str_replace('{LABELS}', $labels, file_get_contents($_SERVER['DOCUMENT_ROOT'] . '/models/labels.html'));
        return $file;
    }



    // Форма для СПСР
    public function get_invoice_form() {
        if ( !$this->get('order_id') ) return false;
        $file = file_get_contents($_SERVER['DOCUMENT_ROOT'] . '/models/invoice.html');
        $prepaid = ($this->get("payment_prepaid"))+($this->get("deposit_payment"));
        if ($prepaid > 0) {
            $prepaid_block = '<div style="float: left; margin: 4px 3px 4px 3px;">-</div><div class="signed_line"><div class="text">{DepositSum}</div>предоплата</div>';
        }
        else{$prepaid_block = '';}
        $ver1 = '<div style="float: left; margin: 6px 3px 6px 40px;">Оплаченная сумма, руб.</div><div class="ShAA_divWithBorder"></div>
                <div style="float: left; margin: 6px 3px 6px 40px;">Позиций</div><div class="ShAA_divWithBorder"></div>';
        $ver2 = '
            <div style="text-align: center; margin: 10px 80px 0;">
                <div class="ShAA_divMiniWithBorder" style="margin-top: -5px;"></div> Сумма принятых вещей <strong>более 10000 рублей.</strong>
            </div>
            <div class="bordered_wrap">
                <div class="signed_line">сумма принятых вещей</div>{Prepaid_Block}<div style="float: left; margin: 4px 3px 4px 3px;">=</div><div class="signed_line">Общая сумма к оплате</div>
            </div>
            <div style="text-align: center; margin: 10px 80px 0;">
                <div class="ShAA_divMiniWithBorder" style="margin-top: -5px;"></div> Сумма принятых вещей <strong>менее 10000 рублей.</strong>
            </div>
            <div class="bordered_wrap">
                <div class="signed_line">сумма принятых вещей</div><div style="float: left; margin: 4px 3px 4px 3px;">+</div><div class="signed_line"><div class="text">{InvoiceDeliveryReal}</div>доставка</div>{Prepaid_Block}<div style="float: left; margin: 4px 3px 4px 3px;">=</div><div class="signed_line">Общая сумма к оплате</div>
            </div>'
            ;
        if ( isset($_GET['ver']) ){
            $file = str_replace(array('{PartialPaymentForm}', '{Prepaid_Block}'),
                                array($ver2, $prepaid_block), $file);
        }
        else{
            $file = str_replace(array('{PartialPaymentForm}', '{Prepaid_Block}'),
                                array($ver1, $prepaid_block), $file);
        }
        if ( isset($_GET['reverse']) ){
            $sender =   '<tr><td class="ShAA_dataBlock" colspan=4>Ф.И.О. отправителя: <span class="ShAA_data">{ReceiverContactName}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Область (регион): <span class="ShAA_data">{ReceiverRegion}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Город: <span class="ShAA_data">{ReceiverCity}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Адрес: <span class="ShAA_data">{ReceiverAddress}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Телефон: <span class="ShAA_data">{ReceiverPhone}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>&nbsp;<span class="ShAA_data"></span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>&nbsp;<span class="ShAA_data"></span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>&nbsp;<span class="ShAA_data"></span></td></tr>';
            $reciever = '<tr><td class="ShAA_dataBlock" colspan=4>№ договора: <span class="ShAA_data">{tkDogovor}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Ф.И.О. получателя: <span class="ShAA_data">ИП Жехарев Илья Всеволодович</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Наим.организации: <span class="ShAA_data">Интернет магазин Лакшери Стор</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Область (регион): <span class="ShAA_data">Нижегородская область</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Город: <span class="ShAA_data">Нижний Новгород</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Адрес: <span class="ShAA_data">Нижневолжская набережная 8/7</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Телефон: <span class="ShAA_data">+79200277337</span></td></tr>';
        }
        else{
            $sender =   '<tr><td class="ShAA_dataBlock" colspan=4>№ договора: <span class="ShAA_data">{tkDogovor}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Ф.И.О. отправителя: <span class="ShAA_data">ИП Жехарев Илья Всеволодович</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Наим.организации: <span class="ShAA_data">Интернет магазин Лакшери Стор</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Область (регион): <span class="ShAA_data">Нижегородская область</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Город: <span class="ShAA_data">Нижний Новгород</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Адрес: <span class="ShAA_data">Нижневолжская набережная 8/7</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Телефон: <span class="ShAA_data">+79200277337</span></td><tr>';
            $reciever = '<tr><td class="ShAA_dataBlock" colspan=4>Ф.И.О. получателя: <span class="ShAA_data">{ReceiverContactName}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Область (регион): <span class="ShAA_data">{ReceiverRegion}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Город: <span class="ShAA_data">{ReceiverCity}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Адрес: <span class="ShAA_data">{ReceiverAddress}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>Телефон: <span class="ShAA_data">{ReceiverPhone}</span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>&nbsp;<span class="ShAA_data"></span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>&nbsp;<span class="ShAA_data"></span></td></tr>
                        <tr><td class="ShAA_dataBlock" colspan=4>&nbsp;<span class="ShAA_data"></span></td></tr>';
        }
        $InvoiceDeliveryDate = strtotime($this->get('delivery_date')) > time() ? 'Ориентировочная дата доставки: ' . date('d/m/y', strtotime($this->get('delivery_date'))) : '';
        $file = str_replace(array('{sender_dataBlock}', '{reciever_dataBlock}', '{InvoiceDeliveryDate}'),
                                array($sender, $reciever, $InvoiceDeliveryDate), $file);
        $file = str_replace(array('{ORDER_ID}', '{ReceiverPhone}', '{ReceiverContactName}', '{ReceiverAddress}', '{ReceiverCity}', '{ReceiverRegion}', '{ReceiverCountry}'),
                            array($this->get('order_id'), $this->get('phone'), $this->get('name'), $this->get('address'), $this->get('city'), $this->get('region'), $this->get('country')), $file);
        $piece  = '<tr><td><span class="ShAA_data">{ProductSKU}</span></td><td><span class="ShAA_data">{ProductModel}, {ProductSize}</span></td>
                    <td><span class="ShAA_data">1</span></td>
                    <td style="text-align: right;"><span class="ShAA_data">{ProductCost}</span></td>
                    <td><span class="ShAA_data"></span></td>
                </tr>';

        $pieces = ''; $total = 0;
        foreach ( $this->_products as $p ) {
            $pieces .= str_replace(array('{ProductBarcode}', '{ProductModel}', '{ProductSize}', '{ProductCost}', '{ProductSKU}',),
                                   array($p->barcode, $p->product_name, $p->size, $p->price, $p->sku), $piece);
            $total += $p->price*$p->quantity;
        }
        $insurance_sum = number_format((float)$total*0.3, 2, '.', '');
        $file = str_replace(array('{InvoiceInsuranceSum}', '{InvoicePiecesCount}', '{InvoiceShipmentNumber}', '{CurrentDate}', '{BarcodeInvoiceShipmentNumber}', '{InvoicePieces}', '{InvoiceDeliverySum}', '{InvoiceDeliveryReal}', '{DepositSum}', '{InvoiceTotalSum}'),
                            array($insurance_sum, count($this->_products), $this->get('barcode'), date('d/m/y'), $this->get_barcode4order($this->get('order_id')), $pieces, $this->get('delivery_price'), str_replace('.00', '', $this->get('real_delivery_price')),  $prepaid, ($total+$this->get('delivery_price'))-($prepaid)), $file);

        $tkData = '';
        if ( $this->get('delivery_company_id') ) {
            $dc     = $this->db->get_row("SELECT * FROM delivery_companies WHERE id = '" . $this->get('delivery_company_id') . "'");
            $tkData = array($dc->dogovor_number, $dc->name, $dc->address, $dc->logo);
        }
        $file = str_replace(array('{tkDogovor}', '{tkName}', '{tkAddress}', '{tkLogo}'), $tkData, $file);

        if (isset($_GET['excel'])){
            header('Content-type:application/vnd.ms-excel');
            header('Content-Disposition: attachment; filename="Доставочная накладная № '.$this->get("barcode").'.xls"');
        }

        return $file;
    }



    public function get_kasatkainvoice_form() {
        if ( !$this->get('order_id') ) return false;
        $file = file_get_contents($_SERVER['DOCUMENT_ROOT'] . '/models/invoice.html');
        $sender =   '<tr><td class="ShAA_dataBlock" colspan=4>№ договора: <span class="ShAA_data">{tkDogovor}</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>Ф.И.О. отправителя: <span class="ShAA_data">Алексей Костин</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>Наим.организации: <span class="ShAA_data">Интернет магазин Лакшери Стор</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>Область (регион): <span class="ShAA_data">Нижегородская область</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>Город: <span class="ShAA_data">Нижний Новгород</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>Адрес: <span class="ShAA_data">Нижневолжская набережная 8/7</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>Телефон: <span class="ShAA_data">8–800–333–21–38</span></td></tr>';
        $reciever = '<tr><td class="ShAA_dataBlock" colspan=4>Ф.И.О. получателя: <span class="ShAA_data">{ReceiverContactName}</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>Область (регион): <span class="ShAA_data">{ReceiverRegion}</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>Город: <span class="ShAA_data">{ReceiverCity}</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>Адрес: <span class="ShAA_data">{ReceiverAddress}</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>Телефон: <span class="ShAA_data">{ReceiverPhone}</span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>&nbsp;<span class="ShAA_data"></span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>&nbsp;<span class="ShAA_data"></span></td></tr>
                    <tr><td class="ShAA_dataBlock" colspan=4>&nbsp;<span class="ShAA_data"></span></td></tr>';
        $file = str_replace(array('{sender_dataBlock}', '{reciever_dataBlock}'),
                                array($sender, $reciever), $file);
        $file = str_replace(array('{ORDER_ID}', '{ReceiverPhone}', '{ReceiverContactName}', '{ReceiverAddress}', '{ReceiverCity}', '{ReceiverRegion}', '{ReceiverCountry}'),
                            array($this->get('order_id'), $this->get('phone'), $this->get('name'), $this->get('address'), $this->get('city'), $this->get('region'), $this->get('country')), $file);

        $piece  = '<tr><td><span class="ShAA_data">{ProductSKU}</span></td><td><span class="ShAA_data">{ProductModel}, {ProductSize}</span></td>
                    <td><span class="ShAA_data">1</span></td>
                    <td style="text-align: right;"><span class="ShAA_data">{ProductCost}</span></td>
                    <td><span class="ShAA_data"></span></td>
                </tr>';

        $pieces = ''; $total = 0;
        foreach ( $this->_products as $p ) {
            $pieces .= str_replace(array('{ProductBarcode}', '{ProductModel}', '{ProductSize}', '{ProductCost}', '{ProductSKU}',),
                                   array($p->barcode, $p->product_name, $p->size, $p->price, $p->sku), $piece);
            $total += $p->price*$p->quantity;
        }
        $file = str_replace(array('{InvoiceInsuranceSum}', '{InvoicePiecesCount}', '{InvoiceShipmentNumber}', '{CurrentDate}', '{BarcodeInvoiceShipmentNumber}', '{InvoicePieces}', '{InvoiceDeliverySum}', '{InvoiceDeliveryReal}', '{DepositSum}', '{InvoiceTotalSum}'),
                            array($total . '.00', count($this->_products), $this->get('barcode'), date('d.m.Y H:i'), $this->get('barcode'), $pieces, $this->get('delivery_price'), $this->get('real_delivery_price'),  (($this->get('payment_prepaid'))+($this->get('deposit_payment')) . '.00'), ($total+$this->get('delivery_price'))-(($this->get('deposit_payment')+($this->get('payment_prepaid')))) . '.00'), $file);

        $tkData = '';
        if ( $this->get('delivery_company_id') ) {
            $dc     = $this->db->get_row("SELECT * FROM delivery_companies WHERE id = '" . $this->get('delivery_company_id') . "'");
            $tkData = array($dc->dogovor_number, $dc->name, $dc->address, $dc->logo);
        }
        $file = str_replace(array('{tkDogovor}', '{tkName}', '{tkAddress}', '{tkLogo}'), $tkData, $file);
        return $file;
    }

    public function get_maximainvoice_form() {
        if ( !$this->get('order_id') ) return false;
        $file = file_get_contents($_SERVER['DOCUMENT_ROOT'] . '/models/maximainvoice.html');
        $ClientAddress = $this->get('country') . ', ' . $this->get('region') . ', ' . $this->get('city') . ', ' . $this->get('address');
        $file = str_replace(array('{OrderId}', '{ClientPhone}', '{ClientName}', '{ClientAddress}'),
                            array($this->get('order_id'), $this->get('phone'), $this->get('name'), $ClientAddress), $file);

        $pieces = ''; $total = 0;
        $notes  = 'накладная, ID: ';
        $piece = '
            <tr class="hight underline">
                <td class="">{ItemSKU}</td>
                <td class="">{ItemName}</td>
                <td class="right">{ItemSize}</td>
                <td class="right">{ItemQuantity}</td>
                <td class="right">{ItemSeason}</td>
                <td class="right">{ItemSale}</td>
                <td class="right">&#9744;</td>
                <td class="right">&#9744;</td>
                <td class="right">{ItemPrice}</td>
            </tr>';
        foreach ( $this->_products as $p ) {
            if ( $p->old_price == 0){
                $p->old_price = $this->db->result("SELECT new_price FROM `price_changes` WHERE product_id = '{$p->product_id}' ORDER BY date ASC LIMIT 1")->new_price;
            }
            if ( $p->old_price != 0){$pr = $p->old_price;}
            if ( $p->offline_price != 0){$pr = $p->offline_price;}
            else{$pr = $p->site_price;}
            $p_sale = round((($pr-$p->price)*100)/$pr, 0);
            $p_sale = ($p_sale < 1) ? '' : $p_sale . "%";
            $pieces .= str_replace(array('{ItemQuantity}', '{ItemName}', '{ItemSize}', '{ItemSeason}', '{ItemSale}', '{ItemPrice}', '{ItemSKU}',),
                                   array($p->quantity, $p->product_name, $p->size, $p->season, $p_sale, number_format($p->price,2,'.',' '), $p->sku), $piece);
            $notes  .= $p->product_id . ' ';
            $total += $p->price*$p->quantity;
        }

        $courier = $this->db->get_row("SELECT orders.courier_id, users.name, users.phone_number FROM orders LEFT JOIN users ON orders.courier_id = users.user_id WHERE orders.order_id = '" . $this->get('order_id') . "'");
        $transaction_id = $this->db->result("SELECT tid FROM rfi_transactions WHERE order_id = '" . $this->get('order_id') . "'")->tid;

        $file = str_replace(array('{ProductsPieses}', '{DeliveryPrice}', '{TransactionID}', '{PaymentPrepaid}', '{TotalItemsPrice}', '{TotalOrderPrice}', '{ManagerName}', '{CourierName}', '{CourierPhone}'),
                            array($pieces, number_format($this->get('delivery_price'),2,'.',' '), $transaction_id,  number_format((($this->get('payment_prepaid'))+($this->get('deposit_payment'))),2,'.',' '), number_format($total,2,'.',' '), number_format((($total+$this->get('delivery_price'))-(($this->get('deposit_payment')+($this->get('payment_prepaid'))))),2,'.',' '), $this->_manager[0]->name, $courier->name, $courier->phone_number), $file);

        return $file;
    }



    public function get_ponyinvoice_form() {
        if ( !$this->get('order_id') ) return false;
        $file = file_get_contents($_SERVER['DOCUMENT_ROOT'] . '/models/ponyinvoice.html');
        $file = str_replace(array('{ORDER_ID}', '{ReceiverPhone}', '{ReceiverContactName}', '{ReceiverAddress}', '{ReceiverCity}', '{ReceiverRegion}', '{ReceiverCountry}'),
                            array($this->get('order_id'), $this->get('phone'), $this->get('name'), $this->get('address'), $this->get('city'), $this->get('region'), $this->get('country')), $file);

        $pieces = ''; $total = 0;
        $notes  = 'накладная, ID: ';
        foreach ( $this->_products as $p ) {
            $pieces .= str_replace(array('{ProductBarcode}', '{ProductModel}', '{ProductSize}', '{ProductCost}', '{ProductSKU}',),
                                   array($p->barcode, $p->product_name, $p->size, $p->price, $p->sku), $piece);
            $notes  .= $p->product_id . ' ';
            $total += $p->price*$p->quantity;
        }


        $invoice_number = $this->get('invoice_number');
        $insurance_sum = number_format((float)$total*0.3, 2);
        $file = str_replace(array('{notes}', '{InvoiceInsuranceSum}',  '{InvoicePiecesCount}', '{InvoicePiecesWeight}', '{InvoiceShipmentNumber}', '{CurrentDate}', '{BarcodeInvoiceShipmentNumber}', '{InvoicePieces}', '{InvoiceDeliverySum}', '{PONI_DEST}', '{InvoiceDeliveryReal}', '{DepositSum}', '{InvoiceTotalSum}'),
                            array($notes,    $insurance_sum, count($this->_products), 0.3*count($this->_products), $invoice_number, date('d.m.Y H:i'), $invoice_number, $pieces, $this->get('delivery_price'), $this->get('poni_dest'), $this->get('real_delivery_price'),  (($this->get('payment_prepaid'))+($this->get('deposit_payment')) . '.00'), ($total+$this->get('delivery_price'))-(($this->get('deposit_payment')+($this->get('payment_prepaid')))) . '.00'), $file);
        $PM = $this->db->results("SELECT * FROM payment_methods WHERE enabled ORDER BY payment_method_id");
        $InvoicePaymentType = 'Наличные';
        foreach ($PM as $v) {
            if ( $v->payment_method_id == $this->get('payment_method_id') ) {
                $InvoicePaymentType = $v->name; break;
            }
        }
        $file   = str_replace(array('{InvoicePaymentSum}',  '{InvoicePaymentType}'),
                            array(number_format(($total < 10000 ? $total+$this->get('delivery_price') : $total)-$this->get('payment_prepaid'), 2), $InvoicePaymentType), $file);

        $tkData = '';
        if ( $this->get('delivery_company_id') ) {
            $dc     = $this->db->get_row("SELECT * FROM delivery_companies WHERE id = '" . $this->get('delivery_company_id') . "'");
            $tkData = array($dc->dogovor_number, $dc->name, $dc->address, $dc->logo);
        }
        $file = str_replace(array('{tkDogovor}', '{tkName}', '{tkAddress}', '{tkLogo}'), $tkData, $file);
        return $file;
    }



    // Отправка запроса в СПСР
    protected function _RequestXml($xml) {
        $curl = curl_init();
        curl_setopt( $curl, CURLOPT_URL, $this->_api_spsr_url);
        curl_setopt( $curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt( $curl, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt( $curl, CURLOPT_POST, 1);
        curl_setopt( $curl, CURLOPT_POSTFIELDS,   $xml );

        $header = array('Content-Type: application/xml');

        curl_setopt( $curl, CURLOPT_HTTPHEADER, $header);

        $result = curl_exec( $curl );
        curl_close( $curl );

        $res = simplexml_load_string((strpos($result, '?xml') ? '' : '<?xml version="1.0"?>') . $result);
        if ( $res->error ) {
            mail('shesternin@gmail.com', $_SERVER['SERVER_NAME'] . ' - СПСР API error', "Error: " . var_export($res->error, true) . "\nURL: http://{$_SERVER['SERVER_NAME']}{$_SERVER['REQUEST_URI']}\n\nRequest: {$xml}");
        }
        return $res;
    }



    // Отправляем запрос в СПСР
    public function api_create_invoice( $debug = false ) {
        if (empty($this->_SID) || !$this->get('order_id')) return false;

        $file = file_get_contents($_SERVER['DOCUMENT_ROOT'] . '/models/order.xml');

        $delivery = $this->db->get_row("SELECT * FROM `delivery_cities` WHERE city_id = '" . $this->get('city_id') . "'");
        $file = str_replace(array('ReceiverPhone', 'ReceiverContactName', 'ReceiverAddress', 'ReceiverCity', 'ReceiverRegion', 'ReceiverCountry'),
                            array($this->get('phone'), str_replace('"', "'", $this->get('name')), str_replace('"', "'", $this->get('address')), str_replace('"', "'", $this->get('city')), ( isset($delivery->region_name) ? $delivery->region_name : '' ), ( isset($delivery->country_name) ? $delivery->country_name : '' )), $file);
        $piece  = '<Piece ClientBarcode="ProductBarcode" Description="16">
                    <SubPiece Description="ProductModel, ProductSize" Cost="ProductCost" ProductCode="ProductSKU" VAT="6" VATSum="0"/></Piece>';
        $pieces = ''; $total = 0;
        foreach ( $this->_products as $p ) {
            $pieces .= str_replace(array('ProductBarcode', 'ProductModel', 'ProductSize', 'ProductCost', 'ProductSKU',),
                                   array($p->barcode, htmlspecialchars(str_replace('"', "'", $p->product_name)), str_replace('"', "'", $p->size) . ', ' . $p->sku, number_format($p->price, 2, '.', ''), $p->sku), $piece);
            $total += $p->price*$p->quantity;
        }
        $InvoiceDeliveryDate = strtotime($this->get('delivery_date')) > time() ? date('Ymd', strtotime($this->get('delivery_date'))) : '';
        $insurance_sum       = number_format((float)$total*0.3, 2, '.', '');
        $goods_sum           = number_format((float)($total - $this->get('payment_prepaid')), 2, '.', '');
        $file = str_replace(array('InvoiceDeliveryDate', 'InvoiceInsuranceSum', 'InvoiceDeliverySum', 'InvoiceGoodsSum', 'InvoicePiecesCount',    'InvoiceShipmentNumber', 'InvoicePieces', 'InvoicePartDelivery'),
                            array($InvoiceDeliveryDate,   $insurance_sum,$this->get('delivery_price'), $goods_sum,       count($this->_products), $this->get('order_id'),   $pieces, (count($this->_products) == 1 ? 0 : 1)), $file);

        // Авторизационные данные
        $file = str_replace(array('LoginIKN', 'LoginSID'),
                            array($this->_IKN, $this->_SID), $file);

        $res = $this->_RequestXml($file);
        if ($debug) {
            echo '<br>';  var_dump($res->Invoice['InvoiceNumber'][0]);
            die();
        }
        return $res->Invoice && isset($res->Invoice['InvoiceNumber'][0]) ? $res->Invoice['InvoiceNumber'][0] : false;
    }



    // Получение токена от СПСР
    public function api_login( $login = 'test', $password = 'test', $IKN = '' ) {
        $this->_login   = $login;
        $this->_IKN     = $IKN;
        $this->_api_spsr_url = 'http://api.spsr.ru/waExec/WAExec';

        $xml = '
            <root xmlns="http://spsr.ru/webapi/usermanagment/login/1.0">
                <p:Params Name="WALogin" Ver="1.0" xmlns:p="http://spsr.ru/webapi/WA/1.0" />
                <Login Login="' . $login . '" Pass="' . $password . '" UserAgent="' . $IKN . '"/>
            </root>
        ';
        $res = $this->_RequestXml($xml);
        $this->_SID = !empty($res->Login['SID']) ? $res->Login['SID'] : false;
        return $this->_SID;
    }



    public function set_deposit_payment( $order_id, $change_sum ) {
        // Экранируем и проверяем данные перед запросом
        $change_sum = (int)$change_sum;
        $order_id   = (int)$order_id;
        if ( !empty($order_id) && !empty($change_sum) ) {
            $this->db->query("UPDATE orders SET deposit_payment = deposit_payment + {$change_sum} WHERE order_id = '{$order_id}'; ");
        }
        return false;
    }



    public function api_logout() {
        if (empty($this->_SID)) return false;
        $xml = '<root xmlns="http://spsr.ru/webapi/usermanagment/logout/1.0" >
            <p:Params Name="WALogout" Ver="1.0" xmlns:p="http://spsr.ru/webapi/WA/1.0" />
            <Logout Login="' . $this->_login . '" SID="' . $this->_SID . '" />
        </root>';
        $res = $this->_RequestXml($xml);
        return isset($res->Logout['Result']) && $res->Logout['Result'] == 'Ok';
    }



    public function request_poni_set_key($key){
        $this->poni_accessKey = $key;
    }



    // Запрос в АПИ пони экспресс
    public function request_poni($order, &$message = '') {
        if (empty($this->poni_accessKey)) return false;

        /****/
        $requestBody->Payment           = $requestBody->PickupDate = $requestBody->ServiceMode = $requestBody->ServiceSender = "";
        $requestBody->ServiceRecipient  = $requestBody->ServiceCargoList = $requestBody->ServiceItemList = "";

        #Оплата
        # Режимы оплаты: Bill – безналичная по счету, CashBySender – наличными отправителем, CashByRecipient – наличными получателем.
        $requestBody->Payment = '
        <Payment>
            <Mode>Bill</Mode>
        </Payment>';
        #Оплата (EDN)

        #Дата отправки заказа
        $t = time();
        if(date('H') > 15){$t += 86400;}
        $requestBody->PickupDate = date('Y-m-d', $t).'T'.date('H:i:s', $t);
        if(!empty($requestBody->PickupDate)) {$requestBody->PickupDate = '<PickupDate>'.$requestBody->PickupDate.'</PickupDate>';}
        #Дата отправки заказа (END)

        #Режим доставки
        #Возможные варианта: Superexpress, Express, Econom, By10, By13, By14, By18, SML, DayOff, Evening, SelfDelivery.
        $requestBody->ServiceMode = 'Express';
        if(!empty($requestBody->ServiceMode)){$requestBody->ServiceMode = '<Mode>'.$requestBody->ServiceMode.'</Mode>';}
        #Режим доставки (END)

        #Информация о отправителе
        $ServiceSender = $this->_request_poni_get_ServiceSender();

        if ($ServiceSender) {
            $requestBody->ServiceSender = '<Sender>
                    <Address>
                        <Country>'.$ServiceSender->Country.'</Country>
                        <City>'.$ServiceSender->City.'</City>
                        <StreetAddress>'.$ServiceSender->StreetAddress.'</StreetAddress>
                    </Address>
                    <Company>
                        <Name>Лакшери Стор</Name>
                    </Company>
                    <PersonList>
                        <Person>
                            <Name>'.$ServiceSender->Name.'</Name>
                            <PhoneList>
                                <string>'.$ServiceSender->Phone.'</string>
                            </PhoneList>
                        </Person>
                    </PersonList>
                </Sender>';
        }
        #Информация о отправителе(END)

        #Информация о получателе
        $RecipientCity = $this->db->result("SELECT city_name FROM delivery_cities WHERE city_id = ".intval($order->city_id));
        $RecipientCity = $RecipientCity->city_name;
        $requestBody->ServiceRecipient = '<Recipient>
                <Address>
                    <Country>Россия</Country>
                    <City>'.$RecipientCity.'</City>
                    <StreetAddress>'.htmlspecialchars($order->address).'</StreetAddress>
                </Address>
                <Company>
                    <Name>'.htmlspecialchars($order->name).'</Name>
                </Company>
                <PersonList>
                    <Person>
                        <Name>'.htmlspecialchars($order->name).'</Name>
                        <PhoneList>
                            <string>'.htmlspecialchars($order->phone).'</string>
                        </PhoneList>
                    </Person>
                </PersonList>
            </Recipient>';
        #Информация о получателе(END)

        $prepaided = false; // Проверим, а не предоплачен ли заказ
        if ($order->payment_prepaid > 0) {
            $total_price = 0;
            foreach($order->products as $product) {
                $total_price += $product->price;
            }
            $prepaided = (int)$order->payment_prepaid >= (int)$total_price;
        }

        #Информация о заказах
        $i = 0; $requestBody->LotsList = '';
        foreach($order->products as $product) {
            $i++;
            // Если заказ предоплачен, то зануляем цену товаров
            $price = $prepaided ? 0 : $product->price;
            $declared_cost = (int)$product->price*0.3;
            // Делаем грузомест по количеству items
            $requestBody->ServiceCargoList .= '
            <Cargo>
                <Id>' . $i . '</Id>
                <Barcode>' . $product->barcode . '</Barcode>
                <Weight>' . 300 . '</Weight>
                <Cost>' . $declared_cost . '</Cost>
            </Cargo>';
            $itemId = $product->product_id . '0' . $product->id;
            $requestBody->ServiceItemList .= '
            <Item>
                <Id>' . $itemId . '</Id>
                <CargoId>' . $i . '</CargoId>
                <Barcode>' . $product->sku . '</Barcode>
                <Description>' . htmlspecialchars($product->product_name) . '</Description>
                <Weight>300</Weight>
                <Cost>' . $declared_cost . '</Cost>
                <Count>1</Count>
            </Item>';
            $requestBody->LotsList .= '
            <Lot>
              <ItemList>
                <CommodityItem>
                  <ItemId>' . $itemId . '</ItemId>
                  <Price>' .  $price . '</Price>
                </CommodityItem>
              </ItemList>
            </Lot>';
        }

        $requestBody->ServiceSalesMediationService = '
        <Service xsi:type="SalesMediationService">
          <Id>1</Id>
          <Mode>Partial</Mode>
          <ConsumerPayment>
            <Mode>Cash</Mode>
          </ConsumerPayment>
          <LotList>' .
          $requestBody->LotsList .
          '</LotList>
        </Service>';

        if (!empty($requestBody->ServiceCargoList)) {
            $requestBody->ServiceCargoList = '<CargoList>'.$requestBody->ServiceCargoList.'</CargoList>';
        }
        if (!empty($requestBody->ServiceItemList)) {
            $requestBody->ServiceItemList = '<ItemList>'.$requestBody->ServiceItemList.'</ItemList>';
        }
        #Информация о заказах(END)

        /****/
        $chk_query = new StdClass();
        // Тут баг в АПИ Пони, поэтому инициализируем два ключа
        $chk_query->accessKey   = $chk_query->accesskey = $this->poni_accessKey;
        $chk_query->requestBody = '<?xml version="1.0" encoding="utf-8"?>
<Request xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="OrderRequest">
    <Mode>Order</Mode>
    <OrderList>
        <Order>
            <ClientsNumber>LS'.$order->order_id.'</ClientsNumber>
            '.$requestBody->Payment.'
            <ServiceList>
                <Service xsi:type="DeliveryService">
                    <Id>1</Id>
                    '.$requestBody->PickupDate.'
                    '.$requestBody->ServiceMode.'
                    '.$requestBody->ServiceSender.'
                    '.$requestBody->ServiceRecipient.'
                    '.$requestBody->ServiceCargoList.'
                    '.$requestBody->ServiceItemList.'
                </Service>
                ' . $requestBody->ServiceSalesMediationService . '
                <Service xsi:type="SMSInfoService">
                    <Id>1</Id>
                    <Mode>LastMile</Mode>
                    <PhoneList>
                        <string>' . htmlspecialchars($order->phone) . '</string>
                    </PhoneList>
                </Service>
            </ServiceList>
        </Order>
    </OrderList>
</Request>';

        if ( isset($_GET['show_request_body']) ) {
            echo '<br>AccessKey:<br>'   . $chk_query->accessKey;
            echo '<br>Запрос:<br>'      . $chk_query->requestBody;
        }

        ini_set("soap.wsdl_cache_enabled", "0"); // disabling WSDL cache
        ini_set("default_charset", "utf-8");     // русский текст для проверки UTF-8
        mb_internal_encoding("UTF-8");

        $result = false; // Признак успешного формирования накладной
        try { // Отправляем запрос в ПОНИ
            $client = new SoapClient("https://svc-api.p2e.ru/UI_Service.svc?singleWsdl", array( "cache_wsdl" => 0, "trace" => 1, "exceptions" => 1));
            $res    = $client->SubmitRequest($chk_query);
            $a = json_decode(json_encode((array)simplexml_load_string($res->SubmitRequestResult)),1);
            if ( isset($_GET['show_request_body']) ) {
                echo '<pre>';var_dump($a);die();
            }
            // Проверяем статусы из обработки заказа
            if ( isset($a['OrderList']['Order']["StatusList"]["OrderStatus"]) && is_array($a['OrderList']['Order']["StatusList"]["OrderStatus"]) ) {
                foreach ( $a['OrderList']['Order']["StatusList"]["OrderStatus"] as $k=>$v ) {
                    if ( isset($v["Code"]) && $v["Code"] == 'Declined' ) {
                        $message = $v["Description"];
                        $result  = false; // Сообщим пользователю причину отказа
                    }
                }
            }
            if ( isset($a['OrderList']['Order']["ServiceList"]["Service"]) && is_array($a['OrderList']['Order']["ServiceList"]["Service"]) ) {
                foreach ( $a['OrderList']['Order']["ServiceList"]["Service"] as $k=>$v ) {
                    if ( isset($v["Waybill"]) && !empty($v["Waybill"]) ) { // Пробрасываем номер накладной в заказ
                        $this->db->query($sql = "UPDATE orders SET invoice_number = '" . $this->db->escape($v["Waybill"]["Number"]) . "', delivery_company_id = '4' WHERE order_id = '" . $this->get('order_id') . "'");
                        $result = true; // Если в накладной все ок - сообщим пользователю
                    }
                    if ( isset($v["Recipient"]) ) {
                        $this->db->query($sql = "UPDATE orders SET poni_dest = '" . $this->db->escape($v["Recipient"]['Node']) . "', delivery_company_id = '4' WHERE order_id = '" . $this->get('order_id') . "'");
                    }
                }
            }
            if ( isset($a['MessageList']['ResponceMessage']['IsError']) && $a['MessageList']['ResponceMessage']['IsError'] == 'true') {
                $message = $a['MessageList']['ResponceMessage']['Text'];
                return false;
            }
            if ( isset($a['MessageList']['ResponceMessage'][0]['IsError']) && $a['MessageList']['ResponceMessage'][0]['IsError'] == 'true') {
                $message = $a['MessageList']['ResponceMessage'][0]['Text'];
                return false;
            }
            $s = $a['OrderList']['Order']['StatusList']['OrderStatus'];
            if ( !isset($s["Description"]) ) {
                $s = $s[count($s)-1];
            }
            $message = $s["Description"];
        }
        catch (SOAPFault $f) {
            $message = 'SOAP Fault. Please try later';
            return false;
        }
        return $result;
    }



    private function _request_poni_get_ServiceSender(){

        $file = file_get_contents($_SERVER['DOCUMENT_ROOT'] . '/models/order.xml');
        preg_match("/<Shipper(.*)>/isU", $file, $row);
        preg_match("/Country\=\"(.*)\"/isU", $row[1], $ServiceSender->Country);
        $ServiceSender->Country = $ServiceSender->Country[1];
        preg_match("/City\=\"(.*)\"/isU", $row[1], $ServiceSender->City);
        $ServiceSender->City = $ServiceSender->City[1];
        preg_match("/Address\=\"(.*)\"/isU", $row[1], $ServiceSender->StreetAddress);
        $ServiceSender->StreetAddress = $ServiceSender->StreetAddress[1];
        preg_match("/ContactName\=\"(.*)\"/isU", $row[1], $ServiceSender->Name);
        $ServiceSender->Name = $ServiceSender->Name[1];
        preg_match("/Phone\=\"(.*)\"/isU", $row[1], $ServiceSender->Phone);
        $ServiceSender->Phone = $ServiceSender->Phone[1];

        return $ServiceSender;
    }



    // Функция обработки A1Lite "URL скрипта обработчика на Вашем сайте"
    // $t - Данные $_POST на входе
    // $secret - "Секретный ключ" совпадающий с указанным в настройках формы создания сервиса
    public function rfi_payment_confirm($t, $secret, $test = false)
    {
        $params = array(
            'tid'           => $t['tid'],
            'name'          => $t['name'],
            'comment'       => $t['comment'],
            'partner_id'    => $t['partner_id'],
            'service_id'    => $t['service_id'],
            'order_id'      => $t['order_id'],
            'type'          => $t['type'],
            'partner_income'=> $t['partner_income'],
            'system_income' => $t['system_income'],
            'test'          => $test ? '1' : '', // Для проверки тестовой интеграции
        );

        $params['check'] = md5(join('', array_values($params)) . $secret);
        $tid = $this->db->result("SELECT tid FROM rfi_transactions WHERE tid = {$t['tid']}")->tid;
        if ($params['check'] === $t['check'] && !$tid) { // Действия по зачислению платежа. Ключи совпали.
            // Добавляем в транзакции
            foreach ($t as $k=>$v) $t[$k] = $this->db->escape($v);
            $this->db->query("
                INSERT INTO `rfi_transactions` (`tid`, `name`, `comment`, `partner_id`, `service_id`, `order_id`, `type`, `partner_income`, `system_income`)
                VALUES ('{$t['tid']}', '{$t['name']}', '{$t['comment']}', '{$t['partner_id']}', '{$t['service_id']}',
                        '{$t['order_id']}', '{$t['type']}', '{$t['partner_income']}', '{$t['system_income']}');
            ");
            // Увеличиваем сумму предоплаты в заказе
            if (!empty($t['order_id'])) {
                $t['order_id'] = intval($t['order_id'] % 1000000); // Если это предоплата за заказ - то она имеет увеличеный номер и чтобы получить номер заказа надо взять остаток от деления
                $this->db->query("UPDATE `orders` SET payment_prepaid = payment_prepaid + {$t['system_income']} WHERE order_id = '{$t['order_id']}' LIMIT 1 ");
                // Если оплачена полная стоимость заказа с учетом 5% скидки за онлайн-оплату, применяем 5% скидку ко всем товарам в заказе
                $no_payment_discount = $this->db->result("SELECT no_payment_discount AS npd FROM orders WHERE order_id = {$t['order_id']}")->npd;
                if (!$no_payment_discount) {
                    $order_sum       = $this->db->result("SELECT SUM(price) AS sum FROM orders_products WHERE order_id = {$t['order_id']}")->sum;
                    $payment_prepaid = $this->db->result("SELECT payment_prepaid AS pp FROM orders WHERE order_id = {$t['order_id']}")->pp;
                    if ($payment_prepaid >= $order_sum*0.95) {
                        $this->db->query("UPDATE orders_products op LEFT JOIN products p ON p.product_id = op.product_id SET op.price = op.price*0.95 WHERE op.order_id = {$t['order_id']} AND op.price > p.last_price_online");
                    }
                }

                $text = "Предоплата через РФИ сумма {$t['system_income']}р, транзакция {$t['tid']}";
                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$t['order_id']}, 0000, 'payment_prepaid', '{$text}')");
                $this->db->query("INSERT INTO order_comments (order_id, user_id, text, date) VALUES ({$t['order_id']}, 0000, '{$text}', NOW())");
                $this->db->query("INSERT INTO payments (order_id, payment_method_id, date, amount) VALUES ({$t['order_id']}, 18, NOW(), {$t['system_income']})");
                $payment_id = $this->db->insert_id();
                Job::push('LifepayExportJob', ['payment_id' => $payment_id]);
            }

            // Отправляем в слак
            $message = "Предоплата через РФИ сумма {$t['system_income']}р, транзакция {$t['tid']}, заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$t['order_id']}|{$t['order_id']}>";
            $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "rfi_payment_confirm" );
            Job::push('SlackJob', $args);

            return true;
        }
        return false;
    }


    //$data - GET параметры на входе от Сбера
    //$secretkey - закрытый ключ
    //вычисляем контрольную сумму функцией hash_hmac, сравниваем с checksum из $data
    public function sber_payment_confirm($data_sber)
    {
        mail('a.shesternina@gmail.com, tirjen@gmail.com', "Sber RAW data", var_export($data_sber, true));
        if (empty($data_sber['amount']) || empty($data_sber['mdOrder']) || empty($data_sber['orderNumber']) || empty($data_sber['checksum'])) {
            echo "Не хватает данных от сбербанка";
            return false;
        }

        $data = 'amount;'.$data_sber['amount'].';mdOrder;'.$data_sber['mdOrder'].';operation;'.$data_sber['operation'].';orderNumber;'.$data_sber['orderNumber'].';status;'.$data_sber['status'].';';

        $secretkey      = 'fpvjkajarb2ma9qk4m952adn34';
        $self_checksum  = strtoupper(hash_hmac('sha256', $data, $secretkey));

        if ($self_checksum == $data_sber['checksum']) {// Действия по зачислению платежа. Контрольные суммы совпали.
            foreach ($data_sber as $k=>$v) $data_sber[$k] = $this->db->escape($v);

            // Транзакция должна быть уникальной
            $order = $this->db->result("SELECT * FROM `sber_transactions` WHERE `md_order` = '{$data_sber['mdOrder']}' LIMIT 1 ");
            if (empty($order->order_key)) { // Если транзакция не обаботана - тогда обрабатываем
                $data_sber['amount'] = $data_sber['amount']/100;

                $order_id = $this->db->result("SELECT order_id FROM orders WHERE sber_order_id = '{$data_sber['mdOrder']}' LIMIT 1 ")->order_id;
                if (empty($order_id)) { echo 'Не найден номер заказа в локальной базе'; return false; }
                $op_status = 3;
                if ($data_sber['status'] == 0){
                  require_once($_SERVER['DOCUMENT_ROOT'] . '/Sberbankpayment.class.php');
                  $sb = new CSberbank();
                  $r  = $sb->getOrderStatus($data_sber['mdOrder'], true);
                  if( $r['OrderStatus'] == 2 || $r['ErrorMessage'] == 'Успешно' )$data_sber['status'] = 1;
                  else $data_sber['ErrorMessage'] = $r['ErrorMessage'];
                }

                // Если оплата прошла
                if ($data_sber['status'] == 1){
                  $op_status = 4;
                  $this->db->query("UPDATE `orders` SET payment_prepaid = payment_prepaid + {$data_sber['amount']} WHERE order_id = '{$order_id}' LIMIT 1 ");

                  // Если оплачена полная стоимость заказа с учетом 5% скидки за онлайн-оплату, применяем 5% скидку ко всем товарам в заказе
                  $no_payment_discount = $this->db->result("SELECT no_payment_discount AS npd FROM orders WHERE order_id = {$order_id}")->npd;
                  if (!$no_payment_discount) {
                      $order_sum       = $this->db->result("SELECT SUM(price) AS sum FROM orders_products WHERE order_id = {$order_id}")->sum;
                      $payment_prepaid = $this->db->result("SELECT payment_prepaid AS pp FROM orders WHERE order_id = {$order_id}")->pp;
                      $order_products = $this->db->results("SELECT p.product_id, p.price, p.old_price, p.offline_price, p.brand_id, p.season_type, op.price AS order_price FROM orders_products op LEFT JOIN products p ON op.product_id = p.product_id WHERE order_id = '{$order_id}' ");
                      $order_total = 0; 
                      $pps = array();
                      foreach($order_products AS $product){
                        $start_price = $product->old_price != 0 ? $product->old_price : $product->offline_price;
                        if(empty($start_price))$start_price = $product->price;
                        $max_sale = $this->db->result($sql = "SELECT max_sale FROM sale_settings WHERE brand_id = '{$product->brand_id}' AND season = '{$product->season_type}' LIMIT 1;")->max_sale;
                        $min_price = $start_price*((100-$max_sale)/100);
                        $price_online = (string)($product->order_price*0.95);
                        if ($price_online < $min_price)$price_online = $product->order_price;
                        $pps[$product->product_id] = $price_online;
                        $order_total += $price_online;
                      }
                      if ($payment_prepaid >= $order_total && $payment_prepaid != $order_sum) {
                        foreach($pps as $k=>$p){
                          $this->db->query("UPDATE orders_products op LEFT JOIN products p ON p.product_id = op.product_id SET op.price = {$p} WHERE op.order_id = {$order_id} AND op.product_id = {$k} AND op.price > p.last_price_online");
                        }
                      }
                  }

                  $this->db->query("INSERT INTO payments (order_id, payment_method_id, date, amount) VALUES ({$order_id}, 20, NOW(), {$data_sber['amount']})");
                  $payment_id = $this->db->insert_id();
                  Job::push('LifepayExportJob', ['payment_id' => $payment_id]);

                  $text = "Предоплата через Сбербанк сумма {$data_sber['amount']}р, номер заказа {$order_id}, код сбера {$data_sber['mdOrder']}";
                  $message = "Предоплата через Сбербанк сумма {$data_sber['amount']}р, номер заказа {$order_id}, код сбера {$data_sber['mdOrder']}, заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}>";
                }
                else{
                  $text = "Не прошла! Предоплата через Сбербанк сумма {$data_sber['amount']}р, номер заказа {$order_id}, код сбера {$data_sber['mdOrder']}. Причина: {$data_sber['ErrorMessage']}";
                  $message = "Не прошла! Предоплата через Сбербанк сумма {$data_sber['amount']}р, номер заказа {$order_id}, код сбера {$data_sber['mdOrder']}, заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}>. Причина: {$data_sber['ErrorMessage']}";
                }
                // Отправляем в слак для менеджеров
                $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "rfi_payment_confirm" );
                Job::push('SlackJob', $args);

                // Складываем в логи
                $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, 0000, 'payment_prepaid', '{$text}')");
                $this->db->query("INSERT INTO order_comments (order_id, user_id, text, date) VALUES ({$order_id}, 0000, '{$text}', NOW())");

                $this->db->query("
                    INSERT INTO `sber_transactions` (`amount`, `md_order`, `operation`, `order_key`, `status`)
                    VALUES ('{$data_sber['amount']}', '{$data_sber['mdOrder']}', '{$data_sber['operation']}', '{$data_sber['orderNumber']}', '{$data_sber['status']}');
                ");
                $id = $this->db->insert_id();
                $this->db->query("UPDATE `online_payments` SET paid = {$op_status}, sb_tran_id = {$id}  WHERE order_id = '{$order_id}' AND amount = {$data_sber['amount']} LIMIT 1 ");
            }
            elseif($data_sber['status'] != $order->status){
              $this->db->query("UPDATE `sber_transactions` SET status = {$data_sber['status']}, operation = {$data_sber['operation']}  WHERE md_order = '{$data_sber['mdOrder']}' LIMIT 1 ");
              
            }
            return true;
        }
        else echo "Checksum не совпадает!";
        return false;
    }

    protected function apple_pay_send($token, $order_id, $test = false){
      if(!empty($token)){
        $url = 'https://securepayments.sberbank.ru/payment/applepay/payment.do';
        if($test)$url = 'https://3dsec.sberbank.ru/payment/applepay/payment.do';
        mail('tirjen@gmail.com', "APPP url data", $url);
        $data = array("merchant"=>"lsboutique",
                      "orderNumber"=>"$order_id",
                      "description"=>"Оплата заказа $order_id",
                      "paymentToken"=>"$token",
                      "language"=>"RU");
        $header = array('Content-Type: application/json');
        $data = json_encode($data);
        $curl = curl_init();
        curl_setopt( $curl, CURLOPT_URL, $url);
        curl_setopt( $curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt( $curl, CURLOPT_POST, 1);
        curl_setopt( $curl, CURLOPT_POSTFIELDS,   $data );
        curl_setopt( $curl, CURLOPT_HTTPHEADER, $header);

        $result = curl_exec( $curl );
        curl_close( $curl );

        //$result->success = true;
        //$result = json_encode($result);
        return $result;
      }

    }

    public function apple_pay_relay($token, $order_id, $user_id=0, $test = false){
      if(!empty($token)){
        $data = $this->apple_pay_send($token, $order_id, $test);
        mail('tirjen@gmail.com', "APPP data", var_export($data, true));
        $data = json_decode($data);
        if($data->success != true ){
          mail('tirjen@gmail.com', "APPP error data", var_export($data, true));
          $data->success = false;
          $sber_order_id = $data->orderStatus->attributes[0]->value;
          $operation = 'declined';
          $status = 0;
          $text = "Не прошла! Предоплата через Apple pay сумма {$data->orderStatus->amount}р, номер заказа от сбера {$data->data->orderId}. Причина: {$data->error->message}";
          $message = "Не прошла! Предоплата через Apple pay сумма {$data->orderStatus->amount}р, номер заказа от сбера {$data->data->orderId}, заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}>. Причина: {$data->error->message}";
        }
        else{
          $sber_order_id = $data->data->orderId;
          $operation = 'deposited';
          $status = 1;
          $text = "Предоплата через Apple pay сумма {$data->orderStatus->amount}р, номер заказа от сбера {$data->data->orderId}";
          $message = "Предоплата через Apple pay сумма {$data->orderStatus->amount}р, номер заказа от сбера {$data->data->orderId}, заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}>";
        }
        $this->db->query("
                  INSERT INTO `apple_pay_confirm` (`amount`, `md_order`, `user_id`, `order_id`, `status`, `date`)
                  VALUES ('{$data->orderStatus->amount}', '{$sber_order_id}', '{$user_id}', '{$order_id}', '{$data->orderStatus->orderStatus}', NOW());");
        // Отправляем в слак для менеджеров
        $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "rfi_payment_confirm" );
        Job::push('SlackJob', $args);
        mail('manager@ls.net.ru', $_SERVER['SERVER_NAME'] . ' - Apple pay', $message);

        // Складываем в логи
        $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, 0000, 'payment_prepaid', '{$text}')");
        $this->db->query("INSERT INTO order_comments (order_id, user_id, text, date) VALUES ({$order_id}, 0000, '{$text}', NOW())");

        $this->db->query("
            INSERT INTO `sber_transactions` (`amount`, `md_order`, `operation`, `order_key`, `status`)
            VALUES ('{$data->orderStatus->amount}', '{$data->data->orderId}', '{$operation}', '{$order_id}', '{$status}');
        ");
        return $data;
      }

    }

    protected function google_pay_send($token, $order_id, $order_total, $test = false){
      if(!empty($token)){
        $url = 'https://securepayments.sberbank.ru/payment/google/payment.do';
        if($test)$url = 'https://3dsec.sberbank.ru/payment/google/payment.do';
        $order_total = $order_total*100;//в копейки
        $data = array("merchant"=>"lsboutique",
                      "orderNumber"=>"$order_id",
                      "description"=>"Оплата заказа $order_id",
                      "amount"=>"$order_total",
                      "paymentToken"=>"$token",
                      "returnUrl"=>"https://lsboutique.ru/",
                      "language"=>"RU");
        $header = array('Content-Type: application/json');
        $data = json_encode($data);
        mail('tirjen@gmail.com', "GPPP data", $data . '<br>' . $url);
        $curl = curl_init();
        curl_setopt( $curl, CURLOPT_URL, $url);
        curl_setopt( $curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt( $curl, CURLOPT_POST, 1);
        curl_setopt( $curl, CURLOPT_POSTFIELDS,   $data );
        curl_setopt( $curl, CURLOPT_HTTPHEADER, $header);

        $result = curl_exec( $curl );
        curl_close( $curl );
        
        mail('tirjen@gmail.com', "google_p data", $result);
        return $result;
      }

    }

    public function google_pay_relay($token, $order_id, $order_total, $user_id=0, $test = false){
      if(!empty($token)){
        $data = $this->google_pay_send($token, $order_id, $order_total, $test);
        $data = json_decode($data);
        if($data->success != true ){
          mail('tirjen@gmail.com', "google error data", var_export($data, true));
          $data->success = false;
          $operation = 'declined';
          $status = 0;
          $g_status = 0;
          $text = "Не прошла! Предоплата через Google pay, номер заказа от сбера {$data->data->orderId}. Причина: {$data->error->message}";
          $message = "Не прошла! Предоплата через Google pay, номер заказа от сбера {$data->data->orderId}, заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}>. Причина: {$data->error->message}";
        }
        else{
          $this->db->query("UPDATE `orders` SET payment_prepaid = payment_prepaid + {$order_total} WHERE order_id = '{$order_id}' LIMIT 1 ");
          $operation = 'deposited';
          $status = 1;
          $g_status = 1;
          $text = "Предоплата через Google pay номер заказа от сбера {$data->data->orderId}";
          $message = "Предоплата через Google pay номер заказа от сбера {$data->data->orderId}, заказ #<https://lsboutique.ru/admin/index.php?section=Order&order_id={$order_id}|{$order_id}>";
        }
        $this->db->query("
                INSERT INTO `google_pay_confirm` (`amount`, `md_order`, `user_id`, `order_id`, `status`, `date`)
                VALUES ('{$order_total}', '{$data->data->orderId}', '{$user_id}', '{$order_id}', '{$g_status}', NOW());");
        // Отправляем в слак для менеджеров
        $args    = array( 'user' => 'ls_admin', 'message' => $message, 'channel' => "rfi_payment_confirm" );
        Job::push('SlackJob', $args);
        mail('tirjen@gmail.com', $_SERVER['SERVER_NAME'] . ' - Google pay', $message);

        // Складываем в логи
        $this->db->query("INSERT INTO orders_events (order_id, user_id, type, text) VALUES ({$order_id}, 0000, 'payment_prepaid', '{$text}')");
        $this->db->query("INSERT INTO order_comments (order_id, user_id, text, date) VALUES ({$order_id}, 0000, '{$text}', NOW())");

        $this->db->query("
            INSERT INTO `sber_transactions` (`amount`, `md_order`, `operation`, `order_key`, `status`)
            VALUES ('{$order_total}', '{$data->data->orderId}', '{$operation}', '{$order_id}', '{$status}');
        ");
        return $data;
      }

    }
}
