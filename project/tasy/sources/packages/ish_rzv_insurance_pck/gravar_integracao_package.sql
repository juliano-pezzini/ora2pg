-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function ish_rzv_insurance_pck.gravar_integracao() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE ish_rzv_insurance_pck.gravar_integracao ( ie_evento_p text, nr_seq_documento_p text, nm_usuario_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL ish_rzv_insurance_pck.gravar_integracao_atx ( ' || quote_nullable(ie_evento_p) || ',' || quote_nullable(nr_seq_documento_p) || ',' || quote_nullable(nm_usuario_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE ish_rzv_insurance_pck.gravar_integracao_atx ( ie_evento_p text, nr_seq_documento_p text, nm_usuario_p text) AS $body$
DECLARE


reg_integracao_w		gerar_int_padrao.reg_integracao;
BEGIN
reg_integracao_w.ie_operacao	:= 'I';
CALL gerar_int_padrao.set_executando_recebimento('N');
reg_integracao_w := gerar_int_padrao.gravar_integracao(ie_evento_p, nr_seq_documento_p, nm_usuario_p, reg_integracao_w);	
CALL gerar_int_padrao.set_executando_recebimento('S');
commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ish_rzv_insurance_pck.gravar_integracao ( ie_evento_p text, nr_seq_documento_p text, nm_usuario_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE ish_rzv_insurance_pck.gravar_integracao_atx ( ie_evento_p text, nr_seq_documento_p text, nm_usuario_p text) FROM PUBLIC;