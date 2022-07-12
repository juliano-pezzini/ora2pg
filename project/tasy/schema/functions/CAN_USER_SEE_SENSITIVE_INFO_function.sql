-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION can_user_see_sensitive_info ( ie_user_sensitive_info_p text, ie_type_info_p text, cd_establishment_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_type_info_p - Field which must be validate on user groups. Values:
 S - Sensitive Information;
 P - Patient Information.
*/
ie_allowed_w varchar(1) := 'N';
nr_records_w bigint := 0;

BEGIN
if (ie_user_sensitive_info_p IS NOT NULL AND ie_user_sensitive_info_p::text <> '') and (ie_user_sensitive_info_p = 'Y') then
	begin
	ie_allowed_w := 'Y';
	end;
else
	begin
	if (ie_type_info_p = 'S') then
		begin
		select 	count(coalesce(g.ie_can_view_sensitive_info,0))
		into STRICT	nr_records_w
		from	grupo_usuario g,
				usuario_grupo u
		where	g.nr_sequencia = u.nr_seq_grupo
		and		u.nm_usuario_grupo = nm_usuario_p
		and		g.cd_estabelecimento = cd_establishment_p
		and		coalesce(g.ie_situacao,'A') = 'A'
		and		coalesce(u.ie_situacao,'A') = 'A'
		and		coalesce(g.ie_can_view_sensitive_info,'N') = 'Y'  LIMIT 1;

		if (nr_records_w > 0) then
			begin
			ie_allowed_w := 'Y';
			end;
		end if;
		end;
	else
		begin
		select 	count(coalesce(g.ie_can_view_patient_info,0))
		into STRICT	nr_records_w
		from	grupo_usuario g,
				usuario_grupo u
		where	g.nr_sequencia = u.nr_seq_grupo
		and		u.nm_usuario_grupo = nm_usuario_p
		and		g.cd_estabelecimento = cd_establishment_p
		and		coalesce(g.ie_situacao,'A') = 'A'
		and		coalesce(u.ie_situacao,'A') = 'A'
		and		coalesce(g.ie_can_view_patient_info,'N') = 'Y'  LIMIT 1;

		if (nr_records_w > 0) then
			begin
			ie_allowed_w := 'Y';
			end;
		end if;
		end;
	end if;
	end;
end if;

return ie_allowed_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION can_user_see_sensitive_info ( ie_user_sensitive_info_p text, ie_type_info_p text, cd_establishment_p bigint, nm_usuario_p text) FROM PUBLIC;
