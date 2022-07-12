-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valores_tit_pagar_data (nr_titulo_p bigint, dt_referencia_inicial_p timestamp, dt_referencia_final_p timestamp, ie_opcao_p text, nr_seq_tf_baixa_p text default null, cd_conta_contabil_p text default null, nr_seq_conta_banco_p text default null, cd_tipo_baixa_cpa_p text default null, nr_seq_classe_p text default null, cd_centro_custo_p text default null) RETURNS bigint AS $body$
DECLARE


/* ie_opcao_p

'P' vl_pago
'B' vl_baixa
'VPSA' valor pago sem abatimento

*/
vl_retorno_w			double precision;
vl_pago_w			double precision;
vl_baixa_w			double precision;
vl_abatimento_w			double precision;


BEGIN
begin

select	sum(coalesce(a.vl_pago,0)),
	sum(coalesce(a.vl_baixa,0)),
	sum(CASE WHEN b.ie_tipo_consistencia=3 THEN coalesce(a.vl_pago,0)  ELSE 0 END )
into STRICT	vl_pago_w,
	vl_baixa_w,
	vl_abatimento_w
FROM titulo_pagar_baixa a
LEFT OUTER JOIN tipo_baixa_cpa b ON (a.cd_tipo_baixa = b.cd_tipo_baixa)
WHERE a.nr_titulo		= nr_titulo_p and a.dt_baixa between dt_referencia_inicial_p and dt_referencia_final_p and (a.nr_seq_trans_fin = nr_seq_tf_baixa_p or coalesce(nr_seq_tf_baixa_p::text, '') = '') and (a.cd_conta_contabil = cd_conta_contabil_p or coalesce(cd_conta_contabil_p::text, '') = '') and (a.nr_seq_conta_banco = nr_seq_conta_banco_p or coalesce(nr_seq_conta_banco_p::text, '') = '') and (a.cd_tipo_baixa = cd_tipo_baixa_cpa_p or coalesce(cd_tipo_baixa_cpa_p::text, '') = '') and (a.nr_seq_classif = nr_seq_classe_p or coalesce(nr_seq_classe_p::text, '') = '') and (a.cd_centro_custo = cd_centro_custo_p or coalesce(cd_centro_custo_p::text, '') = '');
exception
	when others then
		vl_pago_w		:= 0;
		vl_baixa_w		:= 0;
end;

vl_retorno_w		:= 0;
if (ie_opcao_p = 'P') then
	vl_retorno_w		:= vl_pago_w;
elsif (ie_opcao_p = 'B') then
	vl_retorno_w		:= vl_baixa_w;
elsif (ie_opcao_p = 'VPSA') then
	vl_retorno_w		:= coalesce(vl_pago_w,0) - coalesce(vl_abatimento_w,0);
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_tit_pagar_data (nr_titulo_p bigint, dt_referencia_inicial_p timestamp, dt_referencia_final_p timestamp, ie_opcao_p text, nr_seq_tf_baixa_p text default null, cd_conta_contabil_p text default null, nr_seq_conta_banco_p text default null, cd_tipo_baixa_cpa_p text default null, nr_seq_classe_p text default null, cd_centro_custo_p text default null) FROM PUBLIC;

