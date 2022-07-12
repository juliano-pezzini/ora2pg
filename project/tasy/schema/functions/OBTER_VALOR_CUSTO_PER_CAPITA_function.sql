-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_custo_per_capita (nr_sequencia_p bigint, nr_seq_gen_alim_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision;
qt_conversao_w		double precision;
cd_material_w		integer;
cd_estabelecimento_w	smallint;
vl_custo_w		double precision;
qt_componente_w		double precision;


BEGIN

select	sum(qt_componente)
into STRICT	qt_componente_w
from	nut_receita_comp
where	nr_seq_receita = nr_sequencia_p
and	nr_seq_gen_alim = nr_seq_gen_alim_p;

select	g.cd_material,
	coalesce(g.qt_conversao,1),
	cd_estabelecimento
into STRICT	cd_material_w,
	qt_conversao_w,
	cd_estabelecimento_w
from	nut_genero_alim g
where	g.nr_sequencia = nr_seq_gen_alim_p;

select	coalesce(max(c.vl_custo),0)
into STRICT	vl_custo_w
from	custo_mensal_material c
where   c.cd_estabelecimento	= cd_estabelecimento_w
and	c.cd_material		= cd_material_w
and	c.ie_tipo_custo		= 'R';

select	((vl_custo_w / qt_conversao_w) * qt_componente_w)
into STRICT	vl_retorno_w
;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_custo_per_capita (nr_sequencia_p bigint, nr_seq_gen_alim_p bigint) FROM PUBLIC;
