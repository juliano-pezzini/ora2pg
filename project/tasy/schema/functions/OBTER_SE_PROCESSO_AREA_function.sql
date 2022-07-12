-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_processo_area ( nr_seq_processo_p bigint, nr_seq_area_prep_p bigint) RETURNS varchar AS $body$
DECLARE


ie_processo_area_w	varchar(1) := 'S';
ie_area_processo_w	varchar(1) := 'S';


BEGIN
if (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') and (nr_seq_area_prep_p IS NOT NULL AND nr_seq_area_prep_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_area_processo_w
	from	adep_processo_area
	where	nr_seq_processo = nr_seq_processo_p;

	if (ie_area_processo_w = 'S') then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_processo_area_w
		from	adep_processo_area
		where	nr_seq_processo 	= nr_seq_processo_p
		and	nr_seq_area_prep	= nr_seq_area_prep_p;
	else
		ie_processo_area_w	:= 'S';
	end if;
end if;

return ie_processo_area_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_processo_area ( nr_seq_processo_p bigint, nr_seq_area_prep_p bigint) FROM PUBLIC;
