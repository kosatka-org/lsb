<?PHP

require_once('Brands.admin.php');
require_once('PagesNavigation.admin.php');

class Colors extends Brands
{
  var $error_msg;
  var $table    = 'colors';
  var $table_id = 'color_id';
  var $_title   = 'Цвета';
  var $_section = 'Color';
  
  function Colors(&$parent)
  {
    Widget::Widget($parent);
    $this->add_param('page');
    $this->prepare();
  }
}

