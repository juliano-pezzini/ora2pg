-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valores_status_filtro_ge ( DS_LISTA_P text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE



ds_valor_w		varchar(15);
ds_retorno_w		varchar(2000) := '';

c01 CURSOR FOR
SELECT 	vl_dominio
from   	valor_dominio
where  	cd_dominio  = 1226
and    	obter_se_contido_char(vl_dominio, ds_lista_p) = 'S'
order by 1;


BEGIN

open C01;
loop
fetch C01 into
	ds_valor_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ds_retorno_w := ds_retorno_w || ds_valor_w || ',';

	end;
end loop;
close C01;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_status_filtro_ge ( DS_LISTA_P text, nm_usuario_p text) FROM PUBLIC;
