-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Objeto que verifica as alteracoes cadastrais e gera solicitacao de alteracao PF
CREATE OR REPLACE PROCEDURE pls_obj_plussoft_pck.salvar_alteracoes_pf ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nm_pessoa_fisica_p pessoa_fisica.nm_pessoa_fisica%type, nm_abreviado_p pessoa_fisica.nm_abreviado%type, ie_sexo_p pessoa_fisica.ie_sexo%type, ie_estado_civil_p pessoa_fisica.ie_estado_civil%type, nr_ddi_telefone_res_p text, nr_ddd_telefone_res_p text, nr_telefone_res_p text, ds_fone_adic_p text, nr_ddi_celular_p text, nr_ddd_celular_p text, nr_telefone_celular_p text, nr_ddi_telefone_com_p text, nr_ddd_telefone_com_p text, nr_telefone_com_p text, ds_email_pf_p text, --Endereco residencial
 ie_tipo_complemento_res_p text, cd_cep_res_p text, ds_pais_res_p text, sg_estado_res_p text, ds_municipio_res_p text, ds_tipo_logradouro_res_p text, ds_endereco_res_p text, nr_endereco_res_p text, ds_complemento_res_p text, cd_municipio_ibge_res_p text, ds_bairro_res_p text, ie_endereco_pagador_res_p text, --Endereco Comercial
 ie_tipo_complemento_com_p text, cd_cep_com_p text, ds_pais_com_p text, sg_estado_com_p text, ds_municipio_com_p text, ds_tipo_logradouro_com_p text, ds_endereco_com_p text, nr_endereco_com_p text, ds_complemento_com_p text, cd_municipio_ibge_com_p text, ds_bairro_com_p text, ie_endereco_pagador_com_p text, --Inf Adicionais
 nr_identidade_p text, nr_inscricao_estadual_p text, nr_cpf_p text, dt_nascimento_p text, ds_cargo_p text, ds_observacao_pf_p text, nr_pais_ci_p bigint, nm_usuario_p text, ds_naturalidade_p text, --Parametros de saida
 ie_retorno_p INOUT bigint, ds_mensagem_erro_p INOUT text) AS $body$
DECLARE


/*  IE_RETORNO_P : 0 - Operacao realizada     1 - Erro  */

nm_pessoa_fisica_old_w		varchar(255);
dt_nascimento_old_w		timestamp;
cd_nacionalidade_old_w		varchar(8);
nr_cpf_old_w			varchar(11);
ie_estado_civil_old_w		varchar(2);
ie_sexo_old_w			varchar(1);
ds_email_old_w			varchar(255);
nr_identidade_old_w		varchar(15);
dt_emissao_ci_old_w		timestamp;
sg_emissora_ci_old_w		varchar(15);
nr_seq_pais_old_w		bigint;
ds_orgao_emissor_ci_old_w	pessoa_fisica.ds_orgao_emissor_ci%type;
nr_reg_geral_estrang_old_w	varchar(30);
cd_cep_old_w			varchar(15);
ds_endereco_old_w		varchar(40);
nr_endereco_old_w		varchar(5);
ds_complemento_old_w		varchar(40);
ds_bairro_old_w			varchar(80);
cd_municipio_ibge_old_w		varchar(6);
sg_estado_old_w			varchar(15);
nr_ddd_telefone_old_w		varchar(3);
nr_ddi_telefone_old_w		varchar(3);
nr_telefone_old_w		varchar(15);
nr_telefone_celular_old_w	varchar(40);
nr_ctps_old_w			pessoa_fisica.nr_ctps%type;
nr_serie_ctps_old_w		pessoa_fisica.nr_serie_ctps%type;
uf_emissora_ctps_old_w		varchar(15);
ds_municipio_old_w		varchar(255);
nr_pis_pasep_old_w		varchar(15);
cd_declaracao_nasc_vivo_old_w	numeric(30);
nr_cartao_nac_sus_old_w		varchar(20);
nr_ddd_celular_old_w		varchar(3);
nr_cert_casamento_old_w		varchar(20);
dt_emissao_cert_casament_old_w	timestamp;
nr_titulo_eleitor_old_w		varchar(20);
ds_tipo_logradouro_old_w	varchar(125);
cd_tipo_logradouro_old_w	varchar(3);
nm_abreviado_old_w		varchar(255);
nm_mae_old_w			varchar(255);
nm_pai_old_w			varchar(255);
cd_municipio_ibge_nasc_old_w	pessoa_fisica.cd_municipio_ibge%type;
nr_inscricao_estadual_old_w	pessoa_fisica.nr_inscricao_estadual%type;
nr_ddi_celular_old_w		pessoa_fisica.nr_ddi_celular%type;
ds_observacao_old_w		pessoa_fisica.ds_observacao%type;
vl_parametro_w			varchar(20);
nr_pais_ci_w			bigint;
ds_cargo_old_w		 	pessoa_fisica.cd_cargo%type;
qt_registro_w			bigint;
nr_sequencia_w			bigint;
ds_naturalidade_old_w		sus_municipio.cd_municipio_ibge%type;
tag_pais_w			varchar(15);


BEGIN
ie_retorno_p := 1;
ds_mensagem_erro_p := '';

Obter_Param_Usuario(1220, 26, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, vl_parametro_w);
begin

--Dados atuais PF
	select	nm_pessoa_fisica,
		dt_nascimento,
		cd_nacionalidade,
		nr_cpf,
		ie_estado_civil,
		ie_sexo,
		nr_identidade,
		dt_emissao_ci,
		sg_emissora_ci,
		nr_seq_pais,
		ds_orgao_emissor_ci,
		nr_reg_geral_estrang,
		nr_telefone_celular,
		nr_ctps,
		nr_serie_ctps,
		uf_emissora_ctps,
		nr_pis_pasep,
		cd_declaracao_nasc_vivo,
		nr_cartao_nac_sus,
		nr_ddd_celular,
		nr_cert_casamento,
		dt_emissao_cert_casamento,
		nr_titulo_eleitor,
		nm_abreviado,
		cd_municipio_ibge,
		nr_inscricao_estadual,
		nr_ddi_celular,
		ds_observacao,
		cd_cargo,
		cd_municipio_ibge
	into STRICT	nm_pessoa_fisica_old_w,
		dt_nascimento_old_w,
		cd_nacionalidade_old_w,
		nr_cpf_old_w,
		ie_estado_civil_old_w,
		ie_sexo_old_w,
		nr_identidade_old_w,
		dt_emissao_ci_old_w,
		sg_emissora_ci_old_w,
		nr_seq_pais_old_w,
		ds_orgao_emissor_ci_old_w,
		nr_reg_geral_estrang_old_w,
		nr_telefone_celular_old_w,
		nr_ctps_old_w,
		nr_serie_ctps_old_w,
		uf_emissora_ctps_old_w,
		nr_pis_pasep_old_w,
		cd_declaracao_nasc_vivo_old_w,
		nr_cartao_nac_sus_old_w,
		nr_ddd_celular_old_w,
		nr_cert_casamento_old_w,
		dt_emissao_cert_casament_old_w,
		nr_titulo_eleitor_old_w,
		nm_abreviado_old_w,
		cd_municipio_ibge_nasc_old_w,
		nr_inscricao_estadual_old_w,
		nr_ddi_celular_old_w,
		ds_observacao_old_w,
		ds_cargo_old_w,
		ds_naturalidade_old_w
	from	pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p  LIMIT 1;

if (vl_parametro_w = 'S') then
	-- Nome Pessoa
	if (nm_pessoa_fisica_p IS NOT NULL AND nm_pessoa_fisica_p::text <> '') and (upper(nm_pessoa_fisica_p) <> upper(nm_pessoa_fisica_old_w) or coalesce(nm_pessoa_fisica_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(nm_pessoa_fisica_old_w, nm_pessoa_fisica_p, 'NM_PESSOA_FISICA', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--Nome abreviado
	if (nm_abreviado_p IS NOT NULL AND nm_abreviado_p::text <> '') and (upper(nm_abreviado_p) <> upper(nm_abreviado_old_w) or coalesce(nm_abreviado_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(nm_abreviado_old_w, nm_abreviado_p, 'NM_ABREVIADO', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--Sexo
	if (ie_sexo_p IS NOT NULL AND ie_sexo_p::text <> '') and (ie_sexo_p <> ie_sexo_old_w or coalesce(ie_sexo_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(ie_sexo_old_w, ie_sexo_p, 'IE_SEXO', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--Estado civil
	if (ie_estado_civil_p IS NOT NULL AND ie_estado_civil_p::text <> '') and (ie_estado_civil_p <> ie_estado_civil_old_w or coalesce(ie_estado_civil_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(ie_estado_civil_old_w, ie_estado_civil_p, 'IE_ESTADO_CIVIL', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--DDI celular 
	if (nr_ddi_celular_p IS NOT NULL AND nr_ddi_celular_p::text <> '') and (nr_ddi_celular_p <> nr_ddi_celular_old_w or coalesce(nr_ddi_celular_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(nr_ddi_celular_old_w, nr_ddi_celular_p, 'NR_DDI_CELULAR', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--DDD celular
	if (nr_ddd_celular_p IS NOT NULL AND nr_ddd_celular_p::text <> '') and (nr_ddd_celular_p <> nr_ddd_celular_old_w or coalesce(nr_ddd_celular_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(nr_ddd_celular_old_w, nr_ddd_celular_p, 'NR_DDD_CELULAR', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--Celular 
	if (nr_telefone_celular_p IS NOT NULL AND nr_telefone_celular_p::text <> '') and (nr_telefone_celular_p <> nr_telefone_celular_old_w or coalesce(nr_telefone_celular_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(nr_telefone_celular_old_w, nr_telefone_celular_p, 'NR_TELEFONE_CELULAR', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--Identidade
	if (nr_identidade_p IS NOT NULL AND nr_identidade_p::text <> '') and (nr_identidade_p <> nr_identidade_old_w or coalesce(nr_identidade_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(nr_identidade_old_w, nr_identidade_p, 'NR_IDENTIDADE', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--Inscricao Estadual
	if (nr_inscricao_estadual_p IS NOT NULL AND nr_inscricao_estadual_p::text <> '') and (nr_inscricao_estadual_p <> nr_inscricao_estadual_old_w or coalesce(nr_inscricao_estadual_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(nr_inscricao_estadual_old_w, nr_inscricao_estadual_p, 'NR_INSCRICAO_ESTADUAL', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--CPF
	if (nr_cpf_p IS NOT NULL AND nr_cpf_p::text <> '') and (nr_cpf_p <> nr_cpf_old_w or coalesce(nr_cpf_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(nr_cpf_old_w, nr_cpf_p, 'NR_CPF', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--Data nascimento
	if (dt_nascimento_p IS NOT NULL AND dt_nascimento_p::text <> '') and (dt_nascimento_p <> dt_nascimento_old_w or coalesce(dt_nascimento_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(dt_nascimento_old_w, dt_nascimento_p, 'DT_NASCIMENTO', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--Pais
	if (nr_pais_ci_p IS NOT NULL AND nr_pais_ci_p::text <> '') and (nr_pais_ci_p <> nr_seq_pais_old_w or coalesce(nr_seq_pais_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(nr_seq_pais_old_w, nr_pais_ci_p, 'NR_SEQ_PAIS', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--Observacao
	if (ds_observacao_pf_p IS NOT NULL AND ds_observacao_pf_p::text <> '') and (ds_observacao_pf_p <> ds_observacao_old_w or coalesce(ds_observacao_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(ds_observacao_old_w, ds_observacao_pf_p, 'DS_OBSERVACAO', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	--Cargo
	if (ds_cargo_p IS NOT NULL AND ds_cargo_p::text <> '') and (ds_cargo_p <> ds_cargo_old_w or coalesce(ds_cargo_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(ds_cargo_old_w, ds_cargo_p, 'CD_CARGO', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
	-- Naturalidade
	if (ds_naturalidade_p IS NOT NULL AND ds_naturalidade_p::text <> '') and (ds_naturalidade_p <> ds_naturalidade_old_w or coalesce(ds_naturalidade_old_w::text, '') = '') then
		CALL pls_gerar_solicitacao_alt(ds_naturalidade_old_w, ds_naturalidade_p, 'CD_MUNICIPIO_IBGE', cd_pessoa_fisica_p, null, nm_usuario_p);
	end if;
else
	update	pessoa_fisica
	set	nm_pessoa_fisica 	= nm_pessoa_fisica_p,
		nm_abreviado 		= nm_abreviado_p,
		ie_sexo 		= ie_sexo_p,
		ie_estado_civil		= ie_estado_civil_p,
		nr_ddi_celular		= nr_ddi_celular_p,
		nr_ddd_celular		= nr_ddd_celular_p,
		nr_telefone_celular	= nr_telefone_celular_p,
		nr_identidade		= nr_identidade_p,
		nr_inscricao_estadual	= nr_inscricao_estadual_p,
		nr_cpf			= nr_cpf_p,
		dt_nascimento		= dt_nascimento_p,
		nr_seq_pais		= nr_pais_ci_p,
		ds_observacao		= ds_observacao_pf_p,
		cd_cargo		= ds_cargo_p,
		cd_municipio_ibge	= ds_naturalidade_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p;
end if;

CALL pls_tasy_gerar_solicitacao(cd_pessoa_fisica_p,'A');

--Complemento Residencial
select 	count(*)
into STRICT	qt_registro_w
from	compl_pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	ie_tipo_complemento	= 1;

select	max(ds_locale)
into STRICT	tag_pais_w
from	user_locale 
where	nm_user = nm_usuario_p;

if (qt_registro_w = 0) then
	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_sequencia_w
	from	compl_pessoa_fisica
	where 	cd_pessoa_fisica = cd_pessoa_fisica_p;
	
	if (tag_pais_w = 'de_DE')then
		insert into compl_pessoa_fisica(nr_sequencia,
			cd_pessoa_fisica,
			ie_tipo_complemento,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nm_usuario,
			dt_atualizacao,
			ds_endereco,
			ds_bairro,
			cd_municipio_ibge,
			cd_cep,
			sg_estado,
			nr_telefone,
			nr_ddi_telefone,
			nr_ddd_telefone,
			ds_email,
			ds_municipio,
			cd_tipo_logradouro,
			ds_compl_end,
			ds_complemento,
			nr_seq_pais
			)
		values (nr_sequencia_w,
			cd_pessoa_fisica_p,
			1,
			'plusoft',
			clock_timestamp(),
			'plusoft',
			clock_timestamp(),
			substr(ds_endereco_res_p,1,100),
			substr(ds_bairro_res_p,1,80),
			cd_municipio_ibge_res_p,
			substr(cd_cep_res_p,1,15),
			substr(sg_estado_res_p,1,2),
			substr(nr_telefone_res_p,1,15),
			substr(nr_ddi_telefone_res_p,1,15),
			substr(nr_ddd_telefone_res_p,1,15),
			substr(ds_email_pf_p,1,255),
			substr(ds_municipio_res_p,1,40),
			ds_tipo_logradouro_res_p,
			nr_endereco_res_p,
			substr(ds_complemento_res_p,1,40),
			ds_pais_res_p);
	else
		insert into compl_pessoa_fisica(nr_sequencia,
			cd_pessoa_fisica,
			ie_tipo_complemento,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nm_usuario,
			dt_atualizacao,
			ds_endereco,
			ds_bairro,
			cd_municipio_ibge,
			cd_cep,
			sg_estado,
			nr_telefone,
			nr_ddi_telefone,
			nr_ddd_telefone,
			ds_email,
			ds_municipio,
			cd_tipo_logradouro,
			nr_endereco,
			ds_complemento,
			nr_seq_pais
			)
		values (nr_sequencia_w,
			cd_pessoa_fisica_p,
			1,
			'plusoft',
			clock_timestamp(),
			'plusoft',
			clock_timestamp(),
			substr(ds_endereco_res_p,1,100),
			substr(ds_bairro_res_p,1,80),
			cd_municipio_ibge_res_p,
			substr(cd_cep_res_p,1,15),
			substr(sg_estado_res_p,1,2),
			substr(nr_telefone_res_p,1,15),
			substr(nr_ddi_telefone_res_p,1,15),
			substr(nr_ddd_telefone_res_p,1,15),
			substr(ds_email_pf_p,1,255),
			substr(ds_municipio_res_p,1,40),
			ds_tipo_logradouro_res_p,
			nr_endereco_res_p,
			substr(ds_complemento_res_p,1,40),
			ds_pais_res_p);
	end if;
else
	begin
	select	ds_municipio,
		nr_ddd_telefone,
		nr_ddi_telefone,
		nr_telefone,
		ds_bairro,
		cd_municipio_ibge,
		sg_estado,
		cd_cep,
		ds_endereco,
		coalesce(nr_endereco, ds_compl_end) nr_endereco,
		ds_complemento,
		ds_email,
		cd_tipo_logradouro
	into STRICT	ds_municipio_old_w,
		nr_ddd_telefone_old_w,
		nr_ddi_telefone_old_w,
		nr_telefone_old_w,
		ds_bairro_old_w,
		cd_municipio_ibge_old_w,
		sg_estado_old_w,
		cd_cep_old_w,
		ds_endereco_old_w,
		nr_endereco_old_w,
		ds_complemento_old_w,
		ds_email_old_w,
		cd_tipo_logradouro_old_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_complemento	= 1;
	exception
	when others then
		ds_municipio_old_w	:= null;
		nr_ddd_telefone_old_w	:= null;
		nr_ddi_telefone_old_w	:= null;
		nr_telefone_old_w	:= null;
		ds_bairro_old_w		:= null;
		cd_municipio_ibge_old_w	:= null;
		sg_estado_old_w		:= null;
		cd_cep_old_w		:= null;
		ds_endereco_old_w	:= null;
		nr_endereco_old_w	:= null;
		ds_complemento_old_w	:= null;
		ds_email_old_w		:= null;
		cd_tipo_logradouro_old_w:= null;
	end;
	
	/* COMPLEMENTO  RESIDENCIAL*/

	if (vl_parametro_w = 'S') then
		--DDI
		if (nr_ddi_telefone_res_p IS NOT NULL AND nr_ddi_telefone_res_p::text <> '') and (nr_ddi_telefone_res_p <> nr_ddi_telefone_old_w or coalesce(nr_ddi_telefone_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(nr_ddi_telefone_old_w, nr_ddi_telefone_res_p, 'NR_DDI_TELEFONE', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--DDD
		if (nr_ddd_telefone_res_p IS NOT NULL AND nr_ddd_telefone_res_p::text <> '') and (nr_ddd_telefone_res_p <> nr_ddd_telefone_old_w or coalesce(nr_ddd_telefone_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(nr_ddd_telefone_old_w, nr_ddd_telefone_res_p, 'NR_DDD_TELEFONE', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Telefone
		if (nr_telefone_res_p IS NOT NULL AND nr_telefone_res_p::text <> '') and (nr_telefone_res_p <> nr_telefone_old_w or coalesce(nr_telefone_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(nr_telefone_old_w, nr_telefone_res_p, 'NR_TELEFONE', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Email
		if (ds_email_pf_p IS NOT NULL AND ds_email_pf_p::text <> '') and (upper(ds_email_pf_p) <> upper(ds_email_old_w) or coalesce(ds_email_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(ds_email_old_w, ds_email_pf_p, 'DS_EMAIL', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--CEP 
		if (cd_cep_res_p IS NOT NULL AND cd_cep_res_p::text <> '') and (cd_cep_res_p <> cd_cep_old_w or coalesce(cd_cep_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(cd_cep_old_w, cd_cep_res_p, 'CD_CEP', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--UF
		if (sg_estado_res_p IS NOT NULL AND sg_estado_res_p::text <> '') and (sg_estado_res_p <> sg_estado_old_w or coalesce(sg_estado_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(sg_estado_old_w, sg_estado_res_p, 'SG_ESTADO', cd_pessoa_fisica_p, null , nm_usuario_p);
		end if;
		--Municipio
		if (ds_municipio_res_p IS NOT NULL AND ds_municipio_res_p::text <> '') and (upper(ds_municipio_res_p) <> upper(ds_municipio_old_w) or coalesce(ds_municipio_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(ds_municipio_old_w, ds_municipio_res_p, 'DS_MUNICIPIO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Logradouro
		if (ds_tipo_logradouro_res_p IS NOT NULL AND ds_tipo_logradouro_res_p::text <> '') and (ds_tipo_logradouro_res_p <> cd_tipo_logradouro_old_w or coalesce(cd_tipo_logradouro_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(cd_tipo_logradouro_old_w, ds_tipo_logradouro_res_p, 'CD_TIPO_LOGRADOURO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Endereco
		if (ds_endereco_res_p IS NOT NULL AND ds_endereco_res_p::text <> '') and (upper(ds_endereco_res_p) <> upper(ds_endereco_old_w) or coalesce(ds_endereco_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt( ds_endereco_old_w, ds_endereco_res_p, 'DS_ENDERECO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Numero
		if (nr_endereco_res_p IS NOT NULL AND nr_endereco_res_p::text <> '') and (nr_endereco_res_p <> nr_endereco_old_w or coalesce(nr_endereco_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(nr_endereco_old_w, nr_endereco_res_p, 'NR_ENDERECO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Complemento
		if (ds_complemento_res_p IS NOT NULL AND ds_complemento_res_p::text <> '') and (upper(ds_complemento_res_p) <> upper(ds_complemento_old_w) or coalesce(ds_complemento_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(ds_complemento_old_w, ds_complemento_res_p, 'DS_COMPLEMENTO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--IBGE
		if (cd_municipio_ibge_res_p IS NOT NULL AND cd_municipio_ibge_res_p::text <> '') and (cd_municipio_ibge_res_p <> cd_municipio_ibge_old_w or coalesce(cd_municipio_ibge_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(cd_municipio_ibge_old_w, cd_municipio_ibge_res_p, 'CD_MUNICIPIO_IBGE', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Bairro
		if (ds_bairro_res_p IS NOT NULL AND ds_bairro_res_p::text <> '') and (upper(ds_bairro_res_p) <> upper(ds_bairro_old_w) or coalesce(ds_bairro_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(ds_bairro_old_w, ds_bairro_res_p, 'DS_BAIRRO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
	else
		if (tag_pais_w = 'de_DE')then
			update	compl_pessoa_fisica
			set	nr_ddi_telefone		= nr_ddi_telefone_res_p,
				nr_ddd_telefone		= nr_ddd_telefone_res_p,
				nr_telefone		= nr_telefone_res_p,
				ds_email		= ds_email_pf_p,
				cd_cep			= cd_cep_res_p,
				sg_estado		= sg_estado_res_p,
				ds_municipio		= ds_municipio_res_p,
				cd_tipo_logradouro	= ds_tipo_logradouro_res_p,
				ds_endereco		= ds_endereco_res_p,
				ds_compl_end		= nr_endereco_res_p,
				ds_complemento		= ds_complemento_res_p,
				cd_municipio_ibge	= cd_municipio_ibge_res_p,
				ds_bairro		= ds_bairro_res_p,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	cd_pessoa_fisica	= cd_pessoa_fisica_p
			and	ie_tipo_complemento	= 1;
		else
			update	compl_pessoa_fisica
			set	nr_ddi_telefone		= nr_ddi_telefone_res_p,
				nr_ddd_telefone		= nr_ddd_telefone_res_p,
				nr_telefone		= nr_telefone_res_p,
				ds_email		= ds_email_pf_p,
				cd_cep			= cd_cep_res_p,
				sg_estado		= sg_estado_res_p,
				ds_municipio		= ds_municipio_res_p,
				cd_tipo_logradouro	= ds_tipo_logradouro_res_p,
				ds_endereco		= ds_endereco_res_p,
				nr_endereco		= nr_endereco_res_p,
				ds_complemento		= ds_complemento_res_p,
				cd_municipio_ibge	= cd_municipio_ibge_res_p,
				ds_bairro		= ds_bairro_res_p,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	cd_pessoa_fisica	= cd_pessoa_fisica_p
			and	ie_tipo_complemento	= 1;
		end if;
	end if;
	
	CALL pls_tasy_gerar_solic_compl(cd_pessoa_fisica_p, 1,'A','pls_obj_plussoft_pck.salvar_alteracoes_pf()');
end if;

--Complemento Comercial
select 	count(*)
into STRICT	qt_registro_w
from	compl_pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	ie_tipo_complemento	= 2;

if (qt_registro_w = 0) then
	
		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	compl_pessoa_fisica
		where 	cd_pessoa_fisica = cd_pessoa_fisica_p;
		
		if (tag_pais_w = 'de_DE')then
			insert into compl_pessoa_fisica(nr_sequencia,
				cd_pessoa_fisica,
				ie_tipo_complemento,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nm_usuario,
				dt_atualizacao,
				ds_endereco,
				ds_bairro,
				cd_municipio_ibge,
				cd_cep,
				sg_estado,
				nr_telefone,
				nr_ddi_telefone,
				nr_ddd_telefone,
				ds_municipio,
				cd_tipo_logradouro,
				ds_compl_end,
				ds_complemento,
				nr_seq_pais
				)
			values (nr_sequencia_w,
				cd_pessoa_fisica_p,
				2,
				'plusoft',
				clock_timestamp(),
				'plusoft',
				clock_timestamp(),
				substr(ds_endereco_com_p,1,100),
				substr(ds_bairro_com_p,1,80),
				cd_municipio_ibge_com_p,
				substr(cd_cep_com_p,1,15),
				substr(sg_estado_com_p,1,2),
				substr(nr_telefone_com_p,1,15),
				substr(nr_ddi_telefone_com_p,1,3),
				substr(nr_ddd_telefone_com_p,1,3),
				substr(ds_municipio_com_p,1,40),
				ds_tipo_logradouro_com_p,
				nr_endereco_com_p,
				substr(ds_complemento_com_p,1,40),
				ds_pais_com_p);
		else
			insert into compl_pessoa_fisica(nr_sequencia,
				cd_pessoa_fisica,
				ie_tipo_complemento,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nm_usuario,
				dt_atualizacao,
				ds_endereco,
				ds_bairro,
				cd_municipio_ibge,
				cd_cep,
				sg_estado,
				nr_telefone,
				nr_ddi_telefone,
				nr_ddd_telefone,
				ds_municipio,
				cd_tipo_logradouro,
				nr_endereco,
				ds_complemento,
				nr_seq_pais
				)
			values (nr_sequencia_w,
				cd_pessoa_fisica_p,
				2,
				'plusoft',
				clock_timestamp(),
				'plusoft',
				clock_timestamp(),
				substr(ds_endereco_com_p,1,100),
				substr(ds_bairro_com_p,1,80),
				cd_municipio_ibge_com_p,
				substr(cd_cep_com_p,1,15),
				substr(sg_estado_com_p,1,2),
				substr(nr_telefone_com_p,1,15),
				substr(nr_ddi_telefone_com_p,1,3),
				substr(nr_ddd_telefone_com_p,1,3),
				substr(ds_municipio_com_p,1,40),
				ds_tipo_logradouro_com_p,
				nr_endereco_com_p,
				substr(ds_complemento_com_p,1,40),
				ds_pais_com_p);
		end if;
else
	begin
	select	ds_municipio,
		nr_ddd_telefone,
		nr_ddi_telefone,
		nr_telefone,
		ds_bairro,
		cd_municipio_ibge,
		sg_estado,
		cd_cep,
		ds_endereco,
		coalesce(nr_endereco, ds_compl_end) nr_endereco,
		ds_complemento,
		ds_email,
		cd_tipo_logradouro
	into STRICT	ds_municipio_old_w,
		nr_ddd_telefone_old_w,
		nr_ddi_telefone_old_w,
		nr_telefone_old_w,
		ds_bairro_old_w,
		cd_municipio_ibge_old_w,
		sg_estado_old_w,
		cd_cep_old_w,
		ds_endereco_old_w,
		nr_endereco_old_w,
		ds_complemento_old_w,
		ds_email_old_w,
		cd_tipo_logradouro_old_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_complemento	= 2;
	exception
	when others then
		ds_municipio_old_w	:= null;
		nr_ddd_telefone_old_w	:= null;
		nr_ddi_telefone_old_w	:= null;
		nr_telefone_old_w	:= null;
		ds_bairro_old_w		:= null;
		cd_municipio_ibge_old_w	:= null;
		sg_estado_old_w		:= null;
		cd_cep_old_w		:= null;
		ds_endereco_old_w	:= null;
		nr_endereco_old_w	:= null;
		ds_complemento_old_w	:= null;
		ds_email_old_w		:= null;
		cd_tipo_logradouro_old_w:= null;
	end;
	
	/* COMPLEMENTO  COMERCIAL*/

	if (vl_parametro_w = 'S') then
		--Municipio
		if (ds_municipio_com_p IS NOT NULL AND ds_municipio_com_p::text <> '') and (upper(ds_municipio_com_p) <> upper(ds_municipio_old_w) or coalesce(ds_municipio_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(ds_municipio_old_w, ds_municipio_com_p, 'DS_MUNICIPIO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--DDD
		if (nr_ddd_telefone_com_p IS NOT NULL AND nr_ddd_telefone_com_p::text <> '') and (nr_ddd_telefone_com_p <> nr_ddd_telefone_old_w or coalesce(nr_ddd_telefone_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(nr_ddd_telefone_old_w, nr_ddd_telefone_com_p, 'NR_DDD_TELEFONE', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--DDI
		if (nr_ddi_telefone_com_p IS NOT NULL AND nr_ddi_telefone_com_p::text <> '') and (nr_ddi_telefone_com_p <> nr_ddi_telefone_old_w or coalesce(nr_ddi_telefone_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(nr_ddi_telefone_old_w, nr_ddi_telefone_com_p, 'NR_DDI_TELEFONE', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Telefone
		if (nr_telefone_com_p IS NOT NULL AND nr_telefone_com_p::text <> '') and (nr_telefone_com_p <> nr_telefone_old_w or coalesce(nr_telefone_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(nr_telefone_old_w, nr_telefone_com_p, 'NR_TELEFONE', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Bairro
		if (ds_bairro_com_p IS NOT NULL AND ds_bairro_com_p::text <> '') and (upper(ds_bairro_com_p) <> upper(ds_bairro_old_w) or coalesce(ds_bairro_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(ds_bairro_old_w, ds_bairro_com_p, 'DS_BAIRRO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--IBGE
		if (cd_municipio_ibge_com_p IS NOT NULL AND cd_municipio_ibge_com_p::text <> '') and (cd_municipio_ibge_com_p <> cd_municipio_ibge_old_w or coalesce(cd_municipio_ibge_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(cd_municipio_ibge_old_w, cd_municipio_ibge_com_p, 'CD_MUNICIPIO_IBGE', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--UF
		if (sg_estado_com_p IS NOT NULL AND sg_estado_com_p::text <> '') and (sg_estado_com_p <> sg_estado_old_w or coalesce(sg_estado_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(sg_estado_old_w, sg_estado_com_p, 'SG_ESTADO', cd_pessoa_fisica_p, null , nm_usuario_p);
		end if;
		--CEP 
		if (cd_cep_com_p IS NOT NULL AND cd_cep_com_p::text <> '') and (cd_cep_com_p <> cd_cep_old_w or coalesce(cd_cep_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(cd_cep_old_w, cd_cep_com_p, 'CD_CEP', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Endereco
		if (ds_endereco_com_p IS NOT NULL AND ds_endereco_com_p::text <> '') and (upper(ds_endereco_com_p) <> upper(ds_endereco_old_w) or coalesce(ds_endereco_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt( ds_endereco_old_w, ds_endereco_com_p, 'DS_ENDERECO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Numero
		if (nr_endereco_com_p IS NOT NULL AND nr_endereco_com_p::text <> '') and (nr_endereco_com_p <> nr_endereco_old_w or coalesce(nr_endereco_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(nr_endereco_old_w, nr_endereco_com_p, 'NR_ENDERECO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Complemento
		if (ds_complemento_com_p IS NOT NULL AND ds_complemento_com_p::text <> '') and (upper(ds_complemento_com_p) <> upper(ds_complemento_old_w) or coalesce(ds_complemento_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(ds_complemento_old_w, ds_complemento_com_p, 'DS_COMPLEMENTO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
		--Logradouro
		if (ds_tipo_logradouro_com_p IS NOT NULL AND ds_tipo_logradouro_com_p::text <> '') and (ds_tipo_logradouro_com_p <> cd_tipo_logradouro_old_w or coalesce(cd_tipo_logradouro_old_w::text, '') = '') then
			CALL pls_gerar_solicitacao_alt(cd_tipo_logradouro_old_w, ds_tipo_logradouro_com_p, 'CD_TIPO_LOGRADOURO', cd_pessoa_fisica_p, null, nm_usuario_p);
		end if;
	else
		if (tag_pais_w = 'de_DE')then
			update	compl_pessoa_fisica
			set	ds_municipio		= ds_municipio_com_p,
				nr_ddd_telefone		= nr_ddd_telefone_com_p,
				nr_ddi_telefone		= nr_ddi_telefone_com_p,
				nr_telefone		= nr_telefone_com_p,
				ds_bairro		= ds_bairro_com_p,
				cd_municipio_ibge	= cd_municipio_ibge_com_p,
				sg_estado		= sg_estado_com_p,
				cd_cep			= cd_cep_com_p,
				ds_endereco		= ds_endereco_com_p,
				ds_compl_end		= nr_endereco_com_p,
				ds_complemento		= ds_complemento_com_p,
				cd_tipo_logradouro	= ds_tipo_logradouro_com_p,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	cd_pessoa_fisica	= cd_pessoa_fisica_p
			and	ie_tipo_complemento	= 2;
		else
			update	compl_pessoa_fisica
			set	ds_municipio		= ds_municipio_com_p,
				nr_ddd_telefone		= nr_ddd_telefone_com_p,
				nr_ddi_telefone		= nr_ddi_telefone_com_p,
				nr_telefone		= nr_telefone_com_p,
				ds_bairro		= ds_bairro_com_p,
				cd_municipio_ibge	= cd_municipio_ibge_com_p,
				sg_estado		= sg_estado_com_p,
				cd_cep			= cd_cep_com_p,
				ds_endereco		= ds_endereco_com_p,
				nr_endereco		= nr_endereco_com_p,
				ds_complemento		= ds_complemento_com_p,
				cd_tipo_logradouro	= ds_tipo_logradouro_com_p,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	cd_pessoa_fisica	= cd_pessoa_fisica_p
			and	ie_tipo_complemento	= 2;
		end if;
	end if;
	
	CALL pls_tasy_gerar_solic_compl(cd_pessoa_fisica_p, 2,'A','pls_obj_plussoft_pck.salvar_alteracoes_pf()');
end if;

commit;
--Sucesso
ie_retorno_p := 0;

exception
when others then
	--Erro
	ie_retorno_p := 1;
	ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110549, 'DS_ERRO='||sqlerrm(SQLSTATE)) ,1,255);
	rollback;
end;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obj_plussoft_pck.salvar_alteracoes_pf ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nm_pessoa_fisica_p pessoa_fisica.nm_pessoa_fisica%type, nm_abreviado_p pessoa_fisica.nm_abreviado%type, ie_sexo_p pessoa_fisica.ie_sexo%type, ie_estado_civil_p pessoa_fisica.ie_estado_civil%type, nr_ddi_telefone_res_p text, nr_ddd_telefone_res_p text, nr_telefone_res_p text, ds_fone_adic_p text, nr_ddi_celular_p text, nr_ddd_celular_p text, nr_telefone_celular_p text, nr_ddi_telefone_com_p text, nr_ddd_telefone_com_p text, nr_telefone_com_p text, ds_email_pf_p text,  ie_tipo_complemento_res_p text, cd_cep_res_p text, ds_pais_res_p text, sg_estado_res_p text, ds_municipio_res_p text, ds_tipo_logradouro_res_p text, ds_endereco_res_p text, nr_endereco_res_p text, ds_complemento_res_p text, cd_municipio_ibge_res_p text, ds_bairro_res_p text, ie_endereco_pagador_res_p text,  ie_tipo_complemento_com_p text, cd_cep_com_p text, ds_pais_com_p text, sg_estado_com_p text, ds_municipio_com_p text, ds_tipo_logradouro_com_p text, ds_endereco_com_p text, nr_endereco_com_p text, ds_complemento_com_p text, cd_municipio_ibge_com_p text, ds_bairro_com_p text, ie_endereco_pagador_com_p text,  nr_identidade_p text, nr_inscricao_estadual_p text, nr_cpf_p text, dt_nascimento_p text, ds_cargo_p text, ds_observacao_pf_p text, nr_pais_ci_p bigint, nm_usuario_p text, ds_naturalidade_p text,  ie_retorno_p INOUT bigint, ds_mensagem_erro_p INOUT text) FROM PUBLIC;