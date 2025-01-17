bindTrackingEvents = function(PRICE_LIST_ID) {
  var pixel = window.pixel
  var location = String(document.location.href);

  //посешение главной страници
  if(location == 'https://lsboutique.ru' || location == 'https://lsboutique.ru/'){
    let eventParams = {};
    VK.Retargeting.ProductEvent(PRICE_LIST_ID, "view_home", eventParams);
  }
  //посещение страници категории
  if (location.indexOf('brands')+1||location.indexOf('brands')+1||location.indexOf('brands')+1){
    let eventParams = {};
    VK.Retargeting.ProductEvent(PRICE_LIST_ID, "view_category", eventParams);
  }
  //посещение корзины и списка желаний
  if(location.indexOf('cart')+1){
    let eventParams = {};
    VK.Retargeting.ProductEvent(PRICE_LIST_ID, "view_other", eventParams);
    if(location.indexOf('show_wl')+1){
      let eventParams = {};
      VK.Retargeting.ProductEvent(PRICE_LIST_ID, "view_search", eventParams);
    }
    $('#product_wl').click(function () {
      let eventParams = {};
      VK.Retargeting.ProductEvent(PRICE_LIST_ID, "view_search", eventParams);
    });
  }
  //совершение покупки в один клик
  if(location.indexOf('oneclick')+1){
    var oneclick_id = location.split('oneclick/')[1].replace('/','');
    $('.ShAA_popButton_input').click(function () {
      let eventParams = {"products" : [{"id": oneclick_id}]};
      VK.Retargeting.ProductEvent(PRICE_LIST_ID, "purchase", eventParams);
    });
  }
  //совершение покупки
  if(location.indexOf('order')+1){
    var elems =  $('table.order_products a');
    var ids = [];
    for(var i=0; i<elems.length; ++i){
      ids.push($(elems[i]).attr('href').replace(/\D+/g,""));
    }
    var objects = []
    for(var i=0; i<ids.length; ++i){
      objects.push({"id": ids[i]})
    }
    let eventParams = {
      "products" : objects
    };
    console.log(eventParams);
    VK.Retargeting.ProductEvent(PRICE_LIST_ID, "purchase", eventParams);
  }
  if (location.indexOf('products') + 1) {
    var this_product_id = document.getElementById('this_product_id').value;
    var this_category_id = document.getElementById('this_category_id').value;
    //посещение карточки товара
    let eventParams = {
      "products" : [{"id": this_product_id}],
      "category_ids" : this_category_id
    };
    console.log(eventParams);
    VK.Retargeting.ProductEvent(PRICE_LIST_ID, "view_product", eventParams);

    //добавление в корзину
    $('#addToCart').click(function () {
      let eventParams = {
        "products" : [{"id": this_product_id}],
        "category_ids" : this_category_id
      };
      console.log(eventParams);
      VK.Retargeting.ProductEvent(PRICE_LIST_ID, "add_to_cart", eventParams);
    });
    //доавление в избранное
    $('#addToWishList').click(function () {
        let eventParams = {
          "products" : [{"id": this_product_id}],
          "category_ids" : this_category_id
        };
        console.log(eventParams);
        VK.Retargeting.ProductEvent(PRICE_LIST_ID, "add_to_wishlist", eventParams);
    });
    //удаление из избранного в КТ
    $('#removeFromWishList').click(function () {
        let eventParams = {
          "products" : [{"id": this_product_id}],
          "category_ids" : this_category_id
        };
        console.log(eventParams);
        VK.Retargeting.ProductEvent(PRICE_LIST_ID, "remove_from_wishlist", eventParams);
    });
  }
  //удаление из избранного в корзине
  $('.event_remove_item').click(function () {
    var del_id = $(this).parent().attr('data-product-id');
    let eventParams = {
      "products" : [{"id": del_id}]
    };
    console.log(eventParams);
    VK.Retargeting.ProductEvent(PRICE_LIST_ID, "remove_from_wishlist", eventParams);
  });
  //удаление товара из корзины
  $('.del_from_cart').click(function (){

    var del_id = $(this).parent().attr('data-product-id');
    let eventParams = {
      "products" : [{"id": del_id}]
    };
    console.log(eventParams);
    VK.Retargeting.ProductEvent(PRICE_LIST_ID, "remove_from_cart", eventParams);

  });
  //клик "оформить заказ"
  $('#submit_target').click(function(){
    let elems = $(".del_from_cart");
    var ids = [];
    for(var i=0; i<elems.length; ++i){
      ids.push($(elems[i]).parent().attr('data-product-id'));
    }
    var objects = []
    for(var i=0; i<ids.length; ++i){
      objects.push({"id": ids[i]})
    }
    let eventParams = {
      "products" : objects
    };
    console.log(eventParams);
    VK.Retargeting.ProductEvent(PRICE_LIST_ID, "init_checkout", eventParams);
  });
}

$(document).ready(function(){
    setTimeout(function() {
      var el = document.createElement("script");
      el.type = "text/javascript";
      el.src = "https://vk.com/js/api/openapi.js?150";
      el.async = true;
      document.getElementById("vk_api_transport").appendChild(el);
    }, 0);

    window.vkAsyncInit = function() {
        var PRICE_LIST_ID = 3397;
        window.pixel = new VK.Pixel('VK-RTRG-331259-6QZci');
        VK.Retargeting.Init('VK-RTRG-331259-6QZci');
        bindTrackingEvents(PRICE_LIST_ID)
    }
});
