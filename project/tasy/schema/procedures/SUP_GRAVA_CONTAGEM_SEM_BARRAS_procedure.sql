-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_grava_contagem_sem_barras ( nr_seq_inventario_p bigint, cd_material_p bigint, qt_contagem_p bigint, ie_contagem_p bigint, nm_usuario_P text) AS $body$
BEGIN

if (coalesce(ie_contagem_p,0) <> 0) then
	begin

	if (ie_contagem_p = 1) then

		update	inventario_material
		set	qt_contagem			= (coalesce(qt_contagem,0) + qt_contagem_p),
			nm_usuario_contagem 		= nm_usuario_p,
			dt_contagem			= clock_timestamp(),
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_seq_inventario		= nr_seq_inventario_p
		and	cd_material			= cd_material_p;

	elsif (ie_contagem_p = 2) then

		update	inventario_material
		set	qt_recontagem			= (coalesce(qt_recontagem,0) + qt_contagem_p),
			nm_usuario_recontagem 		= nm_usuario_p,
			dt_recontagem			= clock_timestamp(),
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_seq_inventario		= nr_seq_inventario_p
		and	cd_material			= cd_material_p;

	elsif (ie_contagem_p = 3) then

		update	inventario_material
		set	qt_seg_recontagem		= (coalesce(qt_seg_recontagem,0) + qt_contagem_p),
			nm_usuario_seg_recontagem 	= nm_usuario_p,
			dt_seg_recontagem			= clock_timestamp(),
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_seq_inventario		= nr_seq_inventario_p
		and	cd_material			= cd_material_p;

	elsif (ie_contagem_p = 4) then

		update	inventario_material
		set	qt_terc_recontagem		= (coalesce(qt_terc_recontagem,0) + qt_contagem_p),
			nm_usuario_terc_recontagem 	= nm_usuario_p,
			dt_terc_recontagem		= clock_timestamp(),
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_seq_inventario		= nr_seq_inventario_p
		and	cd_material			= cd_material_p;
	end if;

	commit;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_grava_contagem_sem_barras ( nr_seq_inventario_p bigint, cd_material_p bigint, qt_contagem_p bigint, ie_contagem_p bigint, nm_usuario_P text) FROM PUBLIC;

