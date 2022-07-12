-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ehr_template_conteudo_v (nr_sequencia, nr_seq_template, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_elemento, nr_seq_apres, qt_tamanho, ds_label, qt_altura, ds_elemento, qt_tam_grid, ds_label_grid, ds_mascara, vl_minimo, vl_maximo, nr_seq_grid, qt_desloc_dir, ie_obrigatorio, ie_readonly, ie_tabstop, vl_padrao, nr_seq_elem_visual, ie_opcional, ie_vazio, ds_sql, ie_copia, ie_entidade, nr_seq_elem_sup, nr_seq_template_cluster, qt_coluna, ie_wordwrap, ds_formula, ie_alinhamento, ie_italico, ie_negrito, ie_sublinhado, ds_cor, qt_fonte, ie_situacao, ie_macro, nr_seq_texto_padrao, qt_pos_esq, nr_seq_sinal_vital, qt_caracter, qt_pos_topo, ds_function_grid, ds_msg_aviso, ie_bloqueia_aviso, ie_macro_consistencia, dt_inativacao, ie_evolucao, ds_propriedade, ie_nova_linha, ie_sensivel, ie_info_paciente, ie_collapsed, ie_checkbox_cluster, ds_label_field, qt_elemento_result, ds_openehr, qt_pos_esquerda, qt_topo_campo, qt_intervalo_campo, ie_componente, nr_seq_temp_reg, ds_unid_medida, ds_sql_lookup, ds_masc, nr_seq_entidade, nr_seq_localizador, ie_cliente_cadastra, ie_tipo_item, ie_possui_regra, cd_dominio, ds_msg_campo_obrigatorio, ie_ficar_grid_cluster, ie_regra_cluster, ie_consistir_campo_obrig, nm_time_zone_attribute, is_empty_label) AS select	a.NR_SEQUENCIA,
	a.NR_SEQ_TEMPLATE,
	a.DT_ATUALIZACAO,
	a.NM_USUARIO,
	a.DT_ATUALIZACAO_NREC,
	a.NM_USUARIO_NREC,
	a.NR_SEQ_ELEMENTO,
	a.NR_SEQ_APRES,
	a.QT_TAMANHO,
	a.DS_LABEL,
	a.QT_ALTURA,
	a.DS_ELEMENTO,
	a.QT_TAM_GRID,
	a.DS_LABEL_GRID,
	a.DS_MASCARA,
	a.VL_MINIMO,
	a.VL_MAXIMO,
	a.NR_SEQ_GRID,
	a.QT_DESLOC_DIR,
	a.IE_OBRIGATORIO,
	a.IE_READONLY,
	a.IE_TABSTOP,
	a.VL_PADRAO,
	a.NR_SEQ_ELEM_VISUAL,
	a.IE_OPCIONAL,
	a.IE_VAZIO,
	a.DS_SQL,
	a.IE_COPIA,
	a.IE_ENTIDADE,
	a.NR_SEQ_ELEM_SUP,
	a.NR_SEQ_TEMPLATE_CLUSTER,
	a.QT_COLUNA,
	a.IE_WORDWRAP,
	a.DS_FORMULA,
	a.IE_ALINHAMENTO,
	a.IE_ITALICO,
	a.IE_NEGRITO,
	a.IE_SUBLINHADO,
	a.DS_COR,
	a.QT_FONTE,
	a.IE_SITUACAO,
	a.IE_MACRO,
	a.NR_SEQ_TEXTO_PADRAO,
	a.QT_POS_ESQ,
	a.NR_SEQ_SINAL_VITAL,
	a.QT_CARACTER,
	a.QT_POS_TOPO,
	a.DS_FUNCTION_GRID,
	a.DS_MSG_AVISO,
	a.IE_BLOQUEIA_AVISO,
	a.IE_MACRO_CONSISTENCIA,
	a.DT_INATIVACAO,
	a.IE_EVOLUCAO,
	a.DS_PROPRIEDADE,
	a.IE_NOVA_LINHA,
	a.IE_SENSIVEL,
	a.IE_INFO_PACIENTE,
	a.IE_COLLAPSED,
	a.IE_CHECKBOX_CLUSTER,	
	coalesce(a.ds_label, obter_desc_expressao(b.cd_exp_label_tela, null)) ds_label_field,
	substr(obter_qte_elemento_result(a.nr_seq_elemento),1,3) qt_elemento_result,
	substr(obter_desc_tipo_openehr(b.nr_seq_tipo_dado),1,50) ds_openehr, 
	c.qt_pos_esquerda, 
	c.qt_topo_campo, 
	c.qt_intervalo_campo,
	b.ie_componente, 
	0 nr_seq_temp_reg, 
	b.ds_unid_medida,
	coalesce(a.ds_sql,b.ds_sql) ds_sql_lookup,
	coalesce(a.ds_mascara,b.ds_mascara) ds_masc,
	b.nr_seq_entidade,
	b.nr_seq_localizador,
	b.ie_cliente_cadastra,
	b.ie_tipo_item,
	substr(obter_se_regra_elem_cont(a.nr_sequencia),1,1) ie_possui_regra,
	b.cd_dominio,
	c.ds_msg_campo_obrigatorio,
	c.ie_ficar_grid_cluster,
	c.ie_regra_cluster,
	c.ie_consistir_campo_obrig,
	a.NM_TIME_ZONE_ATTRIBUTE,
	coalesce(a.IS_EMPTY_LABEL,'N') IS_EMPTY_LABEL
FROM	ehr_elemento b, 
	ehr_template c,
	ehr_template_conteudo a
where	a.nr_seq_elemento = b.nr_sequencia
and	a.nr_seq_template = c.nr_sequencia
and	a.ie_opcional = 'N'

union

select	a.NR_SEQUENCIA,
	a.NR_SEQ_TEMPLATE,
	a.DT_ATUALIZACAO,
	a.NM_USUARIO,
	a.DT_ATUALIZACAO_NREC,
	a.NM_USUARIO_NREC,
	a.NR_SEQ_ELEMENTO,
	a.NR_SEQ_APRES,
	a.QT_TAMANHO,
	a.DS_LABEL,
	a.QT_ALTURA,
	a.DS_ELEMENTO,
	a.QT_TAM_GRID,
	a.DS_LABEL_GRID,
	a.DS_MASCARA,
	a.VL_MINIMO,
	a.VL_MAXIMO,
	a.NR_SEQ_GRID,
	a.QT_DESLOC_DIR,
	a.IE_OBRIGATORIO,
	a.IE_READONLY,
	a.IE_TABSTOP,
	a.VL_PADRAO,
	a.NR_SEQ_ELEM_VISUAL,
	a.IE_OPCIONAL,
	a.IE_VAZIO,
	a.DS_SQL,
	a.IE_COPIA,
	a.IE_ENTIDADE,
	a.NR_SEQ_ELEM_SUP,
	a.NR_SEQ_TEMPLATE_CLUSTER,
	a.QT_COLUNA,
	a.IE_WORDWRAP,
	a.DS_FORMULA,
	a.IE_ALINHAMENTO,
	a.IE_ITALICO,
	a.IE_NEGRITO,
	a.IE_SUBLINHADO,
	a.DS_COR,
	a.QT_FONTE,
	a.IE_SITUACAO,
	a.IE_MACRO,
	a.NR_SEQ_TEXTO_PADRAO,
	a.QT_POS_ESQ,
	a.NR_SEQ_SINAL_VITAL,
	a.QT_CARACTER,
	a.QT_POS_TOPO,
	a.DS_FUNCTION_GRID,
	a.DS_MSG_AVISO,
	a.IE_BLOQUEIA_AVISO,
	a.IE_MACRO_CONSISTENCIA,
	a.DT_INATIVACAO,
	a.IE_EVOLUCAO,
	a.DS_PROPRIEDADE,
	a.IE_NOVA_LINHA,
	a.IE_SENSIVEL,
	a.IE_INFO_PACIENTE,
	a.IE_COLLAPSED,
	a.IE_CHECKBOX_CLUSTER,
	a.ds_label ds_label_field,
	substr(obter_qte_elemento_result(a.nr_seq_elemento),1,3) qt_elemento_result, 
	null ds_openehr, 
	c.qt_pos_esquerda, 
	c.qt_topo_campo, 
	c.qt_intervalo_campo,
	b.ie_tipo ie_componente,
	0 nr_seq_temp_reg,
	null ds_unid_medida,
	a.ds_sql ds_sql_lookup,
	a.ds_mascara ds_masc,
	0 nr_seq_entidade,
	null nr_seq_localizador,
	null ie_cliente_cadastra,
	null ie_tipo_item,
	null ie_possui_regra,
	null cd_dominio,
	c.ds_msg_campo_obrigatorio,
	c.ie_ficar_grid_cluster,
	c.ie_regra_cluster,
	c.ie_consistir_campo_obrig,
	a.NM_TIME_ZONE_ATTRIBUTE,
	coalesce(a.IS_EMPTY_LABEL,'N') IS_EMPTY_LABEL
from	ehr_elemento_visual b, 
	ehr_template c,
	ehr_template_conteudo a
where	a.nr_seq_elem_visual = b.nr_sequencia
and	a.nr_seq_template = c.nr_sequencia
and	a.ie_opcional = 'N'

union

select	a.NR_SEQUENCIA,
	a.NR_SEQ_TEMPLATE,
	a.DT_ATUALIZACAO,
	a.NM_USUARIO,
	a.DT_ATUALIZACAO_NREC,
	a.NM_USUARIO_NREC,
	a.NR_SEQ_ELEMENTO,
	a.NR_SEQ_APRES,
	a.QT_TAMANHO,
	a.DS_LABEL,
	a.QT_ALTURA,
	a.DS_ELEMENTO,
	a.QT_TAM_GRID,
	a.DS_LABEL_GRID,
	a.DS_MASCARA,
	a.VL_MINIMO,
	a.VL_MAXIMO,
	a.NR_SEQ_GRID,
	a.QT_DESLOC_DIR,
	a.IE_OBRIGATORIO,
	a.IE_READONLY,
	a.IE_TABSTOP,
	a.VL_PADRAO,
	a.NR_SEQ_ELEM_VISUAL,
	a.IE_OPCIONAL,
	a.IE_VAZIO,
	a.DS_SQL,
	a.IE_COPIA,
	a.IE_ENTIDADE,
	a.NR_SEQ_ELEM_SUP,
	a.NR_SEQ_TEMPLATE_CLUSTER,
	a.QT_COLUNA,
	a.IE_WORDWRAP,
	a.DS_FORMULA,
	a.IE_ALINHAMENTO,
	a.IE_ITALICO,
	a.IE_NEGRITO,
	a.IE_SUBLINHADO,
	a.DS_COR,
	a.QT_FONTE,
	a.IE_SITUACAO,
	a.IE_MACRO,
	a.NR_SEQ_TEXTO_PADRAO,
	a.QT_POS_ESQ,
	a.NR_SEQ_SINAL_VITAL,
	a.QT_CARACTER,
	a.QT_POS_TOPO,
	a.DS_FUNCTION_GRID,
	a.DS_MSG_AVISO,
	a.IE_BLOQUEIA_AVISO,
	a.IE_MACRO_CONSISTENCIA,
	a.DT_INATIVACAO,
	a.IE_EVOLUCAO,
	a.DS_PROPRIEDADE,
	a.IE_NOVA_LINHA,
	a.IE_SENSIVEL,
	a.IE_INFO_PACIENTE,
	a.IE_COLLAPSED,
	a.IE_CHECKBOX_CLUSTER,
	coalesce(a.ds_label, obter_desc_expressao(b.cd_exp_label_tela, null)) ds_label_field,
	substr(obter_qte_elemento_result(a.nr_seq_elemento),1,3) qt_elemento_result, 
	substr(obter_desc_tipo_openehr(b.nr_seq_tipo_dado),1,50) ds_openehr, 
	c.qt_pos_esquerda, 
	c.qt_topo_campo, 
	c.qt_intervalo_campo,
	b.ie_componente,
	d.nr_seq_temp_reg,
	b.ds_unid_medida,
	coalesce(a.ds_sql,b.ds_sql) ds_sql_lookup,
	coalesce(a.ds_mascara,b.ds_mascara) ds_masc,
	nr_seq_entidade,
	b.nr_seq_localizador,
	b.ie_cliente_cadastra,
	b.ie_tipo_item,
	substr(obter_se_regra_elem_cont(a.nr_sequencia),1,1) ie_possui_regra,
	b.cd_dominio,
	c.ds_msg_campo_obrigatorio,
	c.ie_ficar_grid_cluster,
	c.ie_regra_cluster,
	c.ie_consistir_campo_obrig,
	a.NM_TIME_ZONE_ATTRIBUTE,
	coalesce(a.IS_EMPTY_LABEL,'N') IS_EMPTY_LABEL
from	ehr_elemento_opcional d,
	ehr_elemento b, 
	ehr_template c,
	ehr_template_conteudo a
where	a.nr_seq_elemento = b.nr_sequencia
and	a.nr_seq_template = c.nr_sequencia
and	a.ie_opcional = 'S'
and	a.nr_sequencia = d.nr_seq_temp_conteudo

union

select	a.NR_SEQUENCIA,
	a.NR_SEQ_TEMPLATE,
	a.DT_ATUALIZACAO,
	a.NM_USUARIO,
	a.DT_ATUALIZACAO_NREC,
	a.NM_USUARIO_NREC,
	a.NR_SEQ_ELEMENTO,
	a.NR_SEQ_APRES,
	a.QT_TAMANHO,
	a.DS_LABEL,
	a.QT_ALTURA,
	a.DS_ELEMENTO,
	a.QT_TAM_GRID,
	a.DS_LABEL_GRID,
	a.DS_MASCARA,
	a.VL_MINIMO,
	a.VL_MAXIMO,
	a.NR_SEQ_GRID,
	a.QT_DESLOC_DIR,
	a.IE_OBRIGATORIO,
	a.IE_READONLY,
	a.IE_TABSTOP,
	a.VL_PADRAO,
	a.NR_SEQ_ELEM_VISUAL,
	a.IE_OPCIONAL,
	a.IE_VAZIO,
	a.DS_SQL,
	a.IE_COPIA,
	a.IE_ENTIDADE,
	a.NR_SEQ_ELEM_SUP,
	a.NR_SEQ_TEMPLATE_CLUSTER,
	a.QT_COLUNA,
	a.IE_WORDWRAP,
	a.DS_FORMULA,
	a.IE_ALINHAMENTO,
	a.IE_ITALICO,
	a.IE_NEGRITO,
	a.IE_SUBLINHADO,
	a.DS_COR,
	a.QT_FONTE,
	a.IE_SITUACAO,
	a.IE_MACRO,
	a.NR_SEQ_TEXTO_PADRAO,
	a.QT_POS_ESQ,
	a.NR_SEQ_SINAL_VITAL,
	a.QT_CARACTER,
	a.QT_POS_TOPO,
	a.DS_FUNCTION_GRID,
	a.DS_MSG_AVISO,
	a.IE_BLOQUEIA_AVISO,
	a.IE_MACRO_CONSISTENCIA,
	a.DT_INATIVACAO,
	a.IE_EVOLUCAO,
	a.DS_PROPRIEDADE,
	a.IE_NOVA_LINHA,
	a.IE_SENSIVEL,
	a.IE_INFO_PACIENTE,
	a.IE_COLLAPSED,
	a.IE_CHECKBOX_CLUSTER,
	a.ds_label ds_label_field,
	substr(obter_qte_elemento_result(a.nr_seq_elemento),1,3) qt_elemento_result, 
	null ds_openehr, 
	c.qt_pos_esquerda, 
	c.qt_topo_campo, 
	c.qt_intervalo_campo,
	b.ie_tipo ie_componente,
	d.nr_seq_temp_reg,
	null ds_unid_medida,
	a.ds_sql ds_sql_lookup,
	a.ds_mascara ds_masc,
	0 nr_seq_entidade,
	null nr_seq_localizador, 
	null ie_cliente_cadastra,
	null ie_tipo_item,
	null ie_possui_regra,
	null cd_dominio,
	c.ds_msg_campo_obrigatorio,
	c.ie_ficar_grid_cluster,
	c.ie_regra_cluster,
	c.ie_consistir_campo_obrig,
	a.NM_TIME_ZONE_ATTRIBUTE,
	coalesce(a.IS_EMPTY_LABEL,'N') IS_EMPTY_LABEL
from	ehr_elemento_opcional d,
	ehr_elemento_visual b,
	ehr_template c,
	ehr_template_conteudo a
where	a.nr_seq_elem_visual = b.nr_sequencia
and	a.nr_seq_template = c.nr_sequencia
and	a.ie_opcional = 'S'
and	a.nr_sequencia = d.nr_seq_temp_conteudo;
