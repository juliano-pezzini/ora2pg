-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_dados_parametro (cd_estabelecimento_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE

/* ie_tipo_p
A = agenda
*/
ds_retorno_w	varchar(255);
cd_agenda_w	varchar(10);


BEGIN

select 	max(cd_agenda)
into STRICT	cd_agenda_w
from	fa_parametro
where	coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p;

if (ie_tipo_p = 'A') then
	ds_retorno_w := cd_agenda_w;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_dados_parametro (cd_estabelecimento_p bigint, ie_tipo_p text) FROM PUBLIC;
