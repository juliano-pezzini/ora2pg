-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_oculta_dependente_integ ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS varchar AS $body$
DECLARE

			
nr_seq_superior_w	prescr_procedimento.nr_seq_exame%type;
nr_seq_exame_w		prescr_procedimento.nr_seq_exame%type;
ie_oculta_integr_w	exame_lab_dependente.ie_oculta_integr%type;
nr_seq_material_w	material_exame_lab.nr_sequencia%type;
nr_seq_material_princ_w	material_exame_lab.nr_sequencia%type;
cd_setor_atendimento_w	prescr_procedimento.cd_setor_atendimento%type;
cd_setor_prescricao_w	prescr_medica.cd_setor_atendimento%type;
cd_convenio_w		atend_categoria_convenio.cd_convenio%type;
nr_atendimento_w	prescr_medica.nr_atendimento%type;
dt_integracao_w		prescr_procedimento.dt_integracao%type;
cd_motivo_baixa_w	prescr_procedimento.cd_motivo_baixa%type;
cd_estabelecimento_w	prescr_medica.cd_estabelecimento%type;
			

BEGIN
	ie_oculta_integr_w := 'N';
	select	coalesce(max(d.nr_seq_exame), 0),
		coalesce(max(a.nr_seq_exame),0),
		coalesce(max(c.cd_estabelecimento), 0),
		coalesce(max(Obter_Material_Exame_Lab(null, a.cd_material_exame, 1)),0),
		coalesce(max(d.nr_seq_material), 0) nr_seq_material_princ,
		coalesce(max(c.cd_setor_atendimento),0),
		coalesce(max(a.cd_setor_atendimento),0),
		coalesce(max(c.nr_atendimento),0),
		max(a.dt_integracao),
		coalesce(max(a.cd_motivo_baixa),0)
	into STRICT	nr_seq_superior_w,
		nr_seq_exame_w,
		cd_estabelecimento_w,
		nr_seq_material_w,
		nr_seq_material_princ_w,
		cd_setor_prescricao_w,
		cd_setor_atendimento_w,
		nr_atendimento_w,
		dt_integracao_w,
		cd_motivo_baixa_w
	from	prescr_procedimento a,
		prescr_medica c,
		(SELECT	b.nr_seq_exame,
			Obter_Material_Exame_Lab(null, b.cd_material_exame, 1) nr_seq_material,
			b.nr_sequencia,
			b.nr_prescricao
		from	prescr_procedimento b) d
	where	a.nr_prescricao = c.nr_prescricao
	  and 	d.nr_prescricao = a.nr_prescricao
	  and 	d.nr_sequencia = a.nr_seq_superior
	  and	a.nr_prescricao = nr_prescricao_p	
	  and	a.nr_sequencia = nr_seq_prescr_p;
	
	if (nr_seq_superior_w > 0 and (dt_integracao_w IS NOT NULL AND dt_integracao_w::text <> '') and cd_motivo_baixa_w > 0) then
		select	coalesce(max(cd_convenio),0)
		into STRICT	cd_convenio_w
		from	atend_categoria_convenio a
		where	a.nr_atendimento = nr_atendimento_w
		  and 	a.dt_inicio_vigencia =	(SELECT max(dt_inicio_vigencia)
						 from	Atend_categoria_convenio b
						 where	nr_atendimento = nr_atendimento_w);
	
		select	coalesce(max(ie_oculta_integr), 'N')
		into STRICT	ie_oculta_integr_w
		from	exame_lab_dependente
		where	nr_seq_exame = nr_seq_superior_w
		  and	nr_seq_exame_dep = nr_seq_exame_w
		  and	coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
		  and	coalesce(nr_seq_material_regra, nr_seq_material_princ_w) = nr_seq_material_princ_w
		  and 	coalesce(nr_seq_material, nr_seq_material_w) = nr_seq_material_w
		  and	coalesce(cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w
		  and	coalesce(cd_setor_prescricao, cd_setor_prescricao_w) = cd_setor_prescricao_w
		  and	coalesce(cd_convenio, cd_convenio_w) = cd_convenio_w;
	end if;
	return ie_oculta_integr_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_oculta_dependente_integ ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;
