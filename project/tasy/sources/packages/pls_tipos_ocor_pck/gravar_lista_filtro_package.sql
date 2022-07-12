-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Insere todos os registros contidos na lista passada por parametro em um unico acesso ao contexto de SQL.

-- Preferimos deixar o Oracle resolver tudo sozinho utilizado o FORALL e as listas por que desenvolver algo para fazer isto nao e viavel.



CREATE OR REPLACE PROCEDURE pls_tipos_ocor_pck.gravar_lista_filtro ( nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nr_seq_conta_p pls_util_cta_pck.t_number_table, nr_seq_conta_proc_p pls_util_cta_pck.t_number_table, nr_seq_conta_mat_p pls_util_cta_pck.t_number_table, nr_seq_segurado_p pls_util_cta_pck.t_number_table, cd_guia_referencia_p pls_util_cta_pck.t_varchar2_table_20, tb_dt_item_p pls_util_cta_pck.t_date_table, tb_dt_hora_ini_p pls_util_cta_pck.t_date_table, tb_dt_hora_fim_p pls_util_cta_pck.t_date_table, tb_dt_dia_ini_p pls_util_cta_pck.t_date_table, tb_dt_dia_fim_p pls_util_cta_pck.t_date_table, tb_ie_origem_proced_p pls_util_cta_pck.t_number_table, tb_cd_procedimento_p pls_util_cta_pck.t_number_table, tb_seq_material_p pls_util_cta_pck.t_number_table, ie_valido_p pls_selecao_ocor_cta.ie_valido%type, nm_usuario_p usuario.nm_usuario%type, dados_filtro_p dados_filtro, dados_regra_p dados_regra) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Insere todos os registros contidos na lista passada por parametro em um unico
	acesso ao contexto de SQL. Serve somente para a manutencao do processamento
	de filtros.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 -
 Alteracao:	Descricao da alteracao.
Motivo:	Descricao do motivo.
 ------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

forall i in nr_seq_conta_p.first..nr_seq_conta_p.last
	insert into pls_selecao_ocor_cta(	nr_sequencia, nr_id_transacao,
			nr_seq_conta, nr_seq_conta_proc,
			nr_seq_conta_mat, nr_seq_filtro,
			nr_seq_segurado, cd_guia_referencia,
			ie_valido, ie_valido_temp,
			ie_excecao, ie_tipo_registro,
			ie_marcado_excecao, dt_item,
			dt_item_hora_ini, dt_item_hora_fim,
			dt_item_dia_ini, dt_item_dia_fim,
			ie_origem_proced, cd_procedimento,
			nr_seq_material, nr_seq_oc_cta_comb)
	values (	nextval('pls_selecao_ocor_cta_seq'), nr_id_transacao_p,
			nr_seq_conta_p(i), nr_seq_conta_proc_p(i),
			nr_seq_conta_mat_p(i), dados_filtro_p.nr_sequencia,
			nr_seq_segurado_p(i), cd_guia_referencia_p(i),
			ie_valido_p, 'S',
			'N', CASE WHEN coalesce(nr_seq_conta_proc_p(i)::text, '') = '' THEN  CASE WHEN coalesce(nr_seq_conta_mat_p(i)::text, '') = '' THEN  'C'  ELSE 'M' END   ELSE 'P' END ,
			'N', tb_dt_item_p(i),
			tb_dt_hora_ini_p(i), tb_dt_hora_fim_p(i),
			tb_dt_dia_ini_p(i), tb_dt_dia_fim_p(i),
			tb_ie_origem_proced_p(i), tb_cd_procedimento_p(i),
			tb_seq_material_p(i),dados_regra_p.nr_sequencia);


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tipos_ocor_pck.gravar_lista_filtro ( nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nr_seq_conta_p pls_util_cta_pck.t_number_table, nr_seq_conta_proc_p pls_util_cta_pck.t_number_table, nr_seq_conta_mat_p pls_util_cta_pck.t_number_table, nr_seq_segurado_p pls_util_cta_pck.t_number_table, cd_guia_referencia_p pls_util_cta_pck.t_varchar2_table_20, tb_dt_item_p pls_util_cta_pck.t_date_table, tb_dt_hora_ini_p pls_util_cta_pck.t_date_table, tb_dt_hora_fim_p pls_util_cta_pck.t_date_table, tb_dt_dia_ini_p pls_util_cta_pck.t_date_table, tb_dt_dia_fim_p pls_util_cta_pck.t_date_table, tb_ie_origem_proced_p pls_util_cta_pck.t_number_table, tb_cd_procedimento_p pls_util_cta_pck.t_number_table, tb_seq_material_p pls_util_cta_pck.t_number_table, ie_valido_p pls_selecao_ocor_cta.ie_valido%type, nm_usuario_p usuario.nm_usuario%type, dados_filtro_p dados_filtro, dados_regra_p dados_regra) FROM PUBLIC;
