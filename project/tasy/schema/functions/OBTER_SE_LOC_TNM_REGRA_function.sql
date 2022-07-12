-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_loc_tnm_regra (nr_seq_regra_p bigint, nr_seq_localizacao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);

BEGIN

select 	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
into STRICT	ie_retorno_w
from	can_tnm_regra_loc
where	nr_seq_regra = nr_Seq_regra_p;

if (ie_retorno_w	= 'N') then

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	from	can_tnm_regra_loc
	where	nr_seq_regra = nr_Seq_regra_p
	and	nr_seq_loc = nr_seq_localizacao_p;

end if;


return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_loc_tnm_regra (nr_seq_regra_p bigint, nr_seq_localizacao_p bigint) FROM PUBLIC;
