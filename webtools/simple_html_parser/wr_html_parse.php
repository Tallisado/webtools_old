<?php include 'dev/simple_html_dom.php'; ?>
<?
$html = file_get_html('http://10.10.9.129');

echo $html
// Find all images 
// foreach($html->find('img') as $element) 
       // echo $element->src . '<br>';

// // Find all links 
// foreach($html->find('a') as $element) 
       // echo $element->href . '<br>';
	   
?>