-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_material_conversao_ext ( cd_material_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


result_w 	varchar(100);
type_w 	varchar(3);
code_w 	varchar(100);

-- 	IE_OPCAO_P
-- 	C 	= CODE
-- 	T 	= TYPE
BEGIN

begin
	if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
		select	max(coalesce(gfc_code, gcr_code)),
			max(CASE WHEN coalesce(gfc_code::text, '') = '' THEN  CASE WHEN coalesce(gcr_code::text, '') = '' THEN  ''  ELSE 'GCR' END   ELSE 'GFC' END )
		into STRICT	code_w,
			type_w
		from	material_conversao
		where	cd_material = cd_material_p;

		case ie_opcao_p
			when 'C' then result_w := code_w;
			when 'T' then result_w := type_w;
			else result_w := '';
		end case;

	end if;
exception when others then
	result_w := '';
end;

return result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_material_conversao_ext ( cd_material_p bigint, ie_opcao_p text) FROM PUBLIC;

