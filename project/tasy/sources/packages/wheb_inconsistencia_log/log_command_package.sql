-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function wheb_inconsistencia_log.log_command() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE wheb_inconsistencia_log.log_command (command_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL wheb_inconsistencia_log.log_command_atx ( ' || quote_nullable(command_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE wheb_inconsistencia_log.log_command_atx (command_p text) AS $body$
DECLARE

    restrained_command_w varchar(4000);
BEGIN
    BEGIN
      restrained_command_w := trim(both command_p);

      INSERT INTO TASY_LOG_INCONSISTENCIA(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO,
                                           DS_COMANDO, NM_TABELA, NM_OBJETO, NR_SEQ_MOTIVO)
                                   VALUES (nextval('tasy_log_inconsistencia_seq'), clock_timestamp(), WHEB_USUARIO_PCK.GET_NM_USUARIO,
                                           restrained_command_w, current_setting('wheb_inconsistencia_log.current_nm_tabela')::varchar(50), current_setting('wheb_inconsistencia_log.current_nm_objeto')::varchar(50), current_setting('wheb_inconsistencia_log.current_nr_seq_motivo')::bigint);

    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_inconsistencia_log.log_command (command_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE wheb_inconsistencia_log.log_command_atx (command_p text) FROM PUBLIC;