-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converte_param_analise_conta ( ds_parametro_p text) RETURNS varchar AS $body$
DECLARE


/*
Esta function é utilizada para converter a informação inserida nos campos de restrição,
na tabela ANALISE_CONTA, quando o registro é inserido pelo HTML.
Nesta situação, a informação é gerada separada por ';' e, desta forma, precisa ser
convertida para o formato usado na procedure GERAR_ANALISE_CONTA_MANUAL
*/
ie_menos_selec_w		varchar(1)	:= 'N';
ds_parametro_w			varchar(4000)	:= '';


BEGIN
ds_parametro_w	:= ds_parametro_p;

if (position('#' in ds_parametro_w) > 0) then

	if (ds_parametro_w	like '%!%') then
		ds_parametro_w	:= replace(ds_parametro_w,'!;','');
		ie_menos_selec_w	:= 'S';
	end if;

	ds_parametro_w  := regexp_replace(ds_parametro_w, '[^0-9;]', '');
	ds_parametro_w	:= replace(ds_parametro_w,';',',');
	ds_parametro_w	:= '(' || ds_parametro_w || ')';

	if (ie_menos_selec_w = 'S') then
		ds_parametro_w	:= chr(39) || '!' || ds_parametro_w || chr(39);
	else
		ds_parametro_w	:= chr(39) || ds_parametro_w || chr(39);
	end if;

end if;

return ds_parametro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_param_analise_conta ( ds_parametro_p text) FROM PUBLIC;
