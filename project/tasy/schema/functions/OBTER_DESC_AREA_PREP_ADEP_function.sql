-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_area_prep_adep ( nr_seq_area_prep_p bigint) RETURNS varchar AS $body$
DECLARE


ds_area_prep_w	varchar(80);


BEGIN
if (nr_seq_area_prep_p IS NOT NULL AND nr_seq_area_prep_p::text <> '') then

	select	max(ds_area_prep)
	into STRICT	ds_area_prep_w
	from	adep_area_prep
	where	nr_sequencia = nr_seq_area_prep_p;

end if;

return ds_area_prep_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_area_prep_adep ( nr_seq_area_prep_p bigint) FROM PUBLIC;

