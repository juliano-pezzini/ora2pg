-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_arredondamento_mat (qt_material_p text) RETURNS bigint AS $body$
DECLARE

qt_material_w	double precision;


BEGIN

qt_material_w := (qt_material_p)::numeric;
if (trunc(qt_material_w,0) <> qt_material_w) then
	qt_material_w	:= trunc(qt_material_w,0) + 1;
end if;

return	qt_material_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_arredondamento_mat (qt_material_p text) FROM PUBLIC;

