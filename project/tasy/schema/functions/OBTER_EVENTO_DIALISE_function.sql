-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_evento_dialise (nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS varchar AS $body$
DECLARE


dt_evento_w	varchar(255);
ds_evento_w	varchar(255);

c01 CURSOR FOR
SELECT	to_char(dt_evento,'dd/mm hh24:mi')
from	hd_prescricao_evento a
where	nr_prescricao	= nr_prescricao_p
and	nr_seq_solucao	= nr_seq_solucao_p
and	a.ie_evento	= 'II'
order by a.dt_evento;


BEGIN

open C01;
loop
fetch C01 into
	dt_evento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	if (ds_evento_w IS NOT NULL AND ds_evento_w::text <> '') then
		ds_evento_w := substr(ds_evento_w || chr(10),1,255);
	end if;

	ds_evento_w	:= substr(ds_evento_w || dt_evento_w || '  A',1,255);
end loop;
close C01;

ds_evento_w	:= ds_evento_w;

return	ds_evento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_evento_dialise (nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;

