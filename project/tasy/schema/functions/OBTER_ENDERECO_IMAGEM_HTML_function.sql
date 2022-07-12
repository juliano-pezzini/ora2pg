-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_endereco_imagem_html ( ds_endereco_p text) RETURNS varchar AS $body$
DECLARE

ds_endereco_w	varchar(2000);

BEGIN

ds_endereco_w	:= ds_endereco_p;

if (substr(ds_endereco_w,1,1)	<> '/') then
	ds_endereco_w	:= '/'||ds_endereco_w;

end if;


if (position('assets' in ds_endereco_w) = 0)then
	ds_endereco_w	:= '/assets'||ds_endereco_w;
end if;


return	ds_endereco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_endereco_imagem_html ( ds_endereco_p text) FROM PUBLIC;
