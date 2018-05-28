drop database portafib;
drop schema portafib cascade;
reassign owned by portafib to postgres;
drop owned by portafib;
drop role portafib;
create user portafib with encrypted password 'portafib' nocreateuser;
create database portafib with owner=portafib;
grant all privileges on database portafib to portafib;
grant all privileges on schema public to portafib;