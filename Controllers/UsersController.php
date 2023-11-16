<?php
namespace Controllers;

use Models\Users;
class UsersController extends Controller
{
    private $users;

    public function __construct() {
        $this->users = new Users();
    }

    public function GetUser() {
        $var['result'] = $this->users->getUser($_POST['user-id']);
        if (isset($var['result']) && $var['result'] != null) {
            $var['status'] = "ok";
        } else {
            $var['status'] = "no user with such id";
        }
        return json_encode($var);
    }

    public function GetUsers() {
        $var = $this->users->getUsers();
        var_dump($var);

        echo '<br><br><br>'.$var[3]['username'];
        die;
    }
}