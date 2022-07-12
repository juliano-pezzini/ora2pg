-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_cartao_cr (nr_seq_movto_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_liquido_w		double precision;
vl_baixas_w		double precision;
vl_saldo_w		double precision;
dt_referencia_w		timestamp;
dt_transacao_w		timestamp;
dt_cancelamento_w	timestamp;
ie_zerar_canc_cartao_cr_w	varchar(1);
cd_estabelecimento_w	smallint;


BEGIN

if (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') then
	dt_referencia_w	:= trunc(dt_referencia_p,'dd') + 86399/86400;
end if;

select	coalesce(max(obter_vl_liquido_cartao(nr_sequencia)),0),
	coalesce(max(dt_transacao),dt_referencia_w),
	max(dt_cancelamento),
	max(cd_estabelecimento)
into STRICT	vl_liquido_w,
	dt_transacao_w,
	dt_cancelamento_w,
	cd_estabelecimento_w
from	movto_cartao_cr
where	nr_sequencia	= nr_seq_movto_p;

if (coalesce(dt_referencia_p::text, '') = '') then
	select	coalesce(sum(vl_baixa),0) + coalesce(sum(vl_desp_equip),0)
	into STRICT	vl_baixas_w
	from	movto_cartao_cr_baixa
	where	nr_seq_movto		= nr_seq_movto_p;
else
	select	coalesce(sum(vl_baixa),0) + coalesce(sum(vl_desp_equip),0)
	into STRICT	vl_baixas_w
	from	movto_cartao_cr_baixa
	where	nr_seq_movto		= nr_seq_movto_p
	and	dt_baixa			<= fim_dia(dt_referencia_w);
end if;

select	max(a.ie_zerar_canc_cartao_cr)
into STRICT	ie_zerar_canc_cartao_cr_w
from	parametro_contas_receber a
where	a.cd_estabelecimento	= cd_estabelecimento_w;

if (coalesce(dt_transacao_w,dt_referencia_w) > dt_referencia_w) or ((ie_zerar_canc_cartao_cr_w in ('S','A')) and (dt_cancelamento_w <= coalesce(dt_referencia_w,clock_timestamp()))) then
	vl_saldo_w	:= 0;
else
	vl_saldo_w	:= vl_liquido_w - vl_baixas_w;
end if;

return	coalesce(vl_saldo_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_cartao_cr (nr_seq_movto_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

