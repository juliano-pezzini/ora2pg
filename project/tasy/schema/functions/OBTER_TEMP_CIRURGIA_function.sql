-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_temp_cirurgia (nr_cirurgia_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);
qt_temp_w	real;
dt_sinal_vital_w	timestamp;

C01 CURSOR FOR
	SELECT	a.qt_temp, dt_sinal_vital
	from	atendimento_sinal_vital a,
		cirurgia b
	where	a.nr_cirurgia = b.nr_cirurgia
	and	trunc(a.dt_sinal_vital) = trunc(b.dt_inicio_real)
	and 	a.nr_cirurgia = nr_cirurgia_p;

BEGIN
open C01;
loop
fetch C01 into
	qt_temp_w, dt_sinal_vital_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w := substr(qt_temp_w||' - '|| to_char(dt_sinal_vital_w, 'dd/mm/yyyy hh24:mi:ss') ||', '|| ds_retorno_w,1,255);
	end;
end loop;
close C01;

/*select 	max(dt_sinal_vital)
into 	dt_sinal_vital_w
from	atendimento_sinal_vital a,
	cirurgia b
where	a.nr_cirurgia = b.nr_cirurgia
and	trunc(a.dt_sinal_vital) = trunc(b.dt_inicio_real)
and 	a.nr_cirurgia = nr_cirurgia_p;

ds_retorno_w := substr(ds_retorno_w,1,length(ds_retorno_w)-2)||' - '|| to_char(dt_sinal_vital_w, 'dd/mm/yyyy hh24:mi:ss');*/
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_temp_cirurgia (nr_cirurgia_p bigint) FROM PUBLIC;

