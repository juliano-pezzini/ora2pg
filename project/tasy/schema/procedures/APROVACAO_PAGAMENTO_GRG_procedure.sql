-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aprovacao_pagamento_grg ( nr_seq_lote_audit_lib_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
BEGIN
if (ie_acao_p = 'A') then

	update	lote_audit_hist_lib
	set	dt_atualizacao	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p,
		dt_aprovacao	= CASE WHEN dt_aprovacao = NULL THEN clock_timestamp()  ELSE null END
	where	nr_sequencia  	= nr_seq_lote_audit_lib_p;

elsif (ie_acao_p = 'R') then

	update	lote_audit_hist_lib
	set	dt_atualizacao	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p,
		dt_reprovacao	= CASE WHEN dt_reprovacao = NULL THEN clock_timestamp()  ELSE null END
	where	nr_sequencia  	= nr_seq_lote_audit_lib_p;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aprovacao_pagamento_grg ( nr_seq_lote_audit_lib_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;
