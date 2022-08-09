-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_mat_adicionais_cir (nr_prescricao_p bigint, cd_material_p bigint, qt_material_p bigint, nr_seq_lote_p bigint, cd_fornec_consig_p text, qt_saldo_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE


qt_saldo_w	double precision	:= 0;
qt_material_w	double precision	:= 0;
nr_seq_item_w	bigint	:= 0;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		qt_material
	from	prescr_material
	where	nr_prescricao		= nr_prescricao_p
	and	cd_material		= cd_material_p;


BEGIN

qt_saldo_w	:= qt_material_p;

open	c01;
loop
fetch	c01 into
	nr_seq_item_w,
	qt_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (qt_saldo_w >= qt_material_w) then
		begin

		if (nr_seq_lote_p > 0) then
			update 	prescr_material
			set 	ie_status_cirurgia	= 'CB',
				nr_seq_lote_fornec 	= nr_seq_lote_p,
				cd_fornec_consignado 	= cd_fornec_consig_p
			where 	nr_sequencia		= nr_seq_item_w
			and 	nr_prescricao 		= nr_prescricao_p;
		else
			update 	prescr_material
			set 	ie_status_cirurgia	= 'CB'
			where 	nr_sequencia		= nr_seq_item_w
			and 	nr_prescricao 		= nr_prescricao_p;
		end if;
		end;
	end if;

	qt_saldo_w	:= qt_saldo_w - qt_material_w;

	end;
end loop;
close c01;

qt_saldo_p	:= qt_saldo_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_mat_adicionais_cir (nr_prescricao_p bigint, cd_material_p bigint, qt_material_p bigint, nr_seq_lote_p bigint, cd_fornec_consig_p text, qt_saldo_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
