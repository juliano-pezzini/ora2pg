-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_a950_pck.insere_guia_sadt_v8 ( nr_seq_arq_xml_p pls_imp_arq_A950.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_proc_realizado_p INOUT dbms_sql.varchar2_table, vl_medico_p INOUT dbms_sql.number_table, nr_auxiliares_p INOUT dbms_sql.number_table, qt_porte_anestesico_p INOUT dbms_sql.number_table, ie_inc_rol_p INOUT dbms_sql.number_table, ie_grupos_planilha_p INOUT dbms_sql.number_table, ie_classificacao_p INOUT dbms_sql.number_table, qt_uco_p INOUT dbms_sql.number_table, ds_doc_racio_p INOUT dbms_sql.varchar2_table, nr_prazo_exec_p INOUT dbms_sql.number_table, nr_prazo_origem_p INOUT dbms_sql.number_table, cd_procedimento_uni_p INOUT dbms_sql.number_table, vl_proc_rol_p INOUT dbms_sql.number_table, nr_prazo_total_p INOUT dbms_sql.number_table, ds_item_rol_p INOUT dbms_sql.varchar2_table, vl_taxa_video_p INOUT dbms_sql.number_table, vl_filme_rol_p INOUT dbms_sql.number_table, qt_classificacao_p INOUT dbms_sql.number_table, tiss_tp_tabela_p INOUT dbms_sql.varchar2_table, tiss_codigo_p INOUT dbms_sql.varchar2_table) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Insere os dados na respectiva tabela
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[ ]  Objetos do dicionario [X] Tasy (Delphi/Java) [ X] Portal [ X]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
			Nao deve possuir regra de negocio, apenas deve mandar para o banco de dados
			
			O commit fica a cargo de quem chamou a rotina

Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

forall i in vl_medico_p.first..vl_medico_p.last
	insert into pls_imp_arq_A950_sadt(	nr_sequencia,
						ie_proc_realizado,
						vl_medico,
						dt_atualizacao,
						nm_usuario,
						nr_auxiliares,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						qt_porte_anestesico,
						nr_seq_arq_a950,
						ie_inc_rol,
						ie_grupos_planilha,
						ie_classificacao,
						qt_uco,
						ds_doc_racio,
						nr_prazo_exec,
						nr_prazo_origem,
						cd_procedimento_uni,
						vl_proc_rol,
						nr_prazo_total,
						ds_item_rol,
						qt_classificacao,
						vl_taxa_video,
						vl_filme_rol,
						ie_tiss_tp_tabela,
						cd_tiss_codigo)
	values (nextval('pls_imp_arq_a950_sadt_seq'),
		ie_proc_realizado_p(i),
		vl_medico_p(i),
		clock_timestamp(),
		nm_usuario_p,
		nr_auxiliares_p(i),
		clock_timestamp(),
		nm_usuario_p,
		qt_porte_anestesico_p(i),
		nr_seq_arq_xml_p,
		ie_inc_rol_p(i),
		ie_grupos_planilha_p(i),
		ie_classificacao_p(i),
		
		qt_uco_p(i),
		ds_doc_racio_p(i),
		nr_prazo_exec_p(i),
		nr_prazo_origem_p(i),
		cd_procedimento_uni_p(i),
		vl_proc_rol_p(i),
		nr_prazo_total_p(i),
		ds_item_rol_p(i),
		qt_classificacao_p(i),
		vl_taxa_video_p(i),
		vl_filme_rol_p(i),
		tiss_tp_tabela_p(i),
		tiss_codigo_p(i));
		
		
ie_proc_realizado_p.delete;
qt_classificacao_p.delete;
nr_auxiliares_p.delete;
qt_porte_anestesico_p.delete;
ie_inc_rol_p.delete;
vl_taxa_video_p.delete;
vl_filme_rol_p.delete;
ie_grupos_planilha_p.delete;
ie_classificacao_p.delete;
qt_uco_p.delete;
ds_doc_racio_p.delete;
nr_prazo_exec_p.delete;
nr_prazo_origem_p.delete;
cd_procedimento_uni_p.delete;
vl_proc_rol_p.delete;
nr_prazo_total_p.delete;
ds_item_rol_p.delete;
tiss_tp_tabela_p.delete;
tiss_codigo_p.delete;
vl_medico_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_a950_pck.insere_guia_sadt_v8 ( nr_seq_arq_xml_p pls_imp_arq_A950.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_proc_realizado_p INOUT dbms_sql.varchar2_table, vl_medico_p INOUT dbms_sql.number_table, nr_auxiliares_p INOUT dbms_sql.number_table, qt_porte_anestesico_p INOUT dbms_sql.number_table, ie_inc_rol_p INOUT dbms_sql.number_table, ie_grupos_planilha_p INOUT dbms_sql.number_table, ie_classificacao_p INOUT dbms_sql.number_table, qt_uco_p INOUT dbms_sql.number_table, ds_doc_racio_p INOUT dbms_sql.varchar2_table, nr_prazo_exec_p INOUT dbms_sql.number_table, nr_prazo_origem_p INOUT dbms_sql.number_table, cd_procedimento_uni_p INOUT dbms_sql.number_table, vl_proc_rol_p INOUT dbms_sql.number_table, nr_prazo_total_p INOUT dbms_sql.number_table, ds_item_rol_p INOUT dbms_sql.varchar2_table, vl_taxa_video_p INOUT dbms_sql.number_table, vl_filme_rol_p INOUT dbms_sql.number_table, qt_classificacao_p INOUT dbms_sql.number_table, tiss_tp_tabela_p INOUT dbms_sql.varchar2_table, tiss_codigo_p INOUT dbms_sql.varchar2_table) FROM PUBLIC;
