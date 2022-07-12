-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_prox_mes_vacina ( nr_seq_vacina_p bigint, ie_dose_p text) RETURNS bigint AS $body$
DECLARE

		
qt_prox_mes_w	vacina_calendario.qt_prox_mes%type;

BEGIN
if (nr_seq_vacina_p IS NOT NULL AND nr_seq_vacina_p::text <> '') then
	begin
	select 	max(a.qt_prox_mes)
	into STRICT 	qt_prox_mes_w
	from 	vacina_calendario a,
		valor_dominio b
	where 	a.nr_seq_vacina = nr_seq_vacina_p
	and 	a.ie_dose       = ie_dose_p
	and 	a.ie_dose       = b.vl_dominio
	and 	b.cd_dominio    = 1018;	
	end;
end if;
return qt_prox_mes_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_prox_mes_vacina ( nr_seq_vacina_p bigint, ie_dose_p text) FROM PUBLIC;

