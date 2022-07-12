-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_contas_a700_pck.gera_copartic_mat ( tab_mat_p dbms_sql.number_table, nm_usuario_p Usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

if (tab_mat_p.count > 0) then

	for i in tab_mat_p.first..tab_mat_p.last loop

		CALL pls_gerar_coparticipacao_mat(tab_mat_p(i), nm_usuario_p, cd_estabelecimento_p);
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_a700_pck.gera_copartic_mat ( tab_mat_p dbms_sql.number_table, nm_usuario_p Usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;