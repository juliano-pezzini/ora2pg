-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pessoa_fisica_v (cd_pessoa_fisica, nm_pessoa_fisica, nm_social, dt_nascimento, nr_ddi_celular, nr_ddd_celular, nr_telefone_celular, nr_identidade, nr_cpf, nr_cartao_nac_sus, ie_estado_civil, ie_sexo, dt_emissao_ci, sg_emissora_ci, nr_seq_pais, ds_orgao_emissor_ci, nr_reg_geral_estrang, nr_cep_cidade_nasc, cd_declaracao_nasc_vivo, nr_pis_pasep, dt_atualizacao, cd_nacionalidade, cd_estabelecimento, im_pessoa_fisica) AS select 	p.cd_pessoa_fisica ,
	p.nm_pessoa_fisica ,
	p.nm_social ,
	p.dt_nascimento ,
	p.nr_ddi_celular ,
	p.nr_ddd_celular ,
	p.nr_telefone_celular ,
	p.nr_identidade ,
	p.nr_cpf ,
	p.nr_cartao_nac_sus ,
	p.ie_estado_civil ,
	p.ie_sexo ,
	p.dt_emissao_ci ,
	p.sg_emissora_ci ,
	p.nr_seq_pais ,
	p.ds_orgao_emissor_ci ,
	p.nr_reg_geral_estrang ,
	p.nr_cep_cidade_nasc ,
	p.cd_declaracao_nasc_vivo ,
	p.nr_pis_pasep ,
	greatest(coalesce(foto.dt_atualizacao, to_date('1970-01-01', 'YYYY/MM/DD')), coalesce(p.dt_atualizacao, to_date('1970-01-01', 'YYYY/MM/DD'))) dt_atualizacao,
	p.cd_nacionalidade ,
	p.cd_estabelecimento,
	foto.im_pessoa_fisica
FROM	pessoa_fisica p
left join pessoa_fisica_foto foto ON (p.cd_pessoa_fisica = foto.cd_pessoa_fisica);

