-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_substituir_string_md ( ds_texto_p text, ds_procura_p text, ds_substituir_p text ) RETURNS varchar AS $body$
DECLARE

    ds_retorno_w	varchar(255);
    vl_pos_w	smallint;

BEGIN
    ds_retorno_w	:= ds_texto_p;
    vl_pos_w	:= position(ds_procura_p in ds_retorno_w);

while(vl_pos_w > 0) loop
	ds_retorno_w := substr(ds_retorno_w, 1, vl_pos_w - 1) || ds_substituir_p || substr(ds_retorno_w, (vl_pos_w + length(ds_procura_p)), length(ds_texto_p));
	vl_pos_w := position(ds_procura_p in ds_retorno_w);
end loop;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_substituir_string_md ( ds_texto_p text, ds_procura_p text, ds_substituir_p text ) FROM PUBLIC;
