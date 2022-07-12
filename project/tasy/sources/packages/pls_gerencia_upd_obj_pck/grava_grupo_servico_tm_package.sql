-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_upd_obj_pck.grava_grupo_servico_tm ( nr_seq_grupo_servico_p pls_util_cta_pck.t_number_table, ie_origem_proced_p pls_util_cta_pck.t_number_table, cd_procedimento_p pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	inserir registros na tabela PLS_GRUPO_SERVICO_TM.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [X] Outros:
	
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

if (nr_seq_grupo_servico_p.count > 0 ) then

	forall i in nr_seq_grupo_servico_p.first..nr_seq_grupo_servico_p.last
		insert 	into pls_grupo_servico_tm t(
			nr_seq_grupo_servico, dt_atualizacao, nm_usuario,
			ie_origem_proced, cd_procedimento
		) values (
			nr_seq_grupo_servico_p(i), clock_timestamp(), nm_usuario_p,
			ie_origem_proced_p(i), cd_procedimento_p(i));
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_upd_obj_pck.grava_grupo_servico_tm ( nr_seq_grupo_servico_p pls_util_cta_pck.t_number_table, ie_origem_proced_p pls_util_cta_pck.t_number_table, cd_procedimento_p pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
