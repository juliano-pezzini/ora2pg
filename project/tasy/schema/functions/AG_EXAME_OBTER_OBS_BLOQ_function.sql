-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ag_exame_obter_obs_bloq ( cd_agenda_p bigint, dt_agenda_p timestamp) RETURNS varchar AS $body$
DECLARE



ds_observacao_w	varchar(255) := '';
ds_retorno_w	varchar(255);

C01 CURSOR FOR
	SELECT 	a.ds_observacao
	FROM 	(	SELECT	b.nr_sequencia,
				b.ds_observacao
			FROM   	agenda_bloqueio b,
				agenda_paciente a
			WHERE  	b.cd_agenda    = cd_agenda_p
			AND	a.cd_agenda    = b.cd_agenda
			AND   	dt_agenda_p BETWEEN b.dt_inicial AND b.dt_final
			and    ((coalesce(ie_dia_semana, pkg_date_utils.get_WeekDay(dt_agenda_p)) = pkg_date_utils.get_WeekDay(dt_agenda_p)) or ((ie_dia_semana = 9) and ie_dia_semana not in (7,1)) or (coalesce(ie_dia_semana::text, '') = ''))
			ORDER BY	b.nr_sequencia DESC) a LIMIT 1;


BEGIN

open C01;
loop
fetch C01 into
	ds_observacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w := ds_observacao_w;
	end;
end loop;
close C01;


return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ag_exame_obter_obs_bloq ( cd_agenda_p bigint, dt_agenda_p timestamp) FROM PUBLIC;
