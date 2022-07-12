-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_a950_pck.processa_guias_sadt ( nr_seq_arq_xml_p pls_imp_arq_A950.nr_sequencia%type, ds_guias_sadt_p pls_imp_arq_A950.ds_xml%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Extrai as guias SP/SADT, e joga elas nos seus respectivos vetores, para dai descarregar no banco
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [ ] Portal [ ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
i			integer;
ds_guia_sadt_w		pls_imp_arq_A950.ds_xml%type;
ds_guia_sadtRol_w	pls_imp_arq_A950.ds_xml%type;
ds_porteAnestesico_w	pls_imp_arq_A950.ds_xml%type;
ds_auxiliares_w		pls_imp_arq_A950.ds_xml%type;
ds_classificacao_w	pls_imp_arq_A950.ds_xml%type;
nr_total_guias_sadt_w	bigint;
nr_guia_atual_w		bigint := 1;
ds_guias_sadt_w		pls_imp_arq_A950.ds_xml%type;

tb_vl_procedimento_w		dbms_sql.number_table;
tb_vl_custo_operacional_w	dbms_sql.number_table;
tb_vl_medico_w			dbms_sql.number_table;
tb_nr_auxiliares_w		dbms_sql.number_table;
tb_qt_porte_anestesico_w	dbms_sql.number_table;
tb_nr_seq_arq_a950_w		dbms_sql.number_table;
tb_ie_inc_rol_w			dbms_sql.number_table;
tb_cd_porte_w			dbms_sql.varchar2_table;
tb_cd_amb_w			dbms_sql.number_table;
tb_ie_grupos_planilha_w		dbms_sql.number_table;
tb_ie_classificacao_w		dbms_sql.number_table;
tb_qt_uco_w			dbms_sql.number_table;
tb_ie_quantidade_w		dbms_sql.number_table;
tb_ds_doc_racio_w		dbms_sql.varchar2_table;
tb_nr_prazo_exec_w		dbms_sql.number_table;
tb_nr_prazo_origem_w		dbms_sql.number_table;
tb_cd_procedimento_uni_w	dbms_sql.number_table;
tb_vl_proc_rol_w		dbms_sql.number_table;
tb_nr_porte_anest_w		dbms_sql.number_table;
tb_nr_prazo_total_w		dbms_sql.number_table;
tb_ds_item_rol_w		dbms_sql.varchar2_table;
tb_ds_amb_rol_w			dbms_sql.varchar2_table;
tb_nr_auxiliar_w		dbms_sql.number_table;
tb_qt_filme_w			dbms_sql.number_table;


BEGIN

nr_total_guias_sadt_w := ptu_a950_pck.obter_numero_tag(ds_guias_sadt_p, 'sadt');
ds_guias_sadt_w := ptu_a950_pck.obter_conteudo_tag(ds_guias_sadt_p, 'sadt', 1, nr_total_guias_sadt_w, 'S');

-- so processa se tiver guias
if (nr_total_guias_sadt_w > 0) then

	i := 0;
	-- Como foi definido um no sadt (para procedimentos) DENTRO de um no sadt(para a guia !!!), sera necessario dividir o total da contagem por 2
	-- para "pular" o no sadt de procedimento da selecao da proxima guia
	--nr_total_guias_sadt_w := nr_total_guias_sadt_w / 2;
	
	-- navega pelas guias
	while(nr_guia_atual_w <= nr_total_guias_sadt_w) loop
	
		-- carrega a guia atual
		ds_guia_sadt_w := ptu_a950_pck.obter_conteudo_tag(ds_guias_sadt_w, 'sadt', nr_guia_atual_w, nr_guia_atual_w + 1, 'N');
		
		-- busca os campos
		
		-- subgrupo sadt
		ds_guia_sadtRol_w := ptu_a950_pck.obter_conteudo_tag(ds_guia_sadt_w, 'sadt', 1, 1, 'N');
			tb_cd_procedimento_uni_w(i)	:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadtRol_w, 'codigoRol', 1, 1, 'N'));
			tb_vl_proc_rol_w(i)		:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadtRol_w, 'valorRol', 1, 1, 'N'));
			tb_cd_amb_w(i)			:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadtRol_w, 'codigoAmb', 1, 1, 'N'));
			tb_vl_procedimento_w(i)		:= coalesce(ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadtRol_w, 'valorAmb', 1, 1, 'N')),0);
			tb_ie_inc_rol_w(i)		:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadtRol_w, 'qtIncidenciaRol', 1, 1, 'N'));
			tb_ds_item_rol_w(i)		:= substr(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadtRol_w, 'descricaoRol', 1, 1, 'N'), 1, 255);
			tb_ds_amb_rol_w(i)		:= substr(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadtRol_w, 'descricaoAmb', 1, 1, 'N'), 1, 255);
			tb_vl_medico_w(i)		:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadtRol_w, 'valorHonorarioMedico', 1, 1, 'N'));
			tb_qt_uco_w(i)			:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadtRol_w, 'qtUtsCustoOperacional', 1, 1, 'N'));
			tb_vl_custo_operacional_w(i)	:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadtRol_w, 'valorCustoOperacionalAmb', 1, 1, 'N'));
		
		tb_cd_porte_w(i) := ptu_a950_pck.obter_conteudo_tag(ds_guia_sadt_w, 'Porte', 1, 1, 'N');
		
		-- subgrupo porteAnestesico
		ds_porteAnestesico_w := ptu_a950_pck.obter_conteudo_tag(ds_guia_sadt_w, 'porteAnestesico', 1, 1, 'N');
			tb_qt_porte_anestesico_w(i)	:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_porteAnestesico_w, 'porteAnestesico', 1, 1, 'N'));
		
		-- subgrupo auxiliares
		ds_auxiliares_w := ptu_a950_pck.obter_conteudo_tag(ds_guia_sadt_w, 'auxiliares', 1, 1, 'N');
			tb_nr_auxiliares_w(i)		:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_auxiliares_w, 'numeroAuxiliaresRol', 1, 1, 'N'));
			tb_nr_auxiliar_w(i)		:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_auxiliares_w, 'numeroAuxiliaresAmb', 1, 1, 'N'));
		
		-- subgrupo classificacao
		ds_classificacao_w := ptu_a950_pck.obter_conteudo_tag(ds_guia_sadt_w, 'classificacao', 1, 2, 'N');
			tb_ie_classificacao_w(i)	:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_classificacao_w, 'classificacao', 1, 1, 'N')); -- usa 2 porque tem a mesma tag(!!!)
			tb_ds_doc_racio_w(i)		:= substr(ptu_a950_pck.obter_conteudo_tag(ds_classificacao_w, 'docRacionalizacao', 1, 1, 'N'), 1, 250);
			tb_nr_prazo_exec_w(i)		:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_classificacao_w, 'prazoExecutora', 1, 1, 'N'));
			tb_nr_prazo_origem_w(i)		:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_classificacao_w, 'prazoOrigem', 1, 1, 'N'));
			tb_nr_prazo_total_w(i)		:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_classificacao_w, 'prazoTotal', 1, 1, 'N'));
			
		tb_ie_grupos_planilha_w(i)		:= ptu_a950_pck.converte_numero(ptu_a950_pck.obter_conteudo_tag(ds_guia_sadt_w, 'gruposPlanilha', 1, 1, 'N'));
		
		tb_ie_quantidade_w(i)			:= null;
		tb_nr_porte_anest_w(i)			:= null;
		tb_qt_filme_w(i)			:= null;
		
		-- incrementa para buscar a proxima guia, ou sair do loop
		-- Como foi definido um no sadt (para procedimentos) DENTRO de um no sadt(para a guia !!!), sera necessario considerar o incremento da guia sempre como 2, 
		-- para "pular" o no sadt de procedimento da selecao da proxima guia
		nr_guia_atual_w := nr_guia_atual_w + 2;
		
		
		-- se chegou no limite, manda para o banco
		if (i >= pls_util_pck.qt_registro_transacao_w) then
		
			SELECT * FROM ptu_a950_pck.insere_guia_sadt(	nr_seq_arq_xml_p, nm_usuario_p, tb_vl_procedimento_w, tb_vl_custo_operacional_w, tb_vl_medico_w, tb_nr_auxiliares_w, tb_qt_porte_anestesico_w, tb_ie_inc_rol_w, tb_cd_porte_w, tb_cd_amb_w, tb_ie_grupos_planilha_w, tb_ie_classificacao_w, tb_qt_uco_w, tb_ie_quantidade_w, tb_ds_doc_racio_w, tb_nr_prazo_exec_w, tb_nr_prazo_origem_w, tb_cd_procedimento_uni_w, tb_vl_proc_rol_w, tb_nr_porte_anest_w, tb_nr_prazo_total_w, tb_ds_item_rol_w, tb_ds_amb_rol_w, tb_nr_auxiliar_w, tb_qt_filme_w) INTO STRICT _ora2pg_r;
 tb_vl_procedimento_w := _ora2pg_r.vl_procedimento_p; tb_vl_custo_operacional_w := _ora2pg_r.vl_custo_operacional_p; tb_vl_medico_w := _ora2pg_r.vl_medico_p; tb_nr_auxiliares_w := _ora2pg_r.nr_auxiliares_p; tb_qt_porte_anestesico_w := _ora2pg_r.qt_porte_anestesico_p; tb_ie_inc_rol_w := _ora2pg_r.ie_inc_rol_p; tb_cd_porte_w := _ora2pg_r.cd_porte_p; tb_cd_amb_w := _ora2pg_r.cd_amb_p; tb_ie_grupos_planilha_w := _ora2pg_r.ie_grupos_planilha_p; tb_ie_classificacao_w := _ora2pg_r.ie_classificacao_p; tb_qt_uco_w := _ora2pg_r.qt_uco_p; tb_ie_quantidade_w := _ora2pg_r.ie_quantidade_p; tb_ds_doc_racio_w := _ora2pg_r.ds_doc_racio_p; tb_nr_prazo_exec_w := _ora2pg_r.nr_prazo_exec_p; tb_nr_prazo_origem_w := _ora2pg_r.nr_prazo_origem_p; tb_cd_procedimento_uni_w := _ora2pg_r.cd_procedimento_uni_p; tb_vl_proc_rol_w := _ora2pg_r.vl_proc_rol_p; tb_nr_porte_anest_w := _ora2pg_r.nr_porte_anest_p; tb_nr_prazo_total_w := _ora2pg_r.nr_prazo_total_p; tb_ds_item_rol_w := _ora2pg_r.ds_item_rol_p; tb_ds_amb_rol_w := _ora2pg_r.ds_amb_rol_p; tb_nr_auxiliar_w := _ora2pg_r.nr_auxiliar_p; tb_qt_filme_w := _ora2pg_r.qt_filme_p;
			
			i:= 0;
		else
			
			i := i + 1;
		end if;
		
	end loop; -- fim navegou pelas guias
	
	-- envia o que sobrou
	
	SELECT * FROM ptu_a950_pck.insere_guia_sadt(	nr_seq_arq_xml_p, nm_usuario_p, tb_vl_procedimento_w, tb_vl_custo_operacional_w, tb_vl_medico_w, tb_nr_auxiliares_w, tb_qt_porte_anestesico_w, tb_ie_inc_rol_w, tb_cd_porte_w, tb_cd_amb_w, tb_ie_grupos_planilha_w, tb_ie_classificacao_w, tb_qt_uco_w, tb_ie_quantidade_w, tb_ds_doc_racio_w, tb_nr_prazo_exec_w, tb_nr_prazo_origem_w, tb_cd_procedimento_uni_w, tb_vl_proc_rol_w, tb_nr_porte_anest_w, tb_nr_prazo_total_w, tb_ds_item_rol_w, tb_ds_amb_rol_w, tb_nr_auxiliar_w, tb_qt_filme_w) INTO STRICT _ora2pg_r;
 tb_vl_procedimento_w := _ora2pg_r.vl_procedimento_p; tb_vl_custo_operacional_w := _ora2pg_r.vl_custo_operacional_p; tb_vl_medico_w := _ora2pg_r.vl_medico_p; tb_nr_auxiliares_w := _ora2pg_r.nr_auxiliares_p; tb_qt_porte_anestesico_w := _ora2pg_r.qt_porte_anestesico_p; tb_ie_inc_rol_w := _ora2pg_r.ie_inc_rol_p; tb_cd_porte_w := _ora2pg_r.cd_porte_p; tb_cd_amb_w := _ora2pg_r.cd_amb_p; tb_ie_grupos_planilha_w := _ora2pg_r.ie_grupos_planilha_p; tb_ie_classificacao_w := _ora2pg_r.ie_classificacao_p; tb_qt_uco_w := _ora2pg_r.qt_uco_p; tb_ie_quantidade_w := _ora2pg_r.ie_quantidade_p; tb_ds_doc_racio_w := _ora2pg_r.ds_doc_racio_p; tb_nr_prazo_exec_w := _ora2pg_r.nr_prazo_exec_p; tb_nr_prazo_origem_w := _ora2pg_r.nr_prazo_origem_p; tb_cd_procedimento_uni_w := _ora2pg_r.cd_procedimento_uni_p; tb_vl_proc_rol_w := _ora2pg_r.vl_proc_rol_p; tb_nr_porte_anest_w := _ora2pg_r.nr_porte_anest_p; tb_nr_prazo_total_w := _ora2pg_r.nr_prazo_total_p; tb_ds_item_rol_w := _ora2pg_r.ds_item_rol_p; tb_ds_amb_rol_w := _ora2pg_r.ds_amb_rol_p; tb_nr_auxiliar_w := _ora2pg_r.nr_auxiliar_p; tb_qt_filme_w := _ora2pg_r.qt_filme_p;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_a950_pck.processa_guias_sadt ( nr_seq_arq_xml_p pls_imp_arq_A950.nr_sequencia%type, ds_guias_sadt_p pls_imp_arq_A950.ds_xml%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
