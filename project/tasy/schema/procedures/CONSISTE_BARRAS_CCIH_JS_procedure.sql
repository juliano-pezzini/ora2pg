-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_barras_ccih_js ( nr_seq_processo_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


cd_material_w		prescr_material.cd_material%type;
nr_prescricao_w		prescr_medica.nr_prescricao%type;
nr_seq_material_w 	prescr_mat_hor.nr_seq_material%type;
ds_erro_w			varchar(4000);

c01 CURSOR FOR
SELECT	nr_prescricao,
		cd_material,
		nr_seq_material
from	prescr_mat_hor
where	nr_seq_processo = nr_seq_processo_p;


BEGIN


if (coalesce(nr_seq_processo_p,0) > 0) then
	open C01;
	loop
	fetch C01 into
		nr_prescricao_w,
		cd_material_w,
		nr_seq_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

	if (nr_prescricao_w > 0) and (cd_material_w > 0) and (nr_seq_material_w > 0) then

		ds_erro_w := Consiste_mat_barras_lote_CCIH(nr_prescricao_w, cd_material_w, nr_seq_material_w, nm_usuario_p, ds_erro_w);

		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			ds_erro_p :=  cd_material_w || ' - ' || substr(obter_desc_material(cd_material_w),1,150) || chr(13) || chr(10) || ds_erro_w;
			exit;
		end if;
	end if;
	end loop;
	close C01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_barras_ccih_js ( nr_seq_processo_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

