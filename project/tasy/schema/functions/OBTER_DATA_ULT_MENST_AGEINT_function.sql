-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_ult_menst_ageint ( nr_seq_ageint_item_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_retorno_w	timestamp;


BEGIN

if (coalesce(nr_seq_ageint_item_p,0) > 0) then
		select	max(a.dt_ultima_menstruacao)
		into STRICT	dt_retorno_w
		from	agenda_integrada a,
				agenda_integrada_item b
		where	a.nr_sequencia = b.nr_seq_agenda_int
		and		b.nr_sequencia = nr_seq_ageint_item_p;
end if;


return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_ult_menst_ageint ( nr_seq_ageint_item_p bigint) FROM PUBLIC;
