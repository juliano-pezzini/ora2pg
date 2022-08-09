-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_titular_convenio ( nm_usuario_p text, cd_convenio_p bigint, cd_categoria_p text, cd_pessoa_fisica_p text, cd_plano_convenio_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, dt_validade_carteira_p timestamp, cd_usuario_convenio_p text default null, ie_tipo_conveniado_p bigint default null) AS $body$
DECLARE

			
nr_sequencia_w		bigint;
qt_pessoa_tit_w		bigint;
nr_prioridade_w		pessoa_titular_convenio.nr_prioridade%type;
ie_atualiza_titular_conv_w	varchar(1);


BEGIN

if (coalesce(cd_convenio_p,0) > 0) and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	
  ie_atualiza_titular_conv_w := obter_param_usuario(916, 842, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_atualiza_titular_conv_w);
	select	count(*)
	into STRICT	qt_pessoa_tit_w
	from	pessoa_titular_convenio
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	cd_convenio	 = cd_convenio_p
	and	cd_categoria	 = cd_categoria_p
  and (ie_atualiza_titular_conv_w <> 'C' or cd_usuario_convenio = cd_usuario_convenio_p);
	
	if (qt_pessoa_tit_w = 0) then
	
		if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') in ('de_DE', 'de_AT'))then
			select	max(c.nr_prioridade_padrao)
			into STRICT	nr_prioridade_w
			from 	convenio c
			where	c.cd_convenio = cd_convenio_p;
			
			if (coalesce(nr_prioridade_w::text, '') = '')then
				select  coalesce(max(ptc.nr_prioridade),0)
				into STRICT   	nr_prioridade_w
				from    pessoa_titular_convenio ptc,
					convenio  c
				where   ptc.cd_convenio = c.cd_convenio
				and     c.ie_tipo_convenio <> 1
				and     ptc.cd_pessoa_fisica = cd_pessoa_fisica_p;
						
				if (nr_prioridade_w < 9999) then
					nr_prioridade_w := nr_prioridade_w + 1;
				end if;			
			end if;
		end if;
		
		select	nextval('pessoa_titular_convenio_seq')
		into STRICT	nr_sequencia_w
		;

		insert into pessoa_titular_convenio(	nr_sequencia,	
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							dt_atualizacao,
							nm_usuario,
							cd_pessoa_fisica,
							cd_pessoa_titular,
							cd_convenio,
							cd_categoria,
							cd_plano_convenio,
							dt_inicio_vigencia,
							dt_fim_vigencia,
							dt_validade_carteira,
							cd_usuario_convenio,
							ie_tipo_conveniado,
							nr_prioridade)
					values (	nr_sequencia_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							cd_pessoa_fisica_p,
							cd_pessoa_fisica_p,
							cd_convenio_p,
							cd_categoria_p,
							cd_plano_convenio_p,
							dt_inicio_vigencia_p,
							dt_fim_vigencia_p,
							dt_validade_carteira_p,
							cd_usuario_convenio_p,
							ie_tipo_conveniado_p,
							nr_prioridade_w);

	end if;
end if;

--commit; ********procedure utilizada em uma trigger, nao pode usar commit
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_titular_convenio ( nm_usuario_p text, cd_convenio_p bigint, cd_categoria_p text, cd_pessoa_fisica_p text, cd_plano_convenio_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, dt_validade_carteira_p timestamp, cd_usuario_convenio_p text default null, ie_tipo_conveniado_p bigint default null) FROM PUBLIC;
