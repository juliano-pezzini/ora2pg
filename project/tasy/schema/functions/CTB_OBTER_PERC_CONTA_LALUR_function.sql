-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_perc_conta_lalur ( nr_seq_lalur_p bigint, cd_conta_contabil_p text, ie_tipo_conta_p text, dt_vigencia_p timestamp) RETURNS bigint AS $body$
DECLARE


nr_seq_regra_vigencia_w		bigint;
pr_valor_w			double precision;



BEGIN

pr_valor_w	:= 100;

select	max(b.nr_sequencia)
into STRICT	nr_seq_regra_vigencia_w
from	conta_contabil_lalur a,
	conta_ctb_lalur_periodo b
where	a.nr_sequencia		= b.nr_seq_conta
and	a.nr_seq_lalur		= nr_seq_lalur_p
and	a.cd_conta_contabil	= cd_conta_contabil_p
and	b.dt_vigencia		= (	SELECT	max(y.dt_vigencia)
					from	conta_contabil_lalur x,
						conta_ctb_lalur_periodo y
					where	x.nr_sequencia		= y.nr_seq_conta
					and	x.nr_seq_lalur		= nr_seq_lalur_p
					and	x.cd_conta_contabil	= cd_conta_contabil_p
					and	y.dt_vigencia 	       <= dt_vigencia_p);

if (coalesce(nr_seq_regra_vigencia_w,0) <> 0) then

	select	coalesce(max(pr_valor),100)
	into STRICT	pr_valor_w
	from	conta_ctb_lalur_periodo
	where	nr_sequencia	= nr_seq_regra_vigencia_w;

end if;

return	pr_valor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_perc_conta_lalur ( nr_seq_lalur_p bigint, cd_conta_contabil_p text, ie_tipo_conta_p text, dt_vigencia_p timestamp) FROM PUBLIC;
