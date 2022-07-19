-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_w_analise_mat_html ( nr_seq_analise_p bigint, nr_seq_conta_p bigint, nr_seq_grupo_p bigint, ie_minha_analise_p text, ie_pendentes_p text, nm_usuario_p text, ie_somente_ocor_p text default 'N', ie_ocultar_canc_p text default 'N', nr_id_transacao_p w_pls_analise_item.nr_id_transacao%type DEFAULT NULL) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Inserir registros visuais (tabela temporária) para os materiais e medicamentos das
contas médicas envolvidas na análise.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
tb_nr_sequencia_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_analise_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_qt_material_imp_w		pls_util_cta_pck.t_number_table;
tb_vl_material_imp_w		pls_util_cta_pck.t_number_table;
tb_vl_unitario_w		pls_util_cta_pck.t_number_table;
tb_vl_material_w		pls_util_cta_pck.t_number_table;
tb_tx_reducao_acrescimo_w	pls_util_cta_pck.t_number_table;
tb_vl_unitario_imp_w		pls_util_cta_pck.t_number_table;
tb_qt_material_w		pls_util_cta_pck.t_number_table;
tb_tx_intercambio_imp_w		pls_util_cta_pck.t_number_table;
tb_tx_intercambio_w		pls_util_cta_pck.t_number_table;
tb_vl_taxa_material_imp_w	pls_util_cta_pck.t_number_table;
tb_vl_taxa_material_w		pls_util_cta_pck.t_number_table;
tb_vl_lib_taxa_material_w	pls_util_cta_pck.t_number_table;
tb_vl_glosa_taxa_material_w	pls_util_cta_pck.t_number_table;
tb_nr_identificador_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_regra_qtde_exec_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_tuss_mat_item_w	pls_util_cta_pck.t_number_table;
tb_qt_liberar_w			pls_util_cta_pck.t_number_table;
tb_qt_cobranca_w		pls_util_cta_pck.t_number_table;
tb_vl_liberado_material_w	pls_util_cta_pck.t_number_table;
tb_vl_glosa_material_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_material_w		pls_util_cta_pck.t_number_table;
tb_vl_glosa_w			pls_util_cta_pck.t_number_table;
tb_vl_liberado_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_mat_w		pls_util_cta_pck.t_number_table;
tb_vl_material_ptu_imp_w	pls_util_cta_pck.t_number_table;
tb_dt_atualizacao_w		pls_util_cta_pck.t_date_table;
tb_dt_atualizacao_nrec_w	pls_util_cta_pck.t_date_table;
tb_dt_atendimento_w		pls_util_cta_pck.t_date_table;
tb_nm_usuario_nrec_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_tipo_linha_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_tipo_item_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_tipo_despesa_w		pls_util_cta_pck.t_varchar2_table_255;
tb_cd_material_ops_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ds_item_w			pls_util_cta_pck.t_varchar2_table_255;
tb_ds_unidade_medida_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ds_item_importacao_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_valor_base_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_item_nao_encontrado_w	pls_util_cta_pck.t_varchar2_table_255;
tb_ie_pagamento_w		pls_util_cta_pck.t_varchar2_table_255;
tb_cd_item_A900_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ds_item_A900_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_pacote_w			pls_util_cta_pck.t_varchar2_table_255;
tb_cd_unidade_medida_w		pls_util_cta_pck.t_varchar2_table_255;
tb_nr_registro_anvisa_w		pls_util_cta_pck.t_varchar2_table_255;
tb_cd_ref_fabricante_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ds_aut_funcionamento_w	pls_util_cta_pck.t_varchar2_table_255;
tb_ie_alto_custo_w		pls_util_cta_pck.t_varchar2_table_255;
tb_cd_tuss_mat_item_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ds_tuss_mat_item_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_pend_grupo_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_status_analise_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ds_status_item_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ds_fornecedor_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_autorizado_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ds_setor_atend_w		pls_util_cta_pck.t_varchar2_table_255;
tb_nm_prestador_pag_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_sem_fluxo_w		pls_util_cta_pck.t_varchar2_table_255;
tb_ie_selecionado_w		pls_util_cta_pck.t_varchar2_table_255;
tb_cd_unidade_medida_a900_w	pls_util_cta_pck.t_varchar2_table_255;
tb_ie_status_item_w		pls_util_cta_pck.t_varchar2_table_255;
tb_seq_guia_w			pls_util_cta_pck.t_varchar2_table_255;
tb_ie_aviso_a520_mat_w		pls_util_cta_pck.t_varchar2_table_5;


index_w				integer	:= 1;
qt_pos_estab_w			integer;
ie_minha_analise_w		varchar(1)	:= 'N';
ie_pendentes_w			varchar(1)	:= 'N';
ds_identacao_w			varchar(30);
nr_nivel_w			bigint;
ie_autorizado_w			varchar(20);
nr_seq_guia_w			pls_conta.nr_seq_guia%type;
cd_guia_w			pls_conta.cd_guia%type;
nm_prestador_solic_w		varchar(255);
nm_prestador_exec_w		varchar(255);
nr_seq_prestador_exec_w		pls_conta.nr_seq_prestador_exec%type;
dt_emissao_conta_w		pls_conta.dt_emissao%type;
nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
ie_tipo_guia_w			varchar(2);
ds_material_w			varchar(255);
nr_nota_fiscal_w		pls_conta_mat.nr_nota_fiscal%type;
nr_seq_prest_fornec_w		bigint;
nr_seq_setor_atend_w		bigint;
ie_glosa_w			pls_conta_mat.ie_glosa%type;
vl_material_ptu_w		pls_conta_mat.vl_material_ptu%type;
ie_exige_nf_w			varchar(3);
nr_seq_restricao_w		bigint;
ie_nota_fiscal_w		varchar(3);
ds_exige_nf_w			varchar(100);
nr_seq_prestador_pgto_w		bigint;
qt_selecao_w			bigint;
cd_material_a900_w		numeric(30);
ds_tipo_guia_w			varchar(255);
nr_seq_mat_ult_w		pls_material.nr_sequencia%type;
ie_param_total_w		varchar(10);
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
ie_somente_ocor_w		varchar(1);
tot_material_w			integer;
ie_ocultar_canc_w		varchar(5);
tp_rede_min_w			pls_util_cta_pck.t_number_table;

C01 CURSOR FOR
	-- todos os materias,  inclusive com glosa / ocorrencia
	SELECT	a.nr_sequencia,
		'IC' ie_tipo_linha, -- Item da conta
		'M' ie_tipo_item, -- Material
		a.ie_tipo_despesa,
		b.cd_material_ops,
		CASE WHEN coalesce(a.dt_inicio_atend::text, '') = '' THEN trunc(a.dt_atendimento)  ELSE to_date(to_char(coalesce(a.dt_atendimento,clock_timestamp()),'dd/mm/yyyy')||to_char(coalesce(a.dt_inicio_atend,clock_timestamp()),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') END  dt_item ,
		substr(coalesce(b.ds_material,'Não encontrado'),1,255) ds_material,
		(	SELECT	substr(x.ds_item_ptu, 1, 255)
			from	pls_conta_mat_regra x
			where	x.nr_sequencia = a.nr_sequencia) ds_material_regra,
		a.qt_material_imp,
		a.vl_material_imp,
		a.vl_unitario,
		a.vl_material,
		a.nr_seq_material nr_seq_material,
		CASE WHEN coalesce(a.tx_reducao_acrescimo,0)=0 THEN 100  ELSE a.tx_reducao_acrescimo END  tx_reducao_acrescimo,
		a.vl_unitario_imp,
		a.vl_glosa,
		a.qt_material,
		a.vl_liberado,
		a.nr_nota_fiscal,
		a.nr_seq_prest_fornec,
		a.nr_seq_setor_atend,
		c.ds_unidade_medida,
		substr((cd_material_imp||' - '||ds_material_imp),1,150) ds_item_importacao,
		a.ie_valor_base,
		a.ie_status,
		CASE WHEN coalesce(b.nr_sequencia::text, '') = '' THEN 'S'  ELSE null END  ie_item_nao_encontrado,
		tx_intercambio_imp,
		tx_intercambio,
		vl_taxa_material_imp,
		vl_taxa_material,
		vl_lib_taxa_material,
		vl_glosa_taxa_material,
		a.ie_glosa,
		a.ie_status_pagamento,
		a.nr_id_analise,
		vl_material_ptu,
		cd_material_imp,
		substr(ds_material_imp,1,255) ds_material_imp,
		a.ie_pacote_ptu,
		a.nr_seq_regra_qtde_exec,
		a.nr_seq_tuss_mat_item,
		a.cd_unidade_medida,
		a.nr_registro_anvisa,
		a.cd_ref_fabricante,
		a.ds_aut_funcionamento,
		a.ie_alto_custo,
		(	select 	count(1)
			from 	pls_conta x,
				pls_conta_mat y 
			where	nr_seq_conta_referencia = d.nr_sequencia
			and	x.nr_sequencia = y.nr_seq_conta
			and	(nr_seq_regra_conta_auto IS NOT NULL AND nr_seq_regra_conta_auto::text <> '')
			and	y.nr_seq_mat_ref = a.nr_sequencia) qt_reg_originados, --identificar se esse item deu origem a outro na abertura de contas mat
		(	select 	tp_rede_min
			from	pls_conta_mat_regra x
			where 	x.nr_sequencia = a.nr_sequencia) tp_rede_min,
		coalesce(a.nr_seq_guia,d.nr_seq_guia) nr_seq_guia,
		(	select	coalesce(max(x.ie_a520), 'N')
			from	pls_conta_mat_regra	x
			where	x.nr_sequencia		= a.nr_sequencia) ie_a520
	FROM pls_conta d, pls_conta_mat a
LEFT OUTER JOIN pls_material b ON (a.nr_seq_material = b.nr_sequencia)
LEFT OUTER JOIN unidade_medida c ON (b.cd_unidade_medida = c.cd_unidade_medida)
WHERE a.nr_seq_conta		= nr_seq_conta_p and d.nr_sequencia		= a.nr_seq_conta and d.ie_status <> 'C' and a.ie_status != 'M' and (a.ie_lanc_manual_pos = 'N' or coalesce(a.ie_lanc_manual_pos::text, '') = '') and ie_somente_ocor_w	= 'N'
	 
union all

	select	a.nr_sequencia,
		'IC' ie_tipo_linha, -- Item da conta
		'M' ie_tipo_item, -- Material
		a.ie_tipo_despesa,
		b.cd_material_ops,
		CASE WHEN coalesce(a.dt_inicio_atend::text, '') = '' THEN trunc(a.dt_atendimento)  ELSE to_date(to_char(coalesce(a.dt_atendimento,clock_timestamp()),'dd/mm/yyyy')||to_char(coalesce(a.dt_inicio_atend,clock_timestamp()),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') END  dt_item ,
		substr(coalesce(b.ds_material,'Não encontrado'),1,255) ds_material,
		(	select	substr(x.ds_item_ptu, 1, 255)
			from	pls_conta_mat_regra x
			where	x.nr_sequencia = a.nr_sequencia) ds_material_regra,
		a.qt_material_imp,
		a.vl_material_imp,
		a.vl_unitario,
		a.vl_material,
		a.nr_seq_material,
		CASE WHEN coalesce(a.tx_reducao_acrescimo,0)=0 THEN 100  ELSE a.tx_reducao_acrescimo END  tx_reducao_acrescimo,
		a.vl_unitario_imp,
		a.vl_glosa,
		a.qt_material,
		a.vl_liberado,
		a.nr_nota_fiscal,
		a.nr_seq_prest_fornec,
		a.nr_seq_setor_atend,
		c.ds_unidade_medida,
		substr((cd_material_imp||' - '||ds_material_imp),1,150) ds_item_importacao,
		a.ie_valor_base,
		a.ie_status,
		CASE WHEN coalesce(b.nr_sequencia::text, '') = '' THEN 'S'  ELSE null END  ie_item_nao_encontrado,
		tx_intercambio_imp,
		tx_intercambio,
		vl_taxa_material_imp,
		vl_taxa_material,
		vl_lib_taxa_material,
		vl_glosa_taxa_material,
		a.ie_glosa,
		a.ie_status_pagamento,
		a.nr_id_analise,
		vl_material_ptu,
		cd_material_imp,
		substr(ds_material_imp,1,255) ds_material_imp,
		a.ie_pacote_ptu,
		a.nr_seq_regra_qtde_exec,
		a.nr_seq_tuss_mat_item,
		a.cd_unidade_medida,
		a.nr_registro_anvisa,
		a.cd_ref_fabricante,
		a.ds_aut_funcionamento,
		a.ie_alto_custo,
		(	select 	count(1) 
			from 	pls_conta x,
				pls_conta_mat y 
			where	nr_seq_conta_referencia = d.nr_sequencia
			and	x.nr_sequencia = y.nr_seq_conta
			and	(nr_seq_regra_conta_auto IS NOT NULL AND nr_seq_regra_conta_auto::text <> '')
			and	y.nr_seq_mat_ref = a.nr_sequencia) qt_reg_originados, --identificar se esse item deu origem a outro na abertura de contas mat
		(	select 	tp_rede_min
			from	pls_conta_mat_regra x
			where 	x.nr_sequencia = a.nr_sequencia) tp_rede_min,
		coalesce(a.nr_seq_guia,d.nr_seq_guia) nr_seq_guia,
		(	select	coalesce(max(x.ie_a520), 'N')
			from	pls_conta_mat_regra	x
			where	x.nr_sequencia		= a.nr_sequencia) ie_a520
	FROM pls_conta d, pls_conta_mat a
LEFT OUTER JOIN pls_material b ON (a.nr_seq_material = b.nr_sequencia)
LEFT OUTER JOIN unidade_medida c ON (b.cd_unidade_medida = c.cd_unidade_medida)
WHERE a.nr_seq_conta		= nr_seq_conta_p and d.nr_sequencia		= a.nr_seq_conta and d.ie_status <> 'C' and a.ie_status != 'M' and (a.ie_lanc_manual_pos = 'N' or coalesce(a.ie_lanc_manual_pos::text, '') = '') and ie_somente_ocor_w	= 'S' and exists (	select	1
				from	pls_conta_glosa
				where	ie_situacao	= 'A'
				and	nr_seq_conta_mat	= a.nr_sequencia
				
union all

				select	1
				from	pls_ocorrencia_benef
				where	ie_situacao	= 'A'
				and	nr_seq_conta_mat	= a.nr_sequencia) order by nr_seq_material;
	
C02 CURSOR( 	nr_seq_conta_mat_w	pls_conta_mat.nr_seq_material%type,
		nr_seq_material_pw	pls_conta_mat.nr_seq_material%type,
		ds_material_pw		pls_material.ds_material%type,
		ds_material_regra_pw	pls_conta_mat_regra.ds_item_ptu%type,
		cd_material_ops_pw	pls_material.cd_material_ops%type,
		ds_identacao_pw		text)FOR
	SELECT	count(1) total,
		sum(a.qt_material_imp) 		qt_material_imp,
		sum(a.vl_material_imp) 		vl_material_imp,
		sum(a.vl_material) 		vl_material,
		nr_seq_material_pw 		nr_seq_material,
		sum(a.vl_glosa) 		vl_glosa,
		sum(qt_material) 		qt_material,
		sum(a.vl_liberado) 		vl_liberado,
		sum(a.vl_taxa_material_imp) 	vl_taxa_material_imp,
		sum(a.vl_taxa_material) 	vl_taxa_material,
		sum(a.vl_lib_taxa_material) 	vl_lib_taxa_material,
		sum(a.vl_glosa_taxa_material) 	vl_glosa_taxa_material,
		max(a.ie_tipo_despesa) 		ie_tipo_despesa,
		substr(ds_identacao_pw || coalesce(ds_material_regra_pw, ds_material_pw),1,255) ds_material, 	-- são as mesmas informações para todos os itens, 
		cd_material_ops_pw cd_material_ops,	   	--alimento aqui apenas por questão de ordenação posteriormente
		CASE WHEN coalesce(max(a.dt_inicio_atend)::text, '') = '' THEN  trunc(max(a.dt_atendimento))  ELSE to_date(to_char(coalesce(max(a.dt_atendimento),clock_timestamp()),'dd/mm/yyyy')				|| to_char(coalesce(max(a.dt_inicio_atend), clock_timestamp()),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') END  dt_item  -- alimenta com a última data para o material, isto para que a rodenação fique correta
	from	pls_conta_mat a,
		pls_conta b
	where	b.nr_sequencia = nr_seq_conta_p
	and	a.nr_seq_conta = b.nr_sequencia
	and (a.ie_lanc_manual_pos = 'N' or coalesce(a.ie_lanc_manual_pos::text, '') = '')
	and	b.ie_status <> 'C'
	and	a.nr_seq_material = nr_seq_conta_mat_w
	and	((ie_ocultar_canc_w = 'N') or
		(ie_ocultar_canc_w = 'S' AND a.ie_status 	<> 'D'));
	
BEGIN

select	count(1)
into STRICT	qt_pos_estab_w
from	pls_conta_pos_estabelecido
where	nr_seq_conta	= nr_seq_conta_p;

select 	max(cd_estabelecimento)
into STRICT 	cd_estabelecimento_w
from	pls_conta
where	nr_sequencia = nr_seq_conta_p;

ie_minha_analise_w	:= coalesce(ie_minha_analise_p,'N');
ie_ocultar_canc_w	:= coalesce(ie_ocultar_canc_p,'N');
ie_pendentes_w		:= coalesce(ie_pendentes_p,'N');
ds_identacao_w		:= '        ';
nr_nivel_w		:= pls_consulta_analise_pck.get_nr_nivel;
ie_somente_ocor_w	:= ie_somente_ocor_p;

ie_param_total_w := coalesce(obter_valor_param_usuario(1365, 34, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w), 'N');

/* Obter dados da conta/guia */

nr_seq_guia_w		:= pls_consulta_analise_pck.get_nr_seq_guia;
ie_autorizado_w		:= pls_consulta_analise_pck.get_ie_autorizado;
cd_guia_w		:= pls_consulta_analise_pck.get_cd_guia;
ds_tipo_guia_w		:= pls_consulta_analise_pck.get_ds_tipo_guia;
nm_prestador_solic_w	:= pls_consulta_analise_pck.get_nm_prestador_solic;
nm_prestador_exec_w	:= pls_consulta_analise_pck.get_nm_prestador_exec;
nr_seq_prestador_exec_w	:= pls_consulta_analise_pck.get_nr_seq_prestador_exec;
dt_emissao_conta_w	:= pls_consulta_analise_pck.get_dt_emissao_conta;
nr_seq_protocolo_w	:= pls_consulta_analise_pck.get_nr_seq_protocolo;
ie_tipo_guia_w		:= pls_consulta_analise_pck.get_ie_tipo_guia;

if (nr_nivel_w > 0) then
	for r_C01_w in C01 loop
		
		--Se materiail estiver cancelado e identificado que o cancelamento foi devido a regra de abertura de contas para materiais, então não exibe o material

		--cancelado. O qt_reg_originados > 0 representa um item lançado por essa abertura de contas
		if	not(r_C01_w.ie_status = 'D' and r_C01_w.qt_reg_originados > 0) then
			-- verifica o parâmetro do totalizador
			if (ie_param_total_w = 'S') then
				-- gera apenas uma vez por material por este motivo sempre que for diferente deve gerar

				-- colocado NVL pois caso algum material não seja encontrado ainda sim deve gerar um totalizador
				if (coalesce(nr_seq_mat_ult_w, -1) != coalesce(r_C01_w.nr_seq_material, -1)) then
					tot_material_w := 0;
					for r_C02_w in C02(	r_C01_w.nr_seq_material, r_C01_w.nr_seq_material,  r_C01_w.ds_material,
								r_C01_w.ds_material_regra, r_C01_w.cd_material_ops, ds_identacao_w) loop
								
						tot_material_w := r_C02_w.total;
						if (r_C02_w.total > 1) then
							tb_ie_tipo_linha_w(index_w) 		:= 'T';
							tb_ie_tipo_item_w(index_w)		:= 'M';
							tb_qt_material_imp_w(index_w)		:= r_C02_w.qt_material_imp;
							tb_vl_material_imp_w(index_w)		:= r_C02_w.vl_material_imp;
							tb_vl_material_w(index_w)		:= r_C02_w.vl_material;
							tb_nr_seq_material_w(index_w)		:= r_C02_w.nr_seq_material;
							tb_vl_glosa_w(index_w)			:= r_C02_w.vl_glosa;
							tb_qt_material_w(index_w)		:= r_C02_w.qt_material;
							tb_vl_liberado_w(index_w)		:= r_C02_w.vl_liberado;
							tb_vl_taxa_material_imp_w(index_w)	:= r_C02_w.vl_taxa_material_imp;
							tb_vl_taxa_material_w(index_w)		:= r_C02_w.vl_taxa_material;
							tb_vl_lib_taxa_material_w(index_w)	:= r_C02_w.vl_lib_taxa_material;
							tb_vl_glosa_taxa_material_w(index_w)	:= r_C02_w.vl_glosa_taxa_material;
							tb_ie_tipo_despesa_w(index_w)		:= r_C02_w.ie_tipo_despesa;
							tb_ds_item_w(index_w)			:= r_C02_w.ds_material;
							tb_cd_material_ops_w(index_w)		:= r_C02_w.cd_material_ops;
							tb_dt_atendimento_w(index_w)		:= r_C02_w.dt_item;
						end if;
					end loop;
					
					--Solicitado na OS 1110733 para que não seja exibida a linha totalizadora de materiais quando tiver apenas uma linha de material, por exemplo, se na análise

					--tiver duas linhas do material  Luvas especiais, e uma seringa, então apenas será gerada uma linha totalizadora para luvas especiais. Caso tiverem duas linhas

					--de cada um dos materiais, então será gerada uma linha totalizadora para luvas especiais e outra para seringa.
					if ( tot_material_w > 1) then			
						tb_nr_seq_analise_w(index_w) := null;
						tb_nr_seq_conta_w(index_w) := null;
						tb_vl_unitario_w(index_w) := null;
						tb_tx_reducao_acrescimo_w(index_w) := null;
						tb_vl_unitario_imp_w(index_w) := null;
						tb_tx_intercambio_imp_w(index_w) := null;
						tb_tx_intercambio_w(index_w) := null;
						tb_nr_identificador_w(index_w) := null;
						tb_nr_seq_regra_qtde_exec_w(index_w) := null;
						tb_nr_seq_tuss_mat_item_w(index_w) := null;
						tb_qt_liberar_w(index_w) := null;
						tb_qt_cobranca_w(index_w) := null;
						tb_vl_liberado_material_w(index_w) := null;
						tb_vl_glosa_material_w(index_w) := null;
						tb_nr_seq_conta_mat_w(index_w) := null;
						tb_vl_material_ptu_imp_w(index_w) := null;
						tb_dt_atualizacao_w(index_w) := null;
						tb_dt_atualizacao_nrec_w(index_w) := null;
						tb_dt_atendimento_w(index_w) := null;
						tb_nm_usuario_nrec_w(index_w) := null;
						tb_ds_unidade_medida_w(index_w) := null;
						tb_ds_item_importacao_w(index_w) := null;
						tb_ie_valor_base_w(index_w) := null;
						tb_ie_item_nao_encontrado_w(index_w) := null;
						tb_ie_pagamento_w(index_w) := null;
						tb_cd_item_A900_w(index_w) := null;
						tb_ds_item_A900_w(index_w) := null;
						tb_ie_pacote_w(index_w) := null;
						tb_cd_unidade_medida_w(index_w) := null;
						tb_nr_registro_anvisa_w(index_w) := null;
						tb_cd_ref_fabricante_w(index_w) := null;
						tb_ds_aut_funcionamento_w(index_w) := null;
						tb_ie_alto_custo_w(index_w) := null;
						tb_cd_tuss_mat_item_w(index_w) := null;
						tb_ds_tuss_mat_item_w(index_w) := null;
						tb_ie_pend_grupo_w(index_w) := null;
						tb_ie_status_analise_w(index_w) := null;
						tb_ds_status_item_w(index_w) := null;
						tb_ds_fornecedor_w(index_w) := null;
						tb_ie_autorizado_w(index_w) := null;
						tb_ds_setor_atend_w(index_w) := null;
						tb_nm_prestador_pag_w(index_w) := null;
						tb_ie_sem_fluxo_w(index_w) := null;
						tb_ie_selecionado_w(index_w) := null;
						tb_cd_unidade_medida_a900_w(index_w) := null;
						tb_ie_status_item_w(index_w) := null;
						tp_rede_min_w(index_w)	:= null;
						tb_seq_guia_w(index_w)	:= null;
						tb_ie_aviso_a520_mat_w(index_w) := null;
						tb_nr_sequencia_w(index_w) := pls_consulta_analise_pck.get_nr_seq_item;
						
						
						CALL pls_consulta_analise_pck.set_nr_seq_item(tb_nr_sequencia_w(index_w) + 1);

						index_w := index_w + 1;
					end if;
				end if;
			end if;

			tb_nr_seq_conta_w(index_w)		:= nr_seq_conta_p;
			tb_nr_seq_conta_mat_w(index_w)		:= r_C01_w.nr_sequencia;
			tb_ie_tipo_linha_w(index_w)		:= r_C01_w.ie_tipo_linha;
			tb_ie_tipo_item_w(index_w)		:= r_C01_w.ie_tipo_item;
			tb_ie_tipo_despesa_w(index_w)		:= r_C01_w.ie_tipo_despesa;
			tb_cd_material_ops_w(index_w)		:= r_C01_w.cd_material_ops;
			tb_dt_atendimento_w(index_w)		:= r_C01_w.dt_item;
			ds_material_w				:= coalesce(r_C01_w.ds_material_regra, r_C01_w.ds_material);
			tb_qt_material_imp_w(index_w)		:= r_C01_w.qt_material_imp;
			tb_vl_material_imp_w(index_w)		:= r_C01_w.vl_material_imp;
			tb_vl_unitario_w(index_w)		:= r_C01_w.vl_unitario;
			tb_vl_material_w(index_w)		:= r_C01_w.vl_material;
			tb_nr_seq_material_w(index_w)		:= r_C01_w.nr_seq_material;
			tb_tx_reducao_acrescimo_w(index_w)	:= r_C01_w.tx_reducao_acrescimo;
			tb_vl_unitario_imp_w(index_w)		:= r_C01_w.vl_unitario_imp;
			tb_vl_glosa_w(index_w)			:= r_C01_w.vl_glosa;
			tb_qt_material_w(index_w)		:= r_C01_w.qt_material;
			tb_vl_liberado_w(index_w)		:= r_C01_w.vl_liberado;
			nr_nota_fiscal_w			:= r_C01_w.nr_nota_fiscal;
			nr_seq_prest_fornec_w			:= r_C01_w.nr_seq_prest_fornec;
			nr_seq_setor_atend_w			:= r_C01_w.nr_seq_setor_atend;
			tb_ds_unidade_medida_w(index_w)		:= r_C01_w.ds_unidade_medida;
			tb_ds_item_importacao_w(index_w)	:= r_C01_w.ds_item_importacao;
			tb_ie_valor_base_w(index_w)		:= r_C01_w.ie_valor_base;
			tb_ie_status_item_w(index_w)		:= r_C01_w.ie_status;
			tb_ie_item_nao_encontrado_w(index_w)	:= r_C01_w.ie_item_nao_encontrado;
			tb_tx_intercambio_imp_w(index_w)	:= r_C01_w.tx_intercambio_imp;
			tb_tx_intercambio_w(index_w)		:= r_C01_w.tx_intercambio;
			tb_vl_taxa_material_imp_w(index_w)	:= r_C01_w.vl_taxa_material_imp;
			tb_vl_taxa_material_w(index_w)		:= r_C01_w.vl_taxa_material;
			tb_vl_lib_taxa_material_w(index_w)	:= r_C01_w.vl_lib_taxa_material;
			tb_vl_glosa_taxa_material_w(index_w)	:= r_C01_w.vl_glosa_taxa_material;
			ie_glosa_w				:= r_C01_w.ie_glosa;
			tb_ie_pagamento_w(index_w)		:= r_C01_w.ie_status_pagamento;
			tb_nr_identificador_w(index_w)		:= r_C01_w.nr_id_analise;
			vl_material_ptu_w			:= r_C01_w.vl_material_ptu;
			tb_cd_item_A900_w(index_w)		:= r_C01_w.cd_material_imp;
			tb_ds_item_A900_w(index_w)		:= r_C01_w.ds_material_imp;
			tb_ie_pacote_w(index_w)			:= r_C01_w.ie_pacote_ptu;
			tb_nr_seq_regra_qtde_exec_w(index_w)	:= r_C01_w.nr_seq_regra_qtde_exec;
			tb_nr_seq_tuss_mat_item_w(index_w)	:= r_C01_w.nr_seq_tuss_mat_item;
			tb_cd_unidade_medida_w(index_w)		:= r_C01_w.cd_unidade_medida;
			tb_nr_registro_anvisa_w(index_w)	:= r_C01_w.nr_registro_anvisa;
			tb_cd_ref_fabricante_w(index_w)		:= r_C01_w.cd_ref_fabricante;
			tb_ds_aut_funcionamento_w(index_w)	:= r_C01_w.ds_aut_funcionamento;
			tb_ie_alto_custo_w(index_w)		:= r_C01_w.ie_alto_custo;
			tp_rede_min_w(index_w)			:= r_C01_w.tp_rede_min;
			tb_seq_guia_w(index_w)			:= r_C01_w.nr_seq_guia;
			tb_ie_aviso_a520_mat_w(index_w)		:= r_C01_w.ie_a520;

			tb_cd_tuss_mat_item_w(index_w)		:= null;
			tb_ds_tuss_mat_item_w(index_w)		:= null;
			tb_ie_pend_grupo_w(index_w)		:= null;							
			tb_ie_pend_grupo_w(index_w)		:= pls_obter_pend_grupo_analise(nr_seq_analise_p,nr_seq_conta_p, null, tb_nr_seq_conta_mat_w(index_w),
												null,nr_seq_grupo_p, 'N');
			tb_ie_selecionado_w(index_w)		:= 'N';

			/* Obter o status geral de análise do item */

			tb_ie_status_analise_w(index_w)		:= pls_obter_status_analise_item(nr_seq_analise_p,null, null, tb_nr_seq_conta_mat_w(index_w),
												null, tb_ie_item_nao_encontrado_w(index_w),'N');
												
			if (tb_ie_status_analise_w(index_w) = 'V') and (tb_ie_pend_grupo_w(index_w) = 'S') then
				tb_ie_status_analise_w(index_w) := 'A';
			end if;		
												
			tb_ds_status_item_w(index_w)		:= null;
			tb_ie_autorizado_w(index_w)		:= null;
			tb_ds_fornecedor_w(index_w)		:= null;
			tb_ds_setor_atend_w(index_w)		:= null;
			tb_nm_prestador_pag_w(index_w)		:= null;
			tb_qt_liberar_w(index_w)		:= null;
			tb_ie_sem_fluxo_w(index_w)		:= null;
			tb_qt_cobranca_w(index_w)		:= 0;
			tb_cd_unidade_medida_a900_w(index_w)	:= null;
			tb_vl_liberado_material_w(index_w)	:= null;
			tb_vl_glosa_material_w(index_w)		:= 0;
			tb_vl_material_ptu_imp_w(index_w)	:= 0;
			
			if	(((ie_minha_analise_w = 'S') and ((tb_ie_pend_grupo_w(index_w) IS NOT NULL AND (tb_ie_pend_grupo_w(index_w))::text <> ''))) or (ie_minha_analise_w = 'N')) and
				((ie_pendentes_w = tb_ie_pend_grupo_w(index_w)) or (tb_ie_status_analise_w(index_w) in ('E','A')) or (ie_pendentes_w = 'N')) or (tb_ie_status_item_w(index_w) = 'A' and tb_vl_material_w(index_w) = 0 and --para listar cmo pendente nos casos de liber com valor apres e calc = 0...Ficava em análise e não era
				tb_vl_material_imp_w(index_w) = 0)then			--listado como pendente e ao fechar ultimo grupo ele acusava item pendente devido ao status
				
				if (ie_ocultar_canc_w = 'N') or
					((ie_ocultar_canc_w = 'S') and (tb_ie_status_analise_w(index_w) <> 'C')) then
					if (nr_nota_fiscal_w IS NOT NULL AND nr_nota_fiscal_w::text <> '')then
						ie_exige_nf_w	:= 'S';	--Entregue
					else
						nr_seq_restricao_w := pls_obter_mat_restricao_data(tb_nr_seq_material_w(index_w), coalesce(tb_dt_atendimento_w(index_w),dt_emissao_conta_w), nr_seq_restricao_w);

						ie_exige_nf_w := 'N';

						if (nr_seq_restricao_w > 0) then
							select	coalesce(ie_nota_fiscal,'N')
							into STRICT	ie_nota_fiscal_w
							from	pls_material_restricao
							where	nr_sequencia	= nr_seq_restricao_w;

							if (ie_nota_fiscal_w = 'S') then
								ie_exige_nf_w := 'E';
							end if;
						end if;
					end if;
					
					if (ie_exige_nf_w = 'S') then
						ds_exige_nf_w := 'Entregue';
					elsif (ie_exige_nf_w = 'N') then
						ds_exige_nf_w := 'Não entregue';
					elsif (ie_exige_nf_w = 'E') then	
						ds_exige_nf_w := 'Exige';
					else
						ds_exige_nf_w := '';
					end if;

					begin
						tb_ds_item_w(index_w)	:= ds_identacao_w || ds_material_w;
					exception
					when others then
						tb_ds_item_w(index_w)	:= substr(ds_identacao_w || ds_material_w,1,255);
					end;
									
					if ((tb_ie_status_item_w(index_w) IS NOT NULL AND (tb_ie_status_item_w(index_w))::text <> '')) then
						select	ds_valor_dominio
						into STRICT	tb_ds_status_item_w(index_w)
						from	valor_dominio_v
						where	cd_dominio	= 1870
						and	vl_dominio	= tb_ie_status_item_w(index_w);
					end if;
					
					if (nr_seq_prest_fornec_w IS NOT NULL AND nr_seq_prest_fornec_w::text <> '') then
						tb_ds_fornecedor_w(index_w)	:= pls_obter_dados_prestador(nr_seq_prest_fornec_w,'N');
					end if;
					
					if (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
						select	CASE WHEN count(1)=0 THEN  'N'  ELSE ie_autorizado_w END
						into STRICT	tb_ie_autorizado_w(index_w)
						from	pls_guia_plano_mat	a
						where	a.nr_seq_guia		= nr_seq_guia_w
						and	a.nr_seq_material	= tb_nr_seq_material_w(index_w);
					end if;
					
					if (nr_seq_setor_atend_w IS NOT NULL AND nr_seq_setor_atend_w::text <> '') then
						select	max(ds_setor_atendimento)
						into STRICT	tb_ds_setor_atend_w(index_w)
						from	pls_setor_atendimento
						where 	nr_sequencia	= nr_seq_setor_atend_w;

					end if;
					
					if (coalesce(tb_ie_pagamento_w(index_w)::text, '') = '') then
						tb_ie_pagamento_w(index_w)	:= pls_analise_obter_status_pag(tb_ie_status_item_w(index_w),tb_qt_material_imp_w(index_w),tb_qt_material_w(index_w),
														tb_vl_material_imp_w(index_w),tb_vl_material_w(index_w),tb_vl_liberado_w(index_w),
														tb_vl_glosa_w(index_w), ie_glosa_w);
					end if;
					
					select  max(nr_seq_prestador_pgto),
						max(nm_prestador_pgto)
					into STRICT	nr_seq_prestador_pgto_w,
						tb_nm_prestador_pag_w(index_w)
					from    pls_conta_medica_resumo
					where   nr_seq_conta           = nr_seq_conta_p
					and	nr_seq_conta_mat       = tb_nr_seq_conta_mat_w(index_w)
					and	ie_situacao 	       = 'A';
						
					if (coalesce(tb_nm_prestador_pag_w(index_w)::text, '') = '') and (nr_seq_prestador_pgto_w IS NOT NULL AND nr_seq_prestador_pgto_w::text <> '') then
						tb_nm_prestador_pag_w(index_w)		:= substr(pls_obter_dados_prestador(nr_seq_prestador_pgto_w,'N'),1,255);
					end if;
					
					/* Obter se possui fluxo de análise */

					tb_ie_sem_fluxo_w(index_w)	:= pls_obter_se_item_sem_fluxo(nr_seq_analise_p,null, null, tb_nr_seq_conta_mat_w(index_w),null);
					
					tb_nr_sequencia_w(index_w)	:= pls_consulta_analise_pck.get_nr_seq_item;
					
					if (pls_consulta_analise_pck.get_se_selecao) then
						select	count(1),
							max(qt_liberar)
						into STRICT	qt_selecao_w,
							tb_qt_liberar_w(index_w)
						from	w_pls_analise_selecao_item	a
						where	a.nr_seq_analise	= nr_seq_analise_p
						and	a.nr_seq_w_item		= tb_nr_sequencia_w(index_w);
					end if;
					
					if (qt_selecao_w > 0) then
						tb_ie_selecionado_w(index_w)	:= 'S';
					else
						tb_ie_selecionado_w(index_w)	:= 'N';
					end if;
					
					if (coalesce(tb_qt_material_w(index_w),0) = 0) then
						tb_vl_unitario_w(index_w)	:= 0;
					else
						tb_vl_unitario_w(index_w)	:= round((tb_vl_material_w(index_w) / tb_qt_material_imp_w(index_w))::numeric, 4);
					end if;

					tb_ds_item_a900_w(index_w)		:= null;
					if (trim(both tb_cd_item_A900_w(index_w)) is not null) then
						
						cd_material_a900_w := somente_numero(tb_cd_item_A900_w(index_w));
					
						if (coalesce(cd_material_a900_w,0) > 0) then
							if (tb_dt_atendimento_w(index_w)	is  not null) then
								select	max(u.cd_unidade_medida),
									max(u.nm_material)
								into STRICT	tb_cd_unidade_medida_a900_w(index_w),
									tb_ds_item_a900_w(index_w)
								from	pls_material_unimed u
								where	u.nr_sequencia = (SELECT max(m.nr_sequencia)
											  from	pls_material_unimed m
											  where m.cd_material = cd_material_a900_w
											  and	tb_dt_atendimento_w(index_w) between trunc(m.dt_inicio_vigencia) and fim_mes(m.dt_fim_vigencia));
							else
								select	max(u.cd_unidade_medida),
									max(u.nm_material)
								into STRICT	tb_cd_unidade_medida_a900_w(index_w),
									tb_ds_item_a900_w(index_w)
								from	pls_material_unimed u
								where	u.nr_sequencia = (SELECT max(m.nr_sequencia)
											  from	pls_material_unimed m
											  where m.cd_material = cd_material_a900_w);
							end if;
						end if;
					end if;
					
					if (qt_pos_estab_w > 0) then
						begin
							select	coalesce(a.qt_item,0)
							into STRICT	tb_qt_cobranca_w(index_w)
							from	pls_conta_pos_estabelecido a
							where	a.nr_seq_conta_mat = tb_nr_seq_conta_mat_w(index_w);
						exception
							when others then
							tb_qt_cobranca_w(index_w):= 0;
						end;
					end if;
					
					tb_vl_liberado_material_w(index_w)	:= tb_vl_liberado_w(index_w) - tb_vl_lib_taxa_material_w(index_w);
					
					if (tb_vl_liberado_material_w(index_w) < 0) then
						tb_vl_liberado_material_w(index_w) := 0;
					end if;
					
					tb_vl_glosa_material_w(index_w)	:= tb_vl_glosa_w(index_w) - tb_vl_glosa_taxa_material_w(index_w);
					
					if (tb_vl_glosa_material_w(index_w) < 0) then
						tb_vl_glosa_material_w(index_w)	:= 0;
					end if;
					
					/*Obter dados para o tuss*/

					if ((tb_nr_seq_tuss_mat_item_w(index_w) IS NOT NULL AND (tb_nr_seq_tuss_mat_item_w(index_w))::text <> ''))	then
						tb_cd_tuss_mat_item_w(index_w)	:= obter_dados_mat_tuss(tb_nr_seq_tuss_mat_item_w(index_w),'C');
						tb_ds_tuss_mat_item_w(index_w)	:= substr(obter_dados_mat_tuss(tb_nr_seq_tuss_mat_item_w(index_w),'D'),1,255);
					end if;
					
					tb_vl_material_ptu_imp_w(index_w)	:= tb_vl_material_imp_w(index_w) - tb_vl_taxa_material_imp_w(index_w);
					
					-- variável que controla o totalizador dos materiais
					nr_seq_mat_ult_w := r_C01_w.nr_seq_material;
					
					if (tb_ie_status_item_w(index_w) <> 'D') then
						begin
						CALL pls_consulta_analise_pck.set_vl_apresentado(tb_vl_material_imp_w(index_w));
						CALL pls_consulta_analise_pck.set_vl_calculado(tb_vl_material_w(index_w));
						CALL pls_consulta_analise_pck.set_vl_liberado(tb_vl_liberado_w(index_w));
						CALL pls_consulta_analise_pck.set_vl_glosado(tb_vl_glosa_w(index_w));
						CALL pls_consulta_analise_pck.set_vl_taxa(tb_vl_taxa_material_w(index_w));
						end;
					end if;
					CALL pls_consulta_analise_pck.set_nr_seq_item(tb_nr_sequencia_w(index_w) + 1);
					index_w := index_w + 1;
				end if;
			end if;		
		end if;
	end loop;
	if (tb_nr_sequencia_w.count > 0) then
		forall i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last			
			insert into w_pls_analise_item(nr_sequencia, nm_usuario, dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec,
							nr_seq_analise, nr_seq_conta, ie_tipo_linha, ie_tipo_item, ie_tipo_despesa, 
							cd_item, dt_item, ds_item, qt_apresentada, vl_apresentado,			
							vl_calculado_unitario, vl_calculado, nr_seq_material, tx_item, vl_unitario_apres,
							vl_glosa, qt_liberado, vl_liberado, nr_seq_guia, cd_guia, 
							ie_autoriz_previa, ds_tipo_guia, nm_prestador_solic, nm_prestador_exec, nm_prestador_pag,
							nr_seq_prestador_exec, ds_fornecedor, ds_setor_atend, ds_unidade_medida, ds_item_importacao,
							nr_seq_conta_mat, ie_valor_base, ie_pagamento, ie_status_item, ds_status_item,
							ie_status_analise, ie_pend_grupo, ie_item_nao_encontrado, ie_selecionado, qt_liberar,
							ie_sem_fluxo, ie_tipo_guia, tx_intercambio_imp, tx_intercambio,	vl_taxa_material_imp,
							vl_taxa_material, vl_lib_taxa_material, vl_glosa_taxa_material, nr_identificador, vl_material_ptu_imp,
							vl_procedimento_ptu_imp, vl_co_ptu_imp, cd_material_A900, ds_material_A900, ie_pacote_ptu,
							qt_cobranca, vl_liberado_material, vl_glosa_material, nr_seq_regra_qtde_exec, nr_seq_tuss_mat_item,
							cd_tuss_mat_item, ds_tuss_mat_item, cd_unidade_medida_a900, cd_unidade_medida, nr_registro_anvisa,  
							cd_ref_fabricante_imp, ds_aut_funcionamento_imp, ie_alto_custo,
							nr_id_transacao, tp_rede_min, ie_a520)
							
			values (tb_nr_sequencia_w(i), nm_usuario_p, clock_timestamp(), nm_usuario_p, clock_timestamp(),
				nr_seq_analise_p, tb_nr_seq_conta_w(i), tb_ie_tipo_linha_w(i), tb_ie_tipo_item_w(i), tb_ie_tipo_despesa_w(i),	
				tb_cd_material_ops_w(i), tb_dt_atendimento_w(i), tb_ds_item_w(i), tb_qt_material_imp_w(i), tb_vl_material_imp_w(i),
				tb_vl_unitario_w(i), tb_vl_material_w(i), tb_nr_seq_material_w(i), tb_tx_reducao_acrescimo_w(i), tb_vl_unitario_imp_w(i),
				tb_vl_glosa_w(i), tb_qt_material_w(i), tb_vl_liberado_w(i), tb_seq_guia_w(i), cd_guia_w,
				tb_ie_autorizado_w(i), ds_tipo_guia_w, nm_prestador_solic_w, nm_prestador_exec_w, tb_nm_prestador_pag_w(i),		
				nr_seq_prestador_exec_w, tb_ds_fornecedor_w(i), tb_ds_setor_atend_w(i), tb_ds_unidade_medida_w(i), tb_ds_item_importacao_w(i),
				tb_nr_seq_conta_mat_w(i), tb_ie_valor_base_w(i), tb_ie_pagamento_w(i), tb_ie_status_item_w(i), tb_ds_status_item_w(i),	
				tb_ie_status_analise_w(i), tb_ie_pend_grupo_w(i), tb_ie_item_nao_encontrado_w(i), tb_ie_selecionado_w(i), tb_qt_liberar_w(i),			
				tb_ie_sem_fluxo_w(i), ie_tipo_guia_w, tb_tx_intercambio_imp_w(i), tb_tx_intercambio_w(i), tb_vl_taxa_material_imp_w(i),	
				tb_vl_taxa_material_w(i), tb_vl_lib_taxa_material_w(i), tb_vl_glosa_taxa_material_w(i), tb_nr_identificador_w(i), tb_vl_material_ptu_imp_w(i),
				0, 0, tb_cd_item_A900_w(i), tb_ds_item_A900_w(i), tb_ie_pacote_w(i),
				tb_qt_cobranca_w(i), tb_vl_liberado_material_w(i), tb_vl_glosa_material_w(i), tb_nr_seq_regra_qtde_exec_w(i), tb_nr_seq_tuss_mat_item_w(i),
				tb_cd_tuss_mat_item_w(i), tb_ds_tuss_mat_item_w(i), tb_cd_unidade_medida_a900_w(i), tb_cd_unidade_medida_w(i), tb_nr_registro_anvisa_w(i),
				tb_cd_ref_fabricante_w(i), tb_ds_aut_funcionamento_w(i), tb_ie_alto_custo_w(i),
				nr_id_transacao_p,tp_rede_min_w(i), tb_ie_aviso_a520_mat_w(i));					
		commit;
		tp_rede_min_w.delete;
		tb_nr_sequencia_w.delete;
		tb_dt_atualizacao_w.delete;		
		tb_nm_usuario_nrec_w.delete;		
		tb_dt_atualizacao_nrec_w.delete;	
		tb_nr_seq_analise_w.delete;		
		tb_nr_seq_conta_w.delete;		
		tb_ie_tipo_linha_w.delete;		
		tb_ie_tipo_item_w.delete;		
		tb_ie_tipo_despesa_w.delete;		
		tb_cd_material_ops_w.delete;		
		tb_dt_atendimento_w.delete;		
		tb_ds_item_w.delete;			
		tb_qt_material_imp_w.delete;		
		tb_vl_material_imp_w.delete;		
		tb_vl_unitario_w.delete;		
		tb_vl_material_w.delete;		
		tb_tx_reducao_acrescimo_w.delete;	
		tb_vl_unitario_imp_w.delete;		
		tb_qt_material_w.delete;		
		tb_ds_unidade_medida_w.delete;		
		tb_ds_item_importacao_w.delete;		
		tb_ie_valor_base_w.delete;		
		tb_tx_intercambio_imp_w.delete;		
		tb_ie_item_nao_encontrado_w.delete;	
		tb_tx_intercambio_w.delete;		
		tb_vl_taxa_material_imp_w.delete;	
		tb_vl_taxa_material_w.delete;		
		tb_vl_lib_taxa_material_w.delete;	
		tb_vl_glosa_taxa_material_w.delete;	
		tb_ie_pagamento_w.delete;		
		tb_nr_identificador_w.delete;		
		tb_cd_item_A900_w.delete;		
		tb_ds_item_A900_w.delete;		
		tb_ie_pacote_w.delete;			
		tb_nr_seq_regra_qtde_exec_w.delete;	
		tb_nr_seq_tuss_mat_item_w.delete;	
		tb_cd_unidade_medida_w.delete;		
		tb_nr_registro_anvisa_w.delete;		
		tb_cd_ref_fabricante_w.delete;		
		tb_ds_aut_funcionamento_w.delete;	
		tb_ie_alto_custo_w.delete;		
		tb_cd_tuss_mat_item_w.delete;		
		tb_ds_tuss_mat_item_w.delete;		
		tb_ie_pend_grupo_w.delete;		
		tb_ie_status_analise_w.delete;		
		tb_ds_status_item_w.delete;		
		tb_ds_fornecedor_w.delete;		
		tb_ie_autorizado_w.delete;		
		tb_ds_setor_atend_w.delete;	
		tb_nm_prestador_pag_w.delete;	
		tb_ie_sem_fluxo_w.delete;	
		tb_qt_liberar_w.delete;		
		tb_ie_selecionado_w.delete;	
		tb_cd_unidade_medida_a900_w.delete;
		tb_qt_cobranca_w.delete;	
		tb_vl_liberado_material_w.delete;
		tb_vl_glosa_material_w.delete;	
		tb_nr_seq_material_w.delete;	
		tb_vl_glosa_w.delete;		
		tb_vl_liberado_w.delete;	
		tb_nr_seq_conta_mat_w.delete;	
		tb_ie_status_item_w.delete;	
		tb_seq_guia_w.delete;	
		tb_vl_material_ptu_imp_w.delete;
		tb_ie_aviso_a520_mat_w.delete;

	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_w_analise_mat_html ( nr_seq_analise_p bigint, nr_seq_conta_p bigint, nr_seq_grupo_p bigint, ie_minha_analise_p text, ie_pendentes_p text, nm_usuario_p text, ie_somente_ocor_p text default 'N', ie_ocultar_canc_p text default 'N', nr_id_transacao_p w_pls_analise_item.nr_id_transacao%type DEFAULT NULL) FROM PUBLIC;

