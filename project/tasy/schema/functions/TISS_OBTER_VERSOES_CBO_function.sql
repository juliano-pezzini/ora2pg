-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_versoes_cbo (nr_seq_cbo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
ie_versao_w	varchar(10);

c01 CURSOR FOR
SELECT	distinct ie_versao
from	cbo_saude_tiss
where	nr_seq_cbo_saude	=  nr_seq_cbo_p
order by ie_versao;


BEGIN

ds_retorno_w	:= null;

open C01;
loop
fetch C01 into
	ie_versao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	if (coalesce(ds_retorno_w::text, '') = '') then
		ds_retorno_w	:= ' (';
	end if;

	ds_retorno_w	:= ds_retorno_w || ie_versao_w ||',';

end loop;
close C01;

if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	ds_retorno_w := ds_retorno_w||')';
	if (position(',)' in ds_retorno_w) > 0) then
		ds_retorno_w	:= replace(ds_retorno_w,',)',')');
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_versoes_cbo (nr_seq_cbo_p bigint) FROM PUBLIC;

