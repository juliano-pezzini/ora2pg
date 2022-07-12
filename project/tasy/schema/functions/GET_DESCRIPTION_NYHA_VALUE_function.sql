-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_description_nyha_value (ie_classe bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(4000);


BEGIN

if (ie_classe IS NOT NULL AND ie_classe::text <> '') then
    if (ie_classe = 1) then
        ds_retorno_w := obter_desc_expressao(874456);

    elsif (ie_classe = 2) then
        ds_retorno_w := obter_desc_expressao(874458);

    elsif (ie_classe = 3) then
        ds_retorno_w := obter_desc_expressao(874460);

    elsif (ie_classe = 4) then
        ds_retorno_w := obter_desc_expressao(874462);

    end	if;
end	if;

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_description_nyha_value (ie_classe bigint) FROM PUBLIC;

