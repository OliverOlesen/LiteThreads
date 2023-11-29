USE LiteThreads;
-- Trigger for users table
DELIMITER //

CREATE TRIGGER users_before_update
BEFORE UPDATE ON users
FOR EACH ROW
SET NEW.latest_update = CURRENT_DATE;

//

DELIMITER ;