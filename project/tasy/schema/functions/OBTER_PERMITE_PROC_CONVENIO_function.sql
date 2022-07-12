-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_permite_proc_convenio (cd_procedimento_p bigint, nr_seq_proc_interno_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE



cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_convenio_w			bigint;
cd_area_procedimento_w		regra_Convenio_Plano.cd_area_procedimento%type;
cd_especialidade_w		regra_Convenio_Plano.cd_especialidade_proc%type;
cd_grupo_proc_w			regra_Convenio_Plano.cd_grupo_proc%type;
ie_tipo_atendimento_w		bigint;
cd_material_w			bigint;
cd_grupo_material_w		bigint;
cd_subgrupo_material_w		bigint;
cd_classe_material_w		bigint;
ds_retorno_w			varchar(1) := 'S';
cd_tipo_acomodacao_w		bigint;
cd_plano_w			varchar(40);
nr_sequencia_w			bigint;
cd_setor_atendimento_w		bigint;
ie_regra_w			smallint;
nr_seq_forma_org_w	bigint := 0;
nr_seq_grupo_w		bigint := 0;
nr_seq_subgrupo_w	bigint := 0;
qt_reg_w		bigint := 0;
qt_regra_w		bigint := 0;
cd_categoria_w		bigint;
/*criar variaveis*/

BEGIN


if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select	max(coalesce(cd_categoria, 0)),
		max(coalesce(cd_convenio, 0)),
		max(coalesce(cd_tipo_acomodacao, 0)),
		max(coalesce(cd_plano_convenio,0))
	into STRICT	cd_categoria_w, 
		cd_convenio_w,
		cd_tipo_acomodacao_w,
		cd_plano_w
	from	atend_categoria_convenio
	where	nr_atendimento = nr_atendimento_p;

	select  count(1)
	into STRICT	qt_reg_w
	from	regra_convenio_plano
	where	cd_convenio = cd_convenio_w
	and 	cd_categoria = cd_categoria_w
	and	((cd_procedimento = cd_procedimento_p)	or (nr_seq_proc_interno = nr_seq_proc_interno_p))
	and     coalesce(ie_checkup,'N') = 'S';
			
	if (qt_reg_w > 0) then
	
		ds_retorno_w := 'N';
	
		select	max(ie_origem_proced)
		into STRICT	ie_origem_proced_w
		from 	procedimento
		where	cd_procedimento = cd_procedimento_p;
			
		select	max(e.cd_area_procedimento),
			max(e.cd_especialidade),
			max(e.cd_grupo_proc),
			max(b.ie_tipo_atendimento)
		into STRICT	cd_area_procedimento_w,
			cd_especialidade_w,
			cd_grupo_proc_w,
			ie_tipo_atendimento_w
		from	estrutura_procedimento_v e,
			atendimento_paciente b
		where	b.nr_atendimento	= nr_atendimento_p
		and	e.cd_procedimento	= cd_procedimento_p
		and	e.ie_origem_proced	= coalesce(ie_origem_proced_w,0);
		
		cd_setor_atendimento_w := Obter_Setor_Atendimento(nr_atendimento_p);
				
		nr_seq_grupo_w		:= coalesce(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_w, 'C', 'G'),'G'),1,10),0);		
		nr_seq_forma_org_w 	:= coalesce(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_w, 'C', 'F'),'F'),1,10),0);
		nr_seq_subgrupo_w 	:= coalesce(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_w, 'C', 'S'),'S'),1,10),0);

		select	count(1)
		into STRICT	qt_regra_w
		from 	regra_Convenio_Plano
		where	cd_convenio					= cd_convenio_w
		and	coalesce(cd_plano, cd_plano_w)			= cd_plano_w
		and	((coalesce(cd_procedimento,cd_procedimento_p) 	= cd_procedimento_p)
		or (coalesce(nr_seq_proc_interno,nr_seq_proc_interno_p) = nr_seq_proc_interno_p))
		and	coalesce(cd_area_procedimento,cd_area_procedimento_w)= cd_area_procedimento_w
		and	coalesce(cd_especialidade_proc,cd_especialidade_w)	= cd_especialidade_w
		and	coalesce(cd_grupo_proc,cd_grupo_proc_w)		= cd_grupo_proc_w
		and	coalesce(nr_seq_forma_org, nr_seq_forma_org_w)	= nr_seq_forma_org_w 	
		and	coalesce(nr_seq_subgrupo, nr_seq_subgrupo_w)		= nr_seq_subgrupo_w
		and	coalesce(nr_seq_grupo, nr_seq_grupo_w)		= nr_seq_grupo_w
		and	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w)	= ie_tipo_atendimento_w
		and	coalesce(cd_tipo_acomodacao, cd_tipo_acomodacao_w)	= cd_tipo_acomodacao_w
		and	coalesce(cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w
		and     coalesce(ie_checkup,'N') = 'S'
		and	coalesce(ie_situacao,'A') = 'A'
		and (clock_timestamp() between
			coalesce(dt_inicio_vigencia,to_date('01/01/1900','dd/mm/yyyy')) and 
			coalesce(dt_fim_vigencia,to_date('31/12/2099','dd/mm/yyyy')))
		and 	coalesce(cd_empresa, coalesce(obter_empresa_estab(wheb_usuario_pck.get_cd_estabelecimento),0)) = coalesce(obter_empresa_estab(wheb_usuario_pck.get_cd_estabelecimento),0);
		
	end if;	

	if (qt_reg_w = 0) or (qt_regra_w > 0) then
		ds_retorno_w := 'S';
	end if;	
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_permite_proc_convenio (cd_procedimento_p bigint, nr_seq_proc_interno_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
