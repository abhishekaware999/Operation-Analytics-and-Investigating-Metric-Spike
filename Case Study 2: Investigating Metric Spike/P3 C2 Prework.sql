use project3;
select * from users;
truncate users;
describe users;
truncate email_events;
describe email_events;
describe users;
truncate users;

-- show variables like 'secure_file_priv';

load data infile "C:/ProgramData/MYSQL2/New folder/Uploads/events.csv"
into table events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from events;
alter table events add column s_occured_at datetime;
update events set s_occured_at = str_to_date(REPLACE(occurred_at, '.', ':'), '%d-%m-%Y %H:%i');
alter table events drop column occurred_at;
alter table events change column s_occured_at occurred_at datetime;

-----
load data infile "C:/ProgramData/MYSQL2/New folder/Uploads/email_events.csv"
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from email_events;
alter table email_events add column s_occured_at datetime;
update email_events set s_occured_at = str_to_date(occurred_at, '%d-%m-%Y %H:%i');
alter table email_events drop column occurred_at;
alter table email_events change column s_occured_at occurred_at datetime;
select * from email_events;
------
load data infile "C:/ProgramData/MYSQL2/New folder/Uploads/users.csv"
into table users
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from users;

set sql_safe_updates = 0;

alter table users add column sample_creted_at datetime;
update users set sample_creted_at = str_to_date(created_at, '%d-%m-%Y %H:%i');
alter table users drop column created_at;
alter table users change column sample_creted_at created_at datetime;
select * from users;

alter table users add column sample_activated_at datetime;
update users set sample_activated_at = str_to_date(activated_at, '%d-%m-%Y %H:%i');
alter table users drop column activated_at;
alter table users change column sample_activated_at activated_at datetime;
select * from users;










