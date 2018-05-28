drop database regweb;
drop schema regweb cascade;
reassign owned by regweb to postgres;
drop owned by regweb;
drop role regweb;
create user regweb with encrypted password 'regweb' nocreateuser;
create database regweb with owner=regweb;
grant all privileges on database regweb to regweb;
grant all privileges on schema public to regweb;