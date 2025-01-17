<?php

class myListener extends PHPUnit_Util_Printer implements PHPUnit_Framework_TestListener {
    protected $currentTestName = "";
    protected $currentTestPass = TRUE;
    public function addError(PHPUnit_Framework_Test $test, Exception $e, $time) {
        //$this->currentTestName = PHPUnit_Util_Test::describe($test);
        //$this->writeCase('error',$time,$e->getMessage());
        //$this->currentTestPass = FALSE;
    }
    public function addFailure(PHPUnit_Framework_Test $test, PHPUnit_Framework_AssertionFailedError $e, $time) {
        $this->currentTestName = PHPUnit_Util_Test::describe($test);
        $this->writeCase('fail',$time,$e->getMessage());
        $this->currentTestPass = FALSE;
    }
    public function addIncompleteTest(PHPUnit_Framework_Test $test, Exception $e, $time) {
        $this->currentTestName = PHPUnit_Util_Test::describe($test);
        $this->writeCase('error', $time, array(), 'Incomplete Test');
        $this->currentTestPass = FALSE;
    }
    public function addSkippedTest(PHPUnit_Framework_Test $test, Exception $e, $time) {
        $this->currentTestName = PHPUnit_Util_Test::describe($test);
        $this->writeCase('error', $time, array(), 'Skipped Test');
        $this->currentTestPass = FALSE;
    }
    public function endTest(PHPUnit_Framework_Test $test, $time){}
    public function startTestSuite(PHPUnit_Framework_TestSuite $suite){}
    public function endTestSuite(PHPUnit_Framework_TestSuite $suite){}
    public function startTest(PHPUnit_Framework_Test $test){}
    public function addRiskyTest(PHPUnit_Framework_Test $test, Exception $e, $time){}
    
    protected function writeCase($status, $time, $message = '') { 
        $m = "Test: " . $this->currentTestName . " - Status: " . $status . " - Time: " . $time . ($message ? " - Message: " . $message: "") . "
        ";
        $args = array( 'user' => 'ls_admin', 'message' => $m, 'channel' => "test_errors" );
        Job::push('SlackJob', $args);
    }
}
?>