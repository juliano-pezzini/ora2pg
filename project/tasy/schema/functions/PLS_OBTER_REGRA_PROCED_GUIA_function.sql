-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_regra_proced_guia ( ie_tipo_guia_p text) RETURNS varchar AS $body$
DECLARE


nr_retorno_w			integer;
ds_retorno_w			varchar(255)	:= 'S';


BEGIN

select	count(1)
into STRICT	nr_retorno_w
from	pls_regra_lanc_automatico
where	ie_situacao	= 'A'
and	ie_tipo_guia	= ie_tipo_guia_p;

if (nr_retorno_w	= 0) then
	ds_retorno_w	:= 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_regra_proced_guia ( ie_tipo_guia_p text) FROM PUBLIC;

