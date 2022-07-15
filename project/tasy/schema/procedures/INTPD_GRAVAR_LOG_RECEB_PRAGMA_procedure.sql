-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function intpd_gravar_log_receb_pragma as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE intpd_gravar_log_receb_pragma ( nr_seq_fila_p bigint, ds_log_p text, nm_usuario_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL intpd_gravar_log_receb_pragma_atx ( ' || quote_nullable(nr_seq_fila_p) || ',' || quote_nullable(ds_log_p) || ',' || quote_nullable(nm_usuario_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE intpd_gravar_log_receb_pragma_atx ( nr_seq_fila_p bigint, ds_log_p text, nm_usuario_p text) AS $body$
BEGIN
intpd_gravar_log_recebimento(nr_seq_fila_p, ds_log_p, nm_usuario_p);
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_gravar_log_receb_pragma ( nr_seq_fila_p bigint, ds_log_p text, nm_usuario_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE intpd_gravar_log_receb_pragma_atx ( nr_seq_fila_p bigint, ds_log_p text, nm_usuario_p text) FROM PUBLIC;

