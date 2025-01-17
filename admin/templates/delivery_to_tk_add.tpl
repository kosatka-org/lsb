<div style="border-bottom:1px solid #ccc;">
<h2 class='order_number'>Добавить посылку</h2>
  <form action="index.php?section=Delivery_to_TK&edit=1" method="post">
    <input type="hidden" name="new_delivery" value="1">
    <table>
      <tr>
        <td class="model" style="width:250px;">Цена посылки:</td>
        <td class="m_t"><input type="text" name="del_price" class="input3"></td>
      </tr>
      <tr>
        <td class="model" style="width:250px;">Добавить заказы</td>
        <td class="m_t">
          <div class="orders_group">
            <input type='text' name="orders[]" class="order_id" style="margin: 0 5px 5px 0;"/></div>
            <!--<select name="orders[]" class="order_id" style="margin-right:5px;">
              <option value=""></option>
              {foreach from=$orders item=order}
                <option value="{$order->order_id}">{$order->order_id}</option>
              {/foreach}
            </select>
          </div>-->
        </td>
      </tr>
      <tr>
        <td class="model"><a href='' class='add_order'><img src="./images/add.jpg" align="top" alt=""/> Еще</a></td>
        <td class="m_t"></td>
      </tr>
      <tr>
        <td class="model"><input type="submit" value="Добавить"></td>
        <td class="m_t"></td>
      </tr>
    </table>
  </form>
</div>