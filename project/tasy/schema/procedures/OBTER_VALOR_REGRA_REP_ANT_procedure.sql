-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_valor_regra_rep_ant (nr_repasse_terceiro_p bigint, nr_seq_regra_anterior_p bigint, vl_regra_p INOUT bigint) AS $body$
DECLARE



nr_seq_regra_ant_w		bigint;
cd_regra_repasse_w		bigint;
vl_rep_ant_w			double precision;
vl_repasse_w			double precision;
vl_liberado_w			double precision;


BEGIN

select	max(nr_seq_regra_ant),
	max(cd_regra_repasse)
into STRICT	nr_seq_regra_ant_w,
	cd_regra_repasse_w
from	terceiro_regra_esp
where	nr_sequencia	= nr_seq_regra_anterior_p;

if (nr_seq_regra_ant_w IS NOT NULL AND nr_seq_regra_ant_w::text <> '') then
	vl_rep_ant_w := OBTER_VALOR_REGRA_REP_ANT(nr_repasse_terceiro_p, nr_seq_regra_ant_w, vl_rep_ant_w);
end if;

select	coalesce(sum(vl_repasse),0)
into STRICT	vl_repasse_w
from	repasse_terceiro_item
where	nr_repasse_terceiro	= nr_repasse_terceiro_p
and	nr_seq_terc_regra_esp	= nr_seq_regra_anterior_p;

select	coalesce(sum(vl_liberado),0)
into STRICT	vl_liberado_w
from (SELECT	a.vl_liberado
	from	procedimento_repasse a
	where	a.cd_regra		= cd_regra_repasse_w
	and	a.nr_repasse_terceiro	= nr_repasse_terceiro_p
	
union all

	SELECT	a.vl_liberado
	from	material_repasse a
	where	a.cd_regra		= cd_regra_repasse_w
	and	a.nr_repasse_terceiro	= nr_repasse_terceiro_p) alias2;

vl_regra_p		:= coalesce(vl_rep_ant_w,0) + coalesce(vl_repasse_w,0) + coalesce(vl_liberado_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_valor_regra_rep_ant (nr_repasse_terceiro_p bigint, nr_seq_regra_anterior_p bigint, vl_regra_p INOUT bigint) FROM PUBLIC;
