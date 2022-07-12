-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_comprador ( nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_comprador_w		varchar(1) := 'N';
qt_existe_w		bigint;

BEGIN
 
select	count(*) 
into STRICT	qt_existe_w 
from	comprador 
where	cd_pessoa_fisica = obter_pessoa_fisica_usuario(nm_usuario_p,'C') 
and	ie_situacao = 'A' 
and	cd_estabelecimento = cd_estabelecimento_p;
 
if (qt_existe_w > 0) then 
	ie_comprador_w := 'S';
end if;
 
return	ie_comprador_w;
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_comprador ( nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

