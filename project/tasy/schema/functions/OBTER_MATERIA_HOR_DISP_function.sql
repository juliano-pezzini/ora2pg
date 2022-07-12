-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_materia_hor_disp ( nr_prescricao_p bigint, nr_seq_material_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_horario_w	timestamp := clock_timestamp();


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then
	select	max(dt_horario)
	into STRICT	dt_horario_w
	from 	prescr_mat_hor
	where 	nr_prescricao = nr_prescricao_p
	and 	nr_seq_material = nr_seq_material_p;
end if;

return	dt_horario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_materia_hor_disp ( nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;

