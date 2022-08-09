-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_registro_atual_inpart (cd_tab_preco_mat_p bigint, cd_estabelecimento_p bigint, cd_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_primeiro_w		varchar(1);
cd_estabelecimento_w	smallint;
cd_material_w		bigint;
dt_inicio_vigencia_w	timestamp;

C01 CURSOR FOR
	SELECT	cd_estabelecimento,
		cd_material,
		dt_inicio_vigencia
	from	preco_material
	where	cd_tab_preco_mat = cd_tab_preco_mat_p
	and 	cd_estabelecimento = cd_estabelecimento_p
	and 	cd_material = cd_material_p
	and 	ie_inpart in ('S','A')
	and 	ie_preco_venda = 'S'
	order by dt_inicio_vigencia desc;


BEGIN

ie_primeiro_w:= 'S';

open C01;
loop
fetch C01 into
	cd_estabelecimento_w,
	cd_material_w,
	dt_inicio_vigencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (ie_primeiro_w = 'S') then

		update	preco_material
		set 	ie_inpart = 'A'
		where 	cd_estabelecimento = cd_estabelecimento_w
		and 	cd_material = cd_material_w
		and 	dt_inicio_vigencia = dt_inicio_vigencia_w
		and 	cd_tab_preco_mat = cd_tab_preco_mat_p
		and 	ie_inpart in ('S','A')
		and 	ie_preco_venda = 'S';

		ie_primeiro_w:= 'N';

	else
		update	preco_material
		set 	ie_inpart = 'S'
		where 	cd_estabelecimento = cd_estabelecimento_w
		and 	cd_material = cd_material_w
		and 	dt_inicio_vigencia = dt_inicio_vigencia_w
		and 	cd_tab_preco_mat = cd_tab_preco_mat_p
		and 	ie_inpart in ('S','A')
		and 	ie_preco_venda = 'S';

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
-- REVOKE ALL ON PROCEDURE atualiza_registro_atual_inpart (cd_tab_preco_mat_p bigint, cd_estabelecimento_p bigint, cd_material_p bigint, nm_usuario_p text) FROM PUBLIC;
