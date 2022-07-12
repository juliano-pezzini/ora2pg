-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.atualizar_cd_guia_ans ( tb_sequencia_p pls_util_cta_pck.t_number_table, tb_cd_guia_p pls_util_cta_pck.t_varchar2_table_20, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

if (tb_sequencia_p.count > 0) then

	forall i in tb_sequencia_p.first .. tb_sequencia_p.last

		update	pls_monitor_tiss_cta_val
		set	dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p,
			cd_guia_operadora		= tb_cd_guia_p(i)
		where	nr_sequencia 			= tb_sequencia_p(i);

	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.atualizar_cd_guia_ans ( tb_sequencia_p pls_util_cta_pck.t_number_table, tb_cd_guia_p pls_util_cta_pck.t_varchar2_table_20, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
