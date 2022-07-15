-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dar_excluir_tables_control (nr_seq_filter_p bigint) AS $body$
DECLARE

	related_data_w bigint;
	datamodel_table_name_w dar_tables_control.nm_tabela%TYPE;

BEGIN
	
	BEGIN
		SELECT	
			COUNT(1)	
		into STRICT	
			related_data_w	
		FROM	
			dar_app_datamodels dad,	
			dar_tables_control dtc	
		WHERE	
			dtc.nr_seq_sql = nr_seq_filter_p	
			AND dad.nr_seq_table_control = dtc.nr_sequencia;
	
		SELECT
			nm_tabela
		INTO STRICT
			datamodel_table_name_w
		FROM dar_tables_control 
		WHERE nr_seq_sql = nr_seq_filter_p;
		
		EXCEPTION
		WHEN no_data_found THEN
        datamodel_table_name_w := NULL;
	END;
	
	IF (related_data_w < 1) THEN
		
		DELETE
		FROM DAR_TAB_CONTROL_FIELDS 
		WHERE NR_SEQ_TABLE_CONTROL = (SELECT NR_SEQUENCIA 
									  FROM DAR_TABLES_CONTROL 
									  WHERE NR_SEQ_SQL = nr_seq_filter_p);
		
		DELETE
		FROM DAR_TABLES_CONTROL 
		WHERE NR_SEQ_SQL = nr_seq_filter_p;
		
		IF (datamodel_table_name_w IS NOT NULL AND datamodel_table_name_w::text <> '') THEN
			EXECUTE 'DROP TABLE ' || datamodel_table_name_w;
		END IF;
		
	END IF;
    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dar_excluir_tables_control (nr_seq_filter_p bigint) FROM PUBLIC;

