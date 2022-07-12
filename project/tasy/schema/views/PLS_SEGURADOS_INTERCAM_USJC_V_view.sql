-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_segurados_intercam_usjc_v (tp_registro, tp_arquivo, cd_empresa, cd_unidade_destino, dt_geracao, ie_tipo_remetente, ie_tipo_carga, cd_versao_layout, ie_tipo_movimentacao, reservado_1, reservado_2, reservado_3, reservado_4, reservado_5, nm_beneficiario, ie_sexo, dt_nascimento, ie_estado_civil, nr_cpf, nr_identidade, nr_cbo, ds_endereco, ds_bairro, nr_cep, ds_cidade, ie_uf, ie_grau_parentesco, dt_admissao, dt_inclusao, dt_exclusao, reservado_6, cd_matricula, cd_unidade_atend, cd_unidade_neg, cd_codigo_ant, nr_proposta_intercambio, nr_seq_segurado, ie_responsavel, cd_responsavel, nm_benefe_cartao, nm_internacional, cd_uni_origem_resp, cd_cart_uni_resp, cd_departamento, cd_secao, cd_setor, ie_padrao_cobertura, info_espec_1, info_espec_2, info_espec_3, info_espec_4, nr_pis_pasep, nr_cartao_sus, nm_mae, nm_pai, ie_abrangencia, reservado_7, reservado_8, ie_tipo_contratacao, nr_protocolo_ans, reservado_9, reservado_10, ds_email, cd_vendedor, ds_orgao_emissor, nm_pais, ie_motivo_inclusao, nr_registro_ans, nr_seq_motivo_can, dt_obito, cd_mod_mae, proposta_mae, nr_seq_seg_mae, ds_nacionalidade, ds_nat_doc_ident, sg_emissora_ci, dt_emissao_ci, nr_telefone, nr_cel_benef, nr_tipo_carencia, ie_acomodacao, dt_fim_carencia, reservado_11, qt_total_segurados, nr_seq_intercambio, nr_ordem) AS select	1										tp_registro,
	''										tp_arquivo, 
	CASE WHEN a.cd_cgc IS NULL THEN obter_dados_pf(a.cd_pessoa_fisica,'CSA')  ELSE (	select	max(x.CD_SISTEMA_ANT) 			FROM	pessoa_juridica	x 			where	x.cd_cgc	= a.cd_cgc) END 				cd_empresa, 
	'0004'										cd_unidade_destino, 
	LOCALTIMESTAMP										dt_geracao, 
	'E'										ie_tipo_remetente, 
	'C'										ie_tipo_carga, 
	'0003'										cd_versao_layout, 
	''										ie_tipo_movimentacao, 
	' '										reservado_1, 
	' '										reservado_2, 
	' '										reservado_3, 
	' '										reservado_4, 
	' '										reservado_5, 
	''										nm_beneficiario, 
	''										ie_sexo, 
	null										dt_nascimento, 
	''										ie_estado_civil, 
	''										nr_cpf, 
	''										nr_identidade, 
	''										nr_cbo, 
	''										ds_endereco, 
	''										ds_bairro, 
	''										nr_cep, 
	''										ds_cidade, 
	''										ie_uf, 
	''										ie_grau_parentesco, 
	null										dt_admissao, 
	null										dt_inclusao, 
	null										dt_exclusao, 
	' '										reservado_6, 
	''										cd_matricula, 
	' '										cd_unidade_atend, 
	' '										cd_unidade_neg, 
	''										cd_codigo_ant, 
	null										nr_proposta_intercambio, 
	null										nr_seq_segurado, 
	''										ie_responsavel, 
	null										cd_responsavel, 
	''										nm_benefe_cartao, 
	' '										nm_internacional, 
	' '										cd_uni_origem_resp, 
	' '										cd_cart_uni_resp, 
	' '										cd_departamento, 
	' '										cd_secao, 
	' '										cd_setor, 
	''										ie_padrao_cobertura, 
	' '										info_espec_1, 
	' '										info_espec_2, 
	' '										info_espec_3, 
	' '										info_espec_4, 
	''										nr_pis_pasep, 
	''										nr_cartao_sus, 
	''										nm_mae, 
	''										nm_pai, 
	''										ie_abrangencia, 
	' '										reservado_7, 
	' '										reservado_8, 
	null										ie_tipo_contratacao, 
	null										nr_protocolo_ans, 
	' '										reservado_9, 
	' '										reservado_10, 
	''										ds_email, 
	null										cd_vendedor, 
	''										ds_orgao_emissor, 
	''										nm_pais, 
	''										ie_motivo_inclusao, 
	null										nr_registro_ans, 
	null										nr_seq_motivo_can, 
	null										dt_obito, 
	null										cd_mod_mae, 
	null										proposta_mae, 
	null										nr_seq_seg_mae, 
	''										ds_nacionalidade, 
	' '										ds_nat_doc_ident, 
	''										sg_emissora_ci, 
	null										dt_emissao_ci, 
	''										nr_telefone, 
	''										nr_cel_benef, 
	' '										nr_tipo_carencia, 
	' '										ie_acomodacao, 
	null										dt_fim_carencia, 
	' '										reservado_11, 
	0										qt_total_segurados, 
	a.nr_sequencia									nr_seq_intercambio, 
	0										nr_ordem				 
from	pls_intercambio	a 

union all
 
select	tp_registro, 
	tp_arquivo, 
	cd_empresa, 
	cd_unidade_destino, 
	dt_geracao, 
	ie_tipo_remetente, 
	ie_tipo_carga, 
	cd_versao_layout, 
	ie_tipo_movimentacao, 
	reservado_1, 
	reservado_2, 
	reservado_3, 
	reservado_4, 
	reservado_5, 
	nm_beneficiario, 
	ie_sexo, 
	dt_nascimento, 
	ie_estado_civil, 
	nr_cpf, 
	nr_identidade, 
	nr_cbo, 
	ds_endereco, 
	ds_bairro, 
	nr_cep, 
	ds_cidade, 
	ie_uf, 
	ie_grau_parentesco, 
	dt_admissao, 
	dt_inclusao, 
	dt_exclusao, 
	reservado_6, 
	cd_matricula, 
	cd_unidade_atend, 
	cd_unidade_neg, 
	cd_codigo_ant, 
	nr_proposta_intercambio, 
	nr_seq_segurado, 
	ie_responsavel, 
	cd_responsavel, 
	nm_benefe_cartao, 
	nm_internacional, 
	cd_uni_origem_resp, 
	cd_cart_uni_resp, 
	cd_departamento, 
	cd_secao, 
	cd_setor, 
	ie_padrao_cobertura, 
	info_espec_1, 
	info_espec_2, 
	info_espec_3, 
	info_espec_4, 
	nr_pis_pasep, 
	nr_cartao_sus, 
	nm_mae, 
	nm_pai, 
	ie_abrangencia, 
	reservado_7, 
	reservado_8, 
	ie_tipo_contratacao, 
	nr_protocolo_ans, 
	reservado_9, 
	reservado_10, 
	ds_email, 
	cd_vendedor, 
	ds_orgao_emissor, 
	nm_pais, 
	ie_motivo_inclusao, 
	nr_registro_ans, 
	nr_seq_motivo_can, 
	dt_obito, 
	cd_mod_mae, 
	proposta_mae, 
	nr_seq_seg_mae, 
	ds_nacionalidade, 
	ds_nat_doc_ident, 
	sg_emissora_ci, 
	dt_emissao_ci, 
	nr_telefone, 
	nr_cel_benef, 
	nr_tipo_carencia, 
	ie_acomodacao, 
	dt_fim_carencia, 
	reservado_11, 
	qt_total_segurados, 
	nr_seq_intercambio, 
	nr_ordem 
from (	select	3										tp_registro, 
			''										tp_arquivo, 
			null										cd_empresa, 
			''										cd_unidade_destino, 
			null										dt_geracao, 
			''										ie_tipo_remetente, 
			''										ie_tipo_carga, 
			' '										cd_versao_layout, 
			pls_obter_movimentacao_benef(b.nr_sequencia)					ie_tipo_movimentacao, 
			' '										reservado_1, 
			' '										reservado_2, 
			' '										reservado_3, 
			' '										reservado_4, 
			' '										reservado_5, 
			UPPER(d.nm_pessoa_fisica)							nm_beneficiario, 
			d.ie_sexo									ie_sexo, 
			d.dt_nascimento									dt_nascimento, 
			pls_obter_cod_integracao_gps(d.ie_estado_civil,'E')				ie_estado_civil, 
			d.nr_cpf									nr_cpf, 
			d.nr_identidade									nr_identidade, 
			'000000'									nr_cbo, 
			e.ds_endereco									ds_endereco, 
			e.ds_bairro									ds_bairro, 
			e.cd_cep									nr_cep, 
			UPPER(e.ds_municipio)								ds_cidade, 
			e.sg_estado									ie_uf, 
			CASE WHEN b.nr_seq_parentesco='' THEN '01'  ELSE f.cd_sistema_anterior END 			ie_grau_parentesco, 
			to_char(i.dt_admissao,'YYYYMMDD')						dt_admissao, 
			to_char(b.dt_inclusao_operadora,'YYYYMMDD')					dt_inclusao, 
			to_char(b.dt_rescisao,'YYYYMMDD')						dt_exclusao, 
			' '										reservado_6, 
			b.cd_matricula_estipulante							cd_matricula, 
			' '										cd_unidade_atend, 
			' '										cd_unidade_neg, 
			c.cd_codigo_ant									cd_codigo_ant, 
			a.cd_sistema_anterior								nr_proposta_intercambio, 
			CASE WHEN pls_obter_movimentacao_benef(b.nr_sequencia)='I' THEN ''  ELSE b.nr_sequencia END 	nr_seq_segurado, 
			CASE WHEN b.nr_seq_titular='' THEN 'S'  ELSE 'N' END 						ie_responsavel, 
			0										cd_responsavel, 
			' '										nm_benefe_cartao, 
			' '										nm_internacional, 
			' '										cd_uni_origem_resp, 
			' '										cd_cart_uni_resp, 
			' '										cd_departamento, 
			' '										cd_secao, 
			' '										cd_setor, 
			CASE WHEN c.ie_abrangencia='M' THEN 'F1' WHEN c.ie_abrangencia='GM' THEN 'F1' WHEN c.ie_abrangencia='E' THEN 'F2'  ELSE 'F3' END 			ie_padrao_cobertura, 
			' '										info_espec_1, 
			' '										info_espec_2, 
			' '										info_espec_3, 
			' '										info_espec_4, 
			d.nr_pis_pasep									nr_pis_pasep, 
			d.nr_cartao_nac_sus								nr_cartao_sus, 
			UPPER(substr(obter_nome_mae_pf(d.cd_pessoa_fisica),1,40))			nm_mae, 
			UPPER(substr(obter_compl_pf(d.cd_pessoa_fisica,4,'N'),1,40))			nm_pai, 
			'06'										ie_abrangencia, 
			' '										reservado_7, 
			' '										reservado_8, 
			CASE WHEN c.ie_tipo_contratacao='I' THEN 1 WHEN c.ie_tipo_contratacao='CA' THEN 2 WHEN c.ie_tipo_contratacao='CE' THEN 3 END 				ie_tipo_contratacao, 
			0										nr_protocolo_ans, 
			' '										reservado_9, 
			' '										reservado_10, 
			substr(e.ds_email,1,50)								ds_email, 
			0										cd_vendedor, 
			CASE WHEN d.nr_identidade IS NULL THEN ''  ELSE 'SSP-SECRET.SEGURANCA PUBLICA' END  			ds_orgao_emissor, 
			UPPER(CASE WHEN d.nr_identidade IS NULL THEN ''  ELSE substr(obter_nome_pais(d.nr_seq_pais),1,20) END )	nm_pais, 
			CASE WHEN h.cd_ans='15' THEN 'N' WHEN h.cd_ans='16' THEN 'V' WHEN h.cd_ans='17' THEN 'C' END 					ie_motivo_inclusao, 
			0										nr_registro_ans, 
			pls_obter_cod_integracao_gps(b.nr_seq_motivo_cancelamento,'M')			nr_seq_motivo_can, 
			d.dt_obito									dt_obito, 
			0										cd_mod_mae, 
			0										proposta_mae, 
			0										nr_seq_seg_mae, 
			' '										ds_nacionalidade, 
			'RG'										ds_nat_doc_ident, 
			CASE WHEN d.nr_identidade IS NULL THEN ''  ELSE d.sg_emissora_ci END 				sg_emissora_ci, 
			CASE WHEN d.nr_identidade IS NULL THEN ''  ELSE d.dt_emissao_ci END 					dt_emissao_ci, 
			replace(e.nr_telefone,'-','')							nr_telefone, 
			d.nr_telefone_celular								nr_cel_benef, 
			' '										nr_tipo_carencia, 
			' '										ie_acomodacao, 
			null										dt_fim_carencia, 
			' '										reservado_11, 
			0										qt_total_segurados, 
			a.nr_sequencia									nr_seq_intercambio, 
			coalesce(b.nr_seq_titular,b.nr_sequencia - 1)					nr_ordem 
		FROM compl_pessoa_fisica e, pessoa_fisica d, pls_plano c, pls_intercambio a, pls_segurado b
LEFT OUTER JOIN grau_parentesco f ON (b.nr_seq_parentesco = f.nr_sequencia)
LEFT OUTER JOIN pls_motivo_inclusao_seg h ON (b.nr_seq_motivo_inclusao = h.nr_sequencia)
LEFT OUTER JOIN pls_segurado_compl i ON (b.nr_sequencia = i.nr_seq_segurado)
WHERE b.nr_seq_plano			= c.nr_sequencia and b.nr_seq_intercambio		= a.nr_sequencia and b.cd_pessoa_fisica		= d.cd_pessoa_fisica and e.cd_pessoa_fisica		= d.cd_pessoa_fisica    and e.ie_tipo_complemento		= 1 ) alias24 

union
	 
select	6										tp_registro, 
	''										tp_arquivo, 
	null										cd_empresa, 
	''										cd_unidade_destino, 
	null										dt_geracao, 
	''										ie_tipo_remetente, 
	''										ie_tipo_carga, 
	' '										cd_versao_layout, 
	''										ie_tipo_movimentacao, 
	' '										reservado_1, 
	' '										reservado_2, 
	' '										reservado_3, 
	' '										reservado_4, 
	' '										reservado_5, 
	''										nm_beneficiario, 
	''										ie_sexo, 
	null										dt_nascimento, 
	''										ie_estado_civil, 
	''										nr_cpf, 
	''										nr_identidade, 
	''										nr_cbo, 
	''										ds_endereco, 
	''										ds_bairro, 
	''										nr_cep, 
	''										ds_cidade, 
	''										ie_uf, 
	''										ie_grau_parentesco, 
	null										dt_admissao, 
	null										dt_inclusao, 
	null										dt_exclusao, 
	' '										reservado_6, 
	''										cd_matricula, 
	' '										cd_unidade_atend, 
	' '										cd_unidade_neg, 
	''										cd_codigo_ant, 
	null										nr_proposta_intercambio, 
	null										nr_seq_segurado, 
	''										ie_responsavel, 
	null										cd_responsavel, 
	''										nm_benefe_cartao, 
	' '										nm_internacional, 
	' '										cd_uni_origem_resp, 
	' '										cd_cart_uni_resp, 
	' '										cd_departamento, 
	' '										cd_secao, 
	' '										cd_setor, 
	''										ie_padrao_cobertura, 
	' '										info_espec_1, 
	' '										info_espec_2, 
	' '										info_espec_3, 
	' '										info_espec_4, 
	''										nr_pis_pasep, 
	''										nr_cartao_sus, 
	''										nm_mae, 
	''										nm_pai, 
	''										ie_abrangencia, 
	' '										reservado_7, 
	' '										reservado_8, 
	null										ie_tipo_contratacao, 
	null										nr_protocolo_ans, 
	' '										reservado_9, 
	' '										reservado_10, 
	''										ds_email, 
	null										cd_vendedor, 
	''										ds_orgao_emissor, 
	''										nm_pais, 
	''										ie_motivo_inclusao, 
	null										nr_registro_ans, 
	null										nr_seq_motivo_can, 
	null										dt_obito, 
	null										cd_mod_mae, 
	null										proposta_mae, 
	null										nr_seq_seg_mae, 
	''										ds_nacionalidade, 
	' '										ds_nat_doc_ident, 
	''										sg_emissora_ci, 
	null										dt_emissao_ci, 
	''										nr_telefone, 
	''										nr_cel_benef, 
	' '										nr_tipo_carencia, 
	' '										ie_acomodacao, 
	null										dt_fim_carencia, 
	' '										reservado_11, 
	count(*)									qt_total_segurados, 
	a.nr_sequencia									nr_seq_intercambio, 
	999999999									nr_ordem 
from	pls_segurado			b, 
	pls_intercambio			a 
where	b.nr_seq_intercambio		= a.nr_sequencia 
group by a.nr_sequencia 
order by nr_ordem;

