-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_os_resultado_acao ( nm_usuario_p text, nr_seq_ordem_p bigint, nr_sequencia_p bigint) AS $body$
BEGIN
update	teste_soft_exec_acao_res
set     	nr_seq_ordem_servico = nr_seq_ordem_p,
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where	nr_sequencia = nr_sequencia_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_os_resultado_acao ( nm_usuario_p text, nr_seq_ordem_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

