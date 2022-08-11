create or replace view nls_database_parameters (value, parameter) as 
select character_set_name as value, 'NLS_CHARACTERSET' as parameter
FROM information_schema.character_sets ;
