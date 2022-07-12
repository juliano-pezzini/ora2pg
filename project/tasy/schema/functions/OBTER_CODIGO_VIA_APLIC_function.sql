-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_via_aplic ( cd_medico_destino_p text, ie_via_aplic_p bigint) RETURNS bigint AS $body$
DECLARE


ie_via_aplic_w	bigint;


BEGIN

Select	min(a.nr_sequencia)
into STRICT	ie_via_aplic_w
from	med_via_aplicacao a
where	a.cd_medico	= cd_medico_destino_p
and	a.ds_via_aplicacao in (	SELECT	b.ds_via_aplicacao
				from	med_via_aplicacao b
				where	b.nr_sequencia	= ie_via_aplic_p);

return ie_via_aplic_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_via_aplic ( cd_medico_destino_p text, ie_via_aplic_p bigint) FROM PUBLIC;
