-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_a500_pck.gerencia_conta_pend_a500 ( nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Carrega as faturas A500 que estao pendentes de gerar as contas medicas
	
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [X] Tasy (Delphi/Java) [X] Portal [X]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


c01 CURSOR FOR
	SELECT	a.nr_seq_fatura,
		a.cd_estabelecimento,
		a.nm_usuario
	from	pls_a500_conta_pend_gerar_v	a
	order by	a.dt_vencimento_fatura asc,
			a.vl_total_fatura asc;
	
BEGIN
CALL wheb_usuario_pck.set_nm_usuario(coalesce(nm_usuario_p, 'Tasy'));

for r_c01_w in c01 loop
	CALL pls_a500_pck.gerar_conta_medica_pend_a500(r_c01_w.nr_seq_fatura, r_c01_w.cd_estabelecimento, r_c01_w.nm_usuario);
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_a500_pck.gerencia_conta_pend_a500 ( nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;