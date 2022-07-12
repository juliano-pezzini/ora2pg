-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_ontologia ( ie_ontologia_p text, ds_valor_ontologia_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	varchar(255);


BEGIN

if (ie_ontologia_p IS NOT NULL AND ie_ontologia_p::text <> '') then

	Select 	max(ds_descricao_ori)
	into STRICT	ds_retorno_w
	from   	res_cadastro_ontologia
	where  	ie_ontologia = ie_ontologia_p
	and		ds_valor_ontologia = ds_valor_ontologia_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_ontologia ( ie_ontologia_p text, ds_valor_ontologia_p text) FROM PUBLIC;
