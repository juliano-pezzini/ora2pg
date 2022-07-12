-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_exame_prescr_amostra ( nr_seq_exame_p bigint, nr_amostra_p bigint ) RETURNS varchar AS $body$
DECLARE


cd_exame_w	varchar(20) := null;


BEGIN

select	max(coalesce(cd_exame_integracao, cd_exame))
into STRICT	cd_exame_w
from	exame_laboratorio e
where	e.nr_seq_superior 	= nr_seq_exame_p
and 	e.nr_ordem_amostra 	= nr_amostra_p;

if (coalesce(cd_exame_w::text, '') = '') then

	select	max(coalesce(cd_exame_integracao, cd_exame))
	into STRICT	cd_exame_w
	from	exame_laboratorio e
	where	e.nr_seq_exame 	= nr_seq_exame_p;

end if;

return	cd_exame_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_exame_prescr_amostra ( nr_seq_exame_p bigint, nr_amostra_p bigint ) FROM PUBLIC;

