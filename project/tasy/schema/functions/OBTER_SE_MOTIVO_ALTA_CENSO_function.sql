-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_motivo_alta_censo (cd_motivo_alta_p bigint) RETURNS varchar AS $body$
DECLARE


ie_censo_diario_w	varchar(1);


BEGIN
if (cd_motivo_alta_p IS NOT NULL AND cd_motivo_alta_p::text <> '') then
	select	coalesce(max(ie_censo_diario),'N')
	into STRICT	ie_censo_diario_w
	from	motivo_alta
	where	cd_motivo_alta = cd_motivo_alta_p;

end if;

return ie_censo_diario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_motivo_alta_censo (cd_motivo_alta_p bigint) FROM PUBLIC;

