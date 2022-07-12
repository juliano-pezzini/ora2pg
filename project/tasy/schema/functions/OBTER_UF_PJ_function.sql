-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_uf_pj (cd_cgc_p text) RETURNS varchar AS $body$
DECLARE


ds_uf_w			varchar(40);

C01 CURSOR FOR
	SELECT	sg_estado
	from	PESSOA_JURIDICA
	where	CD_CGC = cd_cgc_p;


BEGIN
ds_uf_w		:= 'N/E';
open C01;
loop
fetch C01 into
		ds_uf_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	ds_uf_w	:= ds_uf_w;
end loop;
close C01;

return ds_uf_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_uf_pj (cd_cgc_p text) FROM PUBLIC;

