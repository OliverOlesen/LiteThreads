<?php
namespace Middleware;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Firebase\JWT\ExpiredException;
use Firebase\JWT\BeforeValidException;
use Firebase\JWT\SignatureInvalidException;

use Dotenv\Dotenv;
$dotenv = Dotenv::createImmutable(ROOT_DIR);
$dotenv->load();

use Pecee\Http\Middleware\IMiddleware;
use Pecee\Http\Request;

class Authenticated implements IMiddleware
{
    public function handle(Request $request): void
    {
        /*
            IF Rene has time to change it in the app, to where the jwt response is in the header of the request
            it needs be changed to $_SERVER['HTTP_AUTHORIZATION'] instead of get
            since it's more secure, (value wont be logged, and much more)
        */
        if (!isset($_SERVER['HTTP_AUTHORIZATION'])) {
            echo json_encode(['status' => 'failed', 'response' => 'no jwt']);
            die;
        }
        
        $jwt = $_SERVER['HTTP_AUTHORIZATION'];
        
        try {
                // This is to make sure that there it's no more than X seconds since the request was made,
                // if more time than this has passed, it will fail.
                JWT::$leeway = 30; // $leeway in seconds
                $decoded = JWT::decode($jwt, new Key($_ENV["JWT_KEY"], 'HS256'));
                $decodedArray = (array) $decoded;
                /*
                    The following section is to make sure the same token is not in circulation for too long.
                    Since a new token is generated every time a user logs in, it should not become a problem,
                    but for future use, if it needs to be possible to have a user stay logged in,
                    there has been set an experation date, which when exceeded,
                    forces the user to login again, or they can't make requests to in this case,
                    any routes which make use of the Authenticated middleware.
                */
                $jwtIsExpired = $decodedArray['jwt_expiration'];
                $currentDateTime = date("Y-m-d H:i:s");
                if ($currentDateTime > $jwtIsExpired) {
                    echo json_encode(['status' => 'failed', 'response' => 'JWToken has expired']);
                    die;
                }

            } catch (ExpiredException $e) {
                // Token is expired. Handle accordingly.
                http_response_code(401);
                echo json_encode(['status' => 'failed', 'response' => 'Token expired']);
                die;
            } catch (BeforeValidException $e) {
                // Token is not yet valid. Handle accordingly.
                http_response_code(401);
                echo json_encode(['status' => 'failed', 'response' => 'Token not yet valid']);
                die;
            } catch (SignatureInvalidException $e) {
                // Token signature is invalid, indicating possible tampering.
                http_response_code(401);
                echo json_encode(['status' => 'failed', 'response' => 'Invalid token signature']);
                die;
            } catch (\Throwable $e) {
                // Catch any Throwable, including DomainException for malformed UTF-8 characters.
                http_response_code(400);
                echo json_encode(['status' => 'failed', 'response' => 'Malformed or invalid JWT']);
                die;
            } catch (\Exception $e) {
                /*
                    Catch any Exception, including DomainException for malformed UTF-8 characters.
                    This is a last case scenario, so if there is some unforseen error with the jwToken
                    the following will be sent back as a response to the end-user.
                */
                http_response_code(400);
                echo json_encode(['status' => 'failed', 'response' => 'Malformed or invalid JWT']);
                die;
            }
    }
}