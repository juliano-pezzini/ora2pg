-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_obter_custo_margem_contrib ( cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_material_p bigint, ie_classificacao_p text, dt_vigencia_p timestamp, vl_receita_p bigint, vl_custo_variavel_p bigint, vl_custo_var_mc_p INOUT bigint) AS $body$
DECLARE



cd_area_procedimento_w			bigint	:= 0;
cd_especialidade_w			bigint	:= 0;
cd_grupo_proc_w				bigint	:= 0;
cd_procedimento_w			bigint	:= 0;
ie_origem_proced_w			bigint	:= 0;
cd_setor_atendimento_w			bigint	:= 0;
ie_classificacao_w				varchar(15)	:= ie_classificacao_p;
ie_regra_aloc_w				varchar(15);
pr_aplicar_w				double precision;
dt_vigencia_w				timestamp;

c01 CURSOR FOR
SELECT	a.ie_regra_aloc
from	cus_regra_aloc_custo_mc a
where	a.ie_classificacao					= ie_classificacao_w
and	coalesce(a.cd_setor_atendimento, cd_setor_atendimento_w) 	= cd_setor_atendimento_w
and	coalesce(a.cd_procedimento,cd_procedimento_w)		= cd_procedimento_w
and	coalesce(a.ie_origem_proced,ie_origem_proced_w)		= ie_origem_proced_w
and	coalesce(a.cd_area_procedimento, cd_area_procedimento_w)	= cd_area_procedimento_w
and	coalesce(a.cd_especialidade, cd_especialidade_w)		= cd_especialidade_w
and	coalesce(a.cd_grupo_proc, cd_grupo_proc_w)		= cd_grupo_proc_w
and	dt_vigencia_w between a.dt_inic_vigencia and a.dt_fim_vigencia
order by 	a.dt_inic_vigencia,
		coalesce(cd_procedimento,0),
		coalesce(cd_grupo_proc,0),
		coalesce(cd_especialidade,0),
		coalesce(cd_area_procedimento,0);



BEGIN

cd_procedimento_w	:= coalesce(cd_procedimento_p,0);
ie_origem_proced_w	:= coalesce(ie_origem_proced_p,0);
cd_setor_atendimento_w	:= coalesce(cd_setor_atendimento_p,0);
dt_vigencia_w		:= coalesce(dt_vigencia_p,clock_timestamp());

if (cd_procedimento_w <> 0) then
	select 	cd_area_procedimento,
		cd_especialidade,
		cd_grupo_proc
	into STRICT	cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from 	estrutura_procedimento_v
	where 	cd_procedimento	= cd_procedimento_w
	and 	ie_origem_proced	= ie_origem_proced_w;
end if;

open C01;
loop
fetch C01 into
	ie_regra_aloc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_regra_aloc_w	:= ie_regra_aloc_w;
	end;
end loop;
close C01;

if (ie_regra_aloc_w = 'CV') then
	vl_custo_var_mc_p	:= coalesce(vl_custo_variavel_p,0);
elsif (ie_regra_aloc_w = 'CBPR') then
	vl_custo_var_mc_p	:= dividir( (vl_receita_p * pr_aplicar_w), 100);
end if;

vl_custo_var_mc_p	:= coalesce(vl_custo_var_mc_p,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_obter_custo_margem_contrib ( cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_material_p bigint, ie_classificacao_p text, dt_vigencia_p timestamp, vl_receita_p bigint, vl_custo_variavel_p bigint, vl_custo_var_mc_p INOUT bigint) FROM PUBLIC;

