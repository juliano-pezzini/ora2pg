-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_se_dem_ead (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_ead_w	varchar(1) := 'N';


BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then

	select 	coalesce(max(ie_ead),'N')
	into STRICT	ie_ead_w
	from 	com_tipo_demonstracao
	where 	nr_sequencia = nr_sequencia_p;
end if;

return	ie_ead_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_se_dem_ead (nr_sequencia_p bigint) FROM PUBLIC;

