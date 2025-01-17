function get_recomendations(container, type, paramsA, paramsB){

	if (typeof paramsA == "undefined") paramsA = {};
	if (typeof paramsB == "undefined") paramsB = {};
	
	var params = { recommender_type: type };

	if (paramsA.item) {
		params['item'] = paramsA.item;
	}
	if (paramsA.cart) {
		params['cart'] = paramsA.cart;
	}
	if (paramsA.category) {
		params['category'] = paramsA.category;
	}
	params['limit'] = '50'; // Запросим побольше рекомендаций

	REES46.addReadyListener(function () {
		REES46.recommend( params, 
			function (data) {
				if (data == "") return false;

				sex 		= paramsB.sex 			? paramsB.sex : '';
				limit 		= paramsB.limit 		? paramsB.limit : '';
				remove_ids 	= paramsB.remove_ids 	? paramsB.remove_ids : [];
				
				$r.get('/Recomendation.php', {'ids':data, 'limit':limit, 'remove_ids':remove_ids, 'type':type, 'sex':sex}, function(html) {
					if (html != "") {
						$r('.products', container).html(html);
						$r(container).slideDown('slow');
					}
				});
			});
	});
}