-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prescr_atend_parcial ( nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w			varchar(01) := 'N';
qt_existe_w			bigint;
nr_seq_item_w			bigint;
cd_material_w			integer;
qt_material_w			double precision;
qt_material_atend_w		double precision;
dt_baixa_prescr_w			timestamp;
ie_parcial_w			varchar(01) := 'N';

C01 CURSOR FOR
SELECT	nr_sequencia,
	cd_material,
	qt_material
from	prescr_material
where	nr_prescricao	= nr_prescricao_p;


BEGIN

select	dt_baixa
into STRICT	dt_baixa_prescr_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

if (coalesce(dt_baixa_prescr_w::text, '') = '') then
	open C01;
	loop
	fetch C01 into
		nr_seq_item_w,
		cd_material_w,
		qt_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	count(*)
		into STRICT	qt_existe_w
		from	material_atend_paciente
		where	nr_prescricao = nr_prescricao_p;

		select	sum(qt_material)
		into STRICT	qt_material_atend_w
		from	material_atend_paciente
		where	nr_prescricao = nr_prescricao_p
		and	nr_sequencia_prescricao = nr_seq_item_w;

		if (qt_existe_w > 0) and (coalesce(qt_material_w,0) > coalesce(qt_material_atend_w,0)) then
			ie_parcial_w	:= 'S';
		end if;

		if (ds_retorno_w = 'N') then	/*se tiver um item com parcial não entra mais neste if*/
			ds_retorno_w := ie_parcial_w;
		end if;

		end;
	end loop;
	close C01;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prescr_atend_parcial ( nr_prescricao_p bigint) FROM PUBLIC;

