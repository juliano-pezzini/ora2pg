-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ccih_obt_calc_obito_de_ih (dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
qt_total_obito_mes_w	bigint;
qt_total_obito_ih_w	bigint;
vl_taxa_obito_ih_w	double precision;

BEGIN
if (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') and (dt_final_p IS NOT NULL AND dt_final_p::text <> '') then 
	--Total de Óbitos no Mês 
	select	sum(x.nr_obitos) 
	into STRICT	qt_total_obito_mes_w 
	from	eis_ocupacao_setor_v x 
	where	x.ie_periodo = 'M' 
	and	x.dt_referencia between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400 
	and	((x.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = '0'));
	 
	 
	--Total de Óbitos no Mês por IH 
	if (cd_estabelecimento_p = 1) then 
		select	count(*) 
		into STRICT	qt_total_obito_ih_w 
		from	cih_ficha_ocorrencia a, 
			cih_local_infeccao x 
		where	x.cd_caso_infeccao 	= 1 
		and	a.cd_tipo_evolucao	= 2 
		and	x.cd_tipo_evolucao	= 2 
		and	x.nr_ficha_ocorrencia	= a.nr_ficha_ocorrencia	 
		and	x.dt_infeccao between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400;
	else 
		select	count(*) 
		into STRICT	qt_total_obito_ih_w 
		from	atendimento_paciente b, 
			cih_ficha_ocorrencia a, 
			cih_local_infeccao x 
		where	1 = 1 
		and	a.nr_atendimento	= b.nr_atendimento 
		and	x.nr_ficha_ocorrencia	= a.nr_ficha_ocorrencia 
		and	b.cd_estabelecimento	= cd_estabelecimento_p 
		and	x.cd_tipo_evolucao	= 2 
		and	x.dt_infeccao between trunc(dt_inicial_p) and trunc(dt_final_p)+86399/86400;
	end if;
	 
	vl_taxa_obito_ih_w	:=	(qt_total_obito_ih_w / qt_total_obito_mes_w)*100;
end if;
 
return	vl_taxa_obito_ih_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ccih_obt_calc_obito_de_ih (dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;

