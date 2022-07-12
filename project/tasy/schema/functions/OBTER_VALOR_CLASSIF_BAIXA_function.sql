-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_classif_baixa (cd_estabelecimento_p bigint, nr_titulo_pagar_p bigint, nr_titulo_receber_p bigint, cd_conta_financ_p bigint, vl_baixa_p bigint) RETURNS bigint AS $body$
DECLARE

 
vl_total_classificacao_w	double precision;
vl_titulo_w			double precision;
vl_classificacao_w		double precision;
vl_retorno_w			double precision;

cd_conta_financ_cpa_w		bigint;


BEGIN 
 
if (coalesce(nr_titulo_pagar_p,0) > 0) then 
 
	select	coalesce(sum(a.vl_titulo),0) - coalesce(sum(a.vl_desconto),0) + coalesce(sum(a.vl_acrescimo),0) 
	into STRICT	vl_total_classificacao_w 
	from	titulo_pagar_classif a 
	where	nr_titulo	= nr_titulo_pagar_p;
 
	select	(OBTER_DADOS_TIT_PAGAR(b.nr_titulo, 'V'))::numeric  - 
		sum(coalesce(a.vl_descontos, 0) - coalesce(a.vl_outras_deducoes,0) + coalesce(a.VL_JUROS,0) + coalesce(a.VL_MULTA,0) + coalesce(a.VL_OUTROS_ACRESCIMOS,0)) 
	into STRICT	vl_titulo_w 
	FROM titulo_pagar b
LEFT OUTER JOIN titulo_pagar_baixa a ON (b.nr_titulo = a.nr_titulo 
	group	by (OBTER_DADOS_TIT_PAGAR(b.nr_titulo, 'V'))::numeric)
WHERE b.nr_titulo	= nr_titulo_pagar_p;
 
	select	coalesce(sum(a.vl_titulo),0) - coalesce(sum(a.vl_desconto),0) + coalesce(sum(a.vl_acrescimo),0) 
	into STRICT	vl_classificacao_w 
	from	titulo_pagar_classif a 
	where	nr_titulo		= nr_titulo_pagar_p 
	and	nr_seq_conta_financ	= cd_conta_financ_p;
 
	if (vl_classificacao_w = 0) then 
 
		select	cd_conta_financ_cpa 
		into STRICT	cd_conta_financ_cpa_w 
		from	parametro_fluxo_caixa 
		where	cd_estabelecimento		= cd_estabelecimento_p;
 
		if (cd_conta_financ_cpa_w = cd_conta_financ_p) then 
			vl_classificacao_w		:= vl_titulo_w - vl_total_classificacao_w;
		end if;
 
	end if;
 
	vl_retorno_w		:= dividir_sem_round(vl_classificacao_w, vl_total_classificacao_w) * vl_baixa_p;
 
elsif (coalesce(nr_titulo_receber_p,0) > 0) then 
 
	null;
 
end if;	
 
return vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_classif_baixa (cd_estabelecimento_p bigint, nr_titulo_pagar_p bigint, nr_titulo_receber_p bigint, cd_conta_financ_p bigint, vl_baixa_p bigint) FROM PUBLIC;
