-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_ds_tipo_contratacao ( ie_tipo_contrat_p pls_pp_base_atual_trib.ie_tipo_contratacao%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (coalesce(ie_tipo_contrat_p::text, '') = '') or (ie_tipo_contrat_p = 'S') then

	ds_retorno_w := 'Sem tipo contratação';
else

	ds_retorno_w := substr(obter_valor_dominio(3854, ie_tipo_contrat_p), 1, 255);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_ds_tipo_contratacao ( ie_tipo_contrat_p pls_pp_base_atual_trib.ie_tipo_contratacao%type) FROM PUBLIC;

