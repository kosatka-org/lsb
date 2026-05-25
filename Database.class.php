<?php


class Database
{
    var $db_name;
    var $host;
    var $user;
    var $pass;
    var $link;
    var $res_id;
    var $error_msg;
    var $queries = array();

    public static $exceptionOnError = false;

    # Constructor
    function Database($database_name, $host_name = "localhost", $user_name = "", $password = "") {
        $this->db_name = $database_name;
        $this->host = $host_name;
        if (getenv('DB_PORT')) {
            $this->host = '127.0.0.1:'.getenv('DB_PORT');
        }
        $this->user = $user_name;
        $this->pass = $password;
        $this->link = $this->res_id = 0;
        $this->error_msg = "";
    }

    /**
     * Connecting to the database
     *
     * @return false|resource|void
     * @throws Exception
     */
    function connect()
    {
        if (!$this->link = mysql_connect($this->host, $this->user, $this->pass))
            throw new Exception("Could not connect to the database on $this->host");

        if (!mysql_select_db($this->db_name, $this->link))
            throw new Exception("Could not select the $this->db_name database");

        return $this->link;
    }

    # Close the database connection
    function disconnect() {
        if(!mysql_close($this->link)) {
            $this->error_msg = "Could not close the $this->db_name database";
            return 0;
        }
        return 1;
    }

    /**
     * Execute the query or queries array
     *
     * @param string $q
     * @return bool|resource
     * @throws Exception
     */
    function query($q)
    {
        if ($this->link) {
            $start = microtime(true);
            $this->res_id = mysql_query($q, $this->link);
            $query = new stdClass;
            $query->exec_time = microtime(true) - $start;
            $query->sql = $q;
            $this->queries[] = $query;
            if ($query->exec_time > 1 && isset($_GET['profiler']))
                echo "<br>{$q}<br>";
        }
        else {
            $error = "Could not execute query to $this->db_name database, wrong database link";
            if (self::$exceptionOnError)
                throw new Exception($error);
            else {
                $this->error_msg = $error;

                return 0;
            }
        }

        if (self::$exceptionOnError) {
            if ($error = mysql_error($this->link))
                throw new Exception($error);
        }

        if (!$this->res_id) {
            $error = "Could not execute query to $this->db_name database, wrong result id";
            if (self::$exceptionOnError)
                throw new Exception($error);
            else {
                $this->error_msg = $error;

                return 0;
            }

        }

        return $this->res_id;
    }

    function get_results( $q = '' ) {
        return $this->results( $q );
    }

    # Returns results array of the query in array of objects
    function results( $q = '' ) {
        if ( !empty($q) ) {
            $this->query($q);
        }
        $result = array();
        if (!$this->res_id) {
            $this->error_msg = "Could not execute query to $this->db_name database, wrong result id";
            return 0;
        }
        while($row = mysql_fetch_object($this->res_id)) {
            array_push($result, $row);
        }
        return $result;
    }


    function get_var( $q = '' ) {
        $res = $this->result( $q );
        if ($res) {
            foreach ( $res as $k=>$v ) {
                return $v;
            }
        }
        return false;
    }

    function get_row( $q = '' ) {
        return $this->result( $q );
    }

    # Returns result of the query in array of objects
    function result( $q = '' ) {
        if ( !empty($q) ) {
            $this->query($q);
        }
        if(!$this->res_id) {
            $this->error_msg = "Could not execute query to $this->db_name database, wrong result id";
            return 0;
        }
        $row = mysql_fetch_object($this->res_id);
        return $row;
    }

    # Returns last inserted id
    function insert_id() {
        return mysql_insert_id($this->link);
    }

    # Returns last inserted id
    function num_rows() {
        return mysql_num_rows($this->res_id);
    }

    # Returns affected rows
    function affected_rows() {
        return mysql_affected_rows($this->link);
    }

    function escape($str = '') {
        return mysql_real_escape_string($str);
    }
}
