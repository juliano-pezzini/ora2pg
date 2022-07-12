-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valores_tit_pagar (nr_titulo_p bigint, dt_referencia_p timestamp, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/* ie_opcao_p

'D' vl_descontos
'OD' vl_outras_deducoes
'J' vl_juros
'M' vl_multa
'OA' vl_outros_acrescimos
'P' vl_pago
'B' vl_baixa
'JM' vl_juros + vl_multa
'VO' valor original
'VT' valor tributos
'VOT' valor original + alteracao de valor + tributos
'VA' valor abatimento
'VPSA' valor pago sem abatimento
'GP' Glosa principal
'GA' Glosa auxiliar
'VG' Valor da glosa
*/
vl_retorno_w			double precision;
vl_descontos_w			double precision;
vl_outras_deducoes_w		double precision;
vl_juros_w			double precision;
vl_multa_w			double precision;
vl_outros_acrescimos_w		double precision;
vl_pago_w			double precision;
vl_baixa_w			double precision;
vl_original_w			double precision;
vl_imposto_w			double precision;
vl_alteracao_w			double precision;
ie_trib_atualiza_saldo_w	varchar(1);
ie_trib_saldo_tit_nf_w	varchar(1);
vl_abatimento_w			double precision;
vl_glosa_ap_w			double precision;
vl_glosa_w			double precision;
vl_desconto_w			double precision;
vl_glosa_tit_w			double precision;


BEGIN
select 	max(vl_titulo)
into STRICT	vl_original_w
from	titulo_pagar
where	nr_titulo	= nr_titulo_p
and	trunc(dt_emissao,'dd')	<= coalesce(dt_referencia_p, dt_emissao);

begin
select	sum(coalesce(a.vl_descontos,0)),
	sum(coalesce(a.vl_outras_deducoes,0)),
	sum(coalesce(a.vl_juros,0)),
	sum(coalesce(a.vl_multa,0)),
	sum(coalesce(a.vl_outros_acrescimos,0)),
	sum(coalesce(a.vl_pago,0)),
	sum(coalesce(a.vl_baixa,0)),
	sum(CASE WHEN b.ie_tipo_consistencia=3 THEN coalesce(a.vl_pago,0)  ELSE 0 END )
into STRICT	vl_descontos_w,
	vl_outras_deducoes_w,
	vl_juros_w,
	vl_multa_w,
	vl_outros_acrescimos_w,
	vl_pago_w,
	vl_baixa_w,
	vl_abatimento_w
FROM titulo_pagar_baixa a
LEFT OUTER JOIN tipo_baixa_cpa b ON (a.cd_tipo_baixa = b.cd_tipo_baixa)
WHERE a.nr_titulo		= nr_titulo_p and trunc(a.dt_baixa,'dd')	<= coalesce(dt_referencia_p, a.dt_baixa);
exception
	when others then
		vl_descontos_w		:= 0;
		vl_outras_deducoes_w	:= 0;
		vl_juros_w		:= 0;
		vl_multa_w		:= 0;
		vl_outros_acrescimos_w	:= 0;
		vl_pago_w		:= 0;
		vl_baixa_w		:= 0;
end;

select	coalesce(sum(a.vl_glosa_ato_coop_princ),0) vl_glosa_ap,
	coalesce(sum(a.vl_glosa_ato_coop_aux),0) vl_glosa,
	coalesce(sum(a.vl_glosa),0)
into STRICT	vl_glosa_ap_w,
	vl_glosa_w,
	vl_glosa_tit_w
from	titulo_pagar_baixa a
where	nr_titulo = nr_titulo_p;

select	coalesce(max(b.ie_trib_atualiza_saldo),'S'),
	coalesce(max(b.ie_trib_saldo_tit_nf),'N')
into STRICT	ie_trib_atualiza_saldo_w,
	ie_trib_saldo_tit_nf_w
from	parametros_contas_pagar b,
	titulo_pagar a
where	a.nr_titulo		= nr_titulo_p
and	a.cd_estabelecimento	= b.cd_estabelecimento;

begin
select	coalesce(sum(b.vl_imposto), 0)
into STRICT	vl_imposto_w
from	titulo_pagar_imposto b,
	titulo_pagar a
where	b.nr_titulo			= nr_titulo_p
and	a.nr_titulo			= b.nr_titulo
and	b.ie_pago_prev		= 'V'
and (coalesce(a.nr_seq_nota_fiscal::text, '') = '' or
	not exists (SELECT	1
	from	nota_fiscal_trib x
	where	x.cd_tributo	= b.cd_tributo
	and	x.nr_sequencia	= a.nr_seq_nota_fiscal))
and	coalesce(a.nr_repasse_terceiro::text, '') = ''
and	IE_TRIB_ATUALIZA_SALDO_w	= 'S'
and (ie_trib_saldo_tit_nf_w = 'N' and coalesce(b.nr_seq_baixa::text, '') = '');
exception
	when others then
	vl_imposto_w	:= 0;
end;

vl_retorno_w		:= 0;
if (ie_opcao_p = 'D') then
	vl_retorno_w		:= vl_descontos_w;
elsif (ie_opcao_p = 'OD') then
	vl_retorno_w		:= vl_outras_deducoes_w;
elsif (ie_opcao_p = 'J') then
	vl_retorno_w		:= vl_juros_w;
elsif (ie_opcao_p = 'M') then
	vl_retorno_w		:= vl_multa_w;
elsif (ie_opcao_p = 'OA') then
	vl_retorno_w		:= vl_outros_acrescimos_w;
elsif (ie_opcao_p = 'P') then
	vl_retorno_w		:= vl_pago_w;
elsif (ie_opcao_p = 'B') then
	vl_retorno_w		:= vl_baixa_w;
elsif (ie_opcao_p = 'JM') then
	vl_retorno_w		:= vl_juros_w + vl_multa_w;
elsif (ie_opcao_p = 'VO') then
	vl_retorno_w		:= vl_original_w;
elsif (ie_opcao_p = 'VT') then
	vl_retorno_w		:= vl_imposto_w;
elsif (ie_opcao_p = 'VOT') then
	select 	max(vl_titulo)
	into STRICT	vl_original_w
	from	titulo_pagar
	where	nr_titulo	= nr_titulo_p;

	select	coalesce(sum(vl_anterior - vl_alteracao),0)
	into STRICT	vl_alteracao_w
	from	titulo_pagar_alt_valor
	where	nr_titulo	= nr_titulo_p
	and	dt_alteracao	< coalesce(dt_referencia_p, dt_alteracao + 1);

	vl_retorno_w		:= (vl_original_w - vl_alteracao_w) + vl_imposto_w;
elsif (ie_opcao_p = 'VA') then
	vl_retorno_w		:= vl_abatimento_w;
elsif (ie_opcao_p = 'VPSA') then
	vl_retorno_w		:= coalesce(vl_pago_w,0) - coalesce(vl_abatimento_w,0);
elsif (ie_opcao_p = 'GP') then
	vl_retorno_w		:= vl_glosa_ap_w;
elsif (ie_opcao_p = 'GA') then
	vl_retorno_w		:= vl_glosa_w;
elsif (ie_opcao_p = 'VG') then
	vl_retorno_w		:= vl_glosa_tit_w;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_tit_pagar (nr_titulo_p bigint, dt_referencia_p timestamp, ie_opcao_p text) FROM PUBLIC;

