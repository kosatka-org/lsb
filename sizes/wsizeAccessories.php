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
                  else{echo 'Необходимо измерить окружность ладони в широчайшей её части – у основания четырех пальцев. </br></br>
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
        </div>
        <div id="woman_cloth" <?php echo @$_GET['sex'] == '2' ? '' : 'style="display:none;"';?>>
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
        </div>
    </div>
</body>
</html>