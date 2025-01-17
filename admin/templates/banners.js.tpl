{literal}
<script>
  popover_content = function(el) {
    var id = $(this).attr('bannerid');
    return "<button style='margin-right:12px;' type='button' data-bannerid='"+id+"' class='btn btn-danger btn-sm delete-button'>Да<\/button><button style='float: right;' type='button' class='btn btn-default btn-sm'>Нет<\/button>";
  }
  $(function () {
    $('[data-toggle="popover"]').popover({
      placement: 'top',
      trigger: 'focus',
      title: "Удалить баннер?",
      content: popover_content
    });
    $(document).on('inserted.bs.popover', function() {
      $(".delete-button").on("click", function(e){
        e.preventDefault();
        var banner_id = $(this).data('bannerid');
        window.location = "/admin/index.php?section=Banners&delete="+banner_id;
      });
    });
  });
  
  function show_tip(el) {
  var t = el.val();
    if(t.length > 15){
      el.parent().prev().show();
    }
    else{el.parent().prev().hide();}
  }
  $(document).on('blur','.form-control[name="title"]', function() {
    show_tip($(this))
  });
  $('.form-control[name="title"]').each(function(){show_tip($(this));});
</script>
{/literal}