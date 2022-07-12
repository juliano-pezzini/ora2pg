-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_existe_nfse (nr_nfse_p text, cd_serie_p text, cd_estab_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2) := 'N';


BEGIN

select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	nota_fiscal
where	nr_nfe_imp 		= nr_nfse_p
and	cd_serie_nf		= cd_serie_p
and	cd_estabelecimento 	= cd_estab_p;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_existe_nfse (nr_nfse_p text, cd_serie_p text, cd_estab_p text) FROM PUBLIC;
