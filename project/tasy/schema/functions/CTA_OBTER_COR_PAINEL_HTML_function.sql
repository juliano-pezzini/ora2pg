-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cta_obter_cor_painel_html ( vl_referencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_cor_w	cta_regra_cor_painel.ds_cor%type;

C01 CURSOR FOR
	SELECT	ds_cor_html
	from	cta_regra_cor_painel
	where	vl_referencia_p between coalesce(vl_minimo,vl_referencia_p) and coalesce(vl_maximo,vl_referencia_p)
	order by coalesce(vl_maximo,vl_referencia_p);


BEGIN

open C01;
loop
fetch C01 into
	ds_cor_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_cor_w:=ds_cor_w;
	end;
end loop;
close C01;

return	ds_cor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cta_obter_cor_painel_html ( vl_referencia_p bigint) FROM PUBLIC;

