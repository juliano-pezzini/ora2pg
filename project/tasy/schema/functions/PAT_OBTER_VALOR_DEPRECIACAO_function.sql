-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pat_obter_valor_depreciacao ( dt_referencia_p timestamp, cd_conta_contabil_p text, nr_seq_bem_p bigint, ie_valor_p text) RETURNS bigint AS $body$
DECLARE


/*
Tipo de valor
DA = Depreciacao acumulada do mes
DM = Depreciacao do mes
BD = Base depreciacao do mes
BDP = Baixa depreciacao
Para a ultima depreciacao do bem passar dt_referencia = null.
*/
vl_deprec_acum_w	double precision;
vl_deprec_mes_w	double precision;
vl_base_deprec_w	double precision;
vl_baixa_deprec_w	double precision;
vl_valor_w		double precision;
dt_valor_w		timestamp;
dt_referencia_w	timestamp;


BEGIN

dt_referencia_w	:= dt_referencia_p;

if (coalesce(dt_referencia_p::text, '') = '') then
	select	max(dt_valor)
	into STRICT	dt_valor_w
	from	pat_valor_bem
	where	nr_seq_bem = nr_seq_bem_p;

	dt_referencia_w	:= dt_valor_w;
end if;

select	coalesce(sum(vl_deprec_acum),0),
	coalesce(sum(vl_deprec_mes),0),
	coalesce(sum(vl_base_deprec),0),
	coalesce(sum(vl_baixa_deprec),0)
into STRICT	vl_deprec_acum_w,
	vl_deprec_mes_w,
	vl_base_deprec_w,
	vl_baixa_deprec_w
from	pat_valor_bem
where	coalesce(nr_seq_bem_p,nr_seq_bem) = nr_seq_bem
and	coalesce(cd_conta_contabil_p,cd_conta_contabil) = cd_conta_contabil
and	dt_valor between  trunc(dt_referencia_w,'month') and last_day(trunc(dt_referencia_w)) + 86399/86400;
if (ie_valor_p = 'DA') then
	vl_valor_w	:= vl_deprec_acum_w;
elsif (ie_valor_p = 'DM') then
	vl_valor_w	:= vl_deprec_mes_w;
elsif (ie_valor_p = 'BD') then
	vl_valor_w	:= vl_base_deprec_w;
elsif (ie_valor_p = 'BDP') then
	vl_valor_w	:= vl_baixa_deprec_w;
end if;

RETURN	vl_valor_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pat_obter_valor_depreciacao ( dt_referencia_p timestamp, cd_conta_contabil_p text, nr_seq_bem_p bigint, ie_valor_p text) FROM PUBLIC;
