-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ajustar_mi_geracao_classe (nm_obj_menu_p text) RETURNS varchar AS $body$
DECLARE


nm_obj_menu_w		varchar(50);
nr_pos_sigla_wjmi_w	smallint;


BEGIN
if (nm_obj_menu_p IS NOT NULL AND nm_obj_menu_p::text <> '') then
	begin
	nm_obj_menu_w		:= lower(nm_obj_menu_p);
	nr_pos_sigla_wjmi_w	:= position('wjmi' in nm_obj_menu_w);

	if (nr_pos_sigla_wjmi_w = 0) then
		begin
		nm_obj_menu_w := ajustar_menu_item_import_migr(nm_obj_menu_p);
		end;
	else
		begin
		nm_obj_menu_w := nm_obj_menu_p;
		end;
	end if;
	end;
end if;
return nm_obj_menu_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ajustar_mi_geracao_classe (nm_obj_menu_p text) FROM PUBLIC;

