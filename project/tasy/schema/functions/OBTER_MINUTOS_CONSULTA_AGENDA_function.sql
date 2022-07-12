-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_minutos_consulta_agenda (nr_seq_agenda_p bigint) RETURNS bigint AS $body$
DECLARE


dt_inicio_consulta_w	timestamp;
dt_saida_w		timestamp;
retorno_w			bigint;


BEGIN

select	max(dt_inicio_consulta),
	coalesce(max(dt_saida), clock_timestamp())
into STRICT	dt_inicio_consulta_w,
	dt_saida_w
from	med_atendimento
where	nr_seq_agenda	= nr_seq_agenda_p;

if (dt_inicio_consulta_w IS NOT NULL AND dt_inicio_consulta_w::text <> '') then
	begin
	select 	to_number(CASE WHEN coalesce(dt_inicio_consulta_w::text, '') = '' THEN  null  ELSE round((coalesce(dt_saida_w,clock_timestamp()) - dt_inicio_consulta_w) * 1440) END )
	into STRICT	retorno_w
	;
	exception
		when others then
		retorno_w	:= 0;
	end;
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_minutos_consulta_agenda (nr_seq_agenda_p bigint) FROM PUBLIC;
