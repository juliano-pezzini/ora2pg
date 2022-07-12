-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function gerar_int_padrao.setnrprontuario() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE gerar_int_padrao.setnrprontuario ( nr_seq_documento_p text, reg_integracao_p INOUT reg_integracao) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'SELECT * FROM gerar_int_padrao.setnrprontuario_atx ( ' || quote_nullable(nr_seq_documento_p) || ',' || quote_nullable(reg_integracao_p) || ' )';
	SELECT v_ret INTO reg_integracao_p FROM dblink(v_conn_str, v_query) AS p (v_ret reg_integracao);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE gerar_int_padrao.setnrprontuario_atx ( nr_seq_documento_p text, reg_integracao_p INOUT reg_integracao) AS $body$
BEGIN

select	coalesce(max(nr_prontuario), reg_integracao_p.nr_prontuario)
into STRICT	reg_integracao_p.nr_prontuario
from	pessoa_fisica
where	cd_pessoa_fisica = nr_seq_documento_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_padrao.setnrprontuario ( nr_seq_documento_p text, reg_integracao_p INOUT reg_integracao) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE gerar_int_padrao.setnrprontuario_atx ( nr_seq_documento_p text, reg_integracao_p INOUT reg_integracao) FROM PUBLIC;