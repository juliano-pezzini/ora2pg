-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dose_ue100 (nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


qt_result_UE100_w 		 double precision;
qt_retorno_w			 varchar(255);
qt_dose_w				 double precision;
nr_sequencia_w bigint;

BEGIN



select 	coalesce(max(a.nr_sequencia),0)
into STRICT	nr_sequencia_w
from	prescr_material a,
		material b
where	a.nr_prescricao = nr_prescricao_p
and		a.nr_sequencia_solucao = nr_seq_solucao_p
and		((a.nr_sequencia = nr_sequencia_p) or (nr_sequencia_p = 0))
and		b.cd_material = a.cd_material
and		coalesce(b.ie_ancora_solucao,'N') = 'S';

if (nr_sequencia_w > 0) then

	select 	coalesce(max(qt_dose),0)
	into STRICT	qt_dose_w
	from	prescr_material
	where 	nr_prescricao = nr_prescricao_p
	and 	nr_sequencia  = nr_sequencia_w;

	if (substr(qt_dose_w,1,2) =  ',0') and (substr(qt_dose_w,1,3) <> ',00') then
		qt_result_UE100_w := qt_dose_w * 100;
	end if;

	if (qt_result_UE100_w > 0) then
		qt_retorno_w := qt_result_UE100_w || 'UE100';
	end if;

end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dose_ue100 (nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

