-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estorna_aprovacao_os ( nm_usuario_p text, nr_seq_p bigint) AS $body$
BEGIN
update	man_ordem_servico
set	dt_aprovacao  = NULL,
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p,
	dt_fim_analise_qual_soft    = NULL
where    	nr_sequencia  = nr_seq_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estorna_aprovacao_os ( nm_usuario_p text, nr_seq_p bigint) FROM PUBLIC;

