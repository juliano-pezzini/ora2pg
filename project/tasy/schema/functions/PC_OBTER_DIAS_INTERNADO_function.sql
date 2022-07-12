-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pc_obter_dias_internado ( nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

		
qt_dias_internacao_w	bigint;
dt_entrada_w			timestamp;
dt_alta_w				timestamp;
		

BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select	trunc(dt_entrada),
			trunc(coalesce(dt_alta, clock_timestamp()))
	into STRICT	dt_entrada_w,
			dt_alta_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;
	
	qt_dias_internacao_w := (dt_alta_w - dt_entrada_w) + 1;

end if;

return qt_dias_internacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pc_obter_dias_internado ( nr_atendimento_p bigint) FROM PUBLIC;
