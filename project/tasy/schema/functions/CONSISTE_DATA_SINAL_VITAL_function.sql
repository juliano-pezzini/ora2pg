-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_data_sinal_vital ( nr_cirurgia_p bigint, dt_sinal_vital_p timestamp, qt_MinAntes_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN


select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	cirurgia
where	dt_sinal_vital_p between 	coalesce(dt_inicio_real,dt_inicio_prevista) - ((qt_MinAntes_p*60)/86400) and (obter_data_final_cirurgia_graf(nr_cirurgia))
and	nr_cirurgia = nr_cirurgia_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_data_sinal_vital ( nr_cirurgia_p bigint, dt_sinal_vital_p timestamp, qt_MinAntes_p bigint) FROM PUBLIC;

