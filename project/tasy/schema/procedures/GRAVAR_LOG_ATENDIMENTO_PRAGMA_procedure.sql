-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function gravar_log_atendimento_pragma as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE gravar_log_atendimento_pragma ( cd_log_p bigint, nr_atendimento_p bigint, ds_log_p text, nm_usuario_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL gravar_log_atendimento_pragma_atx ( ' || quote_nullable(cd_log_p) || ',' || quote_nullable(nr_atendimento_p) || ',' || quote_nullable(ds_log_p) || ',' || quote_nullable(nm_usuario_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE gravar_log_atendimento_pragma_atx ( cd_log_p bigint, nr_atendimento_p bigint, ds_log_p text, nm_usuario_p text) AS $body$
BEGIN

if (cd_log_p IS NOT NULL AND cd_log_p::text <> '') and (ds_log_p IS NOT NULL AND ds_log_p::text <> '') then

	insert into log_atendimento(
				dt_atualizacao,
				nm_usuario,
				cd_log,
				nr_atendimento,
				ds_log)
			values (clock_timestamp(),
				nm_usuario_p,
				cd_log_p,
				nr_atendimento_p,
				ds_log_p);
	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_atendimento_pragma ( cd_log_p bigint, nr_atendimento_p bigint, ds_log_p text, nm_usuario_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE gravar_log_atendimento_pragma_atx ( cd_log_p bigint, nr_atendimento_p bigint, ds_log_p text, nm_usuario_p text) FROM PUBLIC;

