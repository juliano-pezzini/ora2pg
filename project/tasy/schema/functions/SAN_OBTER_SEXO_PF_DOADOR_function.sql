-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_sexo_pf_doador (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ie_sexo_w		varchar(02);


BEGIN

select	ie_sexo
into STRICT	ie_sexo_w
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_p;

if (ie_sexo_w = 'I') then
	ie_sexo_w := 'A';
end if;

return ie_sexo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_sexo_pf_doador (cd_pessoa_fisica_p text) FROM PUBLIC;

