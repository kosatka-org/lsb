<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" href="css/style.css" type="text/css" />
	<link rel="stylesheet" href="css/style_s.css" type="text/css" />
    <script type="text/javascript" src="/js/jquery/jquery.min.1.9.1.js"></script>
    <script type="text/javascript" src="/design/adaptive/css/bootstrap-toggle.js"></script>
    <meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi" />
</head>
<title></title>
<body style="width: 690px;">
<script type="text/javascript">
$(document).ready(function(){
    if(String(window.location).indexOf('sex=2')+1){
        $('#man_cloth_mobile').toggle(); 
        $('#woman_cloth_mobile').toggle();
    }
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
    $('.section').click(function(){
        var size = $(this).attr('data');
        $('.'+size+'_details div').stop().slideToggle(500);
        $(this).find('span').toggleClass('inverted');
    })
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
@media (min-width: 771px) {
    #size_table_mobile{
        display: none;
    }
}
@media (max-width: 770px) {
    #man_cloth{
        display: none
    }
    #woman_cloth{
        display: none
    }
    body{
        padding: 20px 0px;
        width: 100vw;
    }
}
.XXS_details, .XS_details, .S_details, .M_details, .L_details, .XL_details, .XXL_details, .X3L_details, .X4L_details, .X5L_details{
    width: 150px
}
#size_table_mobile .titleTd{
    
}
.section td:first-child {
    width: 150px;
    text-align: left;
    background: #e7e7e7;
    text-align: center;
}
#size_table_mobile table{
    text-align: center;
    width: 90vw;
}
.section{
    height: 40px;
    border-bottom: 1px solid rgba(0,0,0,0.4)
}
.hide_this{
    display: none !important
}    
.titleTd_mobile div{
    background: #787878;
    width: 150px;
    max-height: 36px !important;
    padding: 10px 0;
    color: #fff;
    display: none
}
.titleTd_mobile ~ td div{
    display: none;
    
}
.titleTd_mobile ~ td{
    background: #f7f7f7
}
html{
    width: 100vw !important;
    overflow-x: hidden;
}
.section span{
    font-size: 10px;
    float: right;
    opacity: 0.7;
    transition: all 0.5s;
    position: relative;
    top: 5px;
    right: 10px;

}
.inverted{
    -moz-transform: rotate(180deg);
    -ms-transform: rotate(180deg);
    -webkit-transform: rotate(180deg);
    -o-transform: rotate(180deg);
    transform: rotate(180deg);
}
#woman_cloth_mobile{
    display:none;
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
                <input <?php echo @$_GET['sex'] == '2' ? '' : 'checked="checked"';?> data-toggle="toggle" data-style="ios" data-on="<?php if($_COOKIE['language'] === 'eng'){ echo 'for Him';} else{echo 'для Него';}?>" data-off="<?php if($_COOKIE['language'] === 'eng'){ echo 'for Her';} else{echo 'для Неё';}?>" type="checkbox" onchange="if(window.innerWidth > 770){$('#man_cloth').toggle(); $('#woman_cloth').toggle();}else{$('#man_cloth_mobile').toggle(); $('#woman_cloth_mobile').toggle();}" />
            </div>
        </div>
        <div>
            <div id="man_cloth" <?php echo @$_GET['sex'] == '2' ? 'style="display:none;"' : '';?>>
                <div class="table" id="men-clothing">
                    <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s clothing';} else{echo 'Мужская одежда';}?></h2>
                    <div class="conformity-table">
                        <table  cellspacing="0" cellpadding="0" class="responsive">
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
                <div class="clear"></div>
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
                    <?php if($_COOKIE['language'] === 'eng'){ echo '
                        <b>Waist circumference:</b> place the measuring tape exactly in the line of the waist</br>
                        <b>The circumference of the hips:</b> measured at the most prominent points of the buttocks and lateral thighs';} else{echo '
                        <b>Обхват талии:</b> измеряется строго по линии талии </br></br>
                        <b>Обхват бедер:</b> измеряется по наиболее выдающимся точкам ягодиц и боковых частей бедер ';}?>
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
    -->
            </div>
	
            <div id="woman_cloth" <?php echo @$_GET['sex'] == '2' ? '' : 'style="display:none;"';?>>
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
                <div class="clear"></div>
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
    -->
            </div>
        </div>
        <div id="size_table_mobile">
            <div id='man_cloth_mobile'>
                <table class="responsive">
                    <tbody>
                        <tr class="row-odd">
                            <td style="background: #787878; color: #fff; min-width: 150px" class="titleTd_mobile"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?><br/> (INT)</td>
                            <td style="background: #787878; color: #fff"  class="titleTd_mobile"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy';} else{echo 'Италия';}?> (IT)</td>
                            <td style="background: #787878; color: #fff"  class="titleTd_mobile"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                            <td style="background: #787878; color: #fff; padding: 0 10px"  class="titleTd_mobile"><?php if($_COOKIE['language'] === 'eng'){ echo 'Denim';} else{echo 'Деним';}?></td> 
                        </tr>
                        <tr class='XXS_section section' data='XXS'>
                            <!-- it -->
                            <td>XXS<span>&#9660;</span></td>
                            <td><div>40</div</td>
                            <td><div>42</div</td>
                            <td><div>28</div</td>
                            
                        </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"> <div> <?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>84-86</div></td>
                            
                            </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"> <div> <?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>70-74</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>90-93</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>61</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>39</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту<br/> (Обхват шеи), см';}?></div></td>
                                <td colspan="3"><div>37</div></td>
                                
                                
                                
                            </tr>
                        
                        <tr class='XS_section section' data='XS'>
                            <!-- it -->
                            <td>XS<span>&#9660;</span></td>
                            <td><div>42</div></td>
                            <td><div>44</div></td>
                            <td><div>28/29</div></td>
                            
                        </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>86-90</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>74-78</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>93-96</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>61</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>40</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту<br/> (Обхват шеи), см';}?></div></td>
                                <td colspan="3"><div>38</div></td>
                                
                                
                                
                            </tr>
                        <tr class='S_section section' data='S'>
                            <!-- it -->
                            <td>S<span>&#9660;</span></td>
                            <td><div>44</div></td>
                            <td><div>46</div></td>
                            <td><div>29/30</div></td>
                        </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>90-94</div></td>
                                
                                
                                
                            </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>78-82</div></td>
                                
                                
                                
                            </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>96-98</div></td>
                                
                                
                                
                            </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>62</div></td>
                                
                                
                                
                            </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>41</div></td>
                                
                                
                                
                            </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту<br/> (Обхват шеи), см';}?></div></td>
                                <td colspan="3"><div>39</div></td>
                                
                                
                                
                            </tr>
                        <tr class='M_section section' data='M'>
                            <!-- it -->
                            <td>M<span>&#9660;</span></td>
                            <td><div>46</div></td>
                            <td><div>48</div></td>
                            <td><div>31/32</div></td>
                        </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>94-98</div></td>
                                
                                
                                
                            </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>82-86</div></td>
                                
                                
                                
                            </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>98-102</div></td>
                                
                                
                                
                            </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>63</div></td>
                                
                                
                                
                            </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>42</div></td>
                                
                                
                                
                            </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту<br/> (Обхват шеи), см';}?></div></td>
                                <td colspan="3"><div>40</div></td>
                                
                                
                                
                            </tr>
                        <tr class='L_section section' data='L'>
                            <!-- it -->
                            <td>L<span>&#9660;</span></td>
                            <td><div>48</div></td>
                            <td><div>50</div></td>
                            <td><div>33/34</div></td>
                        </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>98-102</div></td>
                                
                                
                                
                            </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>86-90</div></td>
                                
                                
                                
                            </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>102-105</div></td>
                                
                                
                                
                            </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>63</div></td>
                                
                                
                                
                            </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>43</div></td>
                                
                                
                                
                            </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту<br/> (Обхват шеи), см';}?></div></td>
                                <td colspan="3"><div>41</div></td>
                                
                                
                                
                            </tr>
                        <tr class='XL_section section' data='XL'>
                            <!-- it -->
                            <td>XL<span>&#9660;</span></td>
                            <td><div>50</div></td>
                            <td><div>52</div></td>
                            <td><div>35</div></td>
                        </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>102-106</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>90-94</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>105-108</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>64</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>43</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту<br/> (Обхват шеи), см';}?></div></td>
                                <td colspan="3"><div>42</div></td>
                                
                                
                                
                            </tr>
                        <tr class='XXL_section section' data='XXL'>
                            <!-- it -->
                            <td>XXL<span>&#9660;</span></td>
                            <td><div>52</div></td>
                            <td><div>54</div></td>
                            <td><div>36/38</div></td>
                        </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>106-110</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>94-100</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>108-111</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>65</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>44</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту<br/> (Обхват шеи), см';}?></div></td>
                                <td colspan="3"><div>43</div></td>
                                
                                
                                
                            </tr> 
                        <tr class='3XL_section section' data='X3L'>
                            <!-- it -->
                            <td>3XL<span>&#9660;</span></td>
                            <td><div>54</div></td>
                            <td><div>56</div></td>
                            <td><div>38/40</div></td>
                            
                        </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>110-114</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>100-104</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>111-114</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>66</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>44</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту<br/> (Обхват шеи), см';}?></div></td>
                                <td colspan="3"><div>44</div></td>
                                
                                
                                
                            </tr>
                        <tr class='4XL_section section' data='X4L'>
                            <!-- it -->
                            <td>4XL<span>&#9660;</span></td>
                            <td><div>58</div></td>
                            <td><div>60</div></td>
                            <td><div>42</div></td>
                        </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>118-122</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>108-112</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>118-124</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>68</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>46</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту<br/> (Обхват шеи), см';}?></div></td>
                                <td colspan="3"><div>46</div></td>
                                
                                
                                
                            </tr>
                        <tr class='5XL_section section' data='X5L'>
                            <!-- it -->
                            <td>-<span>&#9660;</span></td>
                            <td><div>60</div></td>
                            <td><div>62</div></td>
                            <td><div>44</div></td>
                        </tr>
                            <tr class='X5L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>123-127</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X5L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>112-116</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X5L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>124-130</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X5L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>69</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X5L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>48</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X5L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Collar size (neck Circumference) (cm)';} else{echo 'Размер по вороту<br/> (Обхват шеи), см';}?></div></td>
                                <td colspan="3"><div>47</div></td>
                                
                                
                                
                            </tr>                           
                    </tbody>
                </table>
                <div class="ShAA_sizeImg">
                    <img style='width: 90vw' src="/images/<?php if($_COOKIE['language'] === 'eng'){ echo 'eng_';}?>ls_size_man.png" />
                    <div style='width: 100vw'>
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
                    </div>
                </div>
            </div>
            <div id='woman_cloth_mobile'>
                <table>
                    <tbody>
                        <tr class="row-odd">
                            <td style="background: #787878; color: #fff; min-width: 150px" class="titleTd_mobile"><?php if($_COOKIE['language'] === 'eng'){ echo 'International';} else{echo 'Международный';}?><br/> (INT)</td>
                            <td style="background: #787878; color: #fff"  class="titleTd_mobile"><?php if($_COOKIE['language'] === 'eng'){ echo 'Italy';} else{echo 'Италия';}?> (IT)</td>
                            <td style="background: #787878; color: #fff"  class="titleTd_mobile"><?php if($_COOKIE['language'] === 'eng'){ echo 'Europe';} else{echo 'Европа';}?> (EU)</td>
                            <td style="background: #787878; color: #fff; padding: 0 10px"  class="titleTd_mobile"><?php if($_COOKIE['language'] === 'eng'){ echo 'Denim';} else{echo 'Деним';}?></td> 
                        </tr>
                        <tr class='XXS_section section' data='XXS'>
                            <!-- it -->
                            <td>XXS<span>&#9660;</span></td>
                            <td><div>34</div</td>
                            <td><div>28</div</td>
                            <td><div>24</div</td>
                            
                        </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"> <div> <?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>78-81</div></td>
                                
                            </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"> <div> <?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>60-65</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>88-91</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>54</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>39</div></td>
                                
                                
                                
                            </tr>
                        
                        
                        <tr class='XS_section section' data='XS'>
                            <!-- it -->
                            <td>XS<span>&#9660;</span></td>
                            <td><div>36</div></td>
                            <td><div>40</div></td>
                            <td><div>25</div></td>
                            
                        </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>82-85</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>66-69</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>92-95</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>55</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XS_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>33</div></td>
                                
                                
                                
                            </tr>
                            
                        <tr class='S_section section' data='S'>
                            <!-- it -->
                            <td>S<span>&#9660;</span></td>
                            <td><div>38</div></td>
                            <td><div>42</div></td>
                            <td><div>26/27</div></td>
                        </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>86-89</div></td>
                                
                                
                                
                            </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>70-73</div></td>
                                
                                
                                
                            </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>96-98</div></td>
                                
                                
                                
                            </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>55</div></td>
                                
                                
                                
                            </tr>
                            <tr class='S_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>34</div></td>
                                
                                
                                
                            </tr>
                            
                        <tr class='M_section section' data='M'>
                            <!-- it -->
                            <td>M<span>&#9660;</span></td>
                            <td><div>40</div></td>
                            <td><div>44</div></td>
                            <td><div>28/29</div></td>
                        </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>90-93</div></td>
                                
                                
                                
                            </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>74-77</div></td>
                                
                                
                                
                            </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>99-101</div></td>
                                
                                
                                
                            </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>56</div></td>
                                
                                
                                
                            </tr>
                            <tr class='M_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>35</div></td>
                                
                                
                                
                            </tr>
                            
                        <tr class='L_section section' data='L'>
                            <!-- it -->
                            <td>L<span>&#9660;</span></td>
                            <td><div>42</div></td>
                            <td><div>46</div></td>
                            <td><div>30/31</div></td>
                        </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>94/97</div></td>
                                
                                
                                
                            </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>78-81</div></td>
                                
                                
                                
                            </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>102-104</div></td>
                                
                                
                                
                            </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>56</div></td>
                                
                                
                                
                            </tr>
                            <tr class='L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>36</div></td>
                                
                                
                                
                            </tr>
                        
                        <tr class='XL_section section' data='XL'>
                            <!-- it -->
                            <td>XL<span>&#9660;</span></td>
                            <td><div>44</div></td>
                            <td><div>48</div></td>
                            <td><div>32</div></td>
                        </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>98-102</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>82-85</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>105-108</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>57</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>37</div></td>
                                
                                
                                
                            </tr>
                            
                        <tr class='XXL_section section' data='XXL'>
                            <!-- it -->
                            <td>XXL<span>&#9660;</span></td>
                            <td><div>46</div></td>
                            <td><div>50</div></td>
                            <td><div>33/34</div></td>
                        </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>103-107</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>86-90</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>109-112</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>57</div></td>
                                
                                
                                
                            </tr>
                            <tr class='XXL_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>38</div></td>
                                
                                
                                
                            </tr>
                            
                        <tr class='3XL_section section' data='X3L'>
                            <!-- it -->
                            <td>3XL<span>&#9660;</span></td>
                            <td><div>50</div></td>
                            <td><div>54</div></td>
                            <td><div>36/38</div></td>
                            
                        </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>113-117</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>95-98</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>116-119</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>58</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X3L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>40</div></td>
                                
                                
                                
                            </tr>
                            
                        <tr class='4XL_section section' data='X4L'>
                            <!-- it -->
                            <td>4XL<span>&#9660;</span></td>
                            <td><div>52</div></td>
                            <td><div>56</div></td>
                            <td><div>40</div></td>
                        </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Chest circumference (cm)';} else{echo 'Обхват груди (см)';}?></div></td>
                                <td colspan="3"><div>117-121</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Waist circumference (cm)';} else{echo 'Обхват талии (см)';}?></div></td>
                                <td colspan="3"><div>99-102</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'The circumference of the hips (cm)';} else{echo 'Обхват бедер (см)';}?></div></td>
                                <td colspan="3"><div>120-124</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Sleeve length (cm)';} else{echo 'Длина рукава (см)';}?></div></td>
                                <td colspan="3"><div>59</div></td>
                                
                                
                                
                            </tr>
                            <tr class='X4L_details'>
                                <td class="titleTd_mobile"><div><?php if($_COOKIE['language'] === 'eng'){ echo 'Shoulder width (cm)';} else{echo 'Ширина плеч (см)';}?></div></td>
                                <td colspan="3"><div>41</div></td>
                                
                                
                                
                            </tr>                      
                    </tbody>
                </table>
                <div class="ShAA_sizeImg">
                        <img style='width: 90vw' src="/images/<?php if($_COOKIE['language'] === 'eng'){ echo 'eng_';}?>ls_size_woman.png" />
                        <div style='width: 100vw'>
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
                        </div>
                    </div>
            </div>
        </div>
    </div>
</body>
</html>