-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_horario_visita ( cd_paciente_p text, dt_nascimento_p timestamp, dt_entrada_p timestamp) RETURNS varchar AS $body$
DECLARE



ds_retorno_w	varchar(1);
count_w		bigint;


BEGIN

select	count(*)
into STRICT	count_w
from	regra_horario_visita
where  	coalesce(cd_pessoa_fisica,cd_paciente_p) = cd_paciente_p;

if (count_w > 0) then

	select	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from   	regra_horario_visita
	where  	coalesce(cd_pessoa_fisica,cd_paciente_p) = cd_paciente_p
	and	((to_char(dt_entrada_p,'hh24') between ds_horario_inicio and ds_horario_fim) or (coalesce(ds_horario_inicio::text, '') = ''))
	and	obter_idade(dt_nascimento_p,clock_timestamp(),'A') between qt_idade_min and qt_idade_max;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_horario_visita ( cd_paciente_p text, dt_nascimento_p timestamp, dt_entrada_p timestamp) FROM PUBLIC;

