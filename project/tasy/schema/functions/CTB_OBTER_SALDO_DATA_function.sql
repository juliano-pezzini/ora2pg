-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_saldo_data ( cd_estabelecimento_p bigint, cd_conta_contabil_p text, cd_centro_custo_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_saldo_w		double precision;
vl_debito_w		double precision;
vl_credito_w		double precision;
dt_referencia_w	timestamp;
nr_seq_saldo_w	bigint;


BEGIN

vl_saldo_w		:= 0;
dt_referencia_w	:= add_months(trunc(dt_referencia_p,'month'),-1);
select	max(nr_sequencia)
into STRICT	nr_seq_saldo_w
from	ctb_mes_ref
where	dt_referencia	= dt_referencia_w;

select	/*+ index(a ctbsald_uk) */	coalesce(max(vl_saldo),0)
into STRICT	vl_saldo_w
from	ctb_saldo a
where	nr_seq_mes_ref		= nr_seq_saldo_w
and	cd_conta_contabil		= cd_conta_contabil_p
and	cd_estabelecimento		= cd_estabelecimento_p
and	coalesce(cd_centro_custo,0)	= coalesce(cd_centro_custo_p,0);

select	coalesce(ctb_obter_movto_data(
	cd_estabelecimento_p,
	cd_conta_contabil_p,
	cd_centro_custo_p,
	trunc(dt_referencia_p,'month'),
	dt_referencia_p,
	'D'),0)
into STRICT	vl_debito_w
;

select	coalesce(ctb_obter_movto_data(
	cd_estabelecimento_p,
	cd_conta_contabil_p,
	cd_centro_custo_p,
	trunc(dt_referencia_p,'month'),
	dt_referencia_p,
	'C'),0)
into STRICT	vl_credito_w
;

vl_saldo_w		:= vl_saldo_w - vl_debito_w + vl_credito_w;

return vl_saldo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_saldo_data ( cd_estabelecimento_p bigint, cd_conta_contabil_p text, cd_centro_custo_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

