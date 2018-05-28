drop database seycon;
drop schema seycon cascade;
reassign owned by seycon to postgres;
drop owned by seycon;
drop role seycon;
create user seycon with encrypted password 'seycon' nocreateuser;
create database seycon with owner=seycon;
grant all privileges on database seycon to seycon;
grant all privileges on schema public to seycon;
