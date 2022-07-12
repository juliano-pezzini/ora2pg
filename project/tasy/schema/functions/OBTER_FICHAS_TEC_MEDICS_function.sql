-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_fichas_tec_medics ( ds_material_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_ficha_tecnica_w	bigint;
ds_seq_ficha_tecnica_w	varchar(255);

c01 CURSOR FOR
SELECT	distinct coalesce(nr_seq_ficha_tecnica,0)
from	material
where	obter_se_contido(cd_material, ds_material_p) = 'S';


BEGIN
if (ds_material_p IS NOT NULL AND ds_material_p::text <> '') then
	open c01;
	loop
	fetch c01 into nr_seq_ficha_tecnica_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (coalesce(ds_seq_ficha_tecnica_w::text, '') = '') then
			ds_seq_ficha_tecnica_w := nr_seq_ficha_tecnica_w;
		else
			ds_seq_ficha_tecnica_w := ds_seq_ficha_tecnica_w|| ',' ||nr_seq_ficha_tecnica_w;
		end if;
		end;
	end loop;
	close c01;
end if;

return ds_seq_ficha_tecnica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_fichas_tec_medics ( ds_material_p text) FROM PUBLIC;

