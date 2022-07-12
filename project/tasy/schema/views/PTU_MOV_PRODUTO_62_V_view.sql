-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_mov_produto_62_v (nr_seq_movimentacao, tp_registro, nr_sequencia, cd_tipo_registro, cd_unimed_des, cd_unimed_ori, dt_geracao, ie_tipo_mov, dt_mov_inicio, dt_mov_fim, tp_protudo, nr_versao_trans, cd_filial, nm_empr_compl, nm_empr_abre, reservado1, tp_pessoa_con, cd_cgc_cpf302, cd_insc_est, ds_end_pri302, ds_end_cpl, ds_bairro302, nr_cep302, ds_cidade302, cd_uf302, nr_ddd302, dt_incl_uni302, dt_excl_uni, cd_empr_ori302, ie_tipo_natureza, cd_munic, nr_fone302, nr_fax, nr_contrato, nr_endereco_empresa, cd_uni, id_benef, cd_familia, nm_benef, cd_plano_des, dt_nasc, ie_sexo, cd_cgc_cpf304, cd_rg, cd_uf_rg, cd_civil, dt_incl_uni304, dt_exclu_uni, cd_depe, dt_repasse, dt_base_carencia, dt_incl_plano, dt_incl_empr_uni, vl_mensalidade, cd_uni_ant, id_benef_ant, id_benef_tit, nm_compl_benef, tp_prazo_beneficio, id_filho, cd_empr_ori304, ie_tipo_acomodacao, cd_ident, ds_orgao_emissor, cd_pais, cd_plano, nr_cartao_nac_sus, nm_mae, nr_pis_pasep, ds_end_pri306, ds_bairro306, nr_cep306, ds_cidade306, cd_uf306, nr_ddd306, nr_fone306, nr_ramal, nr_endereco_benef, qt_tot_r302, qt_tot_r304, qt_tot_r306, qt_tot_alt, qt_tot_plano, qt_tot_incl, qt_tot_excl, nr_seq_benef, nr_seq_empresa) AS select	nr_sequencia			nr_seq_movimentacao,
	1				tp_registro,
	1				nr_sequencia,
	'301'				cd_tipo_registro,
	cd_unimed_destino		cd_unimed_des,
	cd_unimed_origem		cd_unimed_ori,
	dt_geracao			dt_geracao,
	ie_tipo_mov			ie_tipo_mov,
	dt_mov_inicio			dt_mov_inicio,
	dt_mov_fim			dt_mov_fim,
	ie_tipo_produto			tp_protudo,
	nr_versao_transacao		nr_versao_trans,
	0				cd_filial,
	null				nm_empr_compl,
	null				nm_empr_abre,
	' '				reservado1,
	null				tp_pessoa_con,
	null				cd_cgc_cpf302,
	null				cd_insc_est,
	null				ds_end_pri302,
	null				ds_end_cpl,
	null				ds_bairro302,
	null				nr_cep302,
	null				ds_cidade302,
	null				cd_uf302,
	null				nr_ddd302,
	null				dt_incl_uni302,
	null				dt_excl_uni,
	null				cd_empr_ori302,
	null				ie_tipo_natureza,
	null				cd_munic,
	null				nr_fone302,
	null				nr_fax,
	null				nr_contrato,
	null				nr_endereco_empresa,
	null				cd_uni,
	null				id_benef,
	-1				cd_familia,
	null				nm_benef,
	null				cd_plano_des,
	null				dt_nasc,
	null				ie_sexo,
	null				cd_cgc_cpf304,
	null				cd_rg,
	null				cd_uf_rg,
	null				cd_civil,
	null				dt_incl_uni304,
	null				dt_exclu_uni,
	-1				cd_depe,
	null				dt_repasse,
	null				dt_base_carencia,
	null				dt_incl_plano,
	null				dt_incl_empr_uni,
	null				vl_mensalidade,
	null				cd_uni_ant,
	null				id_benef_ant,
	null				id_benef_tit,
	null				nm_compl_benef,
	null				tp_prazo_beneficio,
	null				id_filho,
	-1				cd_empr_ori304,
	null				ie_tipo_acomodacao,
	null				cd_ident,
	null				ds_orgao_emissor,
	null				cd_pais,
	null				CD_PLANO,
	null				NR_CARTAO_NAC_SUS,
	null				nm_mae,
	null				nr_pis_pasep,
	null				ds_end_pri306,
	null				ds_bairro306,
	null				nr_cep306,
	null				ds_cidade306,
	null				cd_uf306,
	null				nr_ddd306,
	null				nr_fone306,
	null				nr_ramal,
	null				nr_endereco_benef,
	'0'				qt_tot_r302,
	'0'				qt_tot_r304,
	'0'				qt_tot_r306,
	'0'				qt_tot_alt,
	'0'				qt_tot_plano,
	'0'				qt_tot_incl,
	'0'				qt_tot_excl,
	0				nr_seq_benef,
	0				nr_seq_empresa
FROM	ptu_movimentacao_produto

union all

select	nr_seq_mov_produto		nr_seq_movimentacao,
	2				tp_registro,
	2				nr_sequencia,
	'302'				cd_tipo_registro,
	null				cd_unimed_des,
	null				cd_unimed_ori,
	null				dt_geracao,
	null				ie_tipo_mov,
	null				dt_mov_inicio,
	null				dt_mov_fim,
	null				tp_protudo,
	null				nr_versao_trans,
	cd_filial			cd_filial,
	ds_razao_social			nm_empr_compl,
	nm_empr_abrev			nm_empr_abre,
	' '				reservado1,
	ie_tipo_pessoa			tp_pessoa_con,
	cd_cgc_cpf			cd_cgc_cpf302,
	nr_insc_estadual		cd_insc_est,
	ds_endereco			ds_end_pri302,
	ds_complemento			ds_end_cpl,
	ds_bairro			ds_bairro302,
	cd_cep				nr_cep302,
	nm_cidade			ds_cidade302,
	sg_uf				cd_uf302,
	nr_ddd				nr_ddd302,
	dt_inclusao			dt_incl_uni302,
	dt_exclusao			dt_excl_uni,
	cd_empresa_origem		cd_empr_ori302,
	ie_natureza_contratacao		ie_tipo_natureza,
	cd_municipio_ibge		cd_munic,
	nr_telefone			nr_fone302,
	nr_fax				nr_fax,
	nr_contrato			nr_contrato,
	CASE WHEN coalesce(to_char(nr_endereco),'0')='0' THEN  'S/N'  ELSE to_char(nr_endereco) END  nr_endereco_empresa,
	null				cd_uni,
	null				id_benef,
	-1				cd_familia,
	null				nm_benef,
	null				cd_plano_des,
	null				dt_nasc,
	null				ie_sexo,
	null				cd_cgc_cpf304,
	null				cd_rg,
	null				cd_uf_rg,
	null				cd_civil,
	null				dt_incl_uni304,
	null				dt_exclu_uni,
	-1				cd_depe,
	null				dt_repasse,
	null				dt_base_carencia,
	null				dt_incl_plano,
	null				dt_incl_empr_uni,
	null				vl_mensalidade,
	null				cd_uni_ant,
	null				id_benef_ant,
	null				id_benef_tit,
	null				nm_compl_benef,
	null				tp_prazo_beneficio,
	null				id_filho,
	-1				cd_empr_ori304,
	null				ie_tipo_acomodacao,
	null				cd_ident,
	null				ds_orgao_emissor,
	null				cd_pais,
	null				CD_PLANO,
	null				NR_CARTAO_NAC_SUS,
	null				nm_mae,
	null				nr_pis_pasep,
	null				ds_end_pri306,
	null				ds_bairro306,
	null				nr_cep306,
	null				ds_cidade306,
	null				cd_uf306,
	null				nr_ddd306,
	null				nr_fone306,
	null				nr_ramal,
	null				nr_endereco_benef,
	'0'				qt_tot_r302,
	'0'				qt_tot_r304,
	'0'				qt_tot_r306,
	'0'				qt_tot_alt,
	'0'				qt_tot_plano,
	'0'				qt_tot_incl,
	'0'				qt_tot_excl,
	1				nr_seq_benef,
	nr_sequencia			nr_seq_empresa
from	ptu_mov_produto_empresa

union all

select	b.nr_seq_mov_produto		nr_seq_movimentacao,
	3				tp_registro,
	3				nr_sequencia,
	'304'				cd_tipo_registro,
	null				cd_unimed_des,
	null				cd_unimed_ori,
	null				dt_geracao,
	null				ie_tipo_mov,
	null				dt_mov_inicio,
	null				dt_mov_fim,
	null				tp_protudo,
	null				nr_versao_trans,
	b.cd_filial			cd_filial,
	null				nm_empr_compl,
	null				nm_empr_abre,
	' '				reservado1,
	null				tp_pessoa_con,
	null				cd_cgc_cpf302,
	null				cd_insc_est,
	null				ds_end_pri302,
	null				ds_end_cpl,
	null				ds_bairro302,
	null				nr_cep302,
	null				ds_cidade302,
	null				cd_uf302,
	null				nr_ddd302,
	null				dt_incl_uni302,
	null				dt_excl_uni,
	null				cd_empr_ori302,
	null				ie_tipo_natureza,
	null				cd_munic,
	null				nr_fone302,
	null				nr_fax,
	null				nr_contrato,
	null				nr_endereco_empresa,
	a.cd_unimed			cd_uni,
	coalesce(a.cd_usuario_plano, a.cd_usuario_plano_benef)	id_benef,
	a.cd_familia			cd_familia,
	a.nm_benef_abreviado		nm_benef,
	a.cd_plano_destino		cd_plano_des,
	a.dt_nascimento			dt_nasc,
	a.ie_sexo			ie_sexo,
	a.cd_cgc_cpf			cd_cgc_cpf304,
	a.nr_rg				cd_rg,
	substr(pls_obter_campos_null_a300(a.nr_seq_empresa, a.nr_seq_segurado, 'UF'),1,2) cd_uf_rg,
	a.ie_estado_civil		cd_civil,
	--a.dt_inclusao			dt_incl_uni304, 		OS 1115054
	c.dt_contratacao		dt_incl_uni304,
	a.dt_exclusao			dt_exclu_uni,
	a.cd_dependencia		cd_depe,
	a.dt_repasse			dt_repasse,
	a.dt_base_carencia		dt_base_carencia,
	a.dt_inclusao_plano_dest	dt_incl_plano,
	a.dt_inclusao_empr_uni		dt_incl_empr_uni,
	replace(to_char(a.vl_mensalidade,'FM999999999990D00'),',','') vl_mensalidade,
	a.cd_unimed_anterior		cd_uni_ant,
	coalesce(a.cd_usuario_plano_ant, a.cd_plano_benef_ant)	id_benef_ant,
	coalesce(a.cd_titular_plano, a.cd_titular_benef_plano)	id_benef_tit,
	a.nm_beneficiario		nm_compl_benef,
	a.qt_prazo_vinculo       	tp_prazo_beneficio,
	a.ie_filho			id_filho,
	a.cd_empresa_origem		cd_empr_ori304,
	a.ie_tipo_acomodacao		ie_tipo_acomodacao,
	substr(pls_obter_campos_null_a300(a.nr_seq_empresa, a.nr_seq_segurado, 'RG'),1,30) cd_ident,
	substr(pls_obter_campos_null_a300(a.nr_seq_empresa, a.nr_seq_segurado, 'OE'),1,30) ds_orgao_emissor,
	substr(pls_obter_campos_null_a300(a.nr_seq_empresa, a.nr_seq_segurado, 'P'),1,3) cd_pais,
	coalesce(a.cd_plano,a.cd_plano_destino)	cd_plano,
	a.nr_cartao_nac_sus		nr_cartao_nac_sus,
	a.nm_mae_benef			nm_mae,
	a.nr_pis_pasep			nr_pis_pasep,
	null				ds_end_pri306,
	null				ds_bairro306,
	null				nr_cep306,
	null				ds_cidade306,
	null				cd_uf306,
	null				nr_ddd306,
	null				nr_fone306,
	null				nr_ramal,
	null				nr_endereco_benef,
	'0'				qt_tot_r302,
	'0'				qt_tot_r304,
	'0'				qt_tot_r306,
	'0'				qt_tot_alt,
	'0'				qt_tot_plano,
	'0'				qt_tot_incl,
	'0'				qt_tot_excl,
	a.nr_sequencia			nr_seq_benef,
	b.nr_sequencia			nr_seq_empresa
from	ptu_mov_produto_benef	a,
	ptu_mov_produto_empresa	b,
	pls_segurado		c
where	a.nr_seq_empresa	= b.nr_sequencia
and	a.nr_seq_segurado	= c.nr_sequencia

union all

select	b.nr_seq_mov_produto		nr_seq_movimentacao,
	4				tp_registro,
	4				nr_sequencia,
	'306'				cd_tipo_registro,
	null				cd_unimed_des,
	null				cd_unimed_ori,
	null				dt_geracao,
	null				ie_tipo_mov,
	null				dt_mov_inicio,
	null				dt_mov_fim,
	null				tp_protudo,
	null				nr_versao_trans,
	b.cd_filial			cd_filial,
	null				nm_empr_compl,
	null				nm_empr_abre,
	' '				reservado1,
	null				tp_pessoa_con,
	null				cd_cgc_cpf302,
	null				cd_insc_est,
	null				ds_end_pri302,
	null				ds_end_cpl,
	null				ds_bairro302,
	null				nr_cep302,
	null				ds_cidade302,
	null				cd_uf302,
	null				nr_ddd302,
	null				dt_incl_uni302,
	null				dt_excl_uni,
	null				cd_empr_ori302,
	null				ie_tipo_natureza,
	null				cd_munic,
	null				nr_fone302,
	null				nr_fax,
	null				nr_contrato,
	null				nr_endereco_empresa,
	null				cd_uni,
	null				id_benef,
	a.cd_familia			cd_familia,
	null				nm_benef,
	null				cd_plano_des,
	null				dt_nasc,
	null				ie_sexo,
	null				cd_cgc_cpf304,
	null				cd_rg,
	null				cd_uf_rg,
	null				cd_civil,
	null				dt_incl_uni304,
	null				dt_exclu_uni,
	a.cd_dependencia		cd_depe,
	null				dt_repasse,
	null				dt_base_carencia,
	null				dt_incl_plano,
	null				dt_incl_empr_uni,
	null				vl_mensalidade,
	null				cd_uni_ant,
	null				id_benef_ant,
	null				id_benef_tit,
	null				nm_compl_benef,
	null				tp_prazo_beneficio,
	null				id_filho,
	a.cd_empresa_origem		cd_empr_ori304,
	null				ie_tipo_acomodacao,
	null				cd_ident,
	null				ds_orgao_emissor,
	null				cd_pais,
	null				CD_PLANO,
	null				NR_CARTAO_NAC_SUS,
	null				nm_mae,
	null				nr_pis_pasep,
	c.ds_endereco			ds_end_pri306,
	c.ds_bairro			ds_bairro306,
	c.cd_cep			nr_cep306,
	c.nm_municipio			ds_cidade306,
	c.sg_uf				cd_uf306,
	c.nr_ddd			nr_ddd306,
	c.nr_fone			nr_fone306,
	c.nr_ramal			nr_ramal,
	CASE WHEN coalesce(c.nr_endereco,0)=0 THEN  'S/N'  ELSE c.nr_endereco END 		nr_endereco_benef,
	'0'				qt_tot_r302,
	'0'				qt_tot_r304,
	'0'				qt_tot_r306,
	'0'				qt_tot_alt,
	'0'				qt_tot_plano,
	'0'				qt_tot_incl,
	'0'				qt_tot_excl,
	a.nr_sequencia			nr_seq_benef,
	b.nr_sequencia			nr_seq_empresa
from	ptu_mov_produto_benef		a,
	ptu_movimento_benef_compl	c,
	ptu_mov_produto_empresa		b
where	a.nr_seq_empresa	= b.nr_sequencia
and a.nr_sequencia		= c.nr_seq_beneficiario

union all

select	nr_sequencia			nr_seq_movimentacao,
	5				tp_registro,
	5				nr_sequencia,
	'309'				cd_tipo_registro,
	null				cd_unimed_des,
	null				cd_unimed_ori,
	null				dt_geracao,
	null				ie_tipo_mov,
	null				dt_mov_inicio,
	null				dt_mov_fim,
	null				tp_protudo,
	null				nr_versao_trans,
	999999999			cd_filial,
	null				nm_empr_compl,
	null				nm_empr_abre,
	' '				reservado1,
	null				tp_pessoa_con,
	null				cd_cgc_cpf302,
	null				cd_insc_est,
	null				ds_end_pri302,
	null				ds_end_cpl,
	null				ds_bairro302,
	null				nr_cep302,
	null				ds_cidade302,
	null				cd_uf302,
	null				nr_ddd302,
	null				dt_incl_uni302,
	null				dt_excl_uni,
	null				cd_empr_ori302,
	null				ie_tipo_natureza,
	null				cd_munic,
	null				nr_fone302,
	null				nr_fax,
	null				nr_contrato,
	null				nr_endereco_empresa,
	null				cd_uni,
	null				id_benef,
	99999				cd_familia,
	null				nm_benef,
	null				cd_plano_des,
	null				dt_nasc,
	null				ie_sexo,
	null				cd_cgc_cpf304,
	null				cd_rg,
	null				cd_uf_rg,
	null				cd_civil,
	null				dt_incl_uni304,
	null				dt_exclu_uni,
	999				cd_depe,
	null				dt_repasse,
	null				dt_base_carencia,
	null				dt_incl_plano,
	null				dt_incl_empr_uni,
	null				vl_mensalidade,
	null				cd_uni_ant,
	null				id_benef_ant,
	null				id_benef_tit,
	null				nm_compl_benef,
	null				tp_prazo_beneficio,
	null				id_filho,
	99999				cd_empr_ori304,
	null				ie_tipo_acomodacao,
	null				cd_ident,
	null				ds_orgao_emissor,
	null				cd_pais,
	null				CD_PLANO,
	null				nr_cartao_nac_sus,
	null				nm_mae,
	null				nr_pis_pasep,
	null				ds_end_pri306,
	null				ds_bairro306,
	null				nr_cep306,
	null				ds_cidade306,
	null				cd_uf306,
	null				nr_ddd306,
	null				nr_fone306,
	null				nr_ramal,
	null				nr_endereco_benef,
	to_char(qt_reg_empresas)	qt_tot_r302,
	to_char(qt_reg_benef)		qt_tot_r304,
	to_char(qt_reg_compl_benf)	qt_tot_r306,
	'0'				qt_tot_alt,
	'0'				qt_tot_plano,
	'0'				qt_tot_incl,
	'0'				qt_tot_excl,
	99999999			nr_seq_benef,
	9999999999999999		nr_seq_empresa
from	ptu_movimentacao_produto;

