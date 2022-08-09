-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_tipo_cobranca (nr_seq_fatura_p ptu_fatura_geral.nr_sequencia%type, id_cobranca_p ptu_fatura_geral.id_cobranca%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

update	ptu_fatura_geral
set	id_cobranca		= id_cobranca_p,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_fatura_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_tipo_cobranca (nr_seq_fatura_p ptu_fatura_geral.nr_sequencia%type, id_cobranca_p ptu_fatura_geral.id_cobranca%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
