-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_se_derivado_exame ( nr_seq_exame_p bigint, nr_seq_derivado_p bigint, ie_tipo_regra_p text, ie_aferese_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(1);


BEGIN

select 	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
into STRICT	ds_retorno_w
from	san_exame_derivado
where	nr_seq_exame = nr_seq_exame_p
and	coalesce(ie_tipo_regra,'B') = ie_tipo_regra_p;

if (ds_retorno_w = 'N') then

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	san_exame_derivado
	where	nr_seq_exame = nr_seq_exame_p
	and	nr_seq_derivado = nr_seq_derivado_p
	and	coalesce(ie_tipo_regra,'B') = ie_tipo_regra_p
	and (coalesce(ie_aferese, 'N') = 'N'
	or 	coalesce(ie_aferese, 'N') = coalesce(ie_aferese_p, 'N'));
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_se_derivado_exame ( nr_seq_exame_p bigint, nr_seq_derivado_p bigint, ie_tipo_regra_p text, ie_aferese_p text) FROM PUBLIC;

