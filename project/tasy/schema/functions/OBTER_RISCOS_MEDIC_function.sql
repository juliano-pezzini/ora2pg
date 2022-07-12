-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_riscos_medic ( cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_risco_w	varchar(255);
ds_retorno_w	varchar(1000) := obter_desc_expressao(308398)||': ';

C01 CURSOR FOR
SELECT	substr(obter_descricao_padrao('RISCO_MEDICAMENTO','DS_RISCO',nr_seq_risco),1,255)
from	medicamento_risco
where	cd_material = cd_material_p
and	  	coalesce(ie_situacao, 'A') = 'A'
order by 1;


BEGIN

open C01;
loop
fetch C01 into
	ds_risco_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	ds_retorno_w := ds_retorno_w || ds_risco_w || ', ';
end loop;
close C01;

if (ds_retorno_w = obter_desc_expressao(308398)||': ') then
	ds_retorno_w := '';
end if;

return	substr(ds_retorno_w,1,length(trim(both ds_retorno_w))-1);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_riscos_medic ( cd_material_p bigint) FROM PUBLIC;

