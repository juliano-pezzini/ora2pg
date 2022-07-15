-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eme_importa_pessoa ( NM_PESSOA_FISICA_P text, NR_CPF_P text, NR_IDENTIDADE_P text, DS_ORGAO_EMISSOR_CI_P text, DT_NASCIMENTO_P timestamp, IE_SEXO_P text, DS_ENDERECO_P text, NR_ENDERECO_P text, DS_COMPLEMENTO_P text, DS_BAIRRO_P text, DS_MUNICIPIO_P text, SG_ESTADO_P text, CD_CEP_P text, DS_EMAIL_P text, NR_TELEFONE_P text, NM_USUARIO_P text) AS $body$
DECLARE


nm_pessoa_fisica_w		varchar(60);
cd_pessoa_fisica_w		varchar(10);
nr_sequencia_compl_w		smallint;


BEGIN

select	initcap(retira_caracter_final(nm_pessoa_fisica_p,''))
into STRICT	nm_pessoa_fisica_w
;

/* verifica se existe no cadastro pessoa fisica */

select	coalesce(max(cd_pessoa_fisica),0)
into STRICT	cd_pessoa_fisica_w
from	pessoa_fisica
where	dt_nascimento	= dt_nascimento_p
and	ie_sexo		= ie_sexo_p
and	upper(nm_pessoa_fisica) like upper('%' || nm_pessoa_fisica_w || '%');

if (cd_pessoa_fisica_w = 0) then
	begin
	select	nextval('pessoa_fisica_seq')
	into STRICT	cd_pessoa_fisica_w
	;

	insert	into pessoa_fisica(
		cd_pessoa_fisica,
		nm_pessoa_fisica,
		nr_cpf,
		nr_identidade,
		ds_orgao_emissor_ci,
		dt_nascimento,
		ie_sexo,
		ie_tipo_pessoa,
		dt_atualizacao,
		nm_usuario)
	values (
		cd_pessoa_fisica_w,
		nm_pessoa_fisica_p,
		nr_cpf_p,
		nr_identidade_p,
		ds_orgao_emissor_ci_p,
		dt_nascimento_p,
		ie_sexo_p,
		2,
		clock_timestamp(),
		nm_usuario_p);

	select (coalesce(max(nr_sequencia),0)+1)
	into STRICT 	nr_sequencia_compl_w
	from 	compl_pessoa_fisica
	where 	cd_pessoa_fisica = cd_pessoa_fisica_w;

	insert into compl_pessoa_fisica(
		cd_pessoa_fisica,
		nr_sequencia,
		ie_tipo_complemento,
		ds_endereco,
		nr_endereco,
		ds_complemento,
		ds_bairro,
		ds_municipio,
		sg_estado,
		cd_cep,
		ds_email,
		nr_telefone,
		dt_atualizacao,
		nm_usuario)
	values (
		cd_pessoa_fisica_w,
		nr_sequencia_compl_w,
		1,
		ds_endereco_p,
		nr_endereco_p,
		ds_complemento_p,
		ds_bairro_p,
		ds_municipio_p,
		sg_estado_p,
		cd_cep_p,
		ds_email_p,
		nr_telefone_p,
		clock_timestamp(),
		nm_usuario_p);
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eme_importa_pessoa ( NM_PESSOA_FISICA_P text, NR_CPF_P text, NR_IDENTIDADE_P text, DS_ORGAO_EMISSOR_CI_P text, DT_NASCIMENTO_P timestamp, IE_SEXO_P text, DS_ENDERECO_P text, NR_ENDERECO_P text, DS_COMPLEMENTO_P text, DS_BAIRRO_P text, DS_MUNICIPIO_P text, SG_ESTADO_P text, CD_CEP_P text, DS_EMAIL_P text, NR_TELEFONE_P text, NM_USUARIO_P text) FROM PUBLIC;

