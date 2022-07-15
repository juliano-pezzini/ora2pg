-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eup_obter_dados_tit_conv_js ( cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_empresa_p INOUT bigint, cd_convenio_ret_p INOUT bigint, cd_categoria_p INOUT text, dt_inicio_vigencia_p INOUT timestamp, dt_fim_vigencia_p INOUT timestamp, dt_validade_carteira_p INOUT timestamp, cd_usuario_convenio_p INOUT text, cd_plano_convenio_p INOUT text, ie_tipo_conveniado_p INOUT bigint, ie_grau_dependencia_p INOUT text, dt_entrada_p timestamp default clock_timestamp(), nr_seq_justificativa_p INOUT bigint DEFAULT NULL, nr_atendimento_p bigint default null, nr_seq_nivel_filiacao_p INOUT bigint DEFAULT NULL, dt_afiliacao_p INOUT timestamp DEFAULT NULL) AS $body$
DECLARE


is_self_payment_w		varchar(1);
is_bg_w				varchar(1);
timestamp_mask_w	pessoa_fisica.DS_EMPRESA_PF%type;
shortdate_mask_w	pessoa_fisica.DS_EMPRESA_PF%type;
nr_seq_justificativa_w		pessoa_fisica_taxa.nr_seq_justificativa%type;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (coalesce(cd_convenio_p,0) > 0) then

	select	max(cd_empresa_refer)
	into STRICT	cd_empresa_p
	from	pessoa_titular_convenio
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	cd_convenio = cd_convenio_p;
	
select
PKG_DATE_FORMATERS.localize_mask('timestamp',
  PKG_DATE_FORMATERS.getUserLanguageTag(WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO)) 
into STRICT timestamp_mask_w
;

select
PKG_DATE_FORMATERS.localize_mask('shortDate',
  PKG_DATE_FORMATERS.getUserLanguageTag(WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO)) 
into STRICT shortdate_mask_w
;


	select	substr(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'CV', dt_entrada_p),1,30),
		substr(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'CC', dt_entrada_p),1,30),
		to_date(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'DIV', dt_entrada_p),timestamp_mask_w),
        to_date(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'DFV', dt_entrada_p),timestamp_mask_w),
        to_date(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'DVC', dt_entrada_p),shortdate_mask_w),
        to_date(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'DA', dt_entrada_p),shortdate_mask_w),
		substr(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'CUV', dt_entrada_p),1,30),
		substr(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'CPC', dt_entrada_p),1,30),
		substr(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'ITC', dt_entrada_p),1,30),
		substr(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'IGD', dt_entrada_p),1,30),
		substr(obter_dados_titular_convenio(cd_pessoa_fisica_p, cd_convenio_p, 'NFC', dt_entrada_p),1,30)
	into STRICT	cd_convenio_ret_p,
		cd_categoria_p,
		dt_inicio_vigencia_p,
		dt_fim_vigencia_p,
		dt_validade_carteira_p,
		dt_afiliacao_p,
		cd_usuario_convenio_p,
		cd_plano_convenio_p,
		ie_tipo_conveniado_p,
		ie_grau_dependencia_p,
		nr_seq_nivel_filiacao_p
	;

	if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') in ('de_DE', 'de_AT')) then

		select  coalesce(max('S'),'N')
		into STRICT	is_self_payment_w
		from    convenio c
		where   c.cd_convenio = cd_convenio_p
		and     c.ie_tipo_convenio = 1
		and     c.ie_situacao = 'A';

		dt_inicio_vigencia_p := obter_data_nascto_pf(cd_pessoa_fisica_p);

		if (is_self_payment_w = 'N') then

			select	coalesce(max(pf.dt_inicio_vigencia), dt_inicio_vigencia_p)
			into STRICT	dt_inicio_vigencia_p
			from 	pessoa_titular_convenio pf
			where 	pf.cd_pessoa_fisica = cd_pessoa_fisica_p
			and 	pf.cd_convenio = cd_convenio_p;

			select  coalesce(max('S'),'N')
			into STRICT	is_bg_w
			from    tipo_admissao_fat taf
			where   taf.ie_situacao = 'A'
			and     taf.ie_tipo_bg = 'S'
			and     taf.nr_sequencia in ( SELECT  ce.nr_seq_tipo_admissao_fat
						      from    convenio_empresa ce
						      where   ce.cd_convenio = cd_convenio_p);

			if (is_bg_w = 'S') then
				ie_tipo_conveniado_p := 1;
			end if;

		else
			ie_tipo_conveniado_p := 6;
		end if;

		if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

			select 	get_justification_under_aged(cd_pessoa_fisica_p, cd_convenio_p, nr_atendimento_p)
			into STRICT	nr_seq_justificativa_w
			;

			if (coalesce(nr_seq_justificativa_w, 0) > 0) then
				nr_seq_justificativa_p := nr_seq_justificativa_w;
			end if;

		end if;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eup_obter_dados_tit_conv_js ( cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_empresa_p INOUT bigint, cd_convenio_ret_p INOUT bigint, cd_categoria_p INOUT text, dt_inicio_vigencia_p INOUT timestamp, dt_fim_vigencia_p INOUT timestamp, dt_validade_carteira_p INOUT timestamp, cd_usuario_convenio_p INOUT text, cd_plano_convenio_p INOUT text, ie_tipo_conveniado_p INOUT bigint, ie_grau_dependencia_p INOUT text, dt_entrada_p timestamp default clock_timestamp(), nr_seq_justificativa_p INOUT bigint DEFAULT NULL, nr_atendimento_p bigint default null, nr_seq_nivel_filiacao_p INOUT bigint DEFAULT NULL, dt_afiliacao_p INOUT timestamp DEFAULT NULL) FROM PUBLIC;

