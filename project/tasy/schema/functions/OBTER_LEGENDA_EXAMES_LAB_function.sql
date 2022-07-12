-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_legenda_exames_lab ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS varchar AS $body$
DECLARE


qt_resultado_w		varchar(2);
qt_result_w		bigint;

BEGIN

qt_resultado_w := 'N';

select	count(1)
into STRICT	qt_result_w
from	result_laboratorio_copia
where	nr_prescricao = nr_prescricao_p
and	nr_seq_prescricao = nr_seq_prescr_p;

if (coalesce(qt_result_w,0) > 0) then
	select	count(1)
	into STRICT	qt_result_w
	from	prescr_procedimento
	where	nr_prescricao = nr_prescricao_p
	and	nr_sequencia = nr_seq_prescr_p
	and	ie_status_atend < 35;

	if (coalesce(qt_result_w,0) > 0) then
		qt_resultado_w := 'S';
	end if;
end if;

return	qt_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_legenda_exames_lab ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;
