<?php
require('vendor/autoload.php');

$config['displayErrorDetails'] = true;
$config['addContentLengthHeader'] = false;
$config['db']['host'] = "localhost";
$config['db']['user'] = "root";
$config['db']['pass'] = "toor";
$config['db']['dbname'] = "ufmg_msi_rcc";

$app = new \Slim\App(['settings'=>$config]);
$container = $app->getContainer();

$container['db'] = function($self) {
	$db = $self['settings']['db'];
	$pdo = new PDO("mysql:host=$db[host];dbname=$db[dbname]",$db['user'],$db['pass']);

	$pdo->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
	$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE,PDO::FETCH_ASSOC);
	return $pdo;
};

$app->get('/',function($req, $res, $args=[]) {
	return $res->withRedirect('home.html');
});
$app->post('/db',function($req, $res, $args=[]) {
	$query = $req->getParam('query');
	$requestDB = $this->db->prepare($query);

	$requestDB->execute();
	return $res->withJson(json_encode($requestDB->fetchAll()));
});

$app->run();
?>
