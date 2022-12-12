-- SUPERUSER CODE
CREATE USER dpassport WITH PASSWORD 'Th5642RThey';
CREATE DATABASE dpassport OWNER dpassport;
GRANT ALL PRIVILEGES ON DATABASE dpassport TO dpassport;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO dpassport;
CREATE EXTENSION pgcrypto;

pg_restore -h localhost -U dpassport -d dpassport -v "home/andrey/!/dpassport.bkp"
