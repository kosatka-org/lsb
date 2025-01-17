<?php
require_once('route_conf.php');

    $params = array();
    $match = false;
    $requestUrl = null;

    // get Request Url
    if($requestUrl === null) {
        $requestUrl = isset($_SERVER['REQUEST_URI']) ? preg_replace('!/+!', '/', $_SERVER['REQUEST_URI']) : '/';
        if (strpos($_SERVER['REQUEST_URI'], '//') !== false) header("Location: $requestUrl");
    }

    // Strip query string (?a=b) from Request Url
    if (($strpos = strpos($requestUrl, '?')) !== false) {
        $requestUrl = substr($requestUrl, 0, $strpos);
    }

    foreach($routes as $handler) {
        list($method, $route, $params, $redirect) = $handler;
        $match = preg_match ($method, $requestUrl, $params);

        // No match, continue to next route.
        if ($match == 0) continue;

        $full_url = "//$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
        if($params != null) {
            $other_params = parse_url($full_url, PHP_URL_QUERY);
        }
        $params = (isset($other_params) && !empty($other_params)) ? '&' . $other_params : '';

        $actual_url = preg_replace($method,$route,$requestUrl);

        if ($redirect) {
          http_response_code(301);
          header('Location: ' . $actual_url);
          exit;
        }

        if(strpos($_SERVER[REQUEST_URI], '/pass_service/v1/') !== false){
          $payload = json_decode(file_get_contents('php://input'));
          foreach($payload as $key=>$data){
            $_POST["$key"] = $data;
          }
        }

        $set_params = parse_url("//$_SERVER[HTTP_HOST]$actual_url", PHP_URL_QUERY);
        $all_params = $set_params . $params;
        if(!empty($all_params)){
            $params = explode('&',$all_params);
            foreach($params as $p){
                $r = explode('=',$p);
                $_GET["$r[0]"] = isset($r[1]) ? trim(urldecode($r[1]), '/') : '';
            }
        }

        $_SERVER['REQUEST_URI'] = $actual_url;
        $_SERVER['SHOW_URI'] = $requestUrl;
        break;
    }
