-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_trimestre_gestacional (nr_atendimento_p bigint, dt_inicio_atendimento_p timestamp, ie_paciente_gravida_p text) RETURNS bigint AS $body$
DECLARE


ds_retorno_w    bigint;


BEGIN
  ds_retorno_w := 0;

  if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	select max(
		case
		when(ag.dt_ultima_menstruacao IS NOT NULL AND ag.dt_ultima_menstruacao::text <> '') and ((coalesce(ie_paciente_gravida_p, ag.ie_pac_gravida) IS NOT NULL AND (coalesce(ie_paciente_gravida_p, ag.ie_pac_gravida))::text <> ''))
		then
			case
				when trunc( months_between(trunc(dt_inicio_atendimento_p), trunc(ag.dt_ultima_menstruacao) )) <= 3
				then 1
				when trunc( months_between(trunc(dt_inicio_atendimento_p), trunc(ag.dt_ultima_menstruacao) )) <= 6
				then 2
				when trunc( months_between(trunc(dt_inicio_atendimento_p), trunc(ag.dt_ultima_menstruacao) )) > 6
				then 3
			end
			else -1
		end)
	into STRICT ds_retorno_w
	from atendimento_gravidez ag
	where ie_situacao = 'A'
	and ag.nr_atendimento  = nr_atendimento_p;

  end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_trimestre_gestacional (nr_atendimento_p bigint, dt_inicio_atendimento_p timestamp, ie_paciente_gravida_p text) FROM PUBLIC;

