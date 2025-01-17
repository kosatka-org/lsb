<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title><?php if($_COOKIE['language'] === 'eng'){ echo 'Luxury Store';} else{echo 'бутик фирменной одежды из Италии и Франции - Лакшери стор';}?></title>
    <meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0" />

	<link rel="stylesheet" href="css/style.css" type="text/css" />
	<link rel="stylesheet" href="css/style_s.css" type="text/css" />
<!--
    <link media="all" href="/design/adaptive/css/style.css?v=1.133" rel="stylesheet" type="text/css" />
-->
	<script type="text/javascript" src="/js/jquery/jquery.min.1.9.1.js"></script>
    <script type="text/javascript" src="/design/adaptive/css/bootstrap-toggle.js"></script>
    <script type="text/javascript" src="js/responsive/responsive-tables.js"></script>
    <link rel="stylesheet" href="js/responsive/responsive-tables.css" />
</head>
<body>
<div class="mainContent" id="main_top">
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
    display: block;
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
    width: 660px;
}

@media (max-width: 770px) {
    .window {
        width: 100%;
    }
    body {
        width: 92%;
        padding: 4%;
    }
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
			<div style="float: left;" class="ShAA_titlePageSizes"><?php if($_COOKIE['language'] === 'eng'){ echo 'Choose your size';} else{echo 'Подбираем размер';}?></div>
			<div style="margin: 3px 24px; float: left;">
                <input <?php echo @$_GET['sex'] == '2' ? '' : 'checked="checked"';?> data-toggle="toggle" data-style="ios" data-on="<?php if($_COOKIE['language'] === 'eng'){ echo 'for Him';} else{echo 'для Него';}?>" data-off="<?php if($_COOKIE['language'] === 'eng'){ echo 'for Her';} else{echo 'для Неё';}?>" type="checkbox" onchange="$('#man_cloth').toggle(); $('#woman_cloth').toggle();" />
            </div>
		</div>
        <div id="man_cloth" <?php echo @$_GET['sex'] == '2' ? 'style="display:none;"' : '';?> class="leftTableSize">
            <div class="table" id="men-shoes">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s shoes';} else{echo 'Мужская обувь';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy';} else{echo 'Италия';}?> (IT)</td>
                                <td>39</td>
                                <td>39.5</td>
                                <td>40</td>
                                <td>40.5</td>
                                <td>41</td>
                                <td>41.5</td>
                                <td>42</td>
                                <td>42.5</td>
                                <td>43</td>
                                <td>43.5</td>
                                <td>44</td>
                                <td>44.5</td>
                                <td>45</td>
                                <td>45.5</td>
                                <td>46</td>
                                <td>46.5</td>
                                <td>47</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                                <td>39</td>
                                <td>39.5</td>
                                <td>40</td>
                                <td>40.5</td>
                                <td>41</td>
                                <td>41.5</td>
                                <td>42</td>
                                <td>42.5</td>
                                <td>43</td>
                                <td>43.5</td>
                                <td>44</td>
                                <td>44.5</td>
                                <td>45</td>
                                <td>45.5</td>
                                <td>46</td>
                                <td>46.5</td>
                                <td>47</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'England';} else{echo 'Англия';}?> (UK)</td>
                                <td>-</td>
                                <td>-</td>
                                <td>5</td>
                                <td>5.5</td>
                                <td>6</td>
                                <td>6.5</td>
                                <td>7</td>
                                <td>7.5</td>
                                <td>8</td>
                                <td>8.5</td>
                                <td>9</td>
                                <td>9.5</td>
                                <td>10</td>
                                <td>10.5</td>
                                <td>11</td>
                                <td>11.5</td>
                                <td>12</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Foot length (cm)';} else{echo 'Длина стопы (см)';}?></td>
                                <td>24</td>
                                <td>24.5</td>
                                <td>25</td>
                                <td>25.5</td>
                                <td>26</td>
                                <td>26.5</td>
                                <td>27</td>
                                <td>27.5</td>
                                <td>28</td>
                                <td>28.5</td>
                                <td>29</td>
                                <td>29.5</td>
                                <td>30</td>
                                <td>31</td>
                                <td>32</td>
                                <td>-</td>
                                <td>-</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="ShAA_sizeImg">
                <img src="/images/<?php if($_COOKIE['language'] === 'eng'){ echo 'eng_';}?>LS_size_foot.png" />
                <span style="margin-top: 24px;">
                      <?php if($_COOKIE['language'] === 'eng'){echo
                        '<b>Foot length: </b> place the foot on a piece of paper and circle it.</br>
                        Then measure the distance between the two extreme points on the toe and heel in millimeters.</br>
                        This measure will allow you to choose the exact size of the shoes.';
                      } else{echo
                        '<b>Длина ступни:</b> поставьте стопу на лист бумаги и обведите ее.</br>
                        Затем измерьте расстояние между двумя крайними точками на носке и пятке в миллиметрах.</br>
                        Эта мерка позволит подобрать точный размер обуви.';
                      }?>
                   </span>
            </div>
            <div class="table" id="men-clothing">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s clothing';} else{echo 'Мужская одежда';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>XXS</td>
                                <td>XS</td>
                                <td>S</td>
                                <td>M</td>
                                <td>L</td>
                                <td>XL</td>
                                <td>XXL</td>
                                <td>3XL</td>
                                <td>3XL</td>
                                <td>4XL</td>
                                <td>-</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy';} else{echo 'Италия';}?> (IT)</td>
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
                                <td>60</td>
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
                                <td>58</td>
                                <td>60</td>
                                <td>62</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Denim';} else{echo 'Деним';}?></td>
                                <td>28</td>
                                <td>28/29</td>
                                <td>29/30</td>
                                <td>31/32</td>
                                <td>33/34</td>
                                <td>35</td>
                                <td>36/38</td>
                                <td>38/40</td>
                                <td>40</td>
                                <td>42</td>
                                <td>44</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></td>
                                <td>84-86</td>
                                <td>86-90</td>
                                <td>90-94</td>
                                <td>94-98</td>
                                <td>98-102</td>
                                <td>102-106</td>
                                <td>106-110</td>
                                <td>110-114</td>
                                <td>114-118</td>
                                <td>118-122</td>
                                <td>123-127</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></td>
                                <td>70-74</td>
                                <td>74-78</td>
                                <td>78-82</td>
                                <td>82-86</td>
                                <td>86-90</td>
                                <td>90-94</td>
                                <td>94-100</td>
                                <td>100-104</td>
                                <td>104-108</td>
                                <td>108-112</td>
                                <td>112-116</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></td>
                                <td>90-93</td>
                                <td>93-96</td>
                                <td>96-98</td>
                                <td>98-102</td>
                                <td>102-105</td>
                                <td>105-108</td>
                                <td>108-111</td>
                                <td>111-114</td>
                                <td>114-118</td>
                                <td>118-124</td>
                                <td>124-130</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></td>
                                <td>61</td>
                                <td>61</td>
                                <td>62</td>
                                <td>63</td>
                                <td>63</td>
                                <td>64</td>
                                <td>65</td>
                                <td>66</td>
                                <td>68</td>
                                <td>68</td>
                                <td>69</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></td>
                                <td>39</td>
                                <td>40</td>
                                <td>41</td>
                                <td>42</td>
                                <td>43</td>
                                <td>43</td>
                                <td>44</td>
                                <td>44</td>
                                <td>45</td>
                                <td>46</td>
                                <td>48</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту (Обхват шеи), см';}?></td>
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
                                <td>47</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="ShAA_sizeImg">
                <img src="/images/<?php if($_COOKIE['language'] === 'eng'){ echo 'eng_';}?>ls_size_man.png" />
                <span>
                <?php if($_COOKIE['language'] === 'eng'){ echo '
                    <b>Chest circumference:</b> body circumference measured at the most prominent points of the back and chest </br>
                    <b>Waist circumference:</b> measured strictly by the waist line </br></br>
                    ADDITIONAL MEASUREMENTS (for men):</br>
                    <b>Sleeve length:</b> measured with a tape at a slightly bent arm - from the shoulder and through the elbow to the wrist</br>
                    <b>Shoulder width:</b> measured from the extreme point of one shoulder joint to the extreme point of the other</br>
                    <b>Length:</b> centimeter band stretches down from the base of the neck';} 
                else{echo '
                    <b>Обхват груди:</b> измеряется обхват тела по наиболее выступающим точкам спины и груди </br>
                    <b>Обхват талии:</b> измеряется строго по линии талии </br></br>
                    ДОПОЛНИТЕЛЬНЫЕ ИЗМЕРЕНИЯ (для мужчин):</br>
                    <b>Длина руки:</b> измеряется лентой при слегка согнутой руке – от плеча и через локоть до запястья</br>
                    <b>Ширина в плечах:</b> измеряется от крайней точки одного плечевого сустава до крайней точки другого</br>
                    <b>Длина изделия:</b> сантиметровая лента протягивается вниз от основания шеи';}?>
                </span>
            </div>
            <div class="clear"></div>
<!--
            <div class="table" id="men-pants">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s jeans and pants';} else{echo 'Мужские джинсы и брюки';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Denim';} else{echo 'Деним';}?></td>
                                <td>28</td>
                                <td>28/29</td>
                                <td>29/30</td>
                                <td>31/32</td>
                                <td>33/34</td>
                                <td>35</td>
                                <td>36/38</td>
                                <td>38/40</td>
                                <td>40</td>
                                <td>42</td>
                                <td>44</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>XXS</td>
                                <td>XS</td>
                                <td>S</td>
                                <td>M</td>
                                <td>L</td>
                                <td>XL</td>
                                <td>XXL</td>
                                <td>3XL</td>
                                <td>3XL</td>
                                <td>4XL</td>
                                <td>-</td>
                            </tr>

                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></td>
                                <td>70-74</td>
                                <td>74-78</td>
                                <td>78-82</td>
                                <td>82-96</td>
                                <td>86-90</td>
                                <td>90-94</td>
                                <td>94-100</td>
                                <td>100-104</td>
                                <td>104-108</td>
                                <td>108-112</td>
                                <td>112-116</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></td>
                                <td>90-93</td>
                                <td>93-96</td>
                                <td>96-98</td>
                                <td>98-102</td>
                                <td>102-105</td>
                                <td>105-108</td>
                                <td>108-111</td>
                                <td>111-114</td>
                                <td>114-118</td>
                                <td>118-124</td>
                                <td>124-130</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="ShAA_sizeImg">
                <img src="/images/<?php if($_COOKIE['language'] === 'eng'){ echo 'eng_';}?>ls_size_man_down.png" />
                <span>
                    <?php if($_COOKIE['language'] === 'eng'){ echo 'Jeans and pants have a separate dimensional grid. Measuring the circumference of the thighs will help you to determine your size of the jeans.</br>
                    <b>The circumference of the hips:</b> measured at the most prominent points of the buttocks and lateral thighs</br>
                    <b>Waist circumference:</b> place the measuring tape exactly in the line of the waist';} 
                    else{echo 'Джинсы и брюки имеют отдельную размерную сетку. Определить размер джинсов поможет измерение обхвата бедер.</br>
                    <b>Обхват бедер:</b> измеряется по наиболее выдающимся точкам ягодиц и боковых частей бедер</br>
                    <b>Обхват талии:</b> расположите сантиметровую ленту строго по линии талии';}?>
                </span>
            </div>
            <div class="clear"></div>
            
            <div class="table" id="men-shirts">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s shirts ';} else{echo 'Мужские рубашки (сорочки)';}?></h2>
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
                                <td>3XL</td>
                                <td>3XL</td>
                                <td>4XL</td>
                                <td>-</td>
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
                                <td>58</td>
                                <td>60</td>
                                <td>62</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></td>
                                <td>84-86</td>
                                <td>86-90</td>
                                <td>90-94</td>
                                <td>94-98</td>
                                <td>98-102</td>
                                <td>102-106</td>
                                <td>106-110</td>
                                <td>110-114</td>
                                <td>114-118</td>
                                <td>118-122</td>
                                <td>123-127</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></td>
                                <td>61</td>
                                <td>61</td>
                                <td>62</td>
                                <td>63</td>
                                <td>63</td>
                                <td>64</td>
                                <td>65</td>
                                <td>66</td>
                                <td>68</td>
                                <td>68</td>
                                <td>69</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту (Обхват шеи), см';}?></td>
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
                                <td>47</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="clear"></div>
-->
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s belts';} else{echo 'Мужские ремни';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>XXS</td>
                                <td>XS</td>
                                <td>S</td>
                                <td>M</td>
                                <td>L</td>
                                <td>XL</td>
                                <td>XXL</td>
                                <td>XXXL</td>
                                <td>XXXXL</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                                <td>60-65</td>
                                <td>70-75</td>
                                <td>80-85</td>
                                <td>90-95</td>
                                <td>100</td>
                                <td>105</td>
                                <td>110</td>
                                <td>115</td>
                                <td>120</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></td>
                                <td>58-67</td>
                                <td>66-79</td>
                                <td>76-89</td>
                                <td>86-99</td>
                                <td>96-104</td>
                                <td>101-109</td>
                                <td>107-115</td>
                                <td>113-123</td>
                                <td>121-129</td>
                            </tr>
<!--
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Belt length (cm)';} else{echo 'Длина ремня (см)';}?></td>
                                <td>80-85</td>
                                <td>85-90</td>
                                <td>90-95</td>
                                <td>95-100</td>
                                <td>110</td>
                                <td>115</td>
                                <td>120</td>
                                <td>125</td>
                                <td>130</td>
                            </tr>
-->
                        </tbody>
                    </table>
                </div>
            </div>
<!--
            <div class="ShAA_sizeImg">
                <img src="/images/<?php if($_COOKIE['language'] === 'eng'){ echo 'eng_';}?>LS_size_belt.png" />
                <span style="margin-top: 36px;">
                  <?php if($_COOKIE['language'] === 'eng'){ echo 'The length of the belt is measured from the buckle to the center hole.';}
                  else{echo 'Длина ремня измеряется от пряжки до центрального отверстия.';}?>
                </span>
            </div>
-->
            <div class="clear"></div>
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s gloves';} else{echo 'Мужские перчатки';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>XXS</td>
                                <td>XS</td>
                                <td>S</td>
                                <td>S</td>
                                <td>M</td>
                                <td>M</td>
                                <td>L</td>
                                <td>L</td>
                                <td>XL</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe/Italy (EU/IT), inches';} else{echo 'Европа/Италия (EU/IT), дюймы';}?></td>
                                <td>6</td>
                                <td>6,5</td>
                                <td>7</td>
                                <td>7,5</td>
                                <td>8</td>
                                <td>8.5</td>
                                <td>9</td>
                                <td>9.5</td>
                                <td>10</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Palm girth (cm)';} else{echo 'Обхват ладони (см)';}?></td>
                                <td>17.5</td>
                                <td>18</td>
                                <td>19</td>
                                <td>20.5</td>
                                <td>22</td>
                                <td>23.5</td>
                                <td>25</td>
                                <td>26</td>
                                <td>27</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="ShAA_sizeImg">
                <img src="/images/LS_size_hand.png" />
                <span style="margin-top: 40px;">
                    <?php if($_COOKIE['language'] === 'eng'){ echo 'It is necessary to measure the circumference of the palm in its widest part – at the base of four fingers. </br></br>
                      It is important to know how to choose the right size gloves. Gloves should not squeeze the hand, preventing the normal circulation, but too wide gloves will fall down.';}
                    else{echo 
                      'Необходимо измерить окружность ладони в широчайшей её части – у основания четырех пальцев. </br></br>
                      Важно знать, как подобрать размер перчаток правильно. Перчатки не должны сдавливать руку, препятствуя нормальному кровообращению, широкие перчатки же будут спадать.';}?>
                </span>
            </div>
            <div class="clear"></div>
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s hats';} else{echo 'Мужские головные уборы';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>54</td>
                                <td>55</td>
                                <td>56</td>
                                <td>57</td>
                                <td>58</td>
                                <td>59</td>
                                <td>60</td>
                            </tr>
<!--
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Russia';} else{echo 'Россия';}?> (RU)</td>
                                <td>54</td>
                                <td>55</td>
                                <td>56</td>
                                <td>57</td>
                                <td>58</td>
                                <td>59</td>
                                <td>60</td>
                            </tr>
-->
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                                <td>54</td>
                                <td>55</td>
                                <td>56</td>
                                <td>57</td>
                                <td>58</td>
                                <td>59</td>
                                <td>60</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy';} else{echo 'Италия';}?> (IT)</td>
                                <td>54</td>
                                <td>55</td>
                                <td>56</td>
                                <td>57</td>
                                <td>58</td>
                                <td>59</td>
                                <td>60</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of your head (cm)';} else{echo 'Обхват головы, см';}?></td>
                                <td>54</td>
                                <td>55</td>
                                <td>56</td>
                                <td>57</td>
                                <td>58</td>
                                <td>59</td>
                                <td>60</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="ShAA_sizeImg">
                <img src="/images/ls_size_head.png" />
                <span style="margin-top: 40px;">
                  <?php if($_COOKIE['language'] === 'eng'){ echo 'For the most accurate determination of the head size you need to wrap the measuring tape at a distance of 1.5-2.5 cm above the eyebrows, just above the ears and through the point at the back, which will give you the greatest circumference.';}
                  else{echo 'Для максимально точного определения размера головы нужно обернуть сантиметровую ленту на расстоянии 1,5-2,5 сантиметра выше бровей, чуть выше ушей и провести через ту точку на затылке, которая даст вам наибольшую длину окружности.';}?>
                </span>
            </div>
            <div class="clear"></div>
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s socks';} else{echo 'Мужские носки';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoe size (EU)';} else{echo 'Размер обуви (EU)';}?></td>
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
            <div class="clear"></div>
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s underwear';} else{echo 'Мужское нижнее бельё';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
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
                            <tr class="row-even">
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
                            <tr class="row-odd">
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
                            <tr class="row-even">
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
        </div>
	
        <div id="woman_cloth" <?php echo @$_GET['sex'] == '2' ? '' : 'style="display:none;"';?>>
            <div class="table ShAA_sizesLeftTable" id="women-shoes">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Women`s shoes';} else{echo 'Женская обувь';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy';} else{echo 'Италия';}?> (IT)</td>
                                <td>36.5</td>
                                <td>37</td>
                                <td>37.5</td>
                                <td>38</td>
                                <td>38.5</td>
                                <td>39</td>
                                <td>39.5</td>
                                <td>40</td>
                                <td>41</td>
                                <td>41.5</td>
                                <td>42</td>
                                <td>42.5</td>
                                <td>43</td>
                                <td>43</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                                <td>36.5</td>
                                <td>37</td>
                                <td>37.5</td>
                                <td>38</td>
                                <td>38.5</td>
                                <td>39</td>
                                <td>39.5</td>
                                <td>40</td>
                                <td>41</td>
                                <td>41.5</td>
                                <td>42</td>
                                <td>42.5</td>
                                <td>43</td>
                                <td>43</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'England';} else{echo 'Англия';}?> (UK)</td>
                                <td>5.5</td>
                                <td>6</td>
                                <td>6.5</td>
                                <td>7</td>
                                <td>7.5</td>
                                <td>8</td>
                                <td>8.5</td>
                                <td>9</td>
                                <td>9.5</td>
                                <td>10</td>
                                <td>10.5</td>
                                <td>11</td>
                                <td>11.5</td>
                                <td>12</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Foot length (cm)';} else{echo 'Длина стопы (см)';}?></td>
                                <td>22</td>
                                <td>22.5</td>
                                <td>23</td>
                                <td>23.5</td>
                                <td>24</td>
                                <td>24.5</td>
                                <td>25</td>
                                <td>25.5</td>
                                <td>26</td>
                                <td>26.5</td>
                                <td>27</td>
                                <td>27.5</td>
                                <td>28</td>
                                <td>28.5</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="ShAA_sizeImg">
                <img src="/images/<?php if($_COOKIE['language'] === 'eng'){ echo 'eng_';}?>LS_size_foot.png" />
                <span style="margin-top: 24px;">
                      <?php if($_COOKIE['language'] === 'eng'){echo
                        '<b>Foot length: </b> place the foot on a piece of paper and circle it.</br>
                        Then measure the distance between the two extreme points on the toe and heel in millimeters.</br>
                        This measure will allow you to choose the exact size of the shoes.';
                      } else{echo
                        '<b>Длина ступни:</b> поставьте стопу на лист бумаги и обведите ее.</br>
                        Затем измерьте расстояние между двумя крайними точками на носке и пятке в миллиметрах.</br>
                        Эта мерка позволит подобрать точный размер обуви.';
                      }?>
                   </span>
            </div>
            <div class="clear"></div>
            <div class="table" id="women-clothing">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Women`s clothing';} else{echo 'Женская одежда';}?></h2>
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
                                <td>XXL</td>
                                <td>3XL</td>
                                <td>4XL</td>
                            </tr>
<!--
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Russia';} else{echo 'Россия';}?> (RU)</td>
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
                                <td>38</td>
                                <td>40</td>
                                <td>42</td>
                                <td>44</td>
                                <td>46</td>
                                <td>48</td>
                                <td>50</td>
                                <td>52</td>
                                <td>54</td>
                                <td>56</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Denim';} else{echo 'Деним';}?></td>
                                <td>24</td>
                                <td>25</td>
                                <td>26/27</td>
                                <td>28/29</td>
                                <td>30/31</td>
                                <td>32</td>
                                <td>33/34</td>
                                <td>35</td>
                                <td>36/38</td>
                                <td>40</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></td>
                                <td>78-81</td>
                                <td>82-85</td>
                                <td>86-89</td>
                                <td>90-93</td>
                                <td>94-97</td>
                                <td>98-102</td>
                                <td>103-107</td>
                                <td>108-112</td>
                                <td>113-117</td>
                                <td>117-121</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></td>
                                <td>60-65</td>
                                <td>66-69</td>
                                <td>70-73</td>
                                <td>74-77</td>
                                <td>78-81</td>
                                <td>82-85</td>
                                <td>86-90</td>
                                <td>91-95</td>
                                <td>95-98</td>
                                <td>99-102</td>
                            </tr>
                             <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></td>
                                <td>88-91</td>
                                <td>92-95</td>
                                <td>96-98</td>
                                <td>99-101</td>
                                <td>102-104</td>
                                <td>105-108</td>
                                <td>109-112</td>
                                <td>113-116</td>
                                <td>116-119</td>
                                <td>120-124</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></td>
                                <td>54</td>
                                <td>55</td>
                                <td>55</td>
                                <td>56</td>
                                <td>56</td>
                                <td>57</td>
                                <td>57</td>
                                <td>58</td>
                                <td>58</td>
                                <td>59</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></td>
                                <td>32</td>
                                <td>33</td>
                                <td>34</td>
                                <td>35</td>
                                <td>36</td>
                                <td>37</td>
                                <td>38</td>
                                <td>39</td>
                                <td>40</td>
                                <td>41</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="ShAA_sizeImg">
                <img src="/images/<?php if($_COOKIE['language'] === 'eng'){ echo 'eng_';}?>ls_size_woman.png" />
                <span>
                <?php if($_COOKIE['language'] === 'eng'){ echo '<b>Chest circumference:</b> position the centimeter band at the most prominent points of the chest and shoulder blades</br>
                    <b>Waist circumference:</b> place the measuring tape exactly in the line of the waist</br>
                    <b>The circumference of the hips:</b> measured at the most prominent points of the buttocks and lateral thighs';}
                else{echo '
                    <b>Обхват груди:</b> расположите сантиметровую ленту по наиболее выступающим точкам груди и лопаток </br>
                    <b>Обхват талии:</b> расположите сантиметровую ленту строго по линии талии</br>
                    <b>Обхват бедер:</b> измеряется по наиболее выдающимся точкам ягодиц и боковых частей бедер';}?>
                </span>
            </div>
            <div class="clear"></div>
<!--
            <div class="table" id="women-pants">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Women`s jeans and pants';} else{echo 'Женские джинсы и брюки';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Denim';} else{echo 'Деним';}?></td>
                                <td>25</td>
                                <td>26/27</td>
                                <td>28/29</td>
                                <td>30/31</td>
                                <td>32</td>
                                <td>33/34</td>
                                <td>35</td>
                                <td>36/38</td>
                                <td>40</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>XS</td>
                                <td>S</td>
                                <td>M</td>
                                <td>L</td>
                                <td>XL</td>
                                <td>XXL</td>
                                <td>XXL</td>
                                <td>3XL</td>
                                <td>4XL</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy';} else{echo 'Италия';}?> (IT)</td>
                                <td>40</td>
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
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></td>
                                <td>66-69</td>
                                <td>70-73</td>
                                <td>74-77</td>
                                <td>78-81</td>
                                <td>82-85</td>
                                <td>86-90</td>
                                <td>91-95</td>
                                <td>96-98</td>
                                <td>99-102</td>
                            </tr>
                             <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></td>
                                <td>92-95</td>
                                <td>96-98</td>
                                <td>99-101</td>
                                <td>102-104</td>
                                <td>105-108</td>
                                <td>109-112</td>
                                <td>113-116</td>
                                <td>116-119</td>
                                <td>120-124</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="ShAA_sizeImg">
                <img src="/images/<?php if($_COOKIE['language'] === 'eng'){ echo 'eng_';}?>ls_size_woman_down.png" />
                <span>
                    <?php if($_COOKIE['language'] === 'eng'){ echo 'Jeans and pants have a separate dimensional grid. Measuring the circumference of the thighs will help you to determine your size of the jeans.</br>
                    <b>The circumference of the hips:</b> measured at the most prominent points of the buttocks and lateral thighs</br>
                    <b>Waist circumference:</b> place the measuring tape exactly in the line of the waist';} 
                    else{echo 'Джинсы и брюки имеют отдельную размерную сетку. Определить размер джинсов поможет измерение обхвата бедер.</br>
                    <b>Обхват бедер:</b> измеряется по наиболее выдающимся точкам ягодиц и боковых частей бедер</br>
                    <b>Обхват талии:</b> расположите сантиметровую ленту строго по линии талии';}?>
                </span>
            </div>
            <div class="clear"></div>
-->
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Women`s belts';} else{echo 'Женские ремни';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>XXS</td>
                                <td>XS</td>
                                <td>S</td>
                                <td>M</td>
                                <td>L</td>
                                <td>XL</td>
                                <td>XXL</td>
                                <td>XXXL</td>
                                <td>XXXXL</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                                <td>60-65</td>
                                <td>70-75</td>
                                <td>80-85</td>
                                <td>90-95</td>
                                <td>100</td>
                                <td>105</td>
                                <td>110</td>
                                <td>115</td>
                                <td>120</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></td>
                                <td>58-67</td>
                                <td>66-79</td>
                                <td>76-89</td>
                                <td>86-99</td>
                                <td>96-104</td>
                                <td>101-109</td>
                                <td>107-115</td>
                                <td>113-123</td>
                                <td>121-129</td>
                            </tr>
<!--
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Belt length (cm)';} else{echo 'Длина ремня (см)';}?></td>
                                <td>80-85</td>
                                <td>85-90</td>
                                <td>90-95</td>
                                <td>95-100</td>
                                <td>110</td>
                                <td>115</td>
                                <td>120</td>
                                <td>125</td>
                                <td>130</td>
                            </tr>
-->
                        </tbody>
                    </table>
                </div>
            </div>
<!--
            <div class="ShAA_sizeImg">
                <img src="/images/<?php if($_COOKIE['language'] === 'eng'){ echo 'eng_';}?>LS_size_belt.png" />
                <span style="margin-top: 36px;">
                  <?php if($_COOKIE['language'] === 'eng'){ echo 'The length of the belt is measured from the buckle to the center hole.';}
                  else{echo 'Длина ремня измеряется от пряжки до центрального отверстия.';}?>
                </span>
            </div>
-->
            <div class="clear"></div>
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Women`s gloves';} else{echo 'Женские перчатки';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>S</td>
                                <td>S</td>
                                <td>M</td>
                                <td>M</td>
                                <td>L</td>
                                <td>L</td>
                                <td>XL</td>
                                <td>XL</td>
                                <td>XXL</td>
                                <td>XXL</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy (IT), inches';} else{echo 'Италия (IT), дюймы';}?></td>
                                <td>5.5</td>
                                <td>6</td>
                                <td>6.5</td>
                                <td>7</td>
                                <td>7.5</td>
                                <td>8</td>
                                <td>8.5</td>
                                <td>9</td>
                                <td>9.5</td>
                                <td>10</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe (EU), inches';} else{echo 'Европа (EU), дюймы';}?></td>
                                <td>5.5</td>
                                <td>6</td>
                                <td>6.5</td>
                                <td>7</td>
                                <td>7.5</td>
                                <td>8</td>
                                <td>8.5</td>
                                <td>9</td>
                                <td>9.5</td>
                                <td>10</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Palm girth (cm)';} else{echo 'Обхват ладони (см)';}?></td>
                                <td>16.5</td>
                                <td>17.5</td>
                                <td>18</td>
                                <td>19</td>
                                <td>20.5</td>
                                <td>22</td>
                                <td>23.5</td>
                                <td>25</td>
                                <td>26</td>
                                <td>27</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="ShAA_sizeImg">
                <img src="/images/LS_size_hand.png" />
                <span style="margin-top: 40px;">
                    <?php if($_COOKIE['language'] === 'eng'){ echo 'It is necessary to measure the circumference of the palm in its widest part – at the base of four fingers. </br></br>
                      It is important to know how to choose the right size gloves. Gloves should not squeeze the hand, preventing the normal circulation, but too wide gloves will fall down.';}
                    else{echo 
                      'Необходимо измерить окружность ладони в широчайшей её части – у основания четырех пальцев. </br></br>
                      Важно знать, как подобрать размер перчаток правильно. Перчатки не должны сдавливать руку, препятствуя нормальному кровообращению, широкие перчатки же будут спадать.';}?>
                </span>
            </div>
            <div class="clear"></div>
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Woman`s hats';} else{echo 'Женские головные уборы';}?></h2>
                <div class="conformity-table">
                    <table class="responsive">
                        <tbody>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?> (INT)</td>
                                <td>54</td>
                                <td>55</td>
                                <td>56</td>
                                <td>57</td>
                                <td>58</td>
                                <td>59</td>
                                <td>60</td>
                            </tr>
<!--
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Russia';} else{echo 'Россия';}?> (RU)</td>
                                <td>54</td>
                                <td>55</td>
                                <td>56</td>
                                <td>57</td>
                                <td>58</td>
                                <td>59</td>
                                <td>60</td>
                            </tr>
-->
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                                <td>54</td>
                                <td>55</td>
                                <td>56</td>
                                <td>57</td>
                                <td>58</td>
                                <td>59</td>
                                <td>60</td>
                            </tr>
                            <tr class="row-even">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy';} else{echo 'Италия';}?> (EU)</td>
                                <td>54</td>
                                <td>55</td>
                                <td>56</td>
                                <td>57</td>
                                <td>58</td>
                                <td>59</td>
                                <td>60</td>
                            </tr>
                            <tr class="row-odd">
                                <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of your head (cm)';} else{echo 'Обхват головы, см';}?></td>
                                <td>54</td>
                                <td>55</td>
                                <td>56</td>
                                <td>57</td>
                                <td>58</td>
                                <td>59</td>
                                <td>60</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="ShAA_sizeImg">
                <img src="/images/ls_size_head.png" />
                <span style="margin-top: 40px;">
                  <?php if($_COOKIE['language'] === 'eng'){ echo 'For the most accurate determination of the head size you need to wrap the measuring tape at a distance of 1.5-2.5 cm above the eyebrows, just above the ears and through the point at the back, which will give you the greatest circumference.';}
                  else{echo 'Для максимально точного определения размера головы нужно обернуть сантиметровую ленту на расстоянии 1,5-2,5 сантиметра выше бровей, чуть выше ушей и провести через ту точку на затылке, которая даст вам наибольшую длину окружности.';}?>
                </span>
            </div>
            <div class="clear"></div>
            <div class="table">
                <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Women`s underwear and swimwear';} else{echo 'Женские купальные костюмы';}?></h2>
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
</div>
</body>
</html>