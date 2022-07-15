-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function gerar_banco_caixa_hist as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE gerar_banco_caixa_hist ( nr_seq_conta_banco_p bigint, nr_seq_caixa_p bigint, ds_historico_p text, nm_usuario_p text, ie_rollback_p text, ie_commit_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL gerar_banco_caixa_hist_atx ( ' || quote_nullable(nr_seq_conta_banco_p) || ',' || quote_nullable(nr_seq_caixa_p) || ',' || quote_nullable(ds_historico_p) || ',' || quote_nullable(nm_usuario_p) || ',' || quote_nullable(ie_rollback_p) || ',' || quote_nullable(ie_commit_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE gerar_banco_caixa_hist_atx ( nr_seq_conta_banco_p bigint, nr_seq_caixa_p bigint, ds_historico_p text, nm_usuario_p text, ie_rollback_p text, ie_commit_p text) AS $body$
BEGIN

if (coalesce(ie_rollback_p,'N')	= 'S') then

	rollback;

end if;

insert	into banco_caixa_historico(ds_historico,
	dt_atualizacao,
	dt_atualizacao_nrec,
	ie_origem,
	nm_usuario,
	nm_usuario_nrec,
	nr_seq_caixa,
	nr_seq_conta_banco,
	nr_sequencia)
values (ds_historico_p,
	clock_timestamp(),
	clock_timestamp(),
	'S',
	nm_usuario_p,
	nm_usuario_p,
	nr_seq_caixa_p,
	nr_seq_conta_banco_p,
	nextval('banco_caixa_historico_seq'));

if (coalesce(ie_commit_p,'N')	= 'S') then

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_banco_caixa_hist ( nr_seq_conta_banco_p bigint, nr_seq_caixa_p bigint, ds_historico_p text, nm_usuario_p text, ie_rollback_p text, ie_commit_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE gerar_banco_caixa_hist_atx ( nr_seq_conta_banco_p bigint, nr_seq_caixa_p bigint, ds_historico_p text, nm_usuario_p text, ie_rollback_p text, ie_commit_p text) FROM PUBLIC;

