-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_description_nyha_class (ie_classe bigint) RETURNS varchar AS $body$
DECLARE


/*
	309163 - Classe I   -> ie_classe = 1
    309165 - Classe II  -> ie_classe = 2
	746452 - Classe III -> ie_classe = 3
	746456 - Classe IV  -> ie_classe = 4
*/
ds_retorno_w varchar(30);


BEGIN

if (ie_classe = 1) and (ie_classe IS NOT NULL AND ie_classe::text <> '')then
	ds_retorno_w := obter_desc_expressao(309163);

elsif (ie_classe = 2) and (ie_classe IS NOT NULL AND ie_classe::text <> '')then
	ds_retorno_w := obter_desc_expressao(309165);

elsif (ie_classe = 3) and (ie_classe IS NOT NULL AND ie_classe::text <> '')then
	ds_retorno_w := obter_desc_expressao(746452);

elsif (ie_classe = 4) and (ie_classe IS NOT NULL AND ie_classe::text <> '')then
	ds_retorno_w := obter_desc_expressao(746456);

end	if;

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_description_nyha_class (ie_classe bigint) FROM PUBLIC;

