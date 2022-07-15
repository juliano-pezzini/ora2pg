-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function gravar_log_medical_device as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE gravar_log_medical_device ( nm_objeto_his_p text, nm_objeto_cdsa_p text, ds_parametros_p text, ds_erro_p text, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL gravar_log_medical_device_atx ( ' || quote_nullable(nm_objeto_his_p) || ',' || quote_nullable(nm_objeto_cdsa_p) || ',' || quote_nullable(ds_parametros_p) || ',' || quote_nullable(ds_erro_p) || ',' || quote_nullable(nm_usuario_p) || ',' || quote_nullable(ie_commit_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE gravar_log_medical_device_atx ( nm_objeto_his_p text, nm_objeto_cdsa_p text, ds_parametros_p text, ds_erro_p text, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE


ds_stack_w        varchar(4000);
BEGIN



ds_stack_w := dbms_utility.format_call_stack;



insert into log_medical_device(
                nr_sequencia,
                nm_objeto_his,
                nm_objeto_cdsa,
                ds_parametros,
                ds_erro,
                nm_usuario,
                dt_atualizacao,
                nm_usuario_nrec,
                dt_atualizacao_nrec,
                ds_stack)
                values (
                nextval('log_medical_device_seq'),
                nm_objeto_his_p,
                nm_objeto_cdsa_p,
                ds_parametros_p,
                ds_erro_p,
                nm_usuario_p,
                clock_timestamp(),
                nm_usuario_p,
                clock_timestamp(),
                ds_stack_w);

if (ie_commit_p = 'S') then
    commit;
end if;

CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_erro_p);


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_medical_device ( nm_objeto_his_p text, nm_objeto_cdsa_p text, ds_parametros_p text, ds_erro_p text, nm_usuario_p text, ie_commit_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE gravar_log_medical_device_atx ( nm_objeto_his_p text, nm_objeto_cdsa_p text, ds_parametros_p text, ds_erro_p text, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;

