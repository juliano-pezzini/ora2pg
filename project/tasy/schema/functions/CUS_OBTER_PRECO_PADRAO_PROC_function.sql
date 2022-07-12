-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_obter_preco_padrao_proc ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, nr_seq_proc_interno_p bigint) RETURNS bigint AS $body$
DECLARE


cd_estabelecimento_w		smallint	:= cd_estabelecimento_p;
cd_tabela_custo_w			integer;
dt_mesano_referencia_w		timestamp;
ie_atualizado_w			varchar(1) := 'S';
vl_custo_w			double precision;


BEGIN

if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then

	dt_mesano_referencia_w	:= pkg_date_utils.start_of(pkg_date_utils.add_month(dt_referencia_p,-1,0),'MONTH',0);

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
	from	preco_padrao_proc_v2
	where	cd_estabelecimento	= cd_estabelecimento_w
	and	cd_tabela_custo		= cd_tabela_custo_w
	and	nr_seq_proc_interno	= nr_seq_proc_interno_p
	and	coalesce(ie_calcula_conta,'S')	= 'S';

end if;

return	vl_custo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_obter_preco_padrao_proc ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, nr_seq_proc_interno_p bigint) FROM PUBLIC;

