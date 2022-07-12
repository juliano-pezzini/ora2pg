-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rep_obter_ie_conrole_medico (cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


ie_controle_medico_w	smallint;


BEGIN
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	begin
	select	max(obter_controle_medic(cd_material,wheb_usuario_pck.get_cd_estabelecimento,ie_controle_medico,null,null,null))
	into STRICT		ie_controle_medico_w
	from		material
	where	cd_material = cd_material_p;
	end;
end if;

return	ie_controle_medico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rep_obter_ie_conrole_medico (cd_material_p bigint) FROM PUBLIC;

