-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_iniciativas_encer (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w varchar(1);


BEGIN

select 	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
into STRICT	ds_retorno_w
from	man_ordem_servico a
where	a.nr_seq_obj_bsc = nr_sequencia_p
and		((trunc(a.dt_fim_real) >= trunc(clock_timestamp())) or (coalesce(a.dt_fim_real::text, '') = ''));

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_iniciativas_encer (nr_sequencia_p bigint) FROM PUBLIC;

