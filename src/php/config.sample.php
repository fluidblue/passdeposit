<?php
/**
 * config.sample.php
 * This file contains the sample configuration.
 * 
 * WARNING: YOU SHOULD NOT CHANGE config.sample.php. ONLY CHANGE config.php.
 * 
 * If config.php is not present, use one of the following methods:
 * - Preferred: Use the automatic installer (browse to https://yourdomain.com/path/to/passdeposit)
 * - Alternative: Copy config.sample.php to config.php and edit the created file.
 * 
 * @author Max Geissler
 */

$config['sql_server'] = 'localhost';
$config['sql_user']   = 'passdeposit';
$config['sql_pass']   = '';
$config['sql_db']     = 'passdeposit';

// Be warned: Don't try to change the version,
// because doing so can really mess things up.
$config['version'] = '0.1.0';

?>
