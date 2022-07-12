-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_cronico_cid (cd_doenca_p text) RETURNS varchar AS $body$
DECLARE


ie_tipo_cronica_w	dado_basal.ie_doenca_cronica_mx%type;


BEGIN

	select	coalesce(max(ie_doenca_cronica_mx),0)
	into STRICT	ie_tipo_cronica_w
	from	cid_doenca
	where 	cd_doenca_cid = cd_doenca_p;

return	ie_tipo_cronica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_cronico_cid (cd_doenca_p text) FROM PUBLIC;
