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
            <div class="leftTableSize">
                <div class="table" id="men-shoes">
                    <h2><?php if($_COOKIE['language'] === 'eng'){ echo 'Men`s shoes';} else{echo 'Мужская обувь';}?></h2>
                    <div class="conformity-table">
                        <table class="responsive">
                            <tbody>
<!--
                                <tr class="row-odd">
                                    <td class="titleTd"><?php if($_COOKIE['language'] === 'eng'){ echo 'Russia';} else{echo 'Россия';}?> (RU)</td>
                                    <td>38</td>
                                    <td>38.5</td>
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
                                </tr>
-->
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
                    <span style="margin-top: 42px;">
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
                      'Определить точный размер поможет измерение длины ступни в миллиметрах.</br>
                      Для измерения длины ступни поставьте ногу на чистый лист бумаги и отметьте две крайние точки на носке и на пятке.</br>
                      После этого просто замерьте расстояние между ними.';
                    }?>
                </span>
            </div>
        </div>
    </div>
</body>
</html>