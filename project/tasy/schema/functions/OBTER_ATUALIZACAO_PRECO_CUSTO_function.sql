-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atualizacao_preco_custo ( nr_interno_conta_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, vl_custo_p bigint) RETURNS varchar AS $body$
DECLARE

 
cd_estabelecimento_w			smallint;
cd_tabela_custo_w			integer;
dt_mesano_referencia_w			timestamp;	
ie_atualizado_w				varchar(1) := 'S';
vl_custo_w				double precision;		

BEGIN 
 
if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then 
	 
	select 	max(cd_estabelecimento), 
		max(trunc(dt_mesano_referencia,'mm')) 
	into STRICT	cd_estabelecimento_w, 
		dt_mesano_referencia_w 
	from 	conta_paciente 
	where 	nr_interno_conta = nr_interno_conta_p;
 
	select	max(CASE WHEN ie_mes_calculo='C' THEN cd_tabela_venda  ELSE 0 END ) 
	into STRICT	cd_tabela_custo_w 
	from	parametro_custo 
	where	cd_estabelecimento	= cd_estabelecimento_w;
 
	if (coalesce(cd_tabela_custo_w,0) = 0)	 then 
		select	coalesce(max(cd_tabela_custo),0) 
		into STRICT	cd_tabela_custo_w 
		from	tabela_custo 
		where	cd_tipo_tabela_custo	= 9 
		and	cd_estabelecimento	= cd_estabelecimento_w 
		and	dt_mes_referencia	= dt_mesano_referencia_w;
	end if;
 
	select	coalesce(max(vl_preco_calculado),0) 
	into STRICT	vl_custo_w 
	from	preco_padrao_proc_v 
	where	cd_estabelecimento	= cd_estabelecimento_w 
	and	cd_tabela_custo		= cd_tabela_custo_w 
	and	ie_origem_proced	= ie_origem_proced_p 
	and	cd_procedimento		= cd_procedimento_p 
	and	coalesce(ie_calcula_conta,'S')	= 'S';
 
	ie_atualizado_w		:= 'S';
	if (round((coalesce(vl_custo_p,0))::numeric,2) <> round((vl_custo_w)::numeric,2)) then 
		ie_atualizado_w	:= 'N';
	end if;
end if;
return	ie_atualizado_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atualizacao_preco_custo ( nr_interno_conta_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, vl_custo_p bigint) FROM PUBLIC;

