-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_reg_anvisa_material (cd_simpro_p bigint, nr_reg_anvisa_p text, dt_validade_p text, nm_usuario_p text) AS $body$
DECLARE


cd_material_w			integer;

C01 CURSOR FOR
	SELECT 	coalesce(cd_material,0)
	from 	material_simpro
	where 	cd_simpro = cd_simpro_p;


BEGIN

open C01;
loop
fetch C01 into
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (coalesce(cd_material_w,0) > 0) then

		update	material_estab
		set		dt_validade_reg_anvisa  = to_date(dt_validade_p,'ddmmyyyy'),
				nr_registro_anvisa		= nr_reg_anvisa_p,
				ie_vigente_anvisa 		= substr(coalesce(obter_exigencia_anvisa_mat(cd_estabelecimento,cd_material_w,'VI'),'N'),1,1)
		where 	cd_material 			= cd_material_w;

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
-- REVOKE ALL ON PROCEDURE atualiza_reg_anvisa_material (cd_simpro_p bigint, nr_reg_anvisa_p text, dt_validade_p text, nm_usuario_p text) FROM PUBLIC;

