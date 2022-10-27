#!/bin/sh

## Start MariaDB server
service mysql start

## Configure test database
mysql -e "CREATE DATABASE IF NOT EXISTS test; ALTER DATABASE test CHARACTER SET 'utf8'; FLUSH PRIVILEGES;"
mysql -e "CREATE USER '$USER'@'localhost' IDENTIFIED BY ''; GRANT ALL PRIVILEGES ON *.* TO '$USER'@'localhost'; FLUSH PRIVILEGES;"
mysql -D mysql < tools/tz.sql
mysql -e "SET GLOBAL time_zone = 'Europe/Zurich';"
