-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.grava_proc_recurso ( tb_nr_sequencia_p INOUT dbms_sql.number_table, tb_nr_seq_grg_guia_p INOUT dbms_sql.number_table, tb_nr_seq_guia_proc_p INOUT dbms_sql.number_table, tb_nr_seq_dma_procedimento_p INOUT dbms_sql.number_table, tb_cd_procedimento_p INOUT dbms_sql.varchar2_table, tb_ie_origem_proced_p INOUT dbms_sql.varchar2_table, tb_cd_procedimento_imp_p INOUT dbms_sql.varchar2_table, tb_cd_tabela_imp_p INOUT dbms_sql.varchar2_table, tb_vl_cobrado_fat_p INOUT dbms_sql.number_table, tb_vl_glosado_p INOUT dbms_sql.number_table, tb_vl_recursado_p INOUT dbms_sql.number_table, tb_vl_acatado_p INOUT dbms_sql.number_table, tb_dt_realizacao_imp_p INOUT dbms_sql.date_table, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text, ie_esvaziar_table_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Grava os procedimento das guias conforme os protocolos do recurso

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
	insert into pls_grg_guia_proc(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_grg_guia,
					nr_seq_guia_proc,
					nr_seq_dma_procedimento,
					cd_procedimento,
					ie_origem_proced,
					cd_procedimento_imp,
					cd_tabela_imp,
					vl_cobrado_fat,
					vl_glosado,
					vl_recursado,
					vl_acatado,
					dt_realizacao_imp)
	values (	tb_nr_sequencia_p(i),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			tb_nr_seq_grg_guia_p(i),
			tb_nr_seq_guia_proc_p(i),
			tb_nr_seq_dma_procedimento_p(i),
			tb_cd_procedimento_p(i),
			tb_ie_origem_proced_p(i),
			tb_cd_procedimento_imp_p(i),
			tb_cd_tabela_imp_p(i),
			tb_vl_cobrado_fat_p(i),
			tb_vl_glosado_p(i),
			tb_vl_recursado_p(i),
			tb_vl_acatado_p(i),
			tb_dt_realizacao_imp_p(i));

if (coalesce(ie_commit_p,'S') = 'S') then

	commit;
end if;

if (coalesce(ie_esvaziar_table_p,'N') = 'S') then

	tb_nr_sequencia_p.delete;
	tb_nr_seq_grg_guia_p.delete;
	tb_nr_seq_guia_proc_p.delete;
	tb_nr_seq_dma_procedimento_p.delete;
	tb_cd_procedimento_p.delete;
	tb_ie_origem_proced_p.delete;
	tb_cd_procedimento_imp_p.delete;
	tb_cd_tabela_imp_p.delete;
	tb_vl_cobrado_fat_p.delete;
	tb_vl_glosado_p.delete;
	tb_vl_recursado_p.delete;
	tb_vl_acatado_p.delete;
	tb_dt_realizacao_imp_p.delete;
end if;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.grava_proc_recurso ( tb_nr_sequencia_p INOUT dbms_sql.number_table, tb_nr_seq_grg_guia_p INOUT dbms_sql.number_table, tb_nr_seq_guia_proc_p INOUT dbms_sql.number_table, tb_nr_seq_dma_procedimento_p INOUT dbms_sql.number_table, tb_cd_procedimento_p INOUT dbms_sql.varchar2_table, tb_ie_origem_proced_p INOUT dbms_sql.varchar2_table, tb_cd_procedimento_imp_p INOUT dbms_sql.varchar2_table, tb_cd_tabela_imp_p INOUT dbms_sql.varchar2_table, tb_vl_cobrado_fat_p INOUT dbms_sql.number_table, tb_vl_glosado_p INOUT dbms_sql.number_table, tb_vl_recursado_p INOUT dbms_sql.number_table, tb_vl_acatado_p INOUT dbms_sql.number_table, tb_dt_realizacao_imp_p INOUT dbms_sql.date_table, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text, ie_esvaziar_table_p text) FROM PUBLIC;