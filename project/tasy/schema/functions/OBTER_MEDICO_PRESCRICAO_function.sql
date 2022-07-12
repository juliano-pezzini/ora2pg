-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medico_prescricao (nr_prescricao_p bigint, ie_cod_nome_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(100);
cd_medico_w	varchar(10);


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	begin

	select	cd_medico
	into STRICT	cd_medico_w
	from	prescr_medica
	where	nr_prescricao	= nr_prescricao_p;

	if (ie_cod_nome_p 	= 'C')  then
		ds_retorno_w	:= cd_medico_w;
	else
		ds_retorno_w	:= obter_nome_pessoa_fisica(cd_medico_w, null);
	end if;

	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medico_prescricao (nr_prescricao_p bigint, ie_cod_nome_p text) FROM PUBLIC;

