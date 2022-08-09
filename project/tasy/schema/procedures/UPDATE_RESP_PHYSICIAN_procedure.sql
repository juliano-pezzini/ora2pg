-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function update_resp_physician as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE update_resp_physician ( CD_MEDICO_ATENDIMENTO_p text, NR_SEQ_ATEND_PAC_UNIDADE_p bigint) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL update_resp_physician_atx ( ' || quote_nullable(CD_MEDICO_ATENDIMENTO_p) || ',' || quote_nullable(NR_SEQ_ATEND_PAC_UNIDADE_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE update_resp_physician_atx ( CD_MEDICO_ATENDIMENTO_p text, NR_SEQ_ATEND_PAC_UNIDADE_p bigint) AS $body$
BEGIN
update 	ATENDIMENTO_PACIENTE ap
set	ap.CD_MEDICO_RESP = CD_MEDICO_ATENDIMENTO_p
where	ap.NR_ATENDIMENTO = (SELECT   	apu.NR_ATENDIMENTO
				from      	ATEND_PACIENTE_UNIDADE apu
				where     	apu.NR_SEQ_INTERNO = NR_SEQ_ATEND_PAC_UNIDADE_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_resp_physician ( CD_MEDICO_ATENDIMENTO_p text, NR_SEQ_ATEND_PAC_UNIDADE_p bigint) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE update_resp_physician_atx ( CD_MEDICO_ATENDIMENTO_p text, NR_SEQ_ATEND_PAC_UNIDADE_p bigint) FROM PUBLIC;
