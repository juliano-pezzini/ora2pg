-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dmed_obter_total_lote (nr_seq_dmed_p bigint) RETURNS bigint AS $body$
DECLARE


vl_total_lote_w		double precision;


BEGIN

	if (coalesce(nr_seq_dmed_p,0) > 0) then
		select	coalesce(sum(vl_pago),0) total
		into STRICT	vl_total_lote_w
		from	dmed_mensal m,
			dmed d,
			dmed_agrupar_lote a,
			dmed_titulos_mensal t
		where	a.nr_seq_dmed_mensal = m.nr_sequencia
		and     t.nr_seq_dmed_mensal = m.nr_sequencia
		and	a.nr_seq_dmed_anual = d.nr_sequencia
		and	d.nr_sequencia = nr_seq_dmed_p;
	else
		vl_total_lote_w := 0;
	end if;

return	vl_total_lote_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dmed_obter_total_lote (nr_seq_dmed_p bigint) FROM PUBLIC;

