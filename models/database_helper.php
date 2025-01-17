<?php

class database_helper
{
    protected $table           = '';
    protected $id_name         = '';
    protected $where           = '';
    protected $db              = '';
    public    $data            = false;


    protected function _get_table_name($table, $add_prefix = false) {
        if ( !empty($table) ) {
            return $table;
        }
        return false;
    }
    

    public function database_helper( $table = '', $add_prefix = true )
    {   
        if (!$table) {
            $table = $this->table;
        } 
        $this->table   = $this->_get_table_name( $table, $add_prefix );
        $this->id_name = 'id';
        
        global $database_object;
        $this->db = $database_object;
    }



    /**
     * Return a value of field for current row
     * @param string $field
     */
    public function __get($field)
    {
        return $this->get($field);
    }


    /**
     * Return a value of field for current row
     * @param string $field
     */
    public function get($field, $default = NULL)
    {
        return isset($this->data->$field) ? $this->data->$field : $default;
    }



    /**
     * Return a value of field for current row
     * @param string $field
     */
    public function set($field, $value = '', $overwrite = true)
    {
        if (is_array($field) && count($field)>0) {
            foreach ($field as $k=>$v) {
                $this->set($k, $v, $overwrite);
            }
        } else {
            if (isset($this->data->$field) && !$overwrite) {
                return false;
            }
            $this->data->$field = $value;
        }
        return true;
    }



    /**
     * $database_helper->load_data($where_sql)
     *
     * Load all values for single row into $this->data
     */
    public function load_data($id)
    {
        $id = $this->validationId( $id );
        if ( empty($id) ) {
            return $this->data = false;
        }
        return $this->data = $this->db->get_row("SELECT * FROM {$this->table} WHERE {$this->id_name} = '{$id}'");
    }



    public function load_by($params = array())
    {
        $where = array();
        if ( isset($params['equally']) && is_array($params['equally']) && count($params['equally']) ) {
            foreach ($params['equally'] as $k=>$v) {
                $where[] = ' ' . $this->db->escape($k) . " = '" . $this->db->escape($v) . "' ";
            }
        }
        if ( isset($params['like']) && is_array($params['like']) && count($params['like']) ) {
            foreach ($params['like'] as $k=>$v) {
                $where[] = ' ' . $this->db->escape($k) . " LIKE '%" . $this->db->escape($v) . "%' ";
            }
        }
        $where = implode(' AND ', $where);
        if ( empty($where) ) return false;
        return $this->data = $this->db->get_row("SELECT * FROM {$this->table} WHERE {$where}");
    }



    public function validationId( $id = 0 )
    {
        return (int)$id;
    }



    /**
     * Delete from database
     * @param array $parms
     */
     public function delete( $id = 0 )
     {
         $id = $this->validationId( $id );
         if ( $id == 0 ) {
             return false;
         }
         $this->db->query("DELETE FROM $this->table WHERE {$this->id_name} = '{$id}'");
         return true;
     }



    /**
     * Return string in Set format
     */
    public function getSetString( $params = array() )
    {
        $set = '';
        if ( is_array($params) && count($params) ) {
            foreach ( $params as $key=>$value) {
                $value = $this->db->escape($value);
                $key   = $this->db->escape($key);
                $set .= ($set == '') ? '' : ',' ;
                $set .= "`$key` = '$value'";
            }
        }
        return $set;
    }



    /**
     * Interface for upsert function
     * Works as insert - if new, else update
     * @param array $params
     */
    public function upsert($params)
    {
        return true;
    }



    /**
     * Insert an entry into the database
     * @param array $parms
     * @param boolean $process_done
     * @return object|false a database object with rows of objects
     */
    public function insert($params)
    {
        $set = $this->getSetString( $params );
        if ( $set == '' ) {
            return false;
        }

        $this->db->query($sql = "INSERT INTO {$this->table} SET {$set}");

        return $this->db->insert_id() ? $this->db->insert_id() : 0;
    }



    /**
     * Update an entry in the database
     * If entry can't be found, insert it instead
     * @return array of columns in table row
     */
    public function update( $params, $id = 0 )
    {
        $id  = $this->validationId( $id ? $id : $this->get('id') );
        $set = $this->getSetString( $params );
        
        if ( $set == '' || $id == 0 ) {
                return false;
        }
        $sql = "UPDATE {$this->table} SET {$set} WHERE {$this->id_name} = '{$id}'";

        $this->db->query($sql);
        $this->load_data($id);
        return true;
    }



    /**
     *Get WHERE part of SQL query for queries
     */
    public function parse_filter($filter = array(), &$join = '', &$join_select = '')
    {
        // compulsory part of query
        $where_filter = (!empty($this->where)) ? "{$this->table}.{$this->where}" : ' 1 ';
        return $where_filter;
    }


    protected function _order_by( $order_by, &$join, &$join_select = '' ) {
        return " ORDER BY " . $this->db->escape($order_by);
    }
    

    /**
     * Select from database
     * @return array of columns in table row
     */
    public function select(&$count = 0, $filter = array())
    {
        $join_select = $join = $limit = '';

        $where = ' WHERE '.$this->parse_filter(isset($filter['filter']) ? $filter['filter'] : array(), $join, $join_select);

        if ( !empty($filter['limit']) ) {
            $filter['limit'] = (int)$filter['limit'];
            $filter['start'] = (int)@$filter['start'];
            $limit = " LIMIT " . ($filter['start'] ? "{$filter['start']}," : '') . " {$filter['limit']} ";
        }

        $order = !empty($filter['order']) ? $this->_order_by($filter['order'], $join, $join_select) : '';

        $from = "  FROM {$this->table}
                   {$join}  ";

        $group_by = !empty($filter['group_by']) ? " GROUP BY {$this->table}.id " : '';

        $sql = "SELECT SQL_CALC_FOUND_ROWS  {$this->table}.*" . ($join_select ? $join_select : '') . "
                $from $where
                $group_by $order $limit ";

        $list = $this->db->get_results($sql);
        $count = (int)$this->db->get_var("SELECT FOUND_ROWS();");

        $res = array();
        if (is_array($list) && count($list)) {
            foreach ($list as $k=>$v) {
                $res[$v->id] = $this->_get_instance((int)$v->id, $v);
            }
        }
        return $res;
    }


    protected function _get_instance($id, $data = NULL) {
        $class = get_class($this);
        return new $class($id, $data);
    }
}