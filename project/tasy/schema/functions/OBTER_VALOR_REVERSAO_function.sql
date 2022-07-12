-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_reversao (cd_setor_atendimento_p bigint, cd_convenio_p bigint, cd_centro_custo_p bigint, cd_conta_contabil_p text, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_retorno_w	double precision	:= 0;


BEGIN

if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') and (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') and (cd_centro_custo_p IS NOT NULL AND cd_centro_custo_p::text <> '') and (cd_conta_contabil_p IS NOT NULL AND cd_conta_contabil_p::text <> '') and (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') then
	select	sum(coalesce(a.vl_total_receita,0))
	into STRICT	vl_retorno_w
	from	setor_atendimento b,
		pre_faturamento_faturamento_v a
	where	b.cd_setor_atendimento		= a.cd_setor_atendimento
	and	coalesce(a.cd_setor_atendimento,0)	= cd_setor_atendimento_p
	and	coalesce(a.cd_convenio,0) 		= cd_convenio_p
	and	coalesce(b.cd_centro_custo,0)		= cd_centro_custo_p
	and	coalesce(a.cd_conta_contabil,'0')	= cd_conta_contabil_p
	and	dt_referencia				= dt_referencia_p;
end if;

return	vl_retorno_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_reversao (cd_setor_atendimento_p bigint, cd_convenio_p bigint, cd_centro_custo_p bigint, cd_conta_contabil_p text, dt_referencia_p timestamp) FROM PUBLIC;
