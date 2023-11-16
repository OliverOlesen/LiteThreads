<?php
namespace Models;

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

use Dotenv\Dotenv;
$dotenv = Dotenv::createImmutable(ROOT_DIR);
$dotenv->load();

use Models\DB;

class Mailer extends DB {
    protected static function setup() {
        $mail = new PHPMailer(true);
        //Server settings
        $mail->SMTPDebug = 1;                                       //Enable verbose debug output
        $mail->isSMTP();                                            //Send using SMTP
        $mail->Host       = 'in-v3.mailjet.com';                    //Set the SMTP server to send through
        $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
        $mail->SMTPSecure ='TLS';                                   //Enable implicit TLS encryption
        $mail->Username   = $_ENV["MAILJET_UNAME"];                 //SMTP username
        $mail->Password   = $_ENV["MAILJET_PWRD"];                  //SMTP password
        $mail->Port       = 25;                                     //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`
    
        //Recipients
        $mail->setFrom('oiol.skp@edu.mercantec.dk', 'Oliver Olesen');
        return $mail;
    }

    function sendMail($recipient, $subject, $body) {
        $mail = self::setup();
        try {
            $mail->addAddress($recipient, 'name(Not needed works without name)');     //Add a recipient
    
            /*  -- Optional settings
                $mail->addAddress('ellen@example.com');               Name is optional
                $mail->addReplyTo('info@example.com', 'Information');
                $mail->addCC('cc@example.com');
                $mail->addBCC('bcc@example.com');
            
                -- Attachments
                $mail->addAttachment('/var/tmp/file.tar.gz');         Add attachments
                $mail->addAttachment('/tmp/image.jpg', 'new.jpg');    Optional name
            */
        
            //Content
            $mail->isHTML(true);                                  //Set email format to HTML
            $mail->Subject = $subject;
            $mail->Body    = $body;
            $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
        
            $mail->send();
            echo 'helo';
            die;
            return 'Message has been sent';
        } catch (Exception $e) {
            return "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
        }
    }
}

