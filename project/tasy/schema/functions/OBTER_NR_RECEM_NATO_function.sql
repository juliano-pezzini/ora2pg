-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_recem_nato (nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w	bigint;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	select	prescr_medica.nr_recem_nato
	into STRICT	ds_retorno_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;
end if;

RETURN	ds_retorno_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_recem_nato (nr_prescricao_p bigint) FROM PUBLIC;
