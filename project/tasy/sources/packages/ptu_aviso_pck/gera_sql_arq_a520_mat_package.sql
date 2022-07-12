-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_aviso_pck.gera_sql_arq_a520_mat ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, nr_seq_aviso_conta_p ptu_aviso_conta.nr_sequencia%type, dados_gerais_a520_p dados_gerais_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o SQL para a carga dos materiais no A520, vinculados diretamente na conta

-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

			Como e possivel configurar se o A520 vai ser baseado no pos ou pagamento(prestador), alguns calculos
			serao diferentes, inclusive os joins. Somando a possibilidade de usar o pos novo ou antigo, acaba deixando
			com muitas possibilidades e a montagem do SQL dinamico vai deixar muito ilegivel.
			
			Para facilitar a leitura e futuras manutencoes, foi separado a montagem principal conforme parametrizacao.

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ds_sql_w	varchar(32000);
pos_w		alias_t%type;
cta_w		alias_t%type;
mat_w		alias_t%type;


BEGIN

pos_w	:= alias_p.pos;
cta_w	:= alias_p.conta;
mat_w	:= alias_p.material;

-- define se vai ser baseado no pos ou pos aviso

if (coalesce(dados_a520_p.ie_geracao_aviso_cobr, 'PO') in ('PO', 'PA')) then

	if (dados_a520_p.ie_novo_pos_estab = 'N') then -- Pos anterior
		ds_sql_w :=	'select	'||mat_w||'.nr_sequencia nr_seq_conta_mat, '											|| pls_util_pck.enter_w ||
				'	nvl('||pos_w||'.nr_seq_material,'||mat_w||'.nr_seq_material) nr_seq_material, '							|| pls_util_pck.enter_w ||
				'	decode('||mat_w||'.ie_tipo_despesa,''1'',''01'',''2'',''02'',''3'',''03'',''7'',''08'') cd_despesa, '				|| pls_util_pck.enter_w ||
				'	nvl('||pos_w||'.dt_item,'||mat_w||'.dt_atendimento) dt_execucao, '								|| pls_util_pck.enter_w ||
				'	'||pos_w||'.dt_inicio_item hr_inicial, '											|| pls_util_pck.enter_w ||
				'	'||pos_w||'.dt_fim_item hr_final, '												|| pls_util_pck.enter_w ||
				' 	ptu_aviso_pck.gera_cd_tabela(''M'','||mat_w||'.ie_tipo_despesa, null,nvl('||pos_w||'.nr_seq_material,'||mat_w||'.nr_seq_material)) cd_tabela, '    	|| pls_util_pck.enter_w ||
				'	nvl('||mat_w||'.cd_material,'													|| pls_util_pck.enter_w ||
				'		substr(pls_obter_seq_codigo_material('||mat_w||'.nr_seq_material,null),1,255)) cd_mat_envio, '				|| pls_util_pck.enter_w ||
				'	nvl('||pos_w||'.qt_item,1) qt_executada, '											|| pls_util_pck.enter_w ||
				'	nvl(nvl('||mat_w||'.cd_unidade_medida_imp,'||mat_w||'.cd_unidade_medida),''036'') cd_unidade_medida, '				|| pls_util_pck.enter_w ||
				'	ptu_aviso_pck.obter_tx_reducao_acrescimo('||mat_w||'.tx_participacao, null, :ie_via_acesso_mult_p) tx_reducao_acrescimo, '	|| pls_util_pck.enter_w ||
				'	'||pos_w||'.vl_beneficiario/nvl(decode('||pos_w||'.qt_item,0,1,'||pos_w||'.qt_item),1) vl_unitario, '				|| pls_util_pck.enter_w ||
				'	'||pos_w||'.vl_beneficiario vl_total, '												|| pls_util_pck.enter_w ||
				'	nvl(nvl('||pos_w||'.ds_item_convertido,'||pos_w||'.ds_item_ptu),'								|| pls_util_pck.enter_w ||
				'		substr(pls_obter_dados_material('||mat_w||'.nr_seq_material,''DS'',null),1,150)) ds_material, '				|| pls_util_pck.enter_w ||
				'	nvl('||pos_w||'.nr_registro_anvisa,'||mat_w||'.nr_registro_anvisa) nr_registro_anvisa, '					|| pls_util_pck.enter_w ||
				'	nvl('||pos_w||'.cd_ref_fabricante,'||mat_w||'.cd_ref_fabricante) cd_ref_fabricante, '						|| pls_util_pck.enter_w ||
				'	'||mat_w||'.ds_aut_funcionamento cd_autoriz_funcionamento, '									|| pls_util_pck.enter_w ||
				'	'||cta_w||'.nr_sequencia nr_seq_conta, '											|| pls_util_pck.enter_w ||
				'	'||pos_w||'.nr_sequencia nr_seq_conta_pos_estab, '										|| pls_util_pck.enter_w ||
				'	null nr_seq_pos_mat, '														|| pls_util_pck.enter_w ||
				'	''1'' ie_local '														|| pls_util_pck.enter_w ||
				'from	pls_conta_pos_estabelecido '||pos_w||', '											|| pls_util_pck.enter_w ||
				'	pls_conta_mat	'||mat_w||', '													|| pls_util_pck.enter_w ||
				'	pls_conta	'||cta_w||', '													|| pls_util_pck.enter_w ||
				'	ptu_aviso_conta	ac '														|| pls_util_pck.enter_w ||
				'where	'||cta_w||'.nr_sequencia	= ac.nr_seq_conta '										|| pls_util_pck.enter_w ||
				'and	'||cta_w||'.nr_sequencia	= '||mat_w||'.nr_seq_conta '									|| pls_util_pck.enter_w ||
				'and	'||mat_w||'.nr_sequencia	= '||pos_w||'.nr_seq_conta_mat '								|| pls_util_pck.enter_w ||
				'and	'||pos_w||'.nr_seq_mat_rec is null '												|| pls_util_pck.enter_w ||
				'and	'||pos_w||'.nr_seq_disc_mat is null '												|| pls_util_pck.enter_w ||
				'and	'||pos_w||'.nr_seq_lote_fat is null '												|| pls_util_pck.enter_w ||
				'and	'||pos_w||'.ie_status_faturamento = '||case dados_a520_p.ie_geracao_aviso_cobr when 'PA' then '''A''' else '''L''' end		|| pls_util_pck.enter_w ||
				'and	ac.nr_sequencia	= :nr_seq_aviso_conta_p '											|| pls_util_pck.enter_w;

	elsif (dados_a520_p.ie_novo_pos_estab = 'S') then -- Pos novo
		ds_sql_w :=	'select	'||mat_w||'.nr_sequencia nr_seq_conta_mat, '											|| pls_util_pck.enter_w ||
				'	nvl('||pos_w||'.nr_seq_material,'||mat_w||'.nr_seq_material) nr_seq_material, '							|| pls_util_pck.enter_w ||
				'	decode('||mat_w||'.ie_tipo_despesa,''1'',''01'',''2'',''02'',''3'',''03'',''7'',''08'') cd_despesa, '				|| pls_util_pck.enter_w ||
				'	nvl('||pos_w||'.dt_item,'||mat_w||'.dt_atendimento) dt_execucao, '								|| pls_util_pck.enter_w ||
				'	'||mat_w||'.dt_inicio_atend hr_inicial, '											|| pls_util_pck.enter_w ||
				'	'||mat_w||'.dt_fim_atend hr_final, '												|| pls_util_pck.enter_w ||
				' 	ptu_aviso_pck.gera_cd_tabela(''M'','||mat_w||'.ie_tipo_despesa, null,nvl('||pos_w||'.nr_seq_material,'||mat_w||'.nr_seq_material)) cd_tabela, ' 	|| pls_util_pck.enter_w ||
				'	nvl('||mat_w||'.cd_material,'													|| pls_util_pck.enter_w ||
				'		substr(pls_obter_seq_codigo_material('||mat_w||'.nr_seq_material,null),1,255)) cd_mat_envio, '				|| pls_util_pck.enter_w ||
				'	nvl('||pos_w||'.qt_item,1) qt_executada, '											|| pls_util_pck.enter_w ||
				'	nvl(nvl('||mat_w||'.cd_unidade_medida_imp,'||mat_w||'.cd_unidade_medida),''036'') cd_unidade_medida, '				|| pls_util_pck.enter_w ||
				'	ptu_aviso_pck.obter_tx_reducao_acrescimo('||mat_w||'.tx_participacao, null, :ie_via_acesso_mult_p) tx_reducao_acrescimo, '	|| pls_util_pck.enter_w ||
				'	(nvl('||pos_w||'.vl_materiais,0) + nvl('||pos_w||'.vl_lib_taxa_material,0))/ '							|| pls_util_pck.enter_w ||
				'							nvl(decode('||pos_w||'.qt_item,0,1,'||pos_w||'.qt_item),1) vl_unitario, '	|| pls_util_pck.enter_w ||
				'	(nvl('||pos_w||'.vl_materiais,0) + nvl('||pos_w||'.vl_lib_taxa_material,0)) vl_total, '						|| pls_util_pck.enter_w ||
				'	nvl(nvl('||pos_w||'.ds_item_convertido,'||pos_w||'.ds_item_ptu),'								|| pls_util_pck.enter_w ||
				'		substr(pls_obter_dados_material('||mat_w||'.nr_seq_material,''DS'',null),1,150)) ds_material, '				|| pls_util_pck.enter_w ||
				'	nvl('||pos_w||'.nr_registro_anvisa,'||mat_w||'.nr_registro_anvisa) nr_registro_anvisa, '					|| pls_util_pck.enter_w ||
				'	nvl('||pos_w||'.cd_ref_fabricante,'||mat_w||'.cd_ref_fabricante) cd_ref_fabricante, '						|| pls_util_pck.enter_w ||
				'	'||mat_w||'.ds_aut_funcionamento cd_autoriz_funcionamento, '									|| pls_util_pck.enter_w ||
				'	'||cta_w||'.nr_sequencia nr_seq_conta, '											|| pls_util_pck.enter_w ||
				'	null nr_seq_conta_pos_estab, '													|| pls_util_pck.enter_w ||
				'	'||pos_w||'.nr_sequencia nr_seq_pos_mat, '											|| pls_util_pck.enter_w ||
				'	''1'' ie_local '														|| pls_util_pck.enter_w ||
				'from	pls_conta_pos_mat '||pos_w||', '												|| pls_util_pck.enter_w ||
				'	pls_conta_mat	'||mat_w||', '													|| pls_util_pck.enter_w ||
				'	pls_conta	'||cta_w||', '													|| pls_util_pck.enter_w ||
				'	ptu_aviso_conta	ac '														|| pls_util_pck.enter_w ||
				'where	'||cta_w||'.nr_sequencia	= ac.nr_seq_conta '										|| pls_util_pck.enter_w ||
				'and	'||cta_w||'.nr_sequencia	= '||mat_w||'.nr_seq_conta '									|| pls_util_pck.enter_w ||
				'and	'||mat_w||'.nr_sequencia	= '||pos_w||'.nr_seq_conta_mat '								|| pls_util_pck.enter_w ||
				'and	'||pos_w||'.nr_seq_mat_rec is null '												|| pls_util_pck.enter_w ||
				'and	'||pos_w||'.nr_seq_disc_mat is null '												|| pls_util_pck.enter_w ||
				'and	'||pos_w||'.nr_seq_lote_fat is null '												|| pls_util_pck.enter_w ||
				'and	'||pos_w||'.ie_status_faturamento = '||case dados_a520_p.ie_geracao_aviso_cobr when 'PA' then '''A''' else '''L''' end		|| pls_util_pck.enter_w ||
				'and	ac.nr_sequencia	= :nr_seq_aviso_conta_p '											|| pls_util_pck.enter_w;
	end if;
else -- se for no prestador

	ds_sql_w :=	'select	'||mat_w||'.nr_sequencia nr_seq_conta_mat, '												|| pls_util_pck.enter_w ||
			'	'||mat_w||'.nr_seq_material, '														|| pls_util_pck.enter_w ||
			'	decode('||mat_w||'.ie_tipo_despesa,''1'',''01'',''2'',''02'',''3'',''03'',''7'',''08'') cd_despesa, '					|| pls_util_pck.enter_w ||
			'	'||mat_w||'.dt_atendimento dt_execucao, '												|| pls_util_pck.enter_w ||
			'	'||mat_w||'.dt_inicio_atend hr_inicial, '												|| pls_util_pck.enter_w ||
			'	'||mat_w||'.dt_fim_atend hr_final, '													|| pls_util_pck.enter_w ||
			' 	ptu_aviso_pck.gera_cd_tabela(''M'','||mat_w||'.ie_tipo_despesa, null,'||mat_w||'.nr_seq_material) cd_tabela, '    					|| pls_util_pck.enter_w ||
			'	nvl('||mat_w||'.cd_material,'														|| pls_util_pck.enter_w ||
			'		substr(pls_obter_seq_codigo_material('||mat_w||'.nr_seq_material,null),1,255)) cd_mat_envio, '					|| pls_util_pck.enter_w ||
			'	nvl('||mat_w||'.qt_material,1) qt_executada, '												|| pls_util_pck.enter_w ||
			'	nvl(nvl('||mat_w||'.cd_unidade_medida_imp,'||mat_w||'.cd_unidade_medida),''036'') cd_unidade_medida, '					|| pls_util_pck.enter_w ||
			'	nvl('||mat_w||'.tx_reducao_acrescimo_imp, '||mat_w||'.tx_reducao_acrescimo) tx_reducao_acrescimo, '					|| pls_util_pck.enter_w ||
			'	nvl('||mat_w||'.vl_unitario_imp, '||mat_w||'.vl_unitario) vl_unitario, '								|| pls_util_pck.enter_w ||
			'	nvl('||mat_w||'.vl_material_imp, '||mat_w||'.vl_material) vl_total, '									|| pls_util_pck.enter_w ||
			'	substr(pls_obter_dados_material('||mat_w||'.nr_seq_material,''DS'',null),1,150) ds_material, '						|| pls_util_pck.enter_w ||
			'	'||mat_w||'.nr_registro_anvisa, '													|| pls_util_pck.enter_w ||
			'	'||mat_w||'.cd_ref_fabricante, '													|| pls_util_pck.enter_w ||
			'	'||mat_w||'.ds_aut_funcionamento cd_autoriz_funcionamento, '										|| pls_util_pck.enter_w ||
			'	'||cta_w||'.nr_sequencia nr_seq_conta, '												|| pls_util_pck.enter_w ||
			'	null nr_seq_conta_pos_estab, '														|| pls_util_pck.enter_w ||
			'	null nr_seq_pos_mat, '															|| pls_util_pck.enter_w ||
			'	''1'' ie_local '															|| pls_util_pck.enter_w ||
			'from	pls_conta_mat	'||mat_w||', '														|| pls_util_pck.enter_w ||
			'	pls_conta	'||cta_w||', '														|| pls_util_pck.enter_w ||
			'	ptu_aviso_conta	ac '															|| pls_util_pck.enter_w ||
			'where	'||cta_w||'.nr_sequencia	= ac.nr_seq_conta '											|| pls_util_pck.enter_w ||
			'and	ac.nr_seq_conta	= '||mat_w||'.nr_seq_conta '												|| pls_util_pck.enter_w ||
			'and	'||mat_w||'.ie_status	!= ''C'' '													|| pls_util_pck.enter_w ||
			'and	ac.nr_sequencia	= :nr_seq_aviso_conta_p '												|| pls_util_pck.enter_w;
end if;
		
dados_bind_p := sql_pck.bind_variable(':nr_seq_aviso_conta_p', nr_seq_aviso_conta_p, dados_bind_p);
dados_bind_p := sql_pck.bind_variable(':ie_via_acesso_mult_p', dados_a520_p.ie_via_acesso_mult, dados_bind_p);


-- monta os demais filtros


-- Materiais

ds_sql_w := ptu_aviso_pck.add_sql(ds_sql_w, 'and	', dados_bind_p := ptu_aviso_pck.gera_sql_a520_where_mat(dados_a520_p, alias_p, 'S', dados_gerais_a520_p, dados_bind_p));
-- Geral

ds_sql_w := ptu_aviso_pck.add_sql(ds_sql_w, 'and	', dados_bind_p := ptu_aviso_pck.gera_sql_a520_where_geral(dados_a520_p, alias_p, 'N', 'N', dados_bind_p));

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_aviso_pck.gera_sql_arq_a520_mat ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, nr_seq_aviso_conta_p ptu_aviso_conta.nr_sequencia%type, dados_gerais_a520_p dados_gerais_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
