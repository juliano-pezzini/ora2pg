-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_se_possui_solucao (nr_seq_dialise_p bigint) RETURNS varchar AS $body$
DECLARE

ie_retorno_w	varchar(1);

BEGIN
ie_retorno_w := 'S';
if (nr_seq_dialise_p IS NOT NULL AND nr_seq_dialise_p::text <> '') then
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	from	hd_dialise_concentrado a,
		material b
	where	a.cd_material = b.cd_material
	and	a.nr_seq_dialise = nr_seq_dialise_p
	and	b.ie_tipo_solucao = 'A';

	if (ie_retorno_w = 'S') then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_retorno_w
		from	hd_dialise_concentrado a,
			material b
		where	a.cd_material = b.cd_material
		and	a.nr_seq_dialise = nr_seq_dialise_p
		and	b.ie_tipo_solucao = 'B';
	end if;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_se_possui_solucao (nr_seq_dialise_p bigint) FROM PUBLIC;

