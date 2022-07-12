-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_se_pode_pesar (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ie_pode_pesar_w		varchar(1);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select	coalesce(max(ie_pode_pesar), 'S')
	into STRICT	ie_pode_pesar_w
	from	hd_pac_renal_cronico
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

end if;

return ie_pode_pesar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_se_pode_pesar (cd_pessoa_fisica_p text) FROM PUBLIC;
