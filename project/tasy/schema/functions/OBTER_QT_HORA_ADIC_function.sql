-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_hora_adic ( nr_seq_projeto_p bigint) RETURNS bigint AS $body$
DECLARE



qt_horas_w		double precision;


BEGIN

select 	coalesce(sum((dividir(CASE WHEN a.ie_atividade_extra='S' THEN  a.qt_min_ativ END , 60))::numeric ),0) qt_n_adic
into STRICT	qt_horas_w
from    proj_rat b,
	proj_rat_ativ a,
	proj_cron_etapa x,
	proj_cronograma d,
	proj_projeto c
where   b.nr_sequencia = a.nr_seq_rat
and     d.nr_sequencia  = x.nr_seq_cronograma
and     x.nr_sequencia  = a.nr_seq_etapa_cron
and     d.nr_seq_proj = c.nr_sequencia
and     c.nr_seq_cliente = b.nr_seq_cliente
and     c.nr_sequencia = nr_seq_projeto_p
and     d.ie_cobrado = 'S'
and	coalesce(x.ie_situacao,'A') = 'A'
and	a.ie_classificacao in ('40','70','160','20','50');

RETURN qt_horas_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_hora_adic ( nr_seq_projeto_p bigint) FROM PUBLIC;

