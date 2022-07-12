-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_proc_mat_regra_pck.grava_seq_tiss_vinc_proc ( tb_nr_seq_conta_proc_regra_p INOUT dbms_sql.number_table, tb_nr_seq_item_tiss_vinc_p INOUT dbms_sql.number_table, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Grava o vinculo tiss

		Apenas manda para o banco, nao deve possuir nenhuma regra de negocio aqui
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao: 

Alteracoes:

------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

forall i in tb_nr_seq_conta_proc_regra_p.first..tb_nr_seq_conta_proc_regra_p.last
	update	pls_conta_proc_regra
	set	nr_seq_item_tiss_vinculo	= tb_nr_seq_item_tiss_vinc_p(i),
		nm_usuario			= nm_usuario_p,
		dt_atualizacao			= clock_timestamp()
	where	nr_sequencia			= tb_nr_seq_conta_proc_regra_p(i);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_proc_mat_regra_pck.grava_seq_tiss_vinc_proc ( tb_nr_seq_conta_proc_regra_p INOUT dbms_sql.number_table, tb_nr_seq_item_tiss_vinc_p INOUT dbms_sql.number_table, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
