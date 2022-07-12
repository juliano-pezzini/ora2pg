-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_proc_mat_regra_pck.gera_seq_tiss_conta_proc_t ( tb_nr_seq_conta_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o sequencial com base no vetor de contas passado

		Vai pegar todos os procedimentos relacionados a conta que nao tem o sequencial tiss informado
		e vai gerar um novo.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao: 

Alteracoes:

------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


tb_nr_seq_conta_w	dbms_sql.number_table;

BEGIN

for i in tb_nr_seq_conta_p.first..tb_nr_seq_conta_p.last loop

	tb_nr_seq_conta_w(i) := tb_nr_seq_conta_p(i);
end loop;

tb_nr_seq_conta_w := pls_cta_proc_mat_regra_pck.gera_seq_tiss_conta_proc_tb(tb_nr_seq_conta_w, nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_proc_mat_regra_pck.gera_seq_tiss_conta_proc_t ( tb_nr_seq_conta_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
