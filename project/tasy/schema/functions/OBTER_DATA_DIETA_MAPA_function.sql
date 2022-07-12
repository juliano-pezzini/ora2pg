-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_dieta_mapa ( dt_dieta_p timestamp, cd_dieta_p bigint, cd_refeicao_p text) RETURNS timestamp AS $body$
DECLARE


ds_horarios_w		varchar(255);
dt_horario_ref_w	timestamp;
			
c01 CURSOR FOR
SELECT	ds_horarios
from	horario_refeicao_dieta
where	((cd_dieta = cd_dieta_p) or
	((coalesce(cd_dieta::text, '') = '') and (cd_refeicao = cd_refeicao_p)))
order by cd_refeicao, coalesce(cd_dieta,0);
			
			

BEGIN

dt_horario_ref_w	:= null;

open C01;
loop
fetch C01 into	
	ds_horarios_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	dt_horario_ref_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_dieta_p, ds_horarios_w);
	
	end;
end loop;
close C01;

return	dt_horario_ref_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_dieta_mapa ( dt_dieta_p timestamp, cd_dieta_p bigint, cd_refeicao_p text) FROM PUBLIC;
