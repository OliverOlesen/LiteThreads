<?php
namespace Controllers;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

use Dotenv\Dotenv;
$dotenv = Dotenv::createImmutable(ROOT_DIR);
$dotenv->load();

class Controller
{
    public function __construct()
    {
        if (request()->getMethod() !== 'get') {
            $_SESSION['old'] = input()->all();
        }
    }

    protected function jsonErrorResponse($message) {
        $error['status'] = "failed";
        $error['response'] = $message;
        return json_encode($error);
    }

    protected function jsonSuccessResponse($message){
        $success['status'] = "ok";
        $success['response'] = $message;
        return json_encode($success); 
    }

    /*
        This function takes an array or just 1 field, and makes sure that
        they are set, no matter if it's a $_post or a $_get thanks to $_request.
        It then returns the missing fields as an associative array if there are any.
    */
    protected function checkRequiredValues($requiredValues) {
        $missingValues = [];
        foreach ($requiredValues as $value) {
            if (!isset($_REQUEST[$value])) {
                $missingValues[] .= $value;
            }
        }

        if (empty($missingValues)) {
            return false; // No missing values
        } else {
            $missing['missing_fields'] = $missingValues;
            return $missing;
        }
    }

    /*
        This function takes a string and validates that it's a boolean.
        If it's a bolean yes/true/1 it returns 1 or no/false/0 it returns 0.
        Reason this was nessecary, is because the is_boolean function in php,
        has more ways to validate a boolean than in mysql, so to stop it from breaking
        the database if yes is submitted as a true valuable in the api this function
        was created to change the value to either a 1 or a 0

        If it's not a boolean, it returns a string. *is not a valid boolean*
    */
    protected function validateBoolean($value) {
        $validBoolean = filter_var($value, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
        if ($validBoolean === null) {
            return "is not a valid boolean";
        }
    
        return (int)$validBoolean;
    }

    protected function decodeJwt() {
        /*
            if the jwt hasn't been set, return null.
            this way decodeJwt in the __construct of the different controllers
            will only be filled out when the value is set, otherwise it will be null.

            This is nessecary to make the code cleaner, by getting around doing a lot of repetition
        */
        if ($_SERVER['HTTP_AUTHORIZATION'] == "")
            return null;
        
        $decoded = JWT::decode($_SERVER['HTTP_AUTHORIZATION'], new Key($_ENV["JWT_KEY"], 'HS256'));
        $decodedArray = (array) $decoded;
        return $decodedArray;
    }
}