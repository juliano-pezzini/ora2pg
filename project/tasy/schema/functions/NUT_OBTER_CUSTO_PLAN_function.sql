-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_custo_plan ( nr_seq_cardapio_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_custo_total_w	double precision;

BEGIN

if (nr_seq_cardapio_p IS NOT NULL AND nr_seq_cardapio_p::text <> '') then

	SELECT	SUM((nut_obter_custo_gen(c.cd_material,b.qt_componente,a.qt_rendimento,0,c.qt_conversao,'C',c.nr_sequencia)) * coalesce(d.qt_refeicao,0))
	into STRICT	vl_custo_total_w
	FROM   	nut_receita a,
		nut_receita_comp b,
		nut_genero_alim c,
		nut_pac_opcao_rec d
	WHERE  	a.nr_sequencia 		= b.nr_seq_receita
	AND	c.nr_sequencia 		= b.nr_seq_gen_alim
	AND	a.nr_sequencia 		= d.nr_seq_receita
	AND	d.nr_seq_cardapio_dia 	= nr_seq_cardapio_p;
elsif (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') then
	SELECT 	SUM((nut_obter_custo_gen(c.cd_material,b.qt_componente,a.qt_rendimento,0,c.qt_conversao,'C',c.nr_sequencia)) * coalesce(d.qt_refeicao,0))
	into STRICT	vl_custo_total_w
	FROM   	nut_receita a,
		nut_receita_comp b,
		nut_genero_alim c,
		nut_pac_opcao_rec d,
		nut_cardapio_dia e
	WHERE  	a.nr_sequencia = b.nr_seq_receita
	AND	c.nr_sequencia = b.nr_seq_gen_alim
	AND	a.nr_sequencia = d.nr_seq_receita
	AND	e.nr_sequencia = d.nr_seq_cardapio_dia
	AND	e.dt_cardapio between  dt_inicial_p and dt_final_p
	and	e.ie_tipo_cardapio = 'PL';
else
	vl_custo_total_w:= 0;
end if;

return	vl_custo_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_custo_plan ( nr_seq_cardapio_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

