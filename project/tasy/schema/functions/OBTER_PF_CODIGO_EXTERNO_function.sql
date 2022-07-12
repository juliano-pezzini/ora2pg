-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pf_codigo_externo ( ie_tipo_codigo_externo_p text, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint default NULL) RETURNS varchar AS $body$
DECLARE


cd_pessoa_fisica_externo_w	varchar(20);
			

BEGIN

select	max(cd_pessoa_fisica_externo)
into STRICT	cd_pessoa_fisica_externo_w
from	pf_codigo_externo
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and 	coalesce(cd_estabelecimento, 0)  = coalesce(cd_estabelecimento_p, cd_estabelecimento, 0)
and	ie_tipo_codigo_externo	= ie_tipo_codigo_externo_p;


return	cd_pessoa_fisica_externo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pf_codigo_externo ( ie_tipo_codigo_externo_p text, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint default NULL) FROM PUBLIC;
