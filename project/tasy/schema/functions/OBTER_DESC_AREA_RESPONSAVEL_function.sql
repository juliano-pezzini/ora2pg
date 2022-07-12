-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_area_responsavel (nr_seq_area_processo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(150);


BEGIN

select  	max( distinct d.nm_area)
into STRICT	ds_retorno_w
from	prp_etapa_processo a,
	prp_fase_processo b,
	prp_fase_processo_etapa c,
	prp_area_processo d
where	a.nr_sequencia = c.nr_seq_etapa_processo
and 	b.nr_sequencia = c.nr_seq_fase_processo
and	d.nr_sequencia = c.nr_seq_area_processo
and	a.nr_sequencia = nr_seq_area_processo_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_area_responsavel (nr_seq_area_processo_p bigint) FROM PUBLIC;
