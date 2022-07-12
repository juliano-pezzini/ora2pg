-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW intpd_envio_pj_v (cd_ans, cd_cep, cd_cgc, cd_cgc_mantenedora, cd_cnes, cd_cnpj_raiz, cd_cond_pagto, cd_conta_contabil, cd_curp, cd_cvm, cd_internacional, cd_municipio_ibge, cd_operadora_empresa, cd_pf_resp_tecnico, cd_portador, cd_rfc, cd_sistema_ant, cd_tipo_pessoa, cd_tipo_portador, ds_bairro, ds_complemento, ds_endereco, ds_municipio, ds_nome_abrev, ds_observacao, ds_observacao_compl, ds_orgao_reg_resp_tecnico, ds_orientacao_cobranca, ds_razao_social, ds_resp_tecnico, ds_senha, ds_site_internet, dt_criacao, dt_integracao, dt_integracao_externa, dt_ultima_revisao, dt_validade_alvara_munic, dt_validade_alvara_sanit, dt_validade_autor_func, dt_validade_cert_boas_prat, dt_validade_resp_tecnico, ie_alterar_senha, ie_empreendedor_individual, ie_forma_revisao, ie_fornecedor_opme, ie_prod_fabric, ie_qualidade, ie_situacao, ie_status_envio, ie_status_exportar, ie_tipo_trib_municipal, ie_tipo_tributacao, ie_transporte, nm_fantasia, nm_usuario_revisao, nr_alvara_sanitario, nr_alvara_sanitario_munic, nr_autor_func, nr_ccm, nr_cei, nr_certificado_boas_prat, nr_ddd_fax, nr_ddd_telefone, nr_ddi_fax, nr_ddi_telefone, nr_endereco, nr_fax, nr_inscricao_estadual, nr_inscricao_municipal, nr_matricula_cei, nr_registro_pls, nr_registro_resp_tecnico, nr_seq_idioma, nr_seq_pais, nr_telefone, sg_estado, id_legal_entity_estab) AS select	DISTINCT
	--decode(:ie_operacao,'I','INSERT','A','UPDATE','E','DELETE') ie_action,
	a.cd_ans cd_ans,
	a.cd_cep cd_cep,
	a.cd_cgc cd_cgc,
	a.cd_cgc_mantenedora cd_cgc_mantenedora,
	a.cd_cnes cd_cnes,
	a.cd_cnpj_raiz cd_cnpj_raiz,
	a.cd_cond_pagto cd_cond_pagto,
	a.cd_conta_contabil cd_conta_contabil,
	a.cd_curp cd_curp,
	a.cd_cvm cd_cvm,
	a.cd_internacional cd_internacional,
	a.cd_municipio_ibge cd_municipio_ibge,
	a.cd_operadora_empresa cd_operadora_empresa,
	a.cd_pf_resp_tecnico cd_pf_resp_tecnico,
	a.cd_portador cd_portador,
	a.cd_rfc cd_rfc,
	a.cd_sistema_ant cd_sistema_ant,
	a.cd_tipo_pessoa cd_tipo_pessoa,
	a.cd_tipo_portador cd_tipo_portador,
	a.ds_bairro ds_bairro,
	a.ds_complemento ds_complemento,
	a.ds_endereco ds_endereco,
	a.ds_municipio ds_municipio,
	a.ds_nome_abrev ds_nome_abrev,
	a.ds_observacao ds_observacao,
	a.ds_observacao_compl ds_observacao_compl,
	a.ds_orgao_reg_resp_tecnico ds_orgao_reg_resp_tecnico,
	a.ds_orientacao_cobranca ds_orientacao_cobranca,
	a.ds_razao_social ds_razao_social,
	a.ds_resp_tecnico ds_resp_tecnico,
	a.ds_senha ds_senha,
	a.ds_site_internet ds_site_internet,
	a.dt_criacao dt_criacao,
	a.dt_integracao dt_integracao,
	a.dt_integracao_externa dt_integracao_externa,
	a.dt_ultima_revisao dt_ultima_revisao,
	a.dt_validade_alvara_munic dt_validade_alvara_munic,
	a.dt_validade_alvara_sanit dt_validade_alvara_sanit,
	a.dt_validade_autor_func dt_validade_autor_func,
	a.dt_validade_cert_boas_prat dt_validade_cert_boas_prat,
	a.dt_validade_resp_tecnico dt_validade_resp_tecnico,
	a.ie_alterar_senha ie_alterar_senha,
	a.ie_empreendedor_individual ie_empreendedor_individual,
	a.ie_forma_revisao ie_forma_revisao,
	a.ie_fornecedor_opme ie_fornecedor_opme,
	a.ie_prod_fabric ie_prod_fabric,
	a.ie_qualidade ie_qualidade,
	a.ie_situacao ie_situacao,
	a.ie_status_envio ie_status_envio,
	a.ie_status_exportar ie_status_exportar,
	a.ie_tipo_trib_municipal ie_tipo_trib_municipal,
	a.ie_tipo_tributacao ie_tipo_tributacao,
	a.ie_transporte ie_transporte,
	a.nm_fantasia nm_fantasia,
	a.nm_usuario_revisao nm_usuario_revisao,
	a.nr_alvara_sanitario nr_alvara_sanitario,
	a.nr_alvara_sanitario_munic nr_alvara_sanitario_munic,
	a.nr_autor_func nr_autor_func,
	a.nr_ccm nr_ccm,
	a.nr_cei nr_cei,
	a.nr_certificado_boas_prat nr_certificado_boas_prat,
	a.nr_ddd_fax nr_ddd_fax,
	a.nr_ddd_telefone nr_ddd_telefone,
	a.nr_ddi_fax nr_ddi_fax,
	a.nr_ddi_telefone nr_ddi_telefone,
	a.nr_endereco nr_endereco,
	a.nr_fax nr_fax,
	a.nr_inscricao_estadual nr_inscricao_estadual,
	a.nr_inscricao_municipal nr_inscricao_municipal,
	a.nr_matricula_cei nr_matricula_cei,
	a.nr_registro_pls nr_registro_pls,
	a.nr_registro_resp_tecnico nr_registro_resp_tecnico,
	a.nr_seq_idioma nr_seq_idioma,
	a.nr_seq_pais nr_seq_pais,
	a.nr_telefone nr_telefone,
	a.sg_estado sg_estado,
	obter_cgc_estabelecimento(wheb_usuario_pck.get_cd_estabelecimento) id_legal_entity_estab
FROM 	pessoa_juridica	a;
