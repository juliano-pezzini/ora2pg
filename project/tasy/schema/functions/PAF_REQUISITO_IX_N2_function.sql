-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION paf_requisito_ix_n2 () RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(2000);


BEGIN

select 	'N2' ||
	substr(lpad(coalesce(nr_laudo_paf,'0'),10,'0'),1,10) ||
	substr(rpad(coalesce(ds_aplicativo_paf,' '),50,' '),1,50) ||
	substr(lpad(coalesce(nr_versao_paf,'0'),10,'0'),1,10)
into STRICT	ds_retorno_w
from	paf_parametros;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION paf_requisito_ix_n2 () FROM PUBLIC;
