-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_brasindice (cd_laboratorio_p text, cd_apresentacao_p text, cd_medicamento_p text, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE


/* Tipo de Retorno

	M - Medicamento
	L - Laboratorio
	A - Apresentacao

*/
ds_retorno_w	varchar(255) := '';



BEGIN

if (ie_tipo_retorno_p = 'M') and (cd_medicamento_p IS NOT NULL AND cd_medicamento_p::text <> '') then
	begin

	select	ds_medicamento
	into STRICT	ds_retorno_w
	from	brasindice_medicamento
	where	cd_medicamento	= cd_medicamento_p;

	end;
elsif (ie_tipo_retorno_p = 'L') and (cd_laboratorio_p IS NOT NULL AND cd_laboratorio_p::text <> '') then
	begin

	select	ds_laboratorio
	into STRICT	ds_retorno_w
	from	brasindice_laboratorio
	where	cd_laboratorio	= cd_laboratorio_p;

	end;
elsif (ie_tipo_retorno_p = 'A') and (cd_apresentacao_p IS NOT NULL AND cd_apresentacao_p::text <> '') then
	begin

	select	ds_apresentacao
	into STRICT	ds_retorno_w
	from	brasindice_apresentacao
	where	cd_apresentacao	= cd_apresentacao_p;

	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_brasindice (cd_laboratorio_p text, cd_apresentacao_p text, cd_medicamento_p text, ie_tipo_retorno_p text) FROM PUBLIC;
