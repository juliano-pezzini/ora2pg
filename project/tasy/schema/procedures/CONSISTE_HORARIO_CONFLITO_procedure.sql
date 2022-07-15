-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_horario_conflito ( nr_prescricao_p bigint, nr_total_p INOUT bigint) AS $body$
DECLARE


qt_prescr_w	bigint := 0;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '')then
	begin

	CALL Consistir_horarios_prescr(nr_prescricao_p);

	select 	count(*)
	into STRICT	qt_prescr_w
	from 	prescr_mat_hor_conflito
	where 	nr_prescricao = nr_prescricao_p;

	nr_total_p	:= qt_prescr_w;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_horario_conflito ( nr_prescricao_p bigint, nr_total_p INOUT bigint) FROM PUBLIC;

