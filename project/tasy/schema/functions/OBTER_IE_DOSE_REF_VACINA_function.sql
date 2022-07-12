-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ie_dose_ref_vacina ( nr_seq_vacina_p bigint, ie_dose_p text) RETURNS varchar AS $body$
DECLARE


ie_dose_ref_w	varchar(3);


BEGIN
if (nr_seq_vacina_p IS NOT NULL AND nr_seq_vacina_p::text <> '') 	and (ie_dose_p IS NOT NULL AND ie_dose_p::text <> '') 	then
	begin
	select	max(a.ie_dose_referencia)
	into STRICT	ie_dose_ref_w
	from	vacina_calendario a
	where	a.nr_seq_vacina = nr_seq_vacina_p
	and	a.ie_dose 	= ie_dose_p;
	end;
end if;
return ie_dose_ref_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ie_dose_ref_vacina ( nr_seq_vacina_p bigint, ie_dose_p text) FROM PUBLIC;

