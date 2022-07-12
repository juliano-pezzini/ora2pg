-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_ressuprimento (cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_regra_ressup_w	varchar(15);


BEGIN 
 
select	ie_regra_ressup 
into STRICT	ie_regra_ressup_w 
from	parametro_compras 
where	cd_estabelecimento = cd_estabelecimento_p;
 
return	ie_regra_ressup_w;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_ressuprimento (cd_estabelecimento_p bigint) FROM PUBLIC;

