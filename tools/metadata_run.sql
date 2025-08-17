select oradev23.ddl('table', 'MODEL_DETAILS', 'CARS');
--
select dbms_metadata.get_ddl('TABLE','MODEL_DETAILS','CARS') from dual;