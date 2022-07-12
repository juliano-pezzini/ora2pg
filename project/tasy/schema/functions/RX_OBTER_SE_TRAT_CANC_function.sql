-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rx_obter_se_trat_canc (nr_seq_tratamento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
qtd_w			integer;



BEGIN

select	count(*)
into STRICT	qtd_w
from	rxt_tratamento
where	nr_seq_tumor = nr_seq_tratamento_p;

if (qtd_w > 0) then
	select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ds_retorno_w
	from	rxt_tratamento
	where	coalesce(dt_cancelamento::text, '') = ''
	and	nr_seq_tumor = nr_seq_tratamento_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rx_obter_se_trat_canc (nr_seq_tratamento_p bigint) FROM PUBLIC;
