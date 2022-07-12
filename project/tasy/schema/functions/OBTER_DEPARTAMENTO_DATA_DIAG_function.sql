-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_departamento_data_diag ( nr_atendimento_p bigint, dt_referencia_p timestamp default clock_timestamp()) RETURNS bigint AS $body$
DECLARE


cd_retorno_w		bigint;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select	max(b.cd_departamento)
	into STRICT	cd_retorno_w
	from	transf_departamento_medico a,
		departamento_medico b
	where	a.cd_depart_destino 	= b.cd_departamento
	and	a.nr_atendimento 	= nr_atendimento_p
	and	a.dt_transferencia 	= (	SELECT	max(x.dt_transferencia)
						from	transf_departamento_medico x
						where	x.nr_atendimento = nr_atendimento_p
						and	x.dt_transferencia <= dt_referencia_p);

	if (coalesce(cd_retorno_w::text, '') = '') then
		select 	max(b.cd_departamento)
		into STRICT	cd_retorno_w
		from	atend_paciente_unidade a,
			departamento_medico b
		where	a.cd_departamento	= b.cd_departamento
		and	a.nr_atendimento 	= nr_atendimento_p
		and	a.dt_entrada_unidade 	= (	SELECT	max(x.dt_entrada_unidade)
							from	atend_paciente_unidade x
							where	x.nr_atendimento = nr_atendimento_p
							and	x.dt_entrada_unidade <= dt_referencia_p);
	end if;

end if;

return	cd_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_departamento_data_diag ( nr_atendimento_p bigint, dt_referencia_p timestamp default clock_timestamp()) FROM PUBLIC;

