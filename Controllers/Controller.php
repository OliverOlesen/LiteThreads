<?php

namespace Controllers;

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
}