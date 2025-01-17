<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" href="css/style.css" type="text/css" />
	<link rel="stylesheet" href="css/style_s.css" type="text/css" />
	<script type="text/javascript" src="/js/jquery/jquery.min.1.9.1.js"></script>
    <script type="text/javascript" src="/design/adaptive/css/bootstrap-toggle.js"></script>
</head>
<title></title>
<body style="width: 690px;">
<script type="text/javascript">
$(document).ready(function(){
    $('.conformity-table td').mouseout(function(){
        $('.conformity-table td').removeClass('active-col');
        $('.conformity-table tr').removeClass('active-row');
    });
    $('.conformity-table td').mouseover(function(){
        $(this).parent().addClass('active-row');
        var index=$(this).index();
        $(this).parent().parent().find('tr').each(function(){
            $(this).children('td').each(function(i){
                if(i==index){
                    $(this).addClass('active-col');
                }
            });
        });
    });
});
</script>
<style type="text/css">
body {
    margin: 0;
}
.responsive {
    width: 100%;
}

.table{
    margin-top:20px;
    width: 100%;
    float: left;
}
.conformity-table{
    border-collapse:collapse;
}
.conformity-table tr,
.conformity-table td{
    border-collapse:collapse;
    text-align: center;
}

.conformity-table td {
    padding: 12px 5px;
}

.row-odd{
    background:#e7e7e7;
}
.row-even{
    background:#f7f7f7;
}
.row-odd td{
    background:#e7e7e7;
    border:1px solid #e7e7e7;
}
.row-even td{
    background:#f7f7f7;
    border:1px solid #f7f7f7;
}
.active-col{
    background:#ccc !important;
}

.active-row {
    color: #000 !important;
}

.active-row td{
    background:#ccc!important;
}
.row-odd td:hover,
.row-even td:hover{
    background:#787878 !important;
    color: #fff !important;
}

.clear {
    clear: both;
}

.titleTd {
    background: #787878 !important;
    color: #fff;
}

.window {
    min-height: 300px;
    height: auto;
}
</style>
<link media="all" href="../design/adaptive/css/bootstrap.css?v=1.1" rel="stylesheet" type="text/css" />
<link href="../design/adaptive/css/bootstrap-toggle.css?v=1.1" rel="stylesheet" />

<style media="all" type="text/css" >
    .toggle.ios, .toggle-on.ios, .toggle-off.ios, .btn { -moz-border-radius: 4px; -webkit-border-radius: 4px; -khtml-border-radius: 4px; border-radius: 4px; }
    .toggle.ios .toggle-handle { -moz-border-radius: 4px; -webkit-border-radius: 4px; -khtml-border-radius: 4px; border-radius: 4px; }
</style>
	<div class="window" style="margin-bottom: 60px; float: left;">
		<div class="pwt1">
			<div style="float: left;"><?php if($_COOKIE['language'] === 'eng'){ echo 'Choose your size';} else{echo 'Подбираем размер';}?></div>
			<div style="margin: 3px 24px; float: left;">
                <input <?php echo @$_GET['sex'] == '2' ? '' : 'checked="checked"';?> data-toggle="toggle" data-style="ios" data-on="<?php if($_COOKIE['language'] === 'eng'){ echo 'for Him';} else{echo 'для Него';}?>" data-off="<?php if($_COOKIE['language'] === 'eng'){ echo 'for Her';} else{echo 'для Неё';}?>" type="checkbox" onchange="$('#man_cloth').toggle(); $('#woman_cloth').toggle();" />
            </div>
		</div>
		<div id="man_cloth" <?php echo @$_GET['sex'] == '2' ? 'style="display:none;"' : '';?>>
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s underwear';} else{echo 'Мужское нижнее бельё';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>XXS</td>
                                <td>XS</td>
                                <td>S</td>
                                <td>M</td>
                                <td>L</td>
                                <td>XL</td>
                                <td>XXL</td>
                                <td>XXXL</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                                <td>42</td>
                                <td>44</td>
                                <td>46</td>
                                <td>48</td>
                                <td>50</td>
                                <td>52</td>
                                <td>54</td>
                                <td>56</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy';} else{echo 'Италия';}?> (IT)</td>
                                <td>0</td>
                                <td>1</td>
                                <td>2</td>
                                <td>3</td>
                                <td>4</td>
                                <td>5</td>
                                <td>6</td>
                                <td>7</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></td>
                                <td>70-74</td>
                                <td>74-78</td>
                                <td>78-82</td>
                                <td>82-86</td>
                                <td>86-90</td>
                                <td>90-94</td>
                                <td>94-100</td>
                                <td>100-104</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="clear"></div>
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s socks';} else{echo 'Мужские носки';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoe size';} else{echo 'Размер обуви';}?></td>
                                <td>35</td>
                                <td>36</td>
                                <td>37</td>
                                <td>38</td>
                                <td>39</td>
                                <td>40</td>
                                <td>41</td>
                                <td>42</td>
                                <td>43</td>
                                <td>44</td>
                                <td>45</td>
                                <td>46</td>
                            </tr>
<!--
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Russia';} else{echo 'Россия';}?> (RU)</td>
                                <td>23</td>
                                <td>23</td>
                                <td>23</td>
                                <td>25</td>
                                <td>25</td>
                                <td>25</td>
                                <td>27</td>
                                <td>27</td>
                                <td>27</td>
                                <td>29</td>
                                <td>29</td>
                                <td>29</td>
                                <td>31</td>
                                <td>31</td>
                            </tr>
-->
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                                <td>37/38</td>
                                <td>37/38</td>
                                <td>39/40</td>
                                <td>39/40</td>
                                <td>39/40</td>
                                <td>41/42</td>
                                <td>41/42</td>
                                <td>41/42</td>
                                <td>41/42</td>
                                <td>42/43</td>
                                <td>43/44</td>
                                <td>44/45</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
	
        <div id="woman_cloth" <?php echo @$_GET['sex'] == '2' ? '' : 'style="display:none;"';?>>
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Women`s underwear and swimwear';} else{echo 'Женское нижнее бельё и купальные костюмы';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>XS</td>
                                <td>S</td>
                                <td>M</td>
                                <td>M</td>
                                <td>L</td>
                                <td>L</td>
                                <td>XL</td>
                                <td>XL</td>
                                <td>XXL</td>
                                <td>XXXL</td>
                            </tr>
<!--
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Russia';} else{echo 'Россия';}?> (RU)</td>
                                <td>40</td>
                                <td>42</td>
                                <td>44</td>
                                <td>46</td>
                                <td>48</td>
                                <td>50</td>
                                <td>52</td>
                                <td>54</td>
                                <td>56</td>
                                <td>58</td>
                            </tr>
-->
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                                <td>34</td>
                                <td>36</td>
                                <td>38</td>
                                <td>40</td>
                                <td>42</td>
                                <td>44</td>
                                <td>46</td>
                                <td>48</td>
                                <td>50</td>
                                <td>52</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy';} else{echo 'Италия';}?> (IT)</td>
                                <td>1</td>
                                <td>2</td>
                                <td>3</td>
                                <td>4</td>
                                <td>5</td>
                                <td>6</td>
                                <td>7</td>
                                <td>8</td>
                                <td>9</td>
                                <td>10</td>
                            </tr>                        
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></td>
                                <td>80</td>
                                <td>84</td>
                                <td>88</td>
                                <td>92</td>
                                <td>96</td>
                                <td>100</td>
                                <td>104</td>
                                <td>108</td>
                                <td>112</td>
                                <td>116</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></td>
                                <td>64</td>
                                <td>66</td>
                                <td>70</td>
                                <td>74</td>
                                <td>78</td>
                                <td>82</td>
                                <td>85</td>
                                <td>91</td>
                                <td>95</td>
                                <td>100</td>
                            </tr>
                             <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></td>
                                <td>88</td>
                                <td>92</td>
                                <td>96</td>
                                <td>99</td>
                                <td>102</td>
                                <td>105</td>
                                <td>109</td>
                                <td>112</td>
                                <td>116</td>
                                <td>120</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>