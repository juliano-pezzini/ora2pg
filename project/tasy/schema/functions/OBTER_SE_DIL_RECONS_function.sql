-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_dil_recons (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_agrupador_w	smallint;
ds_retorno_w	varchar(255);

BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select 	max(ie_agrupador)
	into STRICT	ie_agrupador_w
	from 	can_ordem_item_prescr
	where	nr_sequencia = nr_sequencia_p;

end if;


if (ie_agrupador_w = 9) then
	ds_retorno_w := wheb_mensagem_pck.get_texto(309462); -- Reconstituinte
else
	ds_retorno_w := wheb_mensagem_pck.get_texto(309463); -- Diluente
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_dil_recons (nr_sequencia_p bigint) FROM PUBLIC;
