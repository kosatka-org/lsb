<?php
if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
  class Job {
    public function push($j, $a, $t=false, $q=false) {
      return 0;
    }
  }
}
else {
  class Job {
    public static $redis;
    private static $client;

    public static function push($job, $args, $time=false, $queue='default') {
      if(!isset(self::$redis))
        self::$redis = new Predis\Client('tcp://127.0.0.1:6379/0');
      if(!isset(self::$client))
        self::$client = new \SidekiqJob\Client(self::$redis, 'resque');
      if ($time) {
        self::$client->schedule($time, $job, [$args], true, $queue);
      }
      else {
        self::$client->push($job, [$args], true, $queue);
      }
    }
  }
}
