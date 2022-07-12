-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nom_obter_nacionalidade_pais (cd_pais_p text) RETURNS varchar AS $body$
DECLARE


cd_nacionalidade_w	nacionalidade.cd_nacionalidade%type;


BEGIN

if (cd_pais_p IS NOT NULL AND cd_pais_p::text <> '') then
	/* It is another catalog in clinical summary */

	select	max(b.cd_nacionalidade)
	into STRICT	cd_nacionalidade_w
	from	nacionalidade b,
			pais a
	where	a.sg_pais = b.cd_externo
	and		a.cd_codigo_pais = cd_pais_p;
	
end if;

return lpad(cd_nacionalidade_w,3,'0');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nom_obter_nacionalidade_pais (cd_pais_p text) FROM PUBLIC;
