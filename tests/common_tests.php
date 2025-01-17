<?php

class CommonTests extends PHPUnit_Framework_TestCase
{
	
	var $url = '';
	var $data = '';
	var $result;
	var $fields1 = array();
	var $fields2 = array();
	
    function Curl_connect($url){
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $result = curl_exec($ch);
		
		return $result;
    }
	function Curl_connect_post($url, $data){
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		$result = curl_exec($ch);
		
		return $result;
	}
	function empty_test($result){
		$this->assertNotEmpty($result);
	}
	function null_test($result){
		$this->assertNotNull($result);
    }
	function equal_test($expect, $result){
		$this->assertNotNull($expect, $result);
    }
	function type_test($result){
		$this->assertInternalType('string', $result);
		
    }
    function field_loop_test($fields, $array){
		foreach($fields as $field){
            $this->assertArrayHasKey($field, $array);
        }
    }
    function fields_test1($result, $fields){
        if(is_string($result)){
            $result = json_decode($result, true);
        }
        foreach($result as $subres){
            if (isset($subres[0]) && is_array($subres[0])){
                $i = 0;
                foreach($subres as $ssubres){
                    $this->field_loop_test($fields, $ssubres);
                    if (($i++) == 4) {break;}
                }
            }
            else{
                $this->field_loop_test($fields, $subres);
            }
        }
    }
	function fields_test2($result, $fields1, $fields2){
        if(is_string($result)){
            $result = json_decode($result, true);
        }
        $this->field_loop_test($fields1, $result);
        if(isset($result['user']) || isset($result['order'])){
            $sres = isset($result['user']) ? $result['user'] : $result['order'];
            $this->field_loop_test($fields2, $sres);
        }
        elseif(!empty($result['products'])){
            $i = 0;
            foreach($result['products'] as $ssubres){
                $this->field_loop_test($fields2, $ssubres);
                if (($i++) == 4) {break;}
            }
        }
        else{
            foreach($result as $sres){
                if(is_array($sres) || is_object($sres)){
                    $i = 0;
                    foreach($sres as $ssubres){
                        $this->field_loop_test($fields2, $ssubres);
                        if (($i++) == 4) {break;}
                    }
                }
            }
        }
	}
	function fields_test3($result, $fields1, $fields2){
		if(is_string($result)){
            $result = json_decode($result, true);
        }
        foreach($result as $r){
            if(isset($r['sets']) || isset($r['look'])){
                $i = 0;
                $r = isset($result['sets']) ? $result['sets'] : $result['look']['set'];
                $this->field_loop_test($fields1, $r);
                foreach($r as $ssubres){
                    $this->field_loop_test($fields2, $ssubres);
                    if (($i++) == 4) {break;}
                }
            }
        }
	}
    
    
    function test_newsitem_generated(){
		$url = 'https://api2.lsboutique.ru/feed/generate_page/2017-01-18/';
		$fields = array('date','header','info');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$result = json_decode($result, true);
        foreach($result as $res){
            $this->field_loop_test($fields, $res);
        }
        if(!empty($result['info'])){
            $fields = array('anons');
            $this->fields_test1($result['info'], $fields);
            if(!empty($result['info']['add_pr'])){
                $fields1 = array('text','brands','categories','products');
                $fields2 = array('name','id');
                $this->fields_test2($result['info']['add_pr'], $fields1, $fields2);
            }
            if(!empty($result['info']['sale_pr'])){
                $fields1 = array('text','brands','categories','products');
                $fields2 = array('name','id');
                $this->fields_test2($result['info']['sale_pr'], $fields1, $fields2);
            }
            if(!empty($result['info']['vid_pr'])){
                $fields1 = array('text','products');
                $fields2 = array('name','id','video');
                $this->fields_test2($result['info']['vid_pr'], $fields1, $fields2);
            }
            if(!empty($result['info']['banner'])){
                $fields = array('banner_name','brand_id','banner_image');
                $this->fields_test1($result['info']['banner'], $fields);
            }
            if(!empty($result['info']['cities'])){
                $fields = array('text','city_id','city_name');
                $this->fields_test1($result['info']['cities'], $fields);
            }
            if(!empty($result['info']['faq'])){
                $fields = array('question','user_name','answer');
                $this->fields_test1($result['info']['faq'], $fields);
            }
        }
	}
    
    function test_newsline_generated(){
		$url = 'https://api2.lsboutique.ru/newsline/generated/';
		$fields = array('date','anons','info');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$result = json_decode($result, true);
        $i = 0;
        foreach($result['news_generated'] as $res){
            $this->field_loop_test($fields, $res);
            if (($i++) == 4) {break;}
        }
        if(!empty($result['info'])){
            if(!empty($result['info']['add_pr'])){
                $fields1 = array('text','brands','categories','products');
                $fields2 = array('name','id');
                $this->fields_test2($result['info']['add_pr'], $fields1, $fields2);
            }
            if(!empty($result['info']['sale_pr'])){
                $fields1 = array('text','brands','categories','products');
                $fields2 = array('name','id');
                $this->fields_test2($result['info']['sale_pr'], $fields1, $fields2);
            }
            if(!empty($result['info']['vid_pr'])){
                $fields1 = array('text','products');
                $fields2 = array('name','id','video');
                $this->fields_test2($result['info']['vid_pr'], $fields1, $fields2);
            }
            if(!empty($result['info']['banner'])){
                $fields = array('banner_name','brand_id','banner_image');
                $this->fields_test1($result['info']['banner'], $fields);
            }
            if(!empty($result['info']['cities'])){
                $fields = array('text','city_id','city_name');
                $this->fields_test1($result['info']['cities'], $fields);
            }
            if(!empty($result['info']['faq'])){
                $fields = array('question','user_name','answer');
                $this->fields_test1($result['info']['faq'], $fields);
            }
        }
	}
    
    function test_get_rfi_keys(){
		$url = 'https://api2.lsboutique.ru/order/get_rfi/';
		$fields = array('rfi_service_id','rfi_key');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_get_all_sizes(){
		$url = 'https://api2.lsboutique.ru/cart/get_all_sizes/';
		$fields = array('topsizes','bottomsizes','shoesizes');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_get_wardrobe(){
		$url = 'https://api2.lsboutique.ru/cart/get_wardrobe/?user_id=1713';
		$fields = array('online_purchase','offline_purchase');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$result = json_decode($result, true);
		$this->field_loop_test($fields, $result);
        if(!empty($result['online_purchase'])){
            $fields = array('model','image','product_id','size','price','order_id','brand','brand_id','category','category_id');
            $this->fields_test1($result['online_purchase'], $fields);
        }
        if(!empty($result['offline_purchase'])){
            $fields = array('model','image','size','brand','brand_id','category','category_id');
            $this->fields_test1($result['offline_purchase'], $fields);
        }
	}
    
    function test_get_keys(){
		$url = 'https://api2.lsboutique.ru/cart/get_keys/?user_id=4877';
		$fields = array('name','network','card_number');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_get_wishlist(){
		$url = 'https://api2.lsboutique.ru/cart/get_wishlist/?user_id=62';
		$fields = array('model','product_id','price','category_id','category','brand_id','brand',
        'large_image','discount_value','size');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_get_subscription(){
		$url = 'https://api2.lsboutique.ru/login/get_subscription/?user_id=4877&brand_id=11';
		$fields = array('active');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$result = json_decode($result, true);
		$this->field_loop_test($fields, $result);
	}
    
    function test_get_subscriptions(){
		$url = 'https://api2.lsboutique.ru/login/get_subscription/?user_id=4877';
        $fields = array('id','name');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_cityitem(){
		$url = 'https://api2.lsboutique.ru/city/1054/';
		$fields = array('city_id','delivery_methods','payment_methods','name','image','image_right',
                'text','text2','map_url');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_cities(){
		$urls = array('https://api2.lsboutique.ru/cart/get_cities/?main', 'https://api2.lsboutique.ru/cart/get_cities/?delivery_page');
		$fields = array('city_id','city_name');
		foreach($urls as $url){
            $result = $this->Curl_connect($url);
            $this->empty_test($result);
            $this->null_test($result);
            $this->type_test($result);
            $this->fields_test1($result, $fields);
        }
	}
    
	function test_banners(){
		$url = 'https://api2.lsboutique.ru/?banners';
		$fields = array('name','brand_id','banner','title','sex','url');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
	
	function test_categories(){
		$url = 'https://api2.lsboutique.ru/catalog/?categories&sex=2&category=1';
		$fields = array('id','name','prod_count_m','prod_count_w');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
	
	function test_brandwall(){
		$url = 'https://api2.lsboutique.ru/brandwall/';
		$fields = array('id','name');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_news(){
		$url = 'https://api2.lsboutique.ru/news/';
		$fields = array('news_id','header','Fdate','body','video','image');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_newsline_text(){
		$url = 'https://api2.lsboutique.ru/newsline/text/';
		$fields = array('text','video','image','date','title','url','special_id','category_id','brand_id','news_id');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_newsitem(){
		$url = 'https://api2.lsboutique.ru/news/148/';
		$fields = array('news_id','header','date','body','video','image');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_faq(){
		$url = 'https://api2.lsboutique.ru/faq/';
		$fields2 = array('id','question','answer','user_name','user_email','user_phone',
			'user_feature','dat');
		$fields1 = array('questions','current_page','pages_num');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test2($result, $fields1, $fields2);
	}
	
	function test_products(){
		$url = 'https://api2.lsboutique.ru/catalog/?products&sex=2&category=4';
		$fields2 = array('product_id','code','category_id','brand_id','color_id','model',
			'sku','price','old_price','description','body','size','sex','season','text_sizes',
			'uhod','s_material','super_price','no_discount','fur_sale','video','brand',
			'golden_sale','no_sale','category','parent','can_buy_from_site',
			'small_image_small','large_image_small','small_image_medium','large_image_medium',
            'small_image_full','large_image_full');
		$fields1 = array('products','sizes','materials','brands','categories');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test2($result, $fields1, $fields2);
	}
	
	function test_product(){
		$url = 'https://api2.lsboutique.ru/products/64418/';
		$fields = array("product_id","code","category_id","brand_id","color_id","model",
			"sku","price","old_price","offline_price","description","body","size","sex",
			"season","text_sizes","uhod","item_location",'video',
			"s_material","special_sale","super_price","no_discount","fur_sale","brand",
			"category","category_image","category_parent","item_location_link",
			"item_location_name","related_products","properties","materials","is_sale","fotos",
			"size_text","tmp_size_text","sizes_url","img_desc","small_image_small",
			"large_image_small","small_image_medium","large_image_medium","small_image_full",
			"large_image_full");
						
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
    
    function test_looks(){
		$url = 'https://api2.lsboutique.ru/looks/?sex=1&brand=103';
		$fields1 = array('id','main_product_id','name','date','big_size','image_small',
            'image_medium','image_full','products');
        $fields2 = array('product_id','model','price','size','video','video_added',
			'small_image_small','small_image_medium','small_image_full','large_image_small',
            'large_image_medium','large_image_full');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test3($result, $fields1, $fields2);
	}
    
    function test_look(){
		$url = 'https://api2.lsboutique.ru/look/3220/';
		$fields1 = array('id','main_product_id','name','date','big_size','image_small','image_medium','image_full','products');
        $fields2 = array('product_id','code','model','category_id','brand_id','color_id','brand',
            'model','sku','old_price','offline_price','description','price','size','video','category',
            'video_added','body','size','sex','season','text_sizes','uhod','item_location',
            's_material','special_sale','super_price','no_discount','fur_sale','size_text',
			'small_image_small','small_image_medium','small_image_full','large_image_small',
            'large_image_medium','large_image_full');
						
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test3($result, $fields1, $fields2);
	}
    
    function test_delpage(){
		$url = 'https://api2.lsboutique.ru/section/161/';
		$fields = array('delivery_methods','payment_methods','return_text','license_text');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
        $result = json_decode($result, true);
		$this->field_loop_test($fields, $result);
	}
    
    function test_statpage(){
		$url = 'https://api2.lsboutique.ru/section/174/';
		$fields = array('section_id','name','header','body');
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
        $result = json_decode($result, true);
		$this->field_loop_test($fields, $result);
	}
	
	function test_one_click(){
		$url = 'https://api2.lsboutique.ru/api_order/?phone=2222222222&product=44444&name=Test%20Tester';
		$expect = 'ok';
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->equal_test($expect, $result);
	}
	
	function test_login(){
		$url = 'https://api2.lsboutique.ru/login/?phone=79877536745&card_number=5475005672412600';
		$fields = array("original_user_id","email","name","deposit","photo","photo_rec","sex","card_number",
						"phone_number","city","city_id","adress","birth_date","personal_discount",
						"show_hidden_brands","sizes_top","sizes_bottom","sizes_shoes");
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test1($result, $fields);
	}
	
	function test_save_token(){
		$url = 'https://api2.lsboutique.ru/login/save_token/?token=354658798075&platform=iOS&phone=79030001122';
		$fields1 = array("message");
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test2($result, $fields1, null);
	}
	
	function test_save_size(){
		$url = 'https://api2.lsboutique.ru/login/save_sizes/?user_id=3639&type_id=1&size=XL';
		$expect = 'set';
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->equal_test($expect, $result);
	}
	
	function test_subscribe(){
		$url = 'https://api2.lsboutique.ru/login/subscribe/?user_id=14574&brand_id=11';
		$fields1 = array("message");
		
		$result = $this->Curl_connect($url);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test2($result, $fields1, null);
	}
	
	function test_register(){
		$url = 'https://api2.lsboutique.ru/login/self_register/';
		$data = 'name=test&surname=tester&phone_number=0011111111&email=1@1&sex=2&test=1';
		$fields1 = array("message", "user");
		$fields2 = array("original_user_id", "email", "name", "sex", "card_number", "phone_number");
		
		$result = $this->Curl_connect_post($url, $data);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test2($result, $fields1, $fields2);
	}
	
	function test_order(){
		$url = 'https://api2.lsboutique.ru/cart/';
		$data = "submit_order=1&phone=79877536745&comment=comment&products[64486]=40, 41&products[64493]=S&products[64440]=р-р не зад&products[63587]=48, 44&test=1";
		$fields1 = array("message", "order");
		$fields2 = array("order_id","weight","delivery_status","delivery_paid","money_status","delivery_price",
				"real_delivery_price","payment_prepaid","coupon_code","date","user_id","manager_id",
				"name","address","city_id","city","region","country","phone","email","user_comment",
				"status","code","deposit_payment","total_amount","products",);
		
		$result = $this->Curl_connect_post($url, $data);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test2($result, $fields1, $fields2);
	}
	
	function test_edit_user(){
		$url = 'https://api2.lsboutique.ru/cart/save_user/';
		$data = 'user_id=13973&name=tester tets&email=name2@domen.ru&sex=2&test=1';
        $fields1 = array("user");
		$fields2 = array("user_id","original_user_id","email","name","deposit","photo","photo_rec","sex","card_number",
				"phone_number","city","city_id","adress","birth_date","personal_discount",
				"show_hidden_brands","sizes_top","sizes_bottom","sizes_shoes");
		
		$result = $this->Curl_connect_post($url, $data);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->fields_test2($result, $fields1, $fields2);
	}
    
    function test_save_question(){
		$url = 'https://api2.lsboutique.ru/faq/question/';
		$data = 'phone_number=1453114531&name=tester tets&email=name2@domen.ru&question=test_question?&test=1';
        $fields = array("message");
		
		$result = $this->Curl_connect_post($url, $data);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$result = json_decode($result, true);
		$this->field_loop_test($fields, $result);
	}
    
    function test_edit_order(){
		$url = 'https://api2.lsboutique.ru/order/';
		$data = 'update_object=1&user_id=15594&order_id=22398&data[address]=пл ленина';
        $expect = 'ok';
        
		$result = $this->Curl_connect_post($url, $data);
		$this->empty_test($result);
		$this->null_test($result);
		$this->type_test($result);
		$this->equal_test($expect, $result);
	}
    
}
?>