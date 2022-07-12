-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_espera_atend (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_min_espera_w		bigint	:= 0;


BEGIN

if (coalesce(nr_atendimento_p,0) > 0) then
	begin
	select	round((coalesce(dt_alta, clock_timestamp()) - dt_entrada) * 1440)
	into STRICT	qt_min_espera_w
	from 	atendimento_paciente
	where	nr_atendimento		= nr_atendimento_p;
	exception
	when 	others then
		qt_min_espera_w	:= 0;
	end;
end if;

return	qt_min_espera_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_espera_atend (nr_atendimento_p bigint) FROM PUBLIC;

