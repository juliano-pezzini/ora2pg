-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eme_importa_usuario ( cd_unimed_p text, cd_empresa_p text, cd_familia_p text, cd_dependencia_p text, nm_usuario_unimed_p text, nr_cpf_p text, dt_inclusao_p timestamp, dt_exclusao_p timestamp, dt_nascimento_p timestamp, ie_sexo_p text, ie_estado_civil_p text, ie_tipo_cliente_p text, nm_usuario_p text, nr_seq_contrato_p bigint, nr_seq_tipo_servico_p bigint, ie_importou_p INOUT text ) AS $body$
DECLARE



cd_pessoa_dependente_w	varchar(10);
cd_pessoa_cadastro_w		varchar(10);
cd_pf_titular_w		varchar(10);
cd_codigo_convenio_w		varchar(30);
nr_seq_dependente_w		bigint;
nr_seq_pf_contrato_w		bigint;
nm_usuario_unimed_w		varchar(60);
nm_pessoa_dependente_w	varchar(60);


BEGIN
cd_codigo_convenio_w	:= cd_unimed_p || cd_empresa_p || cd_familia_p || cd_dependencia_p;

select	initcap(retira_caracter_final(nm_usuario_unimed_p,''))
into STRICT	nm_usuario_unimed_w
;

/* verifica se o usuario existe no cadastro dos dependentes */

select	coalesce(max(cd_pessoa_fisica),0)
into STRICT	cd_pessoa_dependente_w
from	eme_pf_contrato
where	cd_codigo_convenio = cd_codigo_convenio_w;

if (cd_pessoa_dependente_w > 0) then
	begin
	update	eme_pf_contrato
	set	dt_cancelamento	= dt_exclusao_p
	where	cd_codigo_convenio = cd_codigo_convenio_w;

	select	nm_pessoa_fisica
	into STRICT	nm_pessoa_dependente_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_dependente_w;

	if (nm_pessoa_dependente_w <> nm_usuario_unimed_w) then
		update	pessoa_fisica
		set	nm_pessoa_fisica = nm_usuario_unimed_w,
			dt_atualizacao	 = clock_timestamp(),
			nm_usuario	 = nm_usuario_p
		where	cd_pessoa_fisica = cd_pessoa_dependente_w;
	end if;
	end;
end if;

if (cd_pessoa_dependente_w = 0) then
	begin
	/* verifica se existe no cadastro pessoa fisica */

	select	coalesce(max(cd_pessoa_fisica),0)
	into STRICT	cd_pessoa_cadastro_w
	from	pessoa_fisica
	where	dt_nascimento	= dt_nascimento_p
	and	cd_sistema_ant	= cd_codigo_convenio_w;
/*	and	upper(nm_pessoa_fisica) = upper('%' || nm_usuario_unimed_w || '%'); */

	if (cd_pessoa_cadastro_w = 0) then
		begin
		select	nextval('pessoa_fisica_seq')
		into STRICT	cd_pessoa_cadastro_w
		;

		insert	into pessoa_fisica(
			cd_pessoa_fisica,
			nm_pessoa_fisica,
			dt_nascimento,
			ie_tipo_pessoa,
			dt_atualizacao,
			nm_usuario,
			ie_sexo,
			cd_sistema_ant)
		values (
			cd_pessoa_cadastro_w,
			nm_usuario_unimed_w,
			dt_nascimento_p,
			2,
			clock_timestamp(),
			nm_usuario_p,
			ie_sexo_p,
			cd_codigo_convenio_w);
		end;
	end if;

	if (cd_dependencia_p <> '00') then
		select	coalesce(max(cd_pessoa_fisica),0)
		into STRICT	cd_pf_titular_w
		from	eme_pf_contrato
		where	cd_codigo_convenio = cd_unimed_p || cd_empresa_p || cd_familia_p || '00';
	else
		cd_pf_titular_w	:= cd_pessoa_cadastro_w;
	end if;

	ie_importou_p	:= 'N';
	if (cd_pf_titular_w <> 0) then
		begin
		select	nextval('eme_pf_contrato_seq')
		into STRICT	nr_seq_pf_contrato_w
		;

		insert	into eme_pf_contrato(
			nr_sequencia,
			nr_seq_contrato,
			nr_seq_tipo_servico,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			cd_codigo_convenio,
			dt_cancelamento,
			dt_inclusao,
			cd_pf_titular)
		values (
			nr_seq_pf_contrato_w,
			nr_seq_contrato_p,
			nr_seq_tipo_servico_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_cadastro_w,
			cd_codigo_convenio_w,
			dt_exclusao_p,
			dt_inclusao_p,
			cd_pf_titular_w);
		ie_importou_p	:= 'S';
		end;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eme_importa_usuario ( cd_unimed_p text, cd_empresa_p text, cd_familia_p text, cd_dependencia_p text, nm_usuario_unimed_p text, nr_cpf_p text, dt_inclusao_p timestamp, dt_exclusao_p timestamp, dt_nascimento_p timestamp, ie_sexo_p text, ie_estado_civil_p text, ie_tipo_cliente_p text, nm_usuario_p text, nr_seq_contrato_p bigint, nr_seq_tipo_servico_p bigint, ie_importou_p INOUT text ) FROM PUBLIC;

