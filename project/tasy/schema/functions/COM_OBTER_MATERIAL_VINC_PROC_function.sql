-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_material_vinc_proc (cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type) RETURNS bigint AS $body$
DECLARE


cd_material_w		material.cd_material%type;


BEGIN

if (coalesce(cd_procedimento_p,0) <> 0) and (coalesce(ie_origem_proced_p,0) <> 0) then
	begin
	select	max(cd_material)
	into STRICT	cd_material_w
	from 	com_vinc_proced_material
	where	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p;
	end;
end if;

return	cd_material_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_material_vinc_proc (cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type) FROM PUBLIC;
