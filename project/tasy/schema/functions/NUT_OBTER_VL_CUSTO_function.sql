-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_vl_custo ( nr_seq_prod_centro_p bigint) RETURNS bigint AS $body$
DECLARE


vl_custo_w		double precision := 0;
nr_seq_prod_card_w	bigint;
qt_refeicao_custo_w	bigint;
qt_refeicao_total_w	bigint;
vl_custo_total_w	double precision;


BEGIN

if (nr_seq_prod_centro_p IS NOT NULL AND nr_seq_prod_centro_p::text <> '') then

	select	nr_seq_prod_card,
		coalesce(qt_refeicao,0)
	into STRICT	nr_seq_prod_card_w,
		qt_refeicao_custo_w
	from	nut_ordem_prod_centro
	where	nr_sequencia = nr_seq_prod_centro_p;

	select	coalesce(max(qt_refeicao),0),
		coalesce(max(vl_custo),0)
	into STRICT	qt_refeicao_total_w,
		vl_custo_total_w
	from	nut_ordem_prod_card
	where	nr_sequencia = nr_seq_prod_card_w;

	if (qt_refeicao_total_w > 0) then
		vl_custo_w := (vl_custo_total_w / qt_refeicao_total_w) * qt_refeicao_custo_w;
	end if;

end if;

return	vl_custo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_vl_custo ( nr_seq_prod_centro_p bigint) FROM PUBLIC;
