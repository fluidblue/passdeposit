<?php

// Enable compression
ob_start("ob_gzhandler");

// Start session
session_start();

// Set output format
header('content-type: text/html; charset=utf-8');

// Get user name from cookie
$username = isset($_COOKIE['username']) ? $_COOKIE['username'] : '';

?>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>PassDeposit</title>
	<link rel="icon" type="image/x-icon" href="img/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="css/main.css" />
	<link rel="stylesheet" type="text/css" href="css/controls.css" />
	<script type="text/javascript" src="js/sjcl.js"></script>
	<script type="text/javascript" src="js/jquery-1.9.0.min.js"></script>
	<script type="text/javascript" src="js/jquery.cookie.js"></script>
	<script type="text/javascript" src="js/passdeposit.js"></script>
</head>
<body>
	<img src="img/passdeposit.png" alt="PassDeposit" />
	<div id="info">PassDeposit will be available soon. Please come back later.</div>
	<div id="copyright">Copyright &copy; 2013 PassDeposit</div>
</body>
</html>