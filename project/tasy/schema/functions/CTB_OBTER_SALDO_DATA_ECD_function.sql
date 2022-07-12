-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_saldo_data_ecd ( cd_estabelecimento_p bigint, cd_conta_contabil_p text, cd_centro_custo_p bigint, dt_referencia_p timestamp, cd_empresa_p bigint, ie_consolida_empresa_p text) RETURNS bigint AS $body$
DECLARE


vl_saldo_w			double precision;
vl_debito_w			double precision;
vl_credito_w		double precision;
dt_referencia_w		timestamp;
nr_seq_saldo_w		bigint;


BEGIN

vl_saldo_w		:= 0;

dt_referencia_w	:= trunc(dt_referencia_p,'month');

select	max(nr_sequencia)
into STRICT	nr_seq_saldo_w
from	ctb_mes_ref
where	dt_referencia	= dt_referencia_w
and		cd_empresa 		= cd_empresa_p;

if (ie_consolida_empresa_p = 'N')then
	select	/*+ index(a ctbsald_uk) */			coalesce(max(vl_saldo),0)
	into STRICT	vl_saldo_w
	from	ctb_saldo a
	where	nr_seq_mes_ref		= nr_seq_saldo_w
	and		cd_conta_contabil		= cd_conta_contabil_p
	and		cd_estabelecimento		= cd_estabelecimento_p
	and		ie_consolida_empresa_p	= 'N'
	and		coalesce(cd_centro_custo,0)	= coalesce(cd_centro_custo_p,0);
else
	select	sum(a.vl_saldo)
	into STRICT	vl_saldo_w
	FROM ctb_mes_ref d, ctb_saldo a, conta_contabil b
LEFT OUTER JOIN ctb_grupo_conta c ON (b.cd_grupo = c.cd_grupo)
WHERE a.cd_conta_contabil			= b.cd_conta_contabil and d.nr_sequencia				= a.nr_seq_mes_ref and d.cd_empresa				= b.cd_empresa and d.cd_empresa				= cd_empresa_p and a.cd_conta_contabil			= cd_conta_contabil_p and coalesce(a.cd_centro_custo,0)	= coalesce(cd_centro_custo_p,0) and a.nr_seq_mes_ref			= nr_seq_saldo_w;
end if;

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

return coalesce(vl_saldo_w,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_saldo_data_ecd ( cd_estabelecimento_p bigint, cd_conta_contabil_p text, cd_centro_custo_p bigint, dt_referencia_p timestamp, cd_empresa_p bigint, ie_consolida_empresa_p text) FROM PUBLIC;

