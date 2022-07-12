-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_campo_esp (cd_convenio_p bigint, cd_estabelecimento_p bigint, ds_campo_p text, ds_procedimento_p text, ds_despesa_p text, ds_opm_p text, ie_classif_setor_p text, ie_funcao_medico_p text, ie_sexo_p text, dt_nascimento_p text, ie_tipo_protocolo_p bigint, ie_tipo_guia_atend_p text, ds_local_atend_p text, ie_guia_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_setor_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_cgc_prestador_p text, ie_resp_credito_p text, cd_medico_executor_p text, nr_interno_conta_p bigint, nr_prescricao_p text, ds_lado_proc_p text, cd_proc_convenio_p text, cd_desp_convenio_p text, qt_proc_guia_p bigint default null, cd_material_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_anterior_w		varchar(255);
ds_campo_novo_w		varchar(255);
ds_posterior_w		varchar(255);
nr_sequencia_w		varchar(255);
ds_valor_novo_w		varchar(255);
ds_retorno_w		varchar(4000);
vl_padrao_w		varchar(255);
vl_origem_campo_w	varchar(255);
cd_grupo_proc_w		bigint;
cd_especialidade_w	bigint;
cd_area_procedimento_w	bigint;
nm_medico_w		varchar(255);
cd_crm_w		varchar(255);
ds_especialidade_w	varchar(255);
cd_proc_convenio_w	varchar(255);
qt_regra_w		bigint;
dt_entrada_w		timestamp;
dt_alta_w		timestamp;
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w	timestamp;

cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;

cd_cid_w		tiss_conta_guia.cd_cid%type;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	tiss_regra_campo_esp a
where	a.ds_campo		= ds_campo_p
and	a.cd_convenio		= cd_convenio_p
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	((a.ie_tipo_guia		= ie_tipo_guia_atend_p) or (coalesce(a.ie_tipo_guia::text, '') = ''))
and	((a.ie_guia		= 'T') or (a.ie_guia		= ie_guia_p))
and	((a.ie_origem_proced	= ie_origem_proced_p) or (coalesce(a.ie_origem_proced::text, '') = ''))
and	coalesce(a.cd_procedimento, coalesce(cd_procedimento_p,0))		= coalesce(cd_procedimento_p,0)
and	coalesce(a.cd_area_procedimento, coalesce(cd_area_procedimento_w,0))	= coalesce(cd_area_procedimento_w,0)
and	coalesce(a.cd_especialidade, coalesce(cd_especialidade_w,0))		= coalesce(cd_especialidade_w,0)
and	coalesce(a.cd_grupo_proc, coalesce(cd_grupo_proc_w,0))			= coalesce(cd_grupo_proc_w,0)
and	coalesce(a.ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p,0))	= coalesce(ie_tipo_atendimento_p,0)
and	coalesce(a.cd_cgc_prestador, coalesce(cd_cgc_prestador_p, 'X'))		= coalesce(cd_cgc_prestador_p, 'X')
and	coalesce(a.ie_responsavel_credito, coalesce(ie_resp_credito_p, 'X'))	= coalesce(ie_resp_credito_p, 'X')
and	coalesce(a.cd_medico_executor, coalesce(cd_medico_executor_p, 'X'))	= coalesce(cd_medico_executor_p, 'X')
and	coalesce(a.cd_grupo_material, coalesce(cd_grupo_material_w,0))		= coalesce(cd_grupo_material_w,0)
and	coalesce(a.cd_subgrupo_material, coalesce(cd_subgrupo_material_w,0))	= coalesce(cd_subgrupo_material_w,0)
and	coalesce(a.cd_classe_material, coalesce(cd_classe_material_w,0))		= coalesce(cd_classe_material_w,0)
and	coalesce(a.cd_material, coalesce(cd_material_p,0))			= coalesce(cd_material_p,0)
and	coalesce(a.ie_situacao,'A') 	= 'A'
and coalesce(a.cd_setor_atendimento, coalesce(cd_setor_atendimento_p,0)) = coalesce(cd_setor_atendimento_p,0)
order 	by coalesce(a.cd_procedimento, 0),
	coalesce(a.cd_grupo_proc, 0),
	coalesce(a.cd_especialidade, 0),
	coalesce(a.cd_area_procedimento, 0),
	coalesce(a.cd_material, 0),
	coalesce(a.cd_grupo_material, 0),
	coalesce(a.cd_subgrupo_material, 0),
	coalesce(a.cd_classe_material, 0),	
	coalesce(a.cd_setor_atendimento,0),
	coalesce(a.ie_tipo_atendimento,0),
	coalesce(ie_responsavel_credito, 'X'),
	coalesce(a.cd_cgc_prestador,0),
	coalesce(a.cd_medico_executor, 'X'),
	coalesce(a.ie_tipo_guia,'A');

c02 CURSOR FOR
SELECT	b.ds_anterior,
	b.ds_campo,
	b.ds_posterior,
	b.vl_padrao
from	tiss_campo_esp_compl b
where	b.nr_seq_regra		= nr_sequencia_w
order by coalesce(b.nr_seq_apresentacao, b.nr_sequencia);


BEGIN

ds_retorno_w		:= '';
cd_proc_convenio_w	:= cd_proc_convenio_p;

if (coalesce(cd_proc_convenio_p,'XYZ') = 'XYZ') then
	cd_proc_convenio_w	:= to_char(cd_procedimento_p);
end if;

begin
select	1
into STRICT	qt_regra_w
from	tiss_regra_campo_esp a
where	a.ds_campo		= ds_campo_p
and	a.cd_convenio		= cd_convenio_p
and	a.cd_estabelecimento	= cd_estabelecimento_p  LIMIT 1;
exception
when others then
	qt_regra_w	:= 0;
end;

if (qt_regra_w > 0) then

	begin
	select	cd_grupo_proc,
		cd_especialidade,
		cd_area_procedimento
	into STRICT	cd_grupo_proc_w,
		cd_especialidade_w,
		cd_area_procedimento_w
	from	estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p  LIMIT 1;
	exception
	when others then
		cd_grupo_proc_w		:= null;
		cd_especialidade_w	:= null;
		cd_area_procedimento_w	:= null;
	end;
	
	if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	
		begin
			select	cd_grupo_material,
				cd_subgrupo_material,
				cd_classe_material
			into STRICT	cd_grupo_material_w,
				cd_subgrupo_material_w,
				cd_classe_material_w
			from	estrutura_material_v
			where	cd_material	= cd_material_p  LIMIT 1;		
		exception
		when others then
			cd_grupo_material_w	:= null;
			cd_subgrupo_material_w	:= null;
			cd_classe_material_w	:= null;
		end;
	
	end if;

	select	max(substr(obter_nome_pf_pj(cd_medico_executor_p,null),1,255)),
		max(substr(obter_dados_medico(cd_medico_executor_p,'CRM'),1,255)),
		max(substr(obter_especialidade_medico(cd_medico_executor_p,'D'),1,255))
	into STRICT	nm_medico_w,
		cd_crm_w,
		ds_especialidade_w
	;

	begin
	select	a.dt_entrada,
		a.dt_alta,
		b.dt_periodo_inicial,
		b.dt_periodo_final
	into STRICT	dt_entrada_w,
		dt_alta_w,
		dt_periodo_inicial_w,
		dt_periodo_final_w
	from	atendimento_paciente a,
		conta_paciente b
	where	a.nr_atendimento	= b.nr_atendimento
	and	b.nr_interno_conta	= nr_interno_conta_p;
	exception
	when others then
		null;
	end;
	
	begin
	select	cd_cid
	into STRICT	cd_cid_w
	from	tiss_conta_guia
	where	nr_interno_conta	= nr_interno_conta_p
	and	(cd_cid IS NOT NULL AND cd_cid::text <> '')  LIMIT 1;
	exception
	when others then
		cd_cid_w := null;
	end;
	
	begin
	open c01;
	loop
	fetch c01 into
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		ds_retorno_w	:= '';

		open c02;
		loop
		fetch c02 into
			ds_anterior_w,
			ds_campo_novo_w,
			ds_posterior_w,
			vl_padrao_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

			if (vl_padrao_w IS NOT NULL AND vl_padrao_w::text <> '') then
				ds_valor_novo_w		:= vl_padrao_w;
			else

				select	CASE WHEN ds_campo_novo_w='IE_CLASSIF_SET' THEN								ie_classif_setor_p WHEN ds_campo_novo_w='IE_FUNCAO_MED' THEN 								ie_funcao_medico_p WHEN ds_campo_novo_w='DS_DESPESA' THEN 								ds_despesa_p WHEN ds_campo_novo_w='DS_OPM' THEN 								ds_opm_p WHEN ds_campo_novo_w='DS_PROCEDIMENTO' THEN 								ds_procedimento_p WHEN ds_campo_novo_w='IE_SEXO' THEN 								ie_sexo_p WHEN ds_campo_novo_w='DT_NASCIMENTO' THEN 								dt_nascimento_p WHEN ds_campo_novo_w='TP_LOCAL' THEN 								ie_tipo_protocolo_p WHEN ds_campo_novo_w='TP_NOTA' THEN 								ie_tipo_guia_atend_p WHEN ds_campo_novo_w='IE_FUNCAO_TISS' THEN 								ie_funcao_medico_p WHEN ds_campo_novo_w='IE_LOC_ATEND' THEN 								ds_local_atend_p WHEN ds_campo_novo_w='CD_SETOR' THEN 								cd_setor_atendimento_p WHEN ds_campo_novo_w='TP_ATEND' THEN 								ie_tipo_atendimento_p WHEN ds_campo_novo_w='NM_MEDICO' THEN 								nm_medico_w WHEN ds_campo_novo_w='CD_CRM' THEN 								cd_crm_w WHEN ds_campo_novo_w='CD_ESPEC_MED' THEN 								ds_especialidade_w WHEN ds_campo_novo_w='DT_INTERNACAO' THEN 								to_char(dt_entrada_w,'dd/mm/yyyy') WHEN ds_campo_novo_w='DT_ALTA' THEN 								to_char(dt_alta_w,'dd/mm/yyyy') WHEN ds_campo_novo_w='DT_INICAL_CONTA' THEN 								to_char(dt_periodo_inicial_w,'dd/mm/yyyy') WHEN ds_campo_novo_w='DT_FINAL_CONTA' THEN 								to_char(dt_periodo_final_w,'dd/mm/yyyy') WHEN ds_campo_novo_w='NR_PRESCRICAO' THEN 								nr_prescricao_p WHEN ds_campo_novo_w='DS_LADO_PROC' THEN 								ds_lado_proc_p WHEN ds_campo_novo_w='CD_PROCED_CONV' THEN 								cd_proc_convenio_w WHEN ds_campo_novo_w='CD_DESP_CONV' THEN 								cd_desp_convenio_p WHEN ds_campo_novo_w='QT_PROC_GUIA' THEN 									to_char(qt_proc_guia_p) WHEN ds_campo_novo_w='CD_CID' THEN 								cd_cid_w END 
				into STRICT	vl_origem_campo_w
				;

				select	coalesce(max(a.vl_conversao), vl_origem_campo_w)
				into STRICT	ds_valor_novo_w
				from	tiss_campo_esp_conv a
				where	a.nr_seq_regra	= nr_sequencia_w
				and	a.ds_campo	= ds_campo_novo_w
				and	a.vl_origem	= vl_origem_campo_w;

			end if;
			
			--if	(ds_valor_novo_w is not null) then
				ds_retorno_w		:= ds_retorno_w || ds_anterior_w || ds_valor_novo_w || ds_posterior_w;
			--end if;
		end loop;
		close c02;

	end loop;
	close c01;
	exception
	when others then
		null; -- Edgar 14/04/2009, coloquei este tratamento devido ao erro interno do oracle, cfme OS 135036
	end;

	/* Comentado por dsantos, OS148563, no dia 17/06/2009. Por este if estava gerando sempre o ds_proc_tiss_w na tiss_gerar_conta_proc, e como este
	 campo tem prioridade sobre a regra das descri??es do procedimento, estava retornando errado.

	if	(ds_retorno_w is null) then
		ds_retorno_w			:= nvl(ds_procedimento_p, nvl(ds_despesa_p, ds_opm_p));
	end if;
	*/
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_campo_esp (cd_convenio_p bigint, cd_estabelecimento_p bigint, ds_campo_p text, ds_procedimento_p text, ds_despesa_p text, ds_opm_p text, ie_classif_setor_p text, ie_funcao_medico_p text, ie_sexo_p text, dt_nascimento_p text, ie_tipo_protocolo_p bigint, ie_tipo_guia_atend_p text, ds_local_atend_p text, ie_guia_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_setor_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_cgc_prestador_p text, ie_resp_credito_p text, cd_medico_executor_p text, nr_interno_conta_p bigint, nr_prescricao_p text, ds_lado_proc_p text, cd_proc_convenio_p text, cd_desp_convenio_p text, qt_proc_guia_p bigint default null, cd_material_p bigint default null) FROM PUBLIC;

