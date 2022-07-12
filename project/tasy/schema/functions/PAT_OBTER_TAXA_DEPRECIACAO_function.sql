-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pat_obter_taxa_depreciacao ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision;


BEGIN
select	coalesce(max(pr_depreciacao),0)
into STRICT	vl_retorno_w
from	pat_bem_taxa
where	nr_seq_bem = nr_sequencia_p
and	dt_vigencia =
	(SELECT	max(dt_vigencia)
	from	pat_bem_taxa
	where	nr_seq_bem = nr_sequencia_p
	and	dt_vigencia <= clock_timestamp());

if (vl_retorno_w = 0) then
	begin
	select	tx_deprec
	into STRICT	vl_retorno_w
	from	pat_bem
	where	nr_sequencia = nr_sequencia_p;
	end;
end if;

RETURN	vl_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pat_obter_taxa_depreciacao ( nr_sequencia_p bigint) FROM PUBLIC;
