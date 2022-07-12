-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_conv_plano_atend (nr_atendimento_p bigint, nr_seq_procedimento_p bigint, nr_seq_material_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*

ie_opcao_p
'1' - NR_SEQUENCIA da regra selecionada
'2' - IE_REGRA

*/
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_convenio_w			bigint;
cd_area_procedimento_w	regra_Convenio_Plano.cd_area_procedimento%type;
cd_especialidade_w		regra_convenio_plano.cd_especialidade_proc%type;
cd_grupo_proc_w			regra_Convenio_Plano.cd_grupo_proc%type;
ie_tipo_atendimento_w		bigint;
nr_atendimento_w		bigint;
cd_material_w			bigint;
cd_grupo_material_w		bigint;
cd_subgrupo_material_w		bigint;
cd_classe_material_w		bigint;
ds_retorno_w			varchar(254);
cd_tipo_acomodacao_w		bigint;
cd_plano_w			varchar(40);
nr_sequencia_w			bigint;
cd_setor_atendimento_w		bigint;
ie_regra_w			smallint;
ie_tipo_material_w		varchar(3);
ie_classificacao_w		varchar(3);
cd_simpro_w			bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	ie_regra
from (
	SELECT	nr_sequencia,
		ie_regra
	from 	regra_Convenio_Plano
	where	cd_convenio					= cd_convenio_w
	and	coalesce(cd_plano, cd_plano_w)			= cd_plano_w
	and	coalesce(cd_procedimento,cd_procedimento_w) 		= cd_procedimento_w
	and	coalesce(cd_area_procedimento,cd_area_procedimento_w)= cd_area_procedimento_w
	and	coalesce(cd_especialidade_proc,cd_especialidade_w)	= cd_especialidade_w
	and	coalesce(cd_grupo_proc,cd_grupo_proc_w)		= cd_grupo_proc_w
	and	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w)	= ie_tipo_atendimento_w
	and	coalesce(cd_tipo_acomodacao, cd_tipo_acomodacao_w)	= cd_tipo_acomodacao_w
	and	coalesce(cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w
	and	(nr_seq_procedimento_p IS NOT NULL AND nr_seq_procedimento_p::text <> '')
	and	coalesce(ie_situacao,'A') = 'A'
	and (clock_timestamp() between
		coalesce(dt_inicio_vigencia,to_date('01/01/1900','dd/mm/yyyy')) and 
		coalesce(dt_fim_vigencia,to_date('31/12/2099','dd/mm/yyyy')))
	order 	by coalesce(ie_tipo_atendimento,0),
		coalesce(cd_procedimento,0),
		coalesce(ie_origem_proced,ie_origem_proced_w),
		coalesce(cd_grupo_proc,0),
		coalesce(cd_especialidade_proc,0),
		coalesce(cd_area_procedimento,0)) alias22

union all

select	nr_sequencia,
	ie_regra
from (
	select	nr_sequencia,
		ie_regra
	from	regra_Convenio_Plano_mat
	where	cd_convenio					= cd_convenio_w
	and	coalesce(cd_plano, cd_plano_w)			= cd_plano_w
	and	coalesce(cd_material,cd_material_w)			= cd_material_w
	and	coalesce(cd_grupo_material,cd_grupo_material_w)	= cd_grupo_material_w	
	and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w)= cd_subgrupo_material_w
	and	coalesce(cd_classe_material,cd_classe_material_w)	= cd_classe_material_w
	and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w) = ie_tipo_atendimento_w
	and	coalesce(cd_tipo_acomodacao, cd_tipo_acomodacao_w)	= cd_tipo_acomodacao_w
	and	coalesce(cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w
	and	(nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '')
	and 	coalesce(ie_tipo_material, coalesce(ie_tipo_material_w,'0')) = coalesce(ie_tipo_material_w,'0')
	and (clock_timestamp() between 
		coalesce(dt_inicio_vigencia,to_date('01/01/1900','dd/mm/yyyy')) and 
		coalesce(dt_fim_vigencia,to_date('31/12/2099','dd/mm/yyyy')))
	and	coalesce(ie_classificacao, coalesce(ie_classificacao_w, '0'))	=	coalesce(ie_classificacao_w, '0')
	order	by coalesce(ie_tipo_atendimento,0),
		coalesce(cd_material,0),
		coalesce(cd_grupo_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_classe_material,0),
		coalesce(ie_tipo_material,'0')) alias50;


BEGIN

if (nr_seq_procedimento_p IS NOT NULL AND nr_seq_procedimento_p::text <> '') then

	select	a.cd_procedimento,
		a.ie_origem_proced,
		e.cd_area_procedimento,
		e.cd_especialidade,
		e.cd_grupo_proc,
		b.ie_tipo_atendimento,
		a.nr_atendimento,
		a.cd_setor_atendimento
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w,
		ie_tipo_atendimento_w,
		nr_atendimento_w,
		cd_setor_atendimento_w
	from	estrutura_procedimento_v e,
		atendimento_paciente b,
		procedimento_paciente a
	where	a.nr_atendimento	= b.nr_atendimento
	and	a.cd_procedimento	= e.cd_procedimento
	and	a.ie_origem_proced	= e.ie_origem_proced
	and	a.nr_sequencia		= nr_seq_procedimento_p;

elsif (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then

	select	a.cd_material,
		e.cd_grupo_material,
		e.cd_subgrupo_material,
		e.cd_classe_material,
		b.ie_tipo_atendimento,
		a.nr_atendimento,
		a.CD_SETOR_ATENDIMENTO
	into STRICT	cd_material_w,
		cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w,
		ie_tipo_atendimento_w,
		nr_atendimento_w,
		cd_setor_atendimento_w
	from	estrutura_material_v e,
		atendimento_paciente b,
		material_atend_paciente a
	where	a.nr_atendimento	= b.nr_atendimento
	and	a.cd_material		= e.cd_material
	and	a.nr_sequencia		= nr_seq_material_p;

	select 	coalesce(max(ie_tipo_material),'0')
	into STRICT	ie_tipo_material_w
	from 	material	
	where 	cd_material = cd_material_w;

end if;

select	min(a.cd_convenio)
into STRICT	cd_convenio_w
from	convenio a, atend_categoria_convenio b
where	b.nr_atendimento			= nr_atendimento_p
and	a.cd_convenio				= b.cd_convenio
and	a.ie_tipo_convenio			= 2;


select	coalesce(max(a.cd_tipo_acomodacao), 0),
	coalesce(max(a.cd_plano_convenio),0)
into STRICT	cd_tipo_acomodacao_w,
	cd_plano_w
from	convenio b, atend_categoria_convenio a
where	a.nr_atendimento	= nr_atendimento_w
and	a.cd_convenio		= cd_convenio_w
and	a.cd_convenio		= b.cd_convenio
and	b.ie_tipo_convenio	= 2
and	a.dt_inicio_vigencia	=
			(SELECT	max(x.dt_inicio_vigencia)
			from	convenio y, atend_categoria_convenio x
			where	x.nr_atendimento	= a.nr_atendimento
			and	x.cd_convenio		= a.cd_convenio
			and	x.cd_convenio		= y.cd_convenio
			and	y.ie_tipo_convenio	= 2);
			
select	coalesce(max(cd_simpro), 0)
into STRICT	cd_simpro_w
from	material_simpro
where	nr_sequencia	=	nr_seq_material_p;

select	coalesce(max(ie_classificacao), '0')
into STRICT	ie_classificacao_w
from	simpro_preco
where	cd_simpro	=	cd_simpro_w;			

nr_sequencia_w	:= null;
open c01;
loop
fetch c01 into
	nr_sequencia_w,
	ie_regra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	nr_sequencia_w		:= nr_sequencia_w;
end loop;
close c01;

ds_retorno_w		:= null;
if (ie_opcao_p = '1') then
	ds_retorno_w	:= nr_sequencia_w;
elsif (ie_opcao_p = '2') then
	ds_retorno_w	:= ie_regra_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_conv_plano_atend (nr_atendimento_p bigint, nr_seq_procedimento_p bigint, nr_seq_material_p bigint, ie_opcao_p text) FROM PUBLIC;
