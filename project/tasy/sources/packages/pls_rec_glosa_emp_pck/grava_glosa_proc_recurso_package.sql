-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.grava_glosa_proc_recurso ( tb_nr_sequencia_p INOUT dbms_sql.number_table, tb_nr_seq_grg_proc_p INOUT dbms_sql.number_table, tb_nr_seq_motivo_glosa_p INOUT dbms_sql.number_table, tb_ds_justificativa_p INOUT dbms_sql.varchar2_table, tb_nr_seq_dma_proc_glosa_p INOUT dbms_sql.number_table, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text, ie_esvaziar_table_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Grava as glosas conforme os procedimentos

	Essa rotina so deve gravar no banco, nao deve ser inserido regras de negocio aqui
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

forall i in tb_nr_sequencia_p.first..tb_nr_sequencia_p.last
	insert into pls_grg_guia_proc_glosa(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_grg_proc,
						nr_seq_motivo_glosa,
						ds_justificativa,
						nr_seq_dma_proc_glosa)
	values (	tb_nr_sequencia_p(i),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			tb_nr_seq_grg_proc_p(i),
			tb_nr_seq_motivo_glosa_p(i),
			tb_ds_justificativa_p(i),
			tb_nr_seq_dma_proc_glosa_p(i));
			
if (coalesce(ie_commit_p, 'S') = 'S') then

	commit;
end if;

if (coalesce(ie_esvaziar_table_p, 'N') = 'S') then

	tb_nr_sequencia_p.delete;
	tb_nr_seq_grg_proc_p.delete;
	tb_nr_seq_motivo_glosa_p.delete;
	tb_ds_justificativa_p.delete;
	tb_nr_seq_dma_proc_glosa_p.delete;
end if;
	

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.grava_glosa_proc_recurso ( tb_nr_sequencia_p INOUT dbms_sql.number_table, tb_nr_seq_grg_proc_p INOUT dbms_sql.number_table, tb_nr_seq_motivo_glosa_p INOUT dbms_sql.number_table, tb_ds_justificativa_p INOUT dbms_sql.varchar2_table, tb_nr_seq_dma_proc_glosa_p INOUT dbms_sql.number_table, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text, ie_esvaziar_table_p text) FROM PUBLIC;
