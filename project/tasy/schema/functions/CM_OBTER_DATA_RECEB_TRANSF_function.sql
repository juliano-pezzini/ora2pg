-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cm_obter_data_receb_transf ( nr_seq_conjunto_p bigint) RETURNS timestamp AS $body$
DECLARE


nr_seq_lote_transf_w		bigint;
dt_retorno_w			timestamp;


BEGIN

select	max(a.nr_sequencia)
into STRICT	nr_seq_lote_transf_w
from	cm_lote_transferencia a,
	cm_lote_transf_conj b
where	a.nr_sequencia = b.nr_seq_lote_transf
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	b.nr_seq_conjunto = nr_seq_conjunto_p;

if (coalesce(nr_seq_lote_transf_w,0) > 0) then
	begin

	select	dt_baixa
	into STRICT	dt_retorno_w
	from	cm_lote_transferencia
	where	nr_sequencia = nr_seq_lote_transf_w;

	end;
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cm_obter_data_receb_transf ( nr_seq_conjunto_p bigint) FROM PUBLIC;

