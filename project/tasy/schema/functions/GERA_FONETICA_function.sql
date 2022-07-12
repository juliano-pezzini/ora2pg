-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gera_fonetica (ds_campo_p text,ie_consulta_p text) RETURNS varchar AS $body$
DECLARE


/*
* S - Gera e concatena % entre os Fonemas
* N - Gera e concatena os fonemas
*/
ds_campo_w 		varchar(255);
ds_campo_aux_w	varchar(255);
ds_fonetica_w 	varchar(255);
i			smallint;
ds_aux			varchar(20);
pos_sep_w		integer;


BEGIN
ds_campo_aux_w		:= upper(ds_campo_p);
ds_campo_w		:= '';
ds_fonetica_w		:= '';
ds_aux			:= '';

if ( coalesce(ds_campo_aux_w::text, '') = '' ) then
	return null;
end if;

if ( ie_consulta_p = 'S') then
	ds_aux := '%';
end if;

pos_sep_w	:= position(' ' in ds_campo_aux_w);

while( pos_sep_w > 0 ) loop
	ds_campo_w	:= substr(ds_campo_aux_w,1,pos_sep_w-1);
	ds_campo_w	:= trata_fonetica_portugues(ds_campo_w);
	ds_fonetica_w	:= ds_fonetica_w || ds_aux || soundex(ds_campo_w);
	ds_campo_aux_w	:= substr(ds_campo_aux_w,pos_sep_w+1,255);
	pos_sep_w	:= position(' ' in ds_campo_aux_w);
end loop;

ds_campo_aux_w  := trata_fonetica_portugues(ds_campo_aux_w);
ds_fonetica_w	:= ds_fonetica_w || ds_aux ||soundex(ds_campo_aux_w);

if ( ie_consulta_p = 'S') then
	ds_fonetica_w := ds_fonetica_w || '%';
end if;

return ds_fonetica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION gera_fonetica (ds_campo_p text,ie_consulta_p text) FROM PUBLIC;

