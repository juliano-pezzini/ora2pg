-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION retorna_medic_formatado ( ds_formatacao_p text, ds_mascara_p text, ds_valor_p text) RETURNS varchar AS $body$
DECLARE


ie_tam_atrib_w		varchar(1);
vl_substr_w		bigint;
vl_substr_ww		bigint;
vl_substr_www		bigint;
qt_tam_atrib_w		bigint;
ds_retorno_w		varchar(4000);
					

BEGIN

qt_tam_atrib_w		:= 0;
vl_substr_w		:= position(ds_mascara_p||'{' in ds_formatacao_p);
if (vl_substr_w > 0) then
	vl_substr_w	:= position('{' in ds_formatacao_p)+1;
	vl_substr_ww	:= position('}' in ds_formatacao_p);
	vl_substr_www	:= REPLACE( vl_substr_ww , vl_substr_w , '');
	qt_tam_atrib_w	:= LENGTH(substr(ds_formatacao_p, vl_substr_w, vl_substr_www));
end if;

if (qt_tam_atrib_w > 0) then
	ds_retorno_w	:= substr(replace_macro(ds_formatacao_p,ds_mascara_p||'{'||to_char(qt_tam_atrib_w)||'}',rpad(ds_valor_p,qt_tam_atrib_w,' ')),1,3999);
else
	ds_retorno_w	:= substr(replace_macro(ds_formatacao_p,ds_mascara_p,ds_valor_p),1,3999);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION retorna_medic_formatado ( ds_formatacao_p text, ds_mascara_p text, ds_valor_p text) FROM PUBLIC;

