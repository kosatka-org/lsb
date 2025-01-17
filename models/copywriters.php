<?php

class copywriters extends Widget {

    public function get_copywriters($filter = array()) {
        $filter_ids = "";
        if (isset($filter['id'])) {
            $filter_ids = sql_placeholder(" AND c.user_id IN (?@) ", (array)$filter['id']);
        }
        return $this->db->results( sql_placeholder("SELECT c.*, u.name FROM copywriters c INNER JOIN users u ON u.original_user_id = c.user_id WHERE 1 $filter_ids GROUP BY u.original_user_id") );
    }



    public function get_copywriter($id){
        if(empty($id)) return false;
        return $this->db->result( sql_placeholder("SELECT c.*, u.name FROM copywriters c INNER JOIN users u ON u.original_user_id = c.user_id WHERE c.user_id =? GROUP BY u.original_user_id", (int)$id) );
    }



    protected function _filter_copywriter_tasks($filter = array()) {
        $where = '1';
        if (isset($filter['copywriter_id'])) {
            $where .= sql_placeholder(" AND t.copywriter_id IN (?@) ", (array)$filter['copywriter_id']);
        }
        if (!empty($filter['status'])) {
            $where .= sql_placeholder(" AND t.`status` =? ", $filter['status']);
        }
        if (!empty($filter['date_check'])) {
            $where .= sql_placeholder(" AND t.data_check >=? AND t.data_check <=? ", $filter['date_check'].' 00:00:00', $filter['date_check'].' 23:59:59');
        }
        if (!empty($filter['date_start'])) {
            $where .= sql_placeholder(" AND t.date_write >=? ", $filter['date_start'].' 00:00:00');
        }
        if (!empty($filter['date_finish'])) {
            $where .= sql_placeholder(" AND t.date_write <=? ", $filter['date_finish'].' 23:59:59');
        }
        if (!empty($filter['doc_type'])) {
            $where .= sql_placeholder(" AND t.doc_type =? ", $filter['doc_type']);
        }
        if (!empty($filter['doc_id'])) {
            $where .= sql_placeholder(" AND t.doc_id =? ", $filter['doc_id']);
        }
        if (!empty($filter['field'])) {
            $where .= sql_placeholder(" AND t.`field` =? ", $filter['field']);
        }
        return $where;
    }



    public function get_copywriter_tasks($filter = array(), $only_one_task = false) {
        $where = $this->_filter_copywriter_tasks($filter);
        $limit = isset($filter['limit']) ? "LIMIT " . ((int)$filter['limit']) : '';

        $query = sql_placeholder($sql = "
            SELECT t.*, u.name as copywriter_name, u2.name as moderator_name, IF(doc_type='product', IFNULL(large_image, ''), '') as prod_pic
              FROM copywriters_tasks t
              LEFT JOIN users u ON t.copywriter_id = u.original_user_id
              LEFT JOIN users u2 ON t.moderator_id = u2.original_user_id
              LEFT JOIN products p ON doc_id = p.product_id
            WHERE {$where}
            GROUP BY t.id
            ORDER BY prod_pic DESC, t.priority DESC, t.id DESC
            {$limit}
        ");
        //echo $sql;
        if ( $only_one_task ) {
            return $this->db->result($query);
        }
        return $this->db->results($query);
    }



    public function count_copywriter_tasks ($filter = array()) {
        $copywriter_id = $status = $date_start = $date_finish = "";

        $where = $this->_filter_copywriter_tasks($filter);

        $res = $this->db->result( sql_placeholder("SELECT COUNT(t.id) as count FROM copywriters_tasks t WHERE {$where}") );
        return (int)$res->count;
    }



    public function get_copywriter_task($id){
        if(empty($id)) return false;
        return $this->db->result(sql_placeholder('SELECT t.*, u.name as copywriter_name FROM copywriters_tasks t LEFT JOIN users u ON t.copywriter_id = u.original_user_id WHERE t.id=? LIMIT 1', (int)$id));
    }



    public function get_copywriter_task_form( $doc_type, $show_items_list = true, $get_all_data = false) {
        if (empty($doc_type)) return false;
        $query = NULL;

        switch ($doc_type) {
            case 'product':
                $query  = sql_placeholder("
                    SELECT product_id as id, model as name" . ($get_all_data ? ', products.*' : '') . " FROM products
                    WHERE body = '' OR description = '' OR text_sizes = '' ORDER BY model");
                $fields = array('body' => 'Детали', 'description' => 'Заметка редактора', 'text_sizes' => 'Состав', 'uhod' => 'Уход');
            break;
            case 'category':
                $query  = sql_placeholder("
                    SELECT category_id as id, name" . ($get_all_data ? ', categories.*' : '') . " FROM categories
                    WHERE mens_description = '' OR description = '' OR womens_description = '' ORDER BY name");
                $fields = array('description' => 'Описание', 'mens_description' => 'Мужское описание', 'womens_description' => 'Женское описание');
            break;
            case 'city':
                $query  = sql_placeholder("SELECT id, name" . ($get_all_data ? ', cities.*' : '') . " FROM cities WHERE text = '' OR text2 = '' ORDER BY name");
                $fields = array('text' => 'Описание', 'text2' => 'Транспортные компании и адреса');
            break;
            case 'special':
                $query  = sql_placeholder("SELECT special_id as id, name" . ($get_all_data ? ', specials.*' : '') . " FROM specials WHERE seo_words = '' ORDER BY name");
                $fields = array('seo_words' => 'Описание');
            break;
            case 'brand':
                $query  = sql_placeholder("
                    SELECT brand_id as id, name" . ($get_all_data ? ', brands.*' : '') . " FROM brands
                    WHERE description = '' OR description_m = '' OR description_w = '' OR
                        text2 = '' OR text2_1 = '' OR text2_2 = '' OR
                        text1 = '' OR text1_1 = '' OR text1_2 = '' OR
                        text4 = '' OR text4_1 = '' OR text4_2 = '' OR
                        text38 = '' OR text38_1 = '' OR text38_2 = ''
                    ORDER BY name");
                $fields = array(
                    'description' => 'Описание', 'description_m' => 'Описание Мужское', 'description_w' => 'Описание Женское',
                    'text38'      => 'Рыбный текст: Сумки По умолчанию', 'text38_1' => 'Рыбный текст: Сумки Мужские', 'text38_2' => 'Рыбный текст: Сумки Женские',
                    'text2'       => 'Рыбный текст: Обувь По умолчанию', 'text2_1'  => 'Рыбный текст: Обувь Мужская', 'text2_2'  => 'Рыбный текст: Обувь Женская',
                    'text1'       => 'Рыбный текст: Одежда По умолчанию', 'text1_1' => 'Рыбный текст: Одежда Мужская', 'text1_2'  => 'Рыбный текст: Одежда Женская',
                    'text4'       => 'Рыбный текст: Аксессуары По умолчанию', 'text4_1' => 'Рыбный текст: Аксессуары Мужские', 'text4_2'  => 'Рыбный текст: Аксессуары Женские',
                );
            break;
            case 'brand-category':
                $query  = sql_placeholder("SELECT id, title as name" . ($get_all_data ? ', goods.*' : '') . " FROM goods WHERE text = '' ORDER BY title");
                $fields = array('text' => 'Описание');
            break;
            default: return false; break;
        }

        if (empty($query)) return false;

        if ( $show_items_list ) {
            $res['docs']    = $this->db->results($query);
        }
        $res['fields']  = $fields;
        return $res;
    }



    public function add_copywriter_task($data) {
        $data = (array)$data;
        if (empty($data['doc_type'])) return false;

        $query = sql_placeholder('INSERT INTO copywriters_tasks SET ?%', $data);

        return $this->db->query($query) ? $this->db->insert_id() : false;
    }



    public function update_copywriter_task($id, $data){
        if(empty($id)) return false;
        if(empty($data)) return $id;

        $query = sql_placeholder('UPDATE copywriters_tasks SET ?% WHERE id in(?@)', (array)$data, (array)$id);

        return $this->db->query($query) ? $id : false;
    }



    function delete_copywriter_task($id){

        if(empty($id)) return false;
        $query = sql_placeholder('DELETE FROM copywriters_tasks WHERE id in(?@) LIMIT ?', (array)$id, count($id));
        return $this->db->query($query) ? true : false;
    }
}