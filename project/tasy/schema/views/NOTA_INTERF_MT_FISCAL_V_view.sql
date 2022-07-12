-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW nota_interf_mt_fiscal_v (tp_registro, nr_sequencia, cd_empresa, cd_cgc_emitente, nm_pessoa_fisica, cd_natureza_operacao, nr_nota_fiscal, nr_nota_fiscal_final, cd_modelo_nf, cd_especie_nf, cd_serie_nf, dt_entrada_saida, dt_emissao, sg_estado_destino, sg_estado_origem, ie_cancelada, cd_condicao_pagamento, ds_observacao, cd_operacao_nf, vl_aliquota_icms, vl_total_nota, vl_base_calculo, vl_icms, vl_isento_icms, vl_outros_icms, cd_estabelecimento, cd_item, cd_cst, qt_item_nf, vl_total_item_nf, cd_sit_trib, nr_item_nf, vl_base_icms, vl_base_subst_trib, vl_aliquota_icms_item, vl_iss_item, dt_nascimento_pf, cd_cpf_pf, cd_pessoa_fisica_atend, ds_cpf_pessoa_atend) AS select	distinct
	1	tp_registro, 
	n.nr_sequencia, 
	obter_empresa_estab(n.cd_estabelecimento) cd_empresa, 
	CASE WHEN n.cd_cgc IS NULL THEN  '00351056904'  ELSE n.cd_cgc END  cd_cgc_emitente, 
	substr(obter_nome_pf(n.cd_pessoa_fisica),1,100) nm_pessoa_fisica, 
	CASE WHEN upper(substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'UF'),1,2))='SC' THEN  				CASE WHEN upper(elimina_acentuacao(substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'CI'),1,40)))='FLORIANOPOLIS' THEN  					CASE WHEN n.cd_pessoa_fisica IS NULL THEN '800101'  ELSE '800201' END   ELSE CASE WHEN n.cd_pessoa_fisica IS NULL THEN '800102'  ELSE '800202' END  END   ELSE CASE WHEN n.cd_pessoa_fisica IS NULL THEN '800103'  ELSE '800203' END  END  cd_natureza_operacao, 
	n.nr_nota_fiscal, 
	n.nr_nota_fiscal nr_nota_fiscal_final, 
	0	cd_modelo_nf, 
	0	cd_especie_nf, 
	n.cd_serie_nf, 
	n.dt_entrada_saida, 
	n.dt_emissao, 
	substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'UF'),1,2) sg_estado_destino, 
	substr(obter_dados_pf_pj(null,n.cd_cgc_emitente,'UF'),1,2) sg_estado_origem, 
	CASE WHEN n.ie_situacao=9 THEN 'S'  ELSE 'N' END  ie_cancelada, 
	CASE WHEN substr(obter_descricao_padrao('CONDICAO_PAGAMENTO','IE_FORMA_PAGAMENTO',n.cd_condicao_pagamento),1,1)='1' THEN 'V'  ELSE 'P' END  cd_condicao_pagamento, 
	n.ds_observacao, 
	n.cd_operacao_nf, 
	2	vl_aliquota_icms, 
	n.vl_total_nota, 
	n.vl_total_nota	vl_base_calculo, 
	(n.vl_total_nota * 0.02) vl_icms, 
	0	vl_isento_icms, 
	0	vl_outros_icms, 
	n.cd_estabelecimento, 
	0	cd_item, 
	0	cd_cst, 
	0	qt_item_nf, 
	0	vl_total_item_nf, 
	0	cd_sit_trib, 
	0	nr_item_nf, 
	0	vl_base_icms, 
	0	vl_base_subst_trib, 
	0	vl_aliquota_icms_item, 
	0	vl_iss_item, 
	substr(obter_dados_pf(n.cd_pessoa_fisica,'DN'),1,255) dt_nascimento_pf, 
	substr(obter_cgc_cpf_editado(obter_dados_pf(cd_pessoa_fisica,'CPF')),1,255) cd_cpf_pf, 
	substr(obter_nome_pf(obter_pessoa_pagador_atend(obter_nr_atendimento_nota(n.nr_sequencia))),1,60) CD_PESSOA_FISICA_ATEND,	 
	substr(obter_cgc_cpf_editado(obter_dados_pf(obter_pessoa_pagador_atend(obter_nr_atendimento_nota(n.nr_sequencia)),'CPF')),1,255) DS_CPF_PESSOA_ATEND 
FROM	nota_fiscal n 
where	1=1 

union
 
select	distinct 
	3	tp_registro, 
	n.nr_sequencia, 
	0 cd_empresa, 
	CASE WHEN n.cd_cgc IS NULL THEN  '00351056904'  ELSE n.cd_cgc END  cd_cgc_emitente, 
	substr(obter_nome_pf(n.cd_pessoa_fisica),1,100) nm_pessoa_fisica, 
	' ', 
	n.nr_nota_fiscal, 
		n.nr_nota_fiscal nr_nota_fiscal_final, 
	0	cd_modelo_nf, 
	0	cd_especie_nf, 
	n.cd_serie_nf, 
	n.dt_entrada_saida, 
	n.dt_emissao, 
	' '	sg_estado_destino, 
	' '	sg_estado_origem, 
	' '	ie_cancelada, 
	' '	cd_condicao_pagamento, 
	' '	ds_observacao, 
	n.cd_operacao_nf, 
	0	vl_aliquota_icms, 
	n.vl_total_nota, 
	0	vl_base_calculo, 
	0	vl_icms, 
	0	vl_isento_icms, 
	0	vl_outros_icms, 
	n.cd_estabelecimento, 
	coalesce(i.cd_material,i.cd_procedimento) cd_item, 
	0	cd_cst, 
	i.qt_item_nf, 
	n.vl_total_nota vl_total_item_nf, 
	0	cd_sit_trib, 
	i.nr_item_nf, 
	n.vl_total_nota vl_base_icms, 
	0	vl_base_subst_trib, 
	2	vl_aliquota_icms_item, 
	(n.vl_total_nota * 0.02) vl_iss_item, 
	substr(obter_dados_pf(n.cd_pessoa_fisica,'DN'),1,255) dt_nascimento_pf, 
	substr(obter_cgc_cpf_editado(obter_dados_pf(cd_pessoa_fisica,'CPF')),1,255) cd_cpf_pf, 
	' ' cd_pessoa_fisica_atend, 
	' ' ds_cpf_pessoa_atend 
from	nota_fiscal_item i, 
	nota_fiscal n 
where	n.nr_sequencia = i.nr_sequencia 
and	1=1;
