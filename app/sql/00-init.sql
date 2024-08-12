create database if not exists app_development;
create database if not exists app_test;
create user     if not exists 'app'@'%' identified by 'secret';
grant all privileges on app_development.* to 'app'@'%';
grant all privileges on app_test.* to 'app'@'%';
