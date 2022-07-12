-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_horas_cronograma ( nr_seq_proj_p bigint, ie_opcao_p text, dt_referencia_p timestamp default null) RETURNS bigint AS $body$
DECLARE


/*
	IE_OPCAO_P:

	F - Horas faturadas
	NF - Não faturadas
	HC - Horas contrato

*/
qt_horas_real_w			double precision;


BEGIN

if (ie_opcao_p = 'F') then

	select	sum(coalesce(coalesce(ra.qt_min_ativ,0) - coalesce(ra.qt_min_intervalo,0),0) / 60)
	into STRICT	qt_horas_real_w
	from	proj_cronograma c,
			proj_rat r,
			proj_rat_ativ ra
	where	c.nr_sequencia = r.nr_seq_cronograma
	and	r.nr_sequencia = ra.nr_seq_rat
	and	c.nr_seq_proj = nr_seq_proj_p
	and	c.ie_cobrado = 'S'
	and	trunc(ra.dt_inicio_ativ,'month') = dt_referencia_p;

elsif (ie_opcao_p = 'NF') then

	select	sum(coalesce(coalesce(ra.qt_min_ativ,0) - coalesce(ra.qt_min_intervalo,0),0) / 60)
	into STRICT	qt_horas_real_w
	from	proj_cronograma c,
			proj_rat r,
			proj_rat_ativ ra
	where	c.nr_sequencia = r.nr_seq_cronograma
	and	r.nr_sequencia = ra.nr_seq_rat
	and	c.nr_seq_proj = nr_seq_proj_p
	and	c.ie_cobrado = 'N'
	and	trunc(ra.dt_inicio_ativ,'month') = dt_referencia_p;

elsif (ie_opcao_p = 'HC') then

	select	coalesce(sum(c.qt_horas_contrato), 0)
	into STRICT	qt_horas_real_w
	from	proj_cronograma c
	where	c.nr_seq_proj = nr_seq_proj_p
	and	c.ie_situacao = 'A'
	and	coalesce(c.qt_horas_contrato, 0) != 0;

end if;

return qt_horas_real_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_horas_cronograma ( nr_seq_proj_p bigint, ie_opcao_p text, dt_referencia_p timestamp default null) FROM PUBLIC;
