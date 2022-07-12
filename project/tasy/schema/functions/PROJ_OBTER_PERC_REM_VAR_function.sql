-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_perc_rem_var ( dt_parametro_p timestamp, ie_tipo_retorno_p bigint) RETURNS bigint AS $body$
DECLARE


/* ie_tipo_retorno_p
	1 - Gerente
	2 - Coordenador
*/
vl_retorno_w			double precision	:= 0;
pr_rem_ger_w			double precision	:= 0;
pr_rem_coord_w			double precision	:= 0;


C01 CURSOR FOR
	SELECT	pr_rem_ger,
		pr_rem_coord
	from	proj_indice_calc
	where	dt_parametro_p between dt_inicio_vigencia and dt_fim_vigencia
	order by dt_inicio_vigencia;


BEGIN

open C01;
loop
fetch C01 into
	pr_rem_ger_w,
	pr_rem_coord_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

if (ie_tipo_retorno_p	= 1) then
	vl_retorno_w	:= pr_rem_ger_w;
elsif (ie_tipo_retorno_p	= 2) then
	vl_retorno_w	:= pr_rem_coord_w;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_perc_rem_var ( dt_parametro_p timestamp, ie_tipo_retorno_p bigint) FROM PUBLIC;

