-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_adiant_pago (nr_adiantamento_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


dt_referencia_w		timestamp;
vl_adiantamento_w	double precision;
vl_devolucao_w		double precision;
vl_vinculado_oc_w	double precision;
vl_adiant_titulo_w	double precision;
ie_deduzir_ordem_adiant_w	varchar(1)	:= 'S';
cd_estabelecimento_w		smallint;


BEGIN

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	adiantamento_pago
where	nr_adiantamento	= nr_adiantamento_p;

if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then
	select	coalesce(max(ie_deduzir_ordem_adiant),'S')
	into STRICT	ie_deduzir_ordem_adiant_w
	from	parametros_contas_pagar
	where	cd_estabelecimento	= cd_estabelecimento_w;
end if;

dt_referencia_w		:= trunc(dt_referencia_p, 'dd');

if (ie_deduzir_ordem_adiant_w = 'S') then
	begin
	select	coalesce(sum(vl_vinculado), 0)
	into STRICT	vl_vinculado_oc_w
	from	ordem_compra_adiant_pago
	where	nr_adiantamento			= nr_adiantamento_p
	and	trunc(dt_atualizacao,'dd')	<= dt_referencia_w;

	select	coalesce(sum(a.vl_adiantamento), 0)
	into STRICT	vl_adiant_titulo_w
	from	titulo_pagar b,
		titulo_pagar_adiant a
	where	a.nr_adiantamento	= nr_adiantamento_p
	and	b.nr_titulo		= a.nr_titulo
	and	trunc(coalesce(a.dt_contabil, a.dt_atualizacao),'dd')	<= dt_referencia_w
	and	not exists (SELECT	1
		from	nota_fiscal y,
			ordem_compra_adiant_pago x
		where	x.nr_adiantamento	= a.nr_adiantamento
		and	x.nr_ordem_compra	= y.nr_ordem_compra
		and	y.nr_sequencia		= b.nr_seq_nota_fiscal);
	end;
else
	begin
	vl_vinculado_oc_w	:= 0;

	select	coalesce(sum(a.vl_adiantamento), 0)
	into STRICT	vl_adiant_titulo_w
	from	titulo_pagar b,
		titulo_pagar_adiant a
	where	a.nr_adiantamento	= nr_adiantamento_p
	and	b.nr_titulo		= a.nr_titulo
	and	trunc(coalesce(a.dt_contabil, a.dt_atualizacao),'dd')	<= dt_referencia_w;
	end;
end if;

select	coalesce(sum(vl_devolucao), 0)
into STRICT	vl_devolucao_w
from	adiant_pago_dev
where	nr_adiantamento			= nr_adiantamento_p
and	trunc(dt_devolucao, 'dd') 	<= dt_referencia_w;

select	vl_adiantamento
into STRICT	vl_adiantamento_w
from	adiantamento_pago
where	nr_adiantamento			= nr_adiantamento_p;

return	vl_adiantamento_w - vl_devolucao_w - vl_vinculado_oc_w - vl_adiant_titulo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_adiant_pago (nr_adiantamento_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

