-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ordena_item_cpoe ( nr_seq_mat_cpoe_p bigint, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


cd_material_w	prescr_material.cd_material%type;
cd_mat_recons_w	prescr_material.cd_material%type;
cd_mat_dil_w	prescr_material.cd_material%type;
cd_mar_red_w	prescr_material.cd_material%type;
cd_mat_c1_w		prescr_material.cd_material%type;
cd_mat_c2_w		prescr_material.cd_material%type;
cd_mat_c3_w		prescr_material.cd_material%type;
cd_mat_c4_w		prescr_material.cd_material%type;
cd_mat_c5_w		prescr_material.cd_material%type;
cd_mat_c6_w		prescr_material.cd_material%type;
cd_ordenacao_w	prescr_material.cd_material%type := 0;


BEGIN

	select	max(c.cd_material),
			coalesce(max(c.cd_mat_dil),0),
			coalesce(max(c.cd_mat_recons),0),
			coalesce(max(c.cd_mat_red),0),
			coalesce(max(c.cd_Mat_comp1),0),
			coalesce(max(c.cd_mat_comp2),0),
			coalesce(max(c.cd_mat_comp3),0),
			coalesce(max(c.cd_mat_comp4),0),
			coalesce(max(c.cd_mat_comp5),0),
			coalesce(max(c.cd_mat_comp6),0)
	into STRICT	cd_material_w,
			cd_mat_dil_w,
			cd_mat_recons_w,
			cd_mar_red_w,
			cd_mat_c1_w,
			cd_mat_c2_w,
			cd_mat_c3_w,
			cd_mat_c4_w,
			cd_mat_c5_w,
			cd_mat_c6_w
	from	cpoe_material c
	where	nr_sequencia = nr_seq_mat_cpoe_p;

	if (cd_material_w = cd_material_p) then
		cd_ordenacao_w	:= 1;
	elsif (cd_mat_c1_w = cd_material_p) then
		cd_ordenacao_w	:= 2;
	elsif (cd_mat_c2_w = cd_material_p) then
		cd_ordenacao_w	:= 3;
	elsif (cd_mat_c3_w = cd_material_p) then
		cd_ordenacao_w	:= 4;
	elsif (cd_mat_c4_w = cd_material_p) then
		cd_ordenacao_w	:= 5;
	elsif (cd_mat_c5_w = cd_material_p) then
		cd_ordenacao_w	:= 6;
	elsif (cd_mat_c6_w = cd_material_p) then
		cd_ordenacao_w	:= 7;
	elsif (cd_mat_dil_w = cd_material_p) then
		cd_ordenacao_w	:= 8;
	elsif (cd_mar_red_w = cd_material_p) then
		cd_ordenacao_w	:= 9;
	elsif (cd_mat_recons_w = cd_material_p) then
		cd_ordenacao_w	:= 10;
	end if;

return	cd_ordenacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ordena_item_cpoe ( nr_seq_mat_cpoe_p bigint, cd_material_p bigint) FROM PUBLIC;
