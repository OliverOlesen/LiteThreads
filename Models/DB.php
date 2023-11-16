<?php
namespace Models;

use Dotenv\Dotenv;
$dotenv = Dotenv::createImmutable(ROOT_DIR);
$dotenv->load();

use PDO;

class DB {

    protected static function connect() {
        // dsn = data source name = What type of database we are going to be using, what dbHost and dbName.
        $dsn = 'mysql:host=' . $_ENV["DB_HOST"] . ';dbname=' . $_ENV["DB_NAME"];
        // new pdo connection. a base php class for a secure database connection
        $pdo = new PDO($dsn, $_ENV["DB_USER"], $_ENV["DB_PASS"]);

        //default way that we want to pull data from the database
        //fetch mode here is set to be associative arrays when fetching from database
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        return $pdo;
    }

    protected static function selectAll(string $query, array $params = []) {
        $stmt = self::connect()->prepare($query);
        $stmt->execute($params);

        return $stmt->fetchAll();
    }

    protected static function selectFirst(string $query, array $params = []) {
        $stmt = self::connect()->prepare($query);
        $stmt->execute($params);

        return $stmt->fetch();
    }

    protected static function nonSelect(string $query, array $params = [])
    {
        $stmt = self::connect()->prepare($query);
        return $stmt->execute($params);
    }

    protected static function insert(string $query, array $params = []){
        return self::nonSelect($query, $params);
    }

    public static function update(string $query, array $params = [])
    {
        return self::nonSelect($query, $params);
    }

    public static function delete(string $query, array $params = [])
    {
        return self::nonSelect($query, $params);
    }
}