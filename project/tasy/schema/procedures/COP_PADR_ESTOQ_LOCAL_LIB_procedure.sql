-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cop_padr_estoq_local_lib ( cd_local_estoque_p bigint, cd_local_estoque_dest_p bigint, ie_sobrescrever_regra_p text, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w			bigint;
ie_liberar_w			varchar(1);
cd_local_estoque_w		bigint;
cd_grupo_material_w		integer;
cd_subgrupo_material_w		integer;
cd_classe_material_w		integer;
cd_material_w			integer;
ie_origem_documento_w		varchar(3);
nr_seq_familia_w		bigint;

c01 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.cd_grupo_material,
	a.cd_subgrupo_material,
	a.cd_classe_material,
	a.cd_material,
	a.ie_origem_documento,
	a.ie_liberar,
	a.nr_seq_familia
from	loc_estoque_estrut_materiais a
where	a.cd_local_estoque = cd_local_estoque_p
and not exists (
	SELECT	1
	from	loc_estoque_estrut_materiais x
	where	x.cd_local_estoque		= cd_local_estoque_dest_p
	and	coalesce(x.cd_grupo_material, 0)	= coalesce(a.cd_grupo_material, 0)
	and	coalesce(x.cd_subgrupo_material, 0) = coalesce(a.cd_subgrupo_material, 0)
	and	coalesce(x.cd_classe_material, 0)	= coalesce(a.cd_classe_material, 0)
	and	coalesce(x.nr_seq_familia, 0)	= coalesce(a.nr_seq_familia, 0)
	and	coalesce(x.cd_material, 0) 	= coalesce(a.cd_material, 0)
	and	coalesce(x.ie_origem_documento, 'X') = coalesce(a.ie_origem_documento, 'X'));


BEGIN

if (ie_sobrescrever_regra_p = 'S') then
	delete
	from	loc_estoque_estrut_materiais
	where	cd_local_estoque = cd_local_estoque_dest_p;
end if;

open c01;
loop
fetch c01 into
	cd_local_estoque_w,
	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w,
	cd_material_w,
	ie_origem_documento_w,
	ie_liberar_w,
	nr_seq_familia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	max(nr_sequencia) + 1
	into STRICT	nr_sequencia_w
	from	loc_estoque_estrut_materiais;

	insert into loc_estoque_estrut_materiais(
		nr_sequencia,
		cd_local_estoque,
		dt_atualizacao,
		nm_usuario,
		cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material,
		nr_seq_familia,
		cd_material,
		ie_origem_documento,
		ie_liberar)
	values (	nr_sequencia_w,
		cd_local_estoque_dest_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w,
		nr_seq_familia_w,
		cd_material_w,
		ie_origem_documento_w,
		ie_liberar_w);

	end;
end loop;
close c01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cop_padr_estoq_local_lib ( cd_local_estoque_p bigint, cd_local_estoque_dest_p bigint, ie_sobrescrever_regra_p text, nm_usuario_p text) FROM PUBLIC;
