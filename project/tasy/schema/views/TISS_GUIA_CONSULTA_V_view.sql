-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_guia_consulta_v (ie_tipo_dado, cd_ans, cd_guia, dt_emissao_guia, cd_usuario_convenio, nm_pessoa_fisica, ds_plano, dt_validade_carteira, nm_titular, nr_cartao_nac_sus, cd_cgc_cpf_executor, nm_executor, cd_cnes, sg_conselho, nr_crm, uf_crm, cd_cbo_sus, ie_tipo_logradouro, ds_endereco, nr_endereco, ds_complemento, ds_cidade, sg_estado, cd_cidade_ibge, cd_cep, dt_entrada, tp_consulta, nm_solicitante, sg_conselho_solic, nr_crm_solic, sg_estado_solic, cd_cbo_sus_solic, ds_indicacao_clinica, cd_coenca_cid, ie_tipo_doenca, qt_tempo_doenca, ie_tipo_acidente, cd_coneca_cid2, cd_coneca_cid3, cd_coneca_cid4, cd_edicao_amb, cd_procedimento, ds_item, vl_item, ie_tipo_saida) AS SELECT	-- dados beneficiário
	1 ie_tipo_dado,
	b.cd_ans,
	c.cd_guia,
	null dt_emissao_guia,
	d.cd_usuario_convenio,
	f.nm_pessoa_fisica,
	substr(Med_Obter_Desc_Plano(e.nr_seq_plano),1,150) ds_plano,
	e.dt_validade_carteira,
	f.nm_pessoa_fisica nm_titular,
	f.nr_cartao_nac_sus,
	null cd_cgc_cpf_executor,
	null nm_executor,
	null cd_cnes,
	null sg_conselho,
	null nr_crm,
	null uf_crm,
	null cd_cbo_sus,
	null ie_tipo_logradouro,
	null ds_endereco,
	null nr_endereco,
	null ds_complemento,
	null ds_cidade,
	null sg_estado,
	null cd_cidade_ibge,
	null cd_cep,
	null dt_entrada,
	null tp_consulta,
	null nm_solicitante,
	null sg_conselho_solic,
	null nr_crm_solic,
	null sg_estado_solic,
	null cd_cbo_sus_solic,
	null ds_indicacao_clinica,
	null cd_coenca_cid,
	null ie_tipo_doenca,
	null qt_tempo_doenca,
	null ie_tipo_acidente,
	null cd_coneca_cid2,
	null cd_coneca_cid3,
	null cd_coneca_cid4,
	null cd_edicao_amb,
	null cd_procedimento,
	null ds_item,
	null vl_item,
	null ie_tipo_saida
FROM pessoa_fisica f, med_cliente e, med_atendimento d, med_faturamento c, med_prot_convenio a
LEFT OUTER JOIN pessoa_juridica b ON (a.cd_cgc = b.cd_cgc)
WHERE a.nr_sequencia		= c.nr_seq_protocolo and c.nr_atendimento	= d.nr_atendimento and d.nr_seq_cliente	= e.nr_sequencia and e.cd_pessoa_fisica	= f.cd_pessoa_fisica

union all

select	-- dados do executante
	2 ie_tipo_dado,
	null cd_ans,
	null cd_guia,
	null dt_emissao_guia,
	null cd_usuario_convenio,
	null nm_pessoa_fisica,
	null ds_plano,
	null dt_validade_carteira,
	null nm_titular,
	null nr_cartao_nac_sus,
	CASE WHEN a.ie_beneficiario='C' THEN a.cd_cgc  ELSE obter_cpf_pessoa_fisica(a.cd_medico) END  cd_cgc_cpf_executor,
	obter_cpf_pessoa_fisica(a.cd_medico) nm_executor,
	null cd_cnes,
	c.sg_conselho,
	d.nr_crm,
	d.uf_crm,
	b.cd_cbo_sus,
	null ie_tipo_logradouro,
	e.ds_endereco,
	e.nr_endereco,
	e.ds_complemento,
	e.ds_municipio,
	e.sg_estado,
	null cd_cidade_ibge,
	e.cd_cep,
	null dt_entrada,
	null tp_consulta,
	null nm_solicitante,
	null sg_conselho_solic,
	null nr_crm_solic,
	null sg_estado_solic,
	null cd_cbo_sus_solic,
	null ds_indicacao_clinica,
	null cd_coenca_cid,
	null ie_tipo_doenca,
	null qt_tempo_doenca,
	null ie_tipo_acidente,
	null cd_coneca_cid2,
	null cd_coneca_cid3,
	null cd_coneca_cid4,
	null cd_edicao_amb,
	null cd_procedimento,
	null ds_item,
	null vl_item,
	null ie_tipo_saida
from	pessoa_juridica e,
	medico d,
	conselho_profissional c,
	pessoa_fisica b,
	med_prot_convenio a
where	a.cd_medico		= b.cd_pessoa_fisica
and	b.nr_seq_conselho	= c.nr_sequencia
and	b.cd_pessoa_fisica	= d.cd_pessoa_fisica
and	a.cd_cgc		= e.cd_cgc

union all

select	-- dados do atendimento
	3 ie_tipo_dado,
	null cd_ans,
	null cd_guia,
	null dt_emissao_guia,
	null cd_usuario_convenio,
	null nm_pessoa_fisica,
	null ds_plano,
	null dt_validade_carteira,
	null nm_titular,
	null nr_cartao_nac_sus,
	null cd_cgc_cpf_executor,
	null nm_executor,
	null cd_cnes,
	null sg_conselho,
	null nr_crm,
	null uf_crm,
	null cd_cbo_sus,
	null ie_tipo_logradouro,
	null ds_endereco,
	null nr_endereco,
	null ds_complemento,
	null ds_cidade,
	null sg_estado,
	null cd_cidade_ibge,
	null cd_cep,
	b.dt_entrada,
	'' tp_consulta,
	null nm_solicitante,
	null sg_conselho_solic,
	null nr_crm_solic,
	null sg_estado_solic,
	null cd_cbo_sus_solic,
	null ds_indicacao_clinica,
	null cd_coenca_cid,
	null ie_tipo_doenca,
	null qt_tempo_doenca,
	null ie_tipo_acidente,
	null cd_coneca_cid2,
	null cd_coneca_cid3,
	null cd_coneca_cid4,
	null cd_edicao_amb,
	null cd_procedimento,
	null ds_item,
	null vl_item,
	null ie_tipo_saida
from	med_atendimento b,
	med_faturamento a
where	a.nr_atendimento	= b.nr_atendimento

union all

select	-- consulta_referencia
	4 ie_tipo_dado,
	null cd_ans,
	null cd_guia,
	null dt_emissao_guia,
	null cd_usuario_convenio,
	null nm_pessoa_fisica,
	null ds_plano,
	null dt_validade_carteira,
	null nm_titular,
	null nr_cartao_nac_sus,
	null cd_cgc_cpf_executor,
	null nm_executor,
	null cd_cnes,
	null sg_conselho,
	null nr_crm,
	null uf_crm,
	null cd_cbo_sus,
	null ie_tipo_logradouro,
	null ds_endereco,
	null nr_endereco,
	null ds_complemento,
	null ds_cidade,
	null sg_estado,
	null cd_cidade_ibge,
	null cd_cep,
	null dt_entrada,
	null tp_consulta,
	'' nm_solicitante,
	'' sg_conselho_solic,
	'' nr_crm_solic,
	'' sg_estado_solic,
	'' cd_cbo_sus_solic,
	'' ds_indicacao_clinica,
	null cd_coenca_cid,
	null ie_tipo_doenca,
	null qt_tempo_doenca,
	null ie_tipo_acidente,
	null cd_coneca_cid2,
	null cd_coneca_cid3,
	null cd_coneca_cid4,
	null cd_edicao_amb,
	null cd_procedimento,
	null ds_item,
	null vl_item,
	null ie_tipo_saida
from	med_faturamento a

union all

select	-- hipóteses diagnosticas
	5 ie_tipo_dado,
	null cd_ans,
	null cd_guia,
	null dt_emissao_guia,
	null cd_usuario_convenio,
	null nm_pessoa_fisica,
	null ds_plano,
	null dt_validade_carteira,
	null nm_titular,
	null nr_cartao_nac_sus,
	null cd_cgc_cpf_executor,
	null nm_executor,
	null cd_cnes,
	null sg_conselho,
	null nr_crm,
	null uf_crm,
	null cd_cbo_sus,
	null ie_tipo_logradouro,
	null ds_endereco,
	null nr_endereco,
	null ds_complemento,
	null ds_cidade,
	null sg_estado,
	null cd_cidade_ibge,
	null cd_cep,
	null dt_entrada,
	null tp_consulta,
	null nm_solicitante,
	null sg_conselho_solic,
	null nr_crm_solic,
	null sg_estado_solic,
	null cd_cbo_sus_solic,
	null ds_indicacao_clinica,
	'' cd_coenca_cid,
	'' ie_tipo_doenca,
	'' qt_tempo_doenca,
	'' ie_tipo_acidente,
	'' cd_coneca_cid2,
	'' cd_coneca_cid3,
	'' cd_coneca_cid4,
	null cd_edicao_amb,
	null cd_procedimento,
	null ds_item,
	null vl_item,
	null ie_tipo_saida
from	med_faturamento a

union all

select	-- procedimentos realizados
	6 ie_tipo_dado,
	null cd_ans,
	null cd_guia,
	null dt_emissao_guia,
	null cd_usuario_convenio,
	null nm_pessoa_fisica,
	null ds_plano,
	null dt_validade_carteira,
	null nm_titular,
	null nr_cartao_nac_sus,
	null cd_cgc_cpf_executor,
	null nm_executor,
	null cd_cnes,
	null sg_conselho,
	null nr_crm,
	null uf_crm,
	null cd_cbo_sus,
	null ie_tipo_logradouro,
	null ds_endereco,
	null nr_endereco,
	null ds_complemento,
	null ds_cidade,
	null sg_estado,
	null cd_cidade_ibge,
	null cd_cep,
	null dt_entrada,
	null tp_consulta,
	null nm_solicitante,
	null sg_conselho_solic,
	null nr_crm_solic,
	null sg_estado_solic,
	null cd_cbo_sus_solic,
	null ds_indicacao_clinica,
	null cd_coenca_cid,
	null ie_tipo_doenca,
	null qt_tempo_doenca,
	null ie_tipo_acidente,
	null cd_coneca_cid2,
	null cd_coneca_cid3,
	null cd_coneca_cid4,
	'' cd_edicao_amb,
	MED_OBTER_COD_ITEM_CONVENIO(a.NR_ATENDIMENTO, a.NR_SEQ_ITEM) cd_procedimento,
	b.ds_item,
	a.vl_item,
	'' ie_tipo_saida
from	med_item b,
	med_faturamento a
where	a.nr_seq_item	= b.nr_sequencia;
