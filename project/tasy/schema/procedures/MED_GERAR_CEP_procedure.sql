-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_gerar_cep ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, cd_cep_p text, nm_localidade_p INOUT text, cd_unidade_federacao_p INOUT text, cd_municipio_ibge_p INOUT text, nm_logradouro_p INOUT text, nm_bairro_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_tamanho_cep_w	bigint;
ie_cep_internet_w	varchar(1);
nm_logradouro_w		varchar(80);
nm_localidade_w		varchar(60);
nm_bairro_w		varchar(80);
cd_unidade_federacao_w	valor_dominio.vl_dominio%type;
nr_logradouro_w		integer;
cd_municipio_ibge_w	varchar(6);
qt_municipio_w		bigint;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_cep_p IS NOT NULL AND cd_cep_p::text <> '') then
	begin

	select	length(cd_cep_p)
	into STRICT	qt_tamanho_cep_w
	;

	if (qt_tamanho_cep_w > 7) then
		begin
		ie_cep_internet_w	:= coalesce(obter_valor_param_usuario(0, 25, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p), 'N');

		if (ie_cep_internet_w = 'N') then
			select	a.nm_logradouro,
				a.nm_localidade,
				a.nm_bairro,
				a.cd_unidade_federacao,
				a.nr_logradouro
			into STRICT	nm_logradouro_w,
				nm_localidade_w,
				nm_bairro_w,
				cd_unidade_federacao_w,
				nr_logradouro_w
			from	cep_logradouro a
                        where	a.cd_logradouro		= cd_cep_p;
		else
			begin
			select	a.nm_logradouro,
				b.nm_localidade,
				c.ds_bairro,
				a.ds_uf,
				a.cd_cep
			into STRICT	nm_logradouro_w,
				nm_localidade_w,
				nm_bairro_w,
				cd_unidade_federacao_w,
				nr_logradouro_w
                        from	cep_loc b,
				cep_bairro c,
				cep_log a
                        where	b.nr_sequencia		= c.nr_seq_loc
                        and   	a.cd_bairro_inicial	= c.nr_sequencia
                        and   	b.nr_sequencia      	= a.nr_seq_loc
                        and   	a.cd_cep            	= cd_cep_p;

			if (coalesce(nr_logradouro_w::text, '') = '') then
				select	null,
					b.nm_localidade,
					null bairro,
					b.ds_uf uf,
					b.cd_cep cep
				into STRICT	nm_logradouro_w,
					nm_localidade_w,
					nm_bairro_w,
					cd_unidade_federacao_w,
					nr_logradouro_w
                                from	cep_loc b
                                where	b.cd_cep	= cd_cep_p;
			end if;
			end;
		end if;

		select	count(*)
		into STRICT	qt_municipio_w
                from	sus_municipio b,
			cep_municipio a
		where	a.cd_municipio	= b.cd_municipio_sinpas
                and	a.cd_cep	= cd_cep_p;

		if (qt_municipio_w > 0) then

			select	b.cd_municipio_ibge
			into STRICT	cd_municipio_ibge_w
			from	sus_municipio b,
				cep_municipio a
			where	a.cd_municipio	= b.cd_municipio_sinpas
			and	a.cd_cep	= cd_cep_p;

		end if;
		end;
	end if;
	end;
end if;

nm_localidade_p		:= nm_localidade_w;
cd_unidade_federacao_p	:= cd_unidade_federacao_w;
cd_municipio_ibge_p	:= cd_municipio_ibge_w;
nm_logradouro_p		:= nm_logradouro_w;
nm_bairro_p		:= nm_bairro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_gerar_cep ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, cd_cep_p text, nm_localidade_p INOUT text, cd_unidade_federacao_p INOUT text, cd_municipio_ibge_p INOUT text, nm_logradouro_p INOUT text, nm_bairro_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
