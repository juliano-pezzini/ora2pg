-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_ajustar_agrupamento ( nr_prescricao_p bigint) AS $body$
DECLARE


nr_seq_medic_w			bigint;
nr_seq_ant_w			bigint;
nr_sequencia_w			bigint;
nr_sequencia_anterior_w		bigint;
nr_prescricao_anterior_w	bigint;
nr_seq_medic_agrup_w		bigint;
nr_agrupamento_anterior_w	bigint;
nr_agrupamento_w		bigint;
nr_agrup_acum_w			bigint;
ie_composto_w			varchar(1);
cd_material_w			bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	nr_sequencia_anterior,
	nr_prescricao_anterior
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and	ie_agrupador	= 1
and	(nr_prescricao_anterior IS NOT NULL AND nr_prescricao_anterior::text <> '')
and	(nr_sequencia_anterior IS NOT NULL AND nr_sequencia_anterior::text <> '');

c02 CURSOR FOR
SELECT	nr_sequencia
from	prescr_material
where	nr_prescricao	= nr_prescricao_anterior_w
and	nr_agrupamento	= nr_agrupamento_anterior_w;

c03 CURSOR FOR
SELECT	nr_sequencia
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and	ie_agrupador	= 1
and	nr_prescricao_anterior	= nr_prescricao_anterior_w
and	nr_sequencia_anterior	= nr_seq_ant_w;


BEGIN

update	prescr_material
set	nr_agrupamento	= 0
where	nr_prescricao	= nr_prescricao_p
and	ie_agrupador	= 1
and	(nr_prescricao_anterior IS NOT NULL AND nr_prescricao_anterior::text <> '')
and	(nr_sequencia_anterior IS NOT NULL AND nr_sequencia_anterior::text <> '');

open C01;
loop
fetch C01 into
	nr_seq_medic_w,
	nr_sequencia_anterior_w,
	nr_prescricao_anterior_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(nr_agrupamento)
	into STRICT	nr_agrupamento_w
	from	prescr_material
	where	nr_prescricao	= nr_prescricao_p
	and	nr_sequencia	= nr_seq_medic_w;

	if (nr_agrupamento_w	= 0) then

		select	max(nr_agrupamento),
			max(cd_material)
		into STRICT	nr_agrupamento_anterior_w,
			cd_material_w
		from	prescr_material
		where	nr_prescricao	= nr_prescricao_anterior_w
		and	nr_sequencia	= nr_sequencia_anterior_w;

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_composto_w
		from	prescr_material
		where	nr_prescricao	= nr_prescricao_anterior_w
		and	cd_material	<> cd_material_w
		and	nr_agrupamento	= nr_agrupamento_anterior_w;

		select	coalesce(max(nr_agrupamento),0) + 1
		into STRICT	nr_agrup_acum_w
		from	prescr_material
		where	nr_prescricao	= nr_prescricao_p;

		if (ie_composto_w	= 'N') then

			update	prescr_material
			set	nr_agrupamento	= nr_agrup_acum_w
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia	= nr_seq_medic_w;

		else

			open C02;
			loop
			fetch C02 into
				nr_seq_ant_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin

				open C03;
				loop
				fetch C03 into
					nr_sequencia_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin

					update	prescr_material
					set	nr_agrupamento	= nr_agrup_acum_w
					where	nr_prescricao	= nr_prescricao_p
					and	nr_sequencia	= nr_sequencia_w;

					end;
				end loop;
				close C03;

				end;
			end loop;
			close C02;

		end if;

	end if;

	end;
end loop;
close C01;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_ajustar_agrupamento ( nr_prescricao_p bigint) FROM PUBLIC;
