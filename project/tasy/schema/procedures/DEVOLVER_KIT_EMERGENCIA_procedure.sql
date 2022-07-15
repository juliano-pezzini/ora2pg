-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE devolver_kit_emergencia ( nr_prescricao_p bigint, nr_seq_kit_estoque_p bigint, cd_material_p bigint, qt_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_material_w			prescr_material.qt_material%type;
ie_existe_material_kit_w	varchar(1);


BEGIN
if (coalesce(nr_prescricao_p,0) > 0) and (coalesce(qt_material_p,0) > 0) then

	select  CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_existe_material_kit_w
	from	prescr_material
	where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
	and	nr_prescricao = nr_prescricao_p
	and	cd_material = cd_material_p;

	if (ie_existe_material_kit_w = 'S') then

		update	prescr_material
		set		qt_material = (qt_material - coalesce(qt_material_p,0)),
				qt_dose 	= (qt_dose - coalesce(qt_material_p,0)),
				qt_unitaria = (qt_unitaria - coalesce(qt_material_p,0)),
				qt_total_dispensar = (qt_total_dispensar - coalesce(qt_material_p,0)),
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()
		where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
		and		nr_prescricao = nr_prescricao_p
		and		cd_material = cd_material_p
		and		qt_material = (SELECT min(qt_material)
						from	prescr_material
						where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
						and	nr_prescricao = nr_prescricao_p
						and	cd_material = cd_material_p);

		commit;

		select 	coalesce(qt_material,0)
		into STRICT	qt_material_w
		from	prescr_material
		where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
		and	nr_prescricao = nr_prescricao_p
		and	cd_material = cd_material_p
		and	qt_material = (SELECT min(qt_material)
					from	prescr_material
					where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
					and	nr_prescricao = nr_prescricao_p
					and	cd_material = cd_material_p)  LIMIT 1;

		if (qt_material_w <= 0) then

			delete	FROM prescr_material
			where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
			and	nr_prescricao = nr_prescricao_p
			and	cd_material = cd_material_p
			and	qt_material = (SELECT min(qt_material)
					from	prescr_material
					where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
					and	nr_prescricao = nr_prescricao_p
					and	cd_material = cd_material_p);
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE devolver_kit_emergencia ( nr_prescricao_p bigint, nr_seq_kit_estoque_p bigint, cd_material_p bigint, qt_material_p bigint, nm_usuario_p text) FROM PUBLIC;

