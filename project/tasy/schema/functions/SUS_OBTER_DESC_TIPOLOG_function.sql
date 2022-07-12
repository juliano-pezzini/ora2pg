-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_desc_tipolog ( cd_tipo_logradouro_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(40)	:= '';



BEGIN

if (cd_tipo_logradouro_p IS NOT NULL AND cd_tipo_logradouro_p::text <> '') then

	select	coalesce(max(ds_tipo_logradouro),'')
	into STRICT	ds_retorno_w
	from	sus_tipo_logradouro
	where	cd_tipo_logradouro	= cd_tipo_logradouro_p;

end if;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_desc_tipolog ( cd_tipo_logradouro_p text) FROM PUBLIC;
