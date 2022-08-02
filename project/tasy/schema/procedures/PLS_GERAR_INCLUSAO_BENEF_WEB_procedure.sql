-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_inclusao_benef_web ( nm_pessoa_fisica_p text, dt_nascimento_p text, dt_validade_carteira_p text, nr_cpf_p text, nm_mae_p text, ds_plano_carteira_p text, nr_seq_plano_p bigint, nm_empresa_p text, cd_nacionalidade_p text, nr_ddd_celular_p text, nr_telefone_celular_p text, ie_sexo_p text, nr_identidade_p text, cd_cep_p text, ds_endereco_p text, nr_endereco_p text, ds_complemento_p text, ds_bairro_p text, cd_municipio_ibge_p text, sg_estado_p text, nr_ddi_telefone_p text, nr_ddd_telefone_p text, nr_telefone_p text, ds_email_p text, ie_tipo_repasse_p text, ie_pcmso_p text, ie_custo_oper_intercambio_p text, nm_usuario_p text, cd_estabelecimento_p bigint, qt_homonimos_p INOUT bigint, nr_seq_inclusao_p INOUT bigint, nm_social_p text) AS $body$
DECLARE


qt_homonimos_w	bigint := 0;


BEGIN

if (coalesce(nr_seq_inclusao_p::text, '') = '') then
	select	nextval('pls_inclusao_beneficiario_seq')
	into STRICT	nr_seq_inclusao_p
	;

	insert into pls_inclusao_beneficiario(
		nr_sequencia, nm_pessoa_fisica,  dt_nascimento,
		dt_validade_carteira, nr_cpf, nm_mae,
		ds_plano_carteira, nr_seq_plano, nm_empresa,
		cd_nacionalidade, nr_telefone_celular, ie_sexo,
		nr_identidade, cd_cep, ds_endereco,
		nr_endereco, ds_complemento, ds_bairro,
		cd_municipio_ibge, sg_estado, nr_ddi_telefone,
		nr_ddd_telefone, nr_telefone, ds_email,
		ie_tipo_repasse, ie_pcmso, ie_custo_oper_intercambio,
		cd_estabelecimento, nm_usuario, dt_atualizacao,
		nr_ddd_celular, nm_social)
	values (
		nr_seq_inclusao_p, nm_pessoa_fisica_p, to_date(dt_nascimento_p,'dd/mm/yyyy'),
		to_date(dt_validade_carteira_p,'dd/mm/yyyy'), nr_cpf_p, nm_mae_p,
		ds_plano_carteira_p, nr_seq_plano_p, nm_empresa_p,
		cd_nacionalidade_p, nr_telefone_celular_p, ie_sexo_p,
		nr_identidade_p, cd_cep_p, ds_endereco_p,
		nr_endereco_p, ds_complemento_p, ds_bairro_p,
		cd_municipio_ibge_p, sg_estado_p, nr_ddi_telefone_p,
		nr_ddd_telefone_p, nr_telefone_p, ds_email_p,
		ie_tipo_repasse_p, ie_pcmso_p, ie_custo_oper_intercambio_p,
		cd_estabelecimento_p, nm_usuario_p, clock_timestamp(),
		nr_ddd_celular_p, nm_social_p);

	pls_gerar_homonimo_pf(nm_pessoa_fisica_p, dt_nascimento_p, nr_cpf_p, nr_seq_inclusao_p, nm_usuario_p);

	select 	count(1)
	into STRICT	qt_homonimos_w
	from   	pls_homonimo_pessoa_fisica a,
	pessoa_fisica b
	where  	a.cd_pessoa_fisica = b.cd_pessoa_fisica
	and    	a.nr_seq_inclusao_benef = nr_seq_inclusao_p;

	if (qt_homonimos_w	> 0) then
		qt_homonimos_p	:= qt_homonimos_w;
	end if;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_inclusao_benef_web ( nm_pessoa_fisica_p text, dt_nascimento_p text, dt_validade_carteira_p text, nr_cpf_p text, nm_mae_p text, ds_plano_carteira_p text, nr_seq_plano_p bigint, nm_empresa_p text, cd_nacionalidade_p text, nr_ddd_celular_p text, nr_telefone_celular_p text, ie_sexo_p text, nr_identidade_p text, cd_cep_p text, ds_endereco_p text, nr_endereco_p text, ds_complemento_p text, ds_bairro_p text, cd_municipio_ibge_p text, sg_estado_p text, nr_ddi_telefone_p text, nr_ddd_telefone_p text, nr_telefone_p text, ds_email_p text, ie_tipo_repasse_p text, ie_pcmso_p text, ie_custo_oper_intercambio_p text, nm_usuario_p text, cd_estabelecimento_p bigint, qt_homonimos_p INOUT bigint, nr_seq_inclusao_p INOUT bigint, nm_social_p text) FROM PUBLIC;

