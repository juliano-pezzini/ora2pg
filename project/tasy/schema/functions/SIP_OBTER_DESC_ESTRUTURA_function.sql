-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sip_obter_desc_estrutura ( cd_estrutura_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(80)	:= '';


BEGIN

begin
select	ds_estrutura
into STRICT	ds_retorno_w
from	sip_estrutura_proc
where	cd_estrutura	= cd_estrutura_p
and	ie_situacao	= 'A';
exception
	when others then
	ds_retorno_w	:= '';
end;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sip_obter_desc_estrutura ( cd_estrutura_p text) FROM PUBLIC;
