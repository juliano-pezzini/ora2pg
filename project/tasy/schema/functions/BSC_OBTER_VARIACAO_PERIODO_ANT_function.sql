-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bsc_obter_variacao_periodo_ant (cd_ano_p bigint, cd_periodo_p bigint, nr_seq_indicador_p bigint) RETURNS bigint AS $body$
DECLARE


qt_real_w	double precision;
qt_real_ww	double precision;
pr_retorno_w	double precision;


BEGIN

select	sum(a.qt_real)
into STRICT	qt_real_w
from	bsc_ind_inf a,
	bsc_indicador b
where	a.nr_seq_indicador	= b.nr_sequencia
and	a.nr_seq_indicador	= nr_seq_indicador_p
and	a.cd_ano		= cd_ano_p
and	a.cd_periodo		= cd_periodo_p - 11;

select	sum(a.qt_real)
into STRICT	qt_real_ww
from	bsc_ind_inf a,
	bsc_indicador b
where	a.nr_seq_indicador	= b.nr_sequencia
and	a.nr_seq_indicador	= nr_seq_indicador_p
and	a.cd_ano		= cd_ano_p - 1
and	a.cd_periodo		= cd_periodo_p;

pr_retorno_w	:= obter_variacao_entre_valor(qt_real_ww, qt_real_w);

return	pr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bsc_obter_variacao_periodo_ant (cd_ano_p bigint, cd_periodo_p bigint, nr_seq_indicador_p bigint) FROM PUBLIC;

