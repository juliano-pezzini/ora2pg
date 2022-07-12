-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_dieta_prescr ( nr_atendimento_p bigint, nr_horas_anteriores_p bigint, dt_prescricao_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

if (nr_horas_anteriores_p = 0) then
	select	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from   	prescr_medica b,
		prescr_dieta a
	where  	a.nr_prescricao = b.nr_prescricao
	and	b.nr_atendimento = nr_atendimento_p
	and	trunc(b.dt_prescricao,'dd') = trunc(clock_timestamp(), 'dd')
	and	((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') OR (b.dt_liberacao_medico IS NOT NULL AND b.dt_liberacao_medico::text <> ''));
else
	select	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from   	prescr_medica b,
		prescr_dieta a
	where  	a.nr_prescricao = b.nr_prescricao
	and	b.nr_atendimento = nr_atendimento_p
	and	b.dt_prescricao	< dt_prescricao_p - nr_horas_anteriores_p/24
	and	((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') OR (b.dt_liberacao_medico IS NOT NULL AND b.dt_liberacao_medico::text <> ''));
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_dieta_prescr ( nr_atendimento_p bigint, nr_horas_anteriores_p bigint, dt_prescricao_p timestamp) FROM PUBLIC;

