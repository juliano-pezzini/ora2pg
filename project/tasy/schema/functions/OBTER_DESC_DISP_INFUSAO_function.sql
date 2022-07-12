-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_disp_infusao (ie_bomba_infusao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(255);

BEGIN

if (ie_bomba_infusao_p IS NOT NULL AND ie_bomba_infusao_p::text <> '') then

	select 	max(ds_valor_dominio)
	into STRICT	ds_retorno_w
	from	valor_dominio
	where	cd_dominio	 = 1537
	and		vl_dominio 	 = ie_bomba_infusao_p;

end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_disp_infusao (ie_bomba_infusao_p text) FROM PUBLIC;
