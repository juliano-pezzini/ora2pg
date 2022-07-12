-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_fluxo_orcado (cd_estabelecimento_p bigint, cd_conta_financ_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, cd_empresa_p bigint, ie_restringe_estab_p text, ie_periodo_p text default 'M') RETURNS bigint AS $body$
DECLARE


vl_fluxo_w			double precision;
CD_CONTA_FINANC_SALDO_w	bigint;
CD_CONTA_FINANC_SANT_w	bigint;
dt_saldo_w			timestamp;


BEGIN

select	CD_CONTA_FINANC_SALDO,
	CD_CONTA_FINANC_SANT
into STRICT	CD_CONTA_FINANC_SALDO_w,
	CD_CONTA_FINANC_SANT_w
from	parametro_fluxo_caixa
where	cd_estabelecimento		= cd_estabelecimento_p;

if (cd_conta_financ_p	= cd_conta_financ_saldo_w) then	-- conta saldo atual
	select	max(dt_referencia)
	into STRICT	dt_saldo_w
	from	fluxo_caixa x
	where	x.ie_classif_fluxo	= 'O'
	and	(
			(
				(coalesce(ie_restringe_estab_p,'E') = 'E') and (x.cd_estabelecimento	= cd_estabelecimento_p)
			) or
			(
				(coalesce(ie_restringe_estab_p,'E') = 'S') and
				(
					(x.cd_estabelecimento	= cd_estabelecimento_p) or (obter_estab_financeiro(x.cd_estabelecimento) = cd_estabelecimento_p)
				)
			) or (coalesce(ie_restringe_estab_p,'E') = 'N')
		)
	and	x.cd_conta_financ		= cd_conta_financ_p
	and	x.dt_referencia		between trunc(dt_inicial_p,'month') and fim_dia(last_day(dt_final_p));

	select	coalesce(sum(x.vl_fluxo),0)
	into STRICT	vl_fluxo_w
	from	fluxo_caixa x  
	where	x.ie_classif_fluxo		= 'O' 
	and	(
			(
				(coalesce(ie_restringe_estab_p,'E') = 'E') and (x.cd_estabelecimento	= cd_estabelecimento_p)
			) or
			(
				(coalesce(ie_restringe_estab_p,'E') = 'S') and
				(
					(x.cd_estabelecimento	= cd_estabelecimento_p) or (obter_estab_financeiro(x.cd_estabelecimento) = cd_estabelecimento_p)
				)
			) or (coalesce(ie_restringe_estab_p,'E') = 'N')
		)
	and	x.cd_conta_financ		= cd_conta_financ_p
	and	x.dt_referencia		= dt_saldo_w;

elsif (cd_conta_financ_p	= cd_conta_financ_sant_w) then	-- conta saldo anterior
	select	min(dt_referencia)
	into STRICT	dt_saldo_w
	from	fluxo_caixa x
	where	x.ie_classif_fluxo		= 'O'
	and	(
			(
				(coalesce(ie_restringe_estab_p,'E') = 'E') and (x.cd_estabelecimento	= cd_estabelecimento_p)
			) or
			(
				(coalesce(ie_restringe_estab_p,'E') = 'S') and
				(
					(x.cd_estabelecimento	= cd_estabelecimento_p) or (obter_estab_financeiro(x.cd_estabelecimento) = cd_estabelecimento_p)
				)
			) or (coalesce(ie_restringe_estab_p,'E') = 'N')
		)
	and	x.cd_conta_financ		= cd_conta_financ_p
	and	x.dt_referencia		between trunc(dt_inicial_p,'month') and fim_dia(last_day(dt_final_p));

	select	coalesce(sum(x.vl_fluxo),0)
	into STRICT	vl_fluxo_w
	from	fluxo_caixa x
	where	x.ie_classif_fluxo		= 'O' 
	and	(
			(
				(coalesce(ie_restringe_estab_p,'E') = 'E') and (x.cd_estabelecimento	= cd_estabelecimento_p)
			) or
			(
				(coalesce(ie_restringe_estab_p,'E') = 'S') and
				(
					(x.cd_estabelecimento	= cd_estabelecimento_p) or (obter_estab_financeiro(x.cd_estabelecimento) = cd_estabelecimento_p)
				)
			) or (coalesce(ie_restringe_estab_p,'E') = 'N')
		)
	and	x.cd_conta_financ		= cd_conta_financ_p
	and	x.dt_referencia		= dt_saldo_w;

else
	select	coalesce(sum(x.vl_fluxo),0)
	into STRICT	vl_fluxo_w
	from	fluxo_caixa x  
	where	x.ie_classif_fluxo		= 'O' 
	and	(
			(
				(coalesce(ie_restringe_estab_p,'E') = 'E') and (x.cd_estabelecimento	= cd_estabelecimento_p)
			) or
			(
				(coalesce(ie_restringe_estab_p,'E') = 'S') and
				(
					(x.cd_estabelecimento	= cd_estabelecimento_p) or (obter_estab_financeiro(x.cd_estabelecimento) = cd_estabelecimento_p)
				)
			) or (coalesce(ie_restringe_estab_p,'E') = 'N')
		)
	and	x.cd_conta_financ		= cd_conta_financ_p
	and (
				(
					x.ie_periodo = ie_periodo_p
					and	x.dt_referencia		between trunc(dt_inicial_p) and trunc(dt_final_p)
					)
				or (
					x.ie_periodo = ie_periodo_p
					and	x.dt_referencia		between trunc(dt_inicial_p,'month') and fim_dia(last_day(dt_final_p))
					)
				);
end if;

return	vl_fluxo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_fluxo_orcado (cd_estabelecimento_p bigint, cd_conta_financ_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, cd_empresa_p bigint, ie_restringe_estab_p text, ie_periodo_p text default 'M') FROM PUBLIC;

