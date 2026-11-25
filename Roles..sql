
USE soundmetrics;

CREATE ROLE IF NOT EXISTS 'role_admin';
CREATE ROLE IF NOT EXISTS 'role_user';
CREATE ROLE IF NOT EXISTS 'role_analyst';

GRANT ALL PRIVILEGES ON soundmetrics.* TO 'role_admin';

GRANT SELECT, INSERT, UPDATE, DELETE
ON soundmetrics.* TO 'role_user';

GRANT SELECT
ON soundmetrics.* TO 'role_analyst';

GRANT EXECUTE ON soundmetrics.* TO 'role_user';
GRANT EXECUTE ON soundmetrics.* TO 'role_analyst';

GRANT 'role_admin'@'%' TO 'admin_test'@'localhost';
GRANT 'role_user'@'%' TO 'user_test'@'localhost';
GRANT 'role_analyst'@'%' TO 'analyst_test'@'localhost';

SET DEFAULT ROLE 'role_admin' TO 'admin_test'@'localhost';
SET DEFAULT ROLE 'role_user' TO 'user_test'@'localhost';
SET DEFAULT ROLE 'role_analyst' TO 'analyst_test'@'localhost';

SHOW GRANTS FOR 'admin_test'@'localhost';
SHOW GRANTS FOR 'user_test'@'localhost';
SHOW GRANTS FOR 'analyst_test'@'localhost';
