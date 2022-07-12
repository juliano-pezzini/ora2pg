-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE obter_saldo_disp_estoque_pck.set_cd_material (cd_material_p bigint) AS $body$
BEGIN
	if (coalesce(get_cd_material::text, '') = '') or (get_cd_material <> cd_material_p) then
		begin
		PERFORM set_config('obter_saldo_disp_estoque_pck.cd_material_w', cd_material_p, false);
		CALL obter_saldo_disp_estoque_pck.set_cd_material_estoque(cd_material_p);
		end;
	end if;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_saldo_disp_estoque_pck.set_cd_material (cd_material_p bigint) FROM PUBLIC;
