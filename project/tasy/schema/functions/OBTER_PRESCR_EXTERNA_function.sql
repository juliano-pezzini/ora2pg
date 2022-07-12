-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prescr_externa (nr_prescricao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(20);
nr_prescricao_origem_w	bigint;


BEGIN

/*ie_opcao_p
T- TasyLab
*/
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	if (ie_opcao_p = 'T') then

	select	max(a.nr_prescricao_origem)
	into STRICT	nr_prescricao_origem_w
	from	lab_tasylab_cli_prescr a
	where	a.nr_prescricao = nr_prescricao_p;

	end if;
end if;

ds_retorno_w := nr_prescricao_origem_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prescr_externa (nr_prescricao_p bigint, ie_opcao_p text) FROM PUBLIC;

