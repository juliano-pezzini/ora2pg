-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_titular_conv_rn ( nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


nm_pessoa_fisica_w		varchar(255);
qt_dias_int_titular_conv_w	smallint;
qt_dias_internado_w		bigint;
cd_pessoa_fisica_w		varchar(10);
cd_pf_titular_conv_w		varchar(10);
dt_inicial_conta_w		timestamp := clock_timestamp();
ie_data_atecaco_w		varchar(10);
ie_atendimento_rn_w		varchar(10);


BEGIN

select	max(qt_dias_int_titular_conv),
	coalesce(max(ie_data_atecaco),'A')
into STRICT	qt_dias_int_titular_conv_w,
	ie_data_atecaco_w
from	tiss_parametros_convenio
where	cd_convenio		= cd_convenio_p
and	cd_estabelecimento	= cd_estabelecimento_p;

select	max(Obter_Dias_Internacao(a.nr_atendimento)),
	max(a.cd_pessoa_fisica),
	max(coalesce(tiss_obter_nome_abreviado(cd_convenio_p, cd_estabelecimento_p, a.cd_pessoa_fisica), b.nm_pessoa_fisica)),
	max(tiss_obter_se_atend_rn(a.nr_atendimento))
into STRICT	qt_dias_internado_w,
	cd_pessoa_fisica_w,
	nm_pessoa_fisica_w,
	ie_atendimento_rn_w
from	atendimento_paciente a,
	pessoa_fisica b
where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
and	a.nr_atendimento	= nr_atendimento_p;

if (coalesce(nr_interno_conta_p,0)	> 0) then

	select	max(dt_periodo_inicial)
	into STRICT	dt_inicial_conta_w
	from	conta_paciente
	where	nr_interno_conta	= nr_interno_conta_p;

end if;


if (ie_atendimento_rn_w = 'S') and (coalesce(qt_dias_int_titular_conv_w,0) > 0) and (coalesce(qt_dias_internado_w,0) > 0) and (coalesce(qt_dias_internado_w,0) <= coalesce(qt_dias_int_titular_conv_w,0)) then


	if (coalesce(ie_data_atecaco_w,'A') = 'A') then
		select	max(a.cd_pessoa_titular)
		into STRICT	cd_pf_titular_conv_w
		from	pessoa_titular_convenio a
		where	a.cd_pessoa_fisica 	= cd_pessoa_fisica_w
		and	a.cd_convenio		= cd_convenio_p
		and	clock_timestamp()	between coalesce(dt_inicio_vigencia,clock_timestamp() - interval '1 days') and coalesce(dt_fim_vigencia,clock_timestamp() + interval '1 days');

		if (coalesce(cd_pf_titular_conv_w::text, '') = '') then

			begin
			select	a.cd_pessoa_titular
			into STRICT	cd_pf_titular_conv_w
			from	pessoa_titular_convenio a,
				atendimento_paciente b
			where	b.nr_atendimento	= nr_atendimento_p
			and	a.cd_pessoa_fisica 	= (SELECT max(x.cd_pessoa_fisica)
							from atendimento_paciente x
							where x.nr_atendimento = b.nr_atendimento_mae)
			and	a.cd_convenio		= cd_convenio_p
			and	clock_timestamp()	between coalesce(dt_inicio_vigencia,clock_timestamp() - interval '1 days') and coalesce(dt_fim_vigencia,clock_timestamp() + interval '1 days')  LIMIT 1;
			exception
			when others then
				cd_pf_titular_conv_w	:= null;
			end;

		end if;
	else
		select	max(a.cd_pessoa_titular)
		into STRICT	cd_pf_titular_conv_w
		from	pessoa_titular_convenio a
		where	a.cd_pessoa_fisica 	= cd_pessoa_fisica_w
		and	a.cd_convenio		= cd_convenio_p
		and	dt_inicial_conta_w	between coalesce(dt_inicio_vigencia,dt_inicial_conta_w - 1) and coalesce(dt_fim_vigencia,dt_inicial_conta_w + 1);

		if (coalesce(cd_pf_titular_conv_w::text, '') = '') then

			begin
			select	a.cd_pessoa_titular
			into STRICT	cd_pf_titular_conv_w
			from	pessoa_titular_convenio a,
				atendimento_paciente b
			where	b.nr_atendimento	= nr_atendimento_p
			and	a.cd_pessoa_fisica 	= (SELECT max(x.cd_pessoa_fisica)
							from atendimento_paciente x
							where x.nr_atendimento = b.nr_atendimento_mae)
			and	a.cd_convenio		= cd_convenio_p
			and	dt_inicial_conta_w	between coalesce(dt_inicio_vigencia,dt_inicial_conta_w - 1) and coalesce(dt_fim_vigencia,dt_inicial_conta_w + 1)  LIMIT 1;
			exception
			when others then
				cd_pf_titular_conv_w	:= null;
			end;

		end if;
	end if;

	if (cd_pf_titular_conv_w IS NOT NULL AND cd_pf_titular_conv_w::text <> '') then

		nm_pessoa_fisica_w	:= substr('RN de '||obter_nome_pf_pj(cd_pf_titular_conv_w,null),1,100);

	end if;
end if;

return	nm_pessoa_fisica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_titular_conv_rn ( nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
