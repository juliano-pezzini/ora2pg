-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medico_convenio ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_prestador_p text default null, cd_especialidade_p bigint default null, cd_categoria_p text default null, cd_setor_atendimento_p bigint default null, dt_referencia_p timestamp default clock_timestamp(), ie_tipo_atendimento_p bigint default null, ie_funcao_medico_p text default null, ie_carater_inter_sus_p text default null) RETURNS varchar AS $body$
DECLARE


cd_medico_convenio_w		varchar(15);
dt_referencia_w			timestamp;

c01 CURSOR FOR
	SELECT	cd_medico_convenio
	from	medico_convenio
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	cd_convenio	= cd_convenio_p
	and	((cd_estabelecimento = cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = ''))
	and 	((coalesce(cd_prestador,'0')	= coalesce(cd_prestador_p, '0')) or (coalesce(cd_prestador::text, '') = ''))
	and 	((coalesce(cd_especialidade,0) = coalesce(cd_especialidade_p,0)) or (coalesce(cd_especialidade::text, '') = ''))
	and 	((coalesce(cd_categoria::text, '') = '') or (coalesce(cd_categoria,'0')  = coalesce(cd_categoria_p,'0')))
	and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_p,0)) = coalesce(cd_setor_atendimento_p,0)
	and	dt_referencia_w between coalesce(dt_inicio_vigencia,dt_referencia_w) and fim_dia(coalesce(dt_final_vigencia,dt_referencia_w))
	and (coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p,0)) = coalesce(ie_tipo_atendimento_p,0) or (coalesce(ie_tipo_atendimento_p::text, '') = ''))
	and	((coalesce(ie_funcao_medico, coalesce(ie_funcao_medico_p,'0')) = coalesce(ie_funcao_medico_p, '0')) or (coalesce(ie_funcao_medico_p,'0') = '0'))
	and	coalesce(ie_carater_inter_sus, coalesce(ie_carater_inter_sus_p,'0')) = coalesce(ie_carater_inter_sus_p,'0')
	order by
		coalesce(cd_estabelecimento,0),
		coalesce(cd_especialidade,0),
		somente_numero(coalesce(cd_prestador,'0')),
		somente_numero(coalesce(cd_categoria,'0')),
		coalesce(cd_setor_atendimento,0),
		somente_numero(coalesce(ie_funcao_medico, '0')),
		somente_numero(coalesce(ie_carater_inter_sus,'0'));


BEGIN

cd_medico_convenio_w	:= '';
dt_referencia_w		:= coalesce(dt_referencia_p,clock_timestamp());

open c01;
loop
fetch c01 into
	cd_medico_convenio_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	cd_medico_convenio_w		:= cd_medico_convenio_w;
end loop;
close c01;


return cd_medico_convenio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medico_convenio ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_prestador_p text default null, cd_especialidade_p bigint default null, cd_categoria_p text default null, cd_setor_atendimento_p bigint default null, dt_referencia_p timestamp default clock_timestamp(), ie_tipo_atendimento_p bigint default null, ie_funcao_medico_p text default null, ie_carater_inter_sus_p text default null) FROM PUBLIC;
