<?php

// Check if we get POST data to continue with execution of the validator
if(!empty($_POST['url']) && !empty($_POST['username']) && !empty($_POST['userpass'])){

	// Start session
	session_start();
	
	// Get the session ID (This is important)
	$id = session_id();

	#$cmd = 'cd /mnt/CAMERO/WT/webrobot-suite/tools/dom_audit; sudo ruby dom_audit_parser.rb ' . $id . ' "' . $_POST["url"] . '" ' . $_POST["username"] . ' ' . $_POST["userpass"] ;
	$cmd = 'cd /mnt/CAMERO/WT/webrobot-suite/webtools/dom_audit; pwd; sudo ruby dom_audit_parser.rb ' . $id . ' ' . 'http://10.10.9.129' . ' ' . '3011' . ' ' . '1234 ' ;
	#$cmd = 'cd /mnt/CAMERO/WT/webrobot-suite/tools/dom_audit; pwd; sudo ruby dom_audit_parser.rb';
	#$out = shell_exec($cmd);
	exec($cmd, $results);
	$out = join('<br \>', $results);

	echo "---------PHP RESULTS ----------<br>";
	echo $out;
	// Now we're done so lets give the report to the user. Later dude!
	header( 'Location: /results/' . $id . '_dom_audit.html' );
	// Finally, destroy the session. Although in retrospect, this may never be used once we redirect.
	session_destroy();
}
?>
<html>
<head>
<title>NEO DOM Parse - Find missing static IDs</title>
</head>
<body>
<form action="dom_audit_portal.php" method="post">
DOM Audit script: <br /></br></br>
 URL:</br><textarea name="url" rows="2" cols="20" value='http://10.10.9.129/LocalAdmin/index.php'></textarea><br />
 EG: http://10.10.9.129/LocalAdmin/index.php <br><br>
 User Login:</br><textarea name="username" rows="2" cols="20" value='3011'></textarea><br /><br>
 User Password:</br><textarea name="userpass" rows="2" cols="20" value='1234'></textarea><br />
 
 </br>
<input type="submit" value="AUDIT!">
</br><br>
Press once and be patient, the page will redirect when finished! (Wait is about 1minute)
</body>
</html>