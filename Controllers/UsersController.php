<?php
namespace Controllers;

use Models\Users;
use Models\Mailer;
class UsersController extends Controller
{
    private $users;

    public function __construct() {
        $this->users = new Users();
    }

    public function GetUserById() {
        $input['result'] = $this->users->getUserById($_GET['user-id']);
        if (isset($input['result']) && $input['result'] != null) {
            $input['status'] = "ok";
        } else {
            $input['status'] = "no user with such id";
        }

        return json_encode($input);
    }

    public function GetUsers() {
        $input['result'] = $this->users->getUsers();
        
        return json_encode($var);
    }

    public function CheckUsernameEmailAvailable() {
        $requiredValues = ['email', 'username'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $emailExists = $this->users->getUserByMail($_GET['email']);
        if ($emailExists)
            $existingValues['existing_values'][] = "Email";

        $usernameExists = $this->users->getUserByUsername($_GET['username']);
        if ($usernameExists)
            $existingValues['existing_values'][] = "Username";

        if (isset($existingValues['existing_values']))
            return $this->jsonErrorResponse($existingValues);

        return $this->jsonSuccessResponse("Values are available");
    }

    public function CreateUserMailVerf() {
        // Check if the correct get variables are set (email)
        $requiredValues = ['email'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        /* 
            Checks if there is already made a Verf_code for the mail
            if user requests again, it's likely they forgot after deleting the mail
            so we delete the existing code, and create a new one      
        */
        $hasExistingCode = $this->users->getVerfCodeByMail($_POST['email']);
        if ($hasExistingCode)
            $request = $this->users->deleteVerfCodeByMail($_POST['email']);

        // This generates a 6 digit long code, that could be 000000
        // but since rand wouldn't add the 0, str_pad is used to add remaining 0
        // if the rand number was 320, it would add 3 zeros(0) to make it 6 characters long
        // the STR_PAD_LEFT is simply there to tell str_pad where to insert the character u specified
        // in our case we told it to add them on the left side of the rand value
        $randomNumber = str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);
        $input['result'] = $this->users->createEmailVerf($_POST['email'], $randomNumber);
        if (!$input['result'])
            return $this->jsonErrorResponse("Verification could not be created");

        $mailer = new Mailer();
        $mailerResult = $mailer->sendMail($_POST['email'], "Verification code", $randomNumber);
        if ($mailerResult !== true) {
            $this->users->deleteVerfCodeByMail($_POST['email']);
            return $this->jsonErrorResponse($mailerResult);
        }

        return $this->jsonSuccessResponse("Verification code sent");
    }

    public function VerfMailCode() {
        $requiredValues = ['email', 'verf_code'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $verfCodeExists = $this->users->getVerfCodeByMail($_POST['email']);
        if (!$verfCodeExists)
            return $this->jsonErrorResponse("Email has no verification requests.");

        if ($verfCodeExists['verf_code'] !== $_POST['verf_code'])
            return $this->jsonErrorResponse("Code did not match.");

        $request = $this->users->deleteVerfCodeByMailAndCode($_POST['email'], $_POST['verf_code']);

        return $this->jsonSuccessResponse("Verfication code matched");
    }

    public function CreateUser() {
        $requiredValues = ['username', 'password', 'email', 'birthdate'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        // This just makes sure that there isn't a person in the database with that name or mail
        $mailExists = $this->users->getUserByMail($_POST['email']);
        if ($mailExists)
            return $this->jsonErrorResponse("Email is already in use");

        $usernameExists = $this->users->getUserByUsername($_POST['username']);
        if ($usernameExists) {
            return $this->jsonErrorResponse("Username is already in use");
        }
            
        //hashing the password before submitting it to the database
        $hashedPassword = password_hash($_POST['password'], PASSWORD_BCRYPT);
        
        // It's important to keep in mind the \ (backslash) at DateTime
        // DateTime is a global class in php, so because we set the namespace in the top of the file for routing purposes
        // \ is added to use look for the global class DateTime
        $verifiedDate = \DateTime::createFromFormat('Y-m-d', $_POST['birthdate']);
        
        if ($verifiedDate !== false && !array_sum($verifiedDate::getLastErrors())) {
            // Valid date
        } else {
            return $this->jsonErrorResponse("Birthdate is invalid");
        }
        
        $result = $this->users->createUser($_POST['username'], $hashedPassword, $_POST['email'], $_POST['birthdate']);
        return $this->jsonSuccessResponse("User was created.");
    }

    public function LoginUser() {
        $requiredValues = ['email', 'password'];
        $missingValues = $this->checkRequiredValues($requiredValues);
        if ($missingValues) {
            return $this->jsonErrorResponse($missingValues);
        }

        $input['result'] = $this->users->getUserCredByMail($_POST['email']);
        if ($input['result'] == NULL) {
            $input = ['error'=>'No user with that email.'];
            return json_encode($input);
        }

        //stored hashed password from server
        $hashedPassword = $input['result']['password'];
        // Check if the user password "DOES NOT" match hashed password from database
        if (!password_verify($_POST['password'], $input['result']['password'])) {
            return $this->jsonErrorResponse("Password did not match");
        }

        //In the future this is the JWToken
        $JWToken = "This is a JWToken";
        return $this->jsonSuccessResponse($JWToken);
    }
}