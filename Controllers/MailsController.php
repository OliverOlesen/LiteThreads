<?php
namespace Controllers;

use Models\Mailer;
class MailsController extends Controller
{
    private $mailer;

    public function __construct() {
        $this->mailer = new Mailer();
    }

    public function SendMail() {
        $result = $this->mailer->sendMail("oliverolesen404@gmail.com","med","dig");

    }
}