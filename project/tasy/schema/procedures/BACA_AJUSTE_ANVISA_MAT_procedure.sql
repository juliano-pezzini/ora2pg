-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajuste_anvisa_mat ( nm_usuario_p text) AS $body$
DECLARE



cd_material_w			bigint;
dt_validade_anvisa_w		timestamp;
nr_registro_anvisa_w		varchar(60);
qt_reg_anvisa_dif_w		bigint;
qt_val_anvisa_dif_w		bigint;
qt_registro_w			bigint;

C01 CURSOR FOR
	SELECT	cd_material
	from	material a
	where	exists (	SELECT	1
			from	material_estab x
			where	x.cd_material	= a.cd_material
			and	(x.nr_registro_anvisa IS NOT NULL AND x.nr_registro_anvisa::text <> ''));



BEGIN

qt_registro_w	:= 0;

open C01;
loop
fetch C01 into
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	count(distinct nr_registro_anvisa),
		max(a.nr_registro_anvisa)
	into STRICT	qt_reg_anvisa_dif_w,
		nr_registro_anvisa_w
	from	material_estab a
	where	a.cd_material	= cd_material_w
	and	(a.nr_registro_anvisa IS NOT NULL AND a.nr_registro_anvisa::text <> '');

	if (qt_reg_anvisa_dif_w = 1) then
		update	material
		set	nr_registro_anvisa	= nr_registro_anvisa_w
		where	cd_material		= cd_material_w;
	end if;

	select	count(distinct dt_validade_reg_anvisa),
		max(a.dt_validade_reg_anvisa)
	into STRICT	qt_val_anvisa_dif_w,
		dt_validade_anvisa_w
	from	material_estab a
	where	a.cd_material	= cd_material_w
	and	(a.nr_registro_anvisa IS NOT NULL AND a.nr_registro_anvisa::text <> '');

	if (qt_val_anvisa_dif_w = 1) then
		update	material
		set	dt_validade_reg_anvisa	= dt_validade_anvisa_w
		where	cd_material		= cd_material_w;
	end if;

	qt_registro_w	:= qt_registro_w + 1;

	if (qt_registro_w = 500) then
		commit;
		qt_registro_w	:= 0;
	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajuste_anvisa_mat ( nm_usuario_p text) FROM PUBLIC;

