-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_lib_dia_padrao ( nr_seq_regra_p cpoe_regra_dias_padroes.nr_sequencia%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, ie_tipo_item_p text, cd_setor_atendimento_p setor_atendimento.cd_setor_atendimento%type, cd_convenio_p convenio.cd_convenio%type, cd_material_p material.cd_material%type, nr_seq_proc_interno_p proc_interno.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


qt_retorno_w 		bigint;
scriptQuery_w		varchar(4000);
scriptParam_w		varchar(4000);
cd_grupo_material_w  	grupo_material.cd_grupo_material%type;
cd_subgrupo_material_w	subgrupo_material.cd_subgrupo_material%type;
cd_classe_material_w	classe_material.cd_classe_material%type;
cd_procedimento_w	procedimento.cd_procedimento%type;
ie_origem_proced_w	procedimento.ie_origem_proced%type;
cd_especialidade_w	especialidade_proc.cd_especialidade%type;
cd_area_procedimento_w	area_procedimento.cd_area_procedimento%type;
cd_grupo_proc_w	grupo_proc.cd_grupo_proc%type;
cd_doenca_cid_w		cid_doenca.cd_doenca_cid%type;


BEGIN

select 	count(1)
into STRICT	qt_retorno_w
from 	cpoe_regra_dias_lib
where 	nr_seq_regra_lib = nr_seq_regra_p;

if (qt_retorno_w = 0) then
	return 'S';
end if;

select 	coalesce(obter_cod_diagnostico_atend(nr_atendimento_p),'XPTO')
into STRICT	cd_doenca_cid_w
;

scriptQuery_w := 'select 1 ' ||
	' from 	cpoe_regra_dias_lib ' ||
	' where (nr_seq_regra_lib = :nr_seq_regra_p or nr_seq_regra_lib is null ) ' ||
	' and 	(cd_estabelecimento = :cd_estabelecimento_p or cd_estabelecimento is null ) ' ||
	' and 	(cd_perfil = :cd_perfil_p or cd_perfil is null ) ' ||
	' and 	(ie_tipo_item = :ie_tipo_item_p or ie_tipo_item is null ) ' ||
	' and 	(cd_setor_atendimento = :cd_setor_atendimento_p or cd_setor_atendimento is null ) '  ||
	' and 	(cd_convenio = :cd_convenio_p or cd_convenio is null ) ' ||
	' and 	(cd_doenca_cid = :cd_doenca_cid_w or cd_doenca_cid is null ) ' ||
	' and 	(cd_setor_excecao <> :cd_setor_atendimento_p or cd_setor_excecao is null ) ';

scriptParam_w := 'nr_seq_regra_p='||nr_seq_regra_p||
		 ';cd_estabelecimento_p='||cd_estabelecimento_p||
		 ';cd_perfil_p='||cd_perfil_p||
		 ';ie_tipo_item_p='||ie_tipo_item_p||
		 ';cd_setor_atendimento_p='||cd_setor_atendimento_p||
		 ';cd_convenio_p='||cd_convenio_p||
		 ';cd_doenca_cid_w='||cd_doenca_cid_w||';';

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select 	max(cd_grupo_material),
		max(cd_subgrupo_material),
		max(cd_classe_material)
	into STRICT 	cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w
	from	estrutura_material_v
	where	cd_material = cd_material_p;
	
	scriptQuery_w := scriptQuery_w ||
		' and 	(cd_material = :cd_material_p or cd_material is null ) ' ||
		' and 	(cd_grupo_material = :cd_grupo_material_w or cd_grupo_material is null ) ' ||
		' and 	(cd_subgrupo_material = :cd_subgrupo_material_w or cd_subgrupo_material is null ) ' ||
		' and 	(cd_classe_material = :cd_classe_material_w or cd_classe_material is null )  ';
		
	scriptParam_w := scriptParam_w ||
		 'cd_material_p='||cd_material_p||
		 ';cd_grupo_material_w='||cd_grupo_material_w||
		 ';cd_subgrupo_material_w='||cd_subgrupo_material_w||
		 ';cd_classe_material_w='||cd_classe_material_w||';';
else
	scriptQuery_w := scriptQuery_w ||
		' and    cd_material is null ' ||
		' and    cd_grupo_material is null ' ||
		' and    cd_subgrupo_material is null ' ||
		' and    cd_classe_material is null ';
end if;

if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then

	SELECT * FROM obter_proc_tab_interno(nr_seq_proc_interno_p, 0, nr_atendimento_p, 0, cd_procedimento_w, ie_origem_proced_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	
	select 	max(cd_especialidade),
		max(cd_area_procedimento),
		max(cd_grupo_proc)
	into STRICT	cd_especialidade_w,
		cd_area_procedimento_w,
		cd_grupo_proc_w
	from 	estrutura_procedimento_v
	where	cd_procedimento = cd_procedimento_w;
	
	scriptQuery_w := scriptQuery_w ||
		' and 	(nr_seq_proc_interno = :nr_seq_proc_interno_p or nr_seq_proc_interno is null )  ' ||
		' and 	(cd_procedimento = :cd_procedimento_w or cd_procedimento is null )  ' ||
		' and 	(ie_origem_proced = :ie_origem_proced_w or ie_origem_proced is null ) ' ||
		' and 	(cd_especialidade = :cd_especialidade_w or cd_especialidade is null ) ' ||
		' and 	(cd_area_procedimento = :cd_area_procedimento_w or cd_area_procedimento is null ) ' ||
		' and 	(cd_grupo_proc = :cd_grupo_proc_w or cd_grupo_proc is null ) ';

	scriptParam_w := scriptParam_w ||
		 'nr_seq_proc_interno_p='||nr_seq_proc_interno_p||
		 ';cd_procedimento_w='||cd_procedimento_w||
		 ';ie_origem_proced_w='||ie_origem_proced_w||
		 ';cd_especialidade_w='||cd_especialidade_w||
		 ';cd_area_procedimento_w='||cd_area_procedimento_w||
		 ';cd_grupo_proc_w='||cd_grupo_proc_w||';';
else
	scriptParam_w := scriptParam_w ||
		' and   nr_seq_proc_interno is null ' ||
		' and   cd_procedimento is null ' ||
		' and   ie_origem_proced is null ' ||
		' and   cd_especialidade is null ' ||
		' and   cd_area_procedimento is null ' ||
		' and   cd_grupo_proc is null ';
end if;

qt_retorno_w := obter_valor_dinamico_bv(scriptQuery_w, scriptParam_w, qt_retorno_w);

if (qt_retorno_w > 0) then
	return 'S';
else
	return 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_lib_dia_padrao ( nr_seq_regra_p cpoe_regra_dias_padroes.nr_sequencia%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, ie_tipo_item_p text, cd_setor_atendimento_p setor_atendimento.cd_setor_atendimento%type, cd_convenio_p convenio.cd_convenio%type, cd_material_p material.cd_material%type, nr_seq_proc_interno_p proc_interno.nr_sequencia%type) FROM PUBLIC;
