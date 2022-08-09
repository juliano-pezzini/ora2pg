-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_material_assoc_cont (nr_atendimento_p bigint, nr_seq_proc_interno_p bigint, nr_seq_procedimento_p bigint, nr_seq_contraste_p bigint, cd_intervalo_p text, dt_inicio_p timestamp, ie_urgencia_p text, cd_pessoa_fisica_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_mat_insert_p INOUT text) AS $body$
DECLARE

										
										
cd_material_w				material.cd_material%type;
qt_dose_w			     	prescr_material.qt_dose%type;
cd_unidade_medida_w			unidade_medida.cd_unidade_medida%type;
cd_intervalo_w				intervalo_prescricao.cd_intervalo%type;
qt_min_intervalo_w			intervalo_prescricao.qt_min_intervalo%type;
ie_via_aplicacao_w			via_aplicacao.ie_via_aplicacao%type;
nr_ocorrencia_w				double precision;
ie_duplicar_w				char(1);
hr_prim_horario_w			char(5);
ds_horarios_w				varchar(4000);
ds_horarios_aux_w			varchar(2000);
dt_inicio_w					timestamp;
nr_sequencia_w				cpoe_material.nr_sequencia%type;
dt_fim_w					timestamp;
ie_intervalo_fixo_w			char(1);
ie_checar_adep_w			char(1);
nr_ocorrencia_cpoe_w	    cpoe_procedimento.nr_ocorrencia%type;


C01 CURSOR FOR
	
SELECT	a.cd_material,
		coalesce(a.cd_unidade_medida,m.cd_unidade_medida_consumo),
		coalesce(a.qt_dose,0),
		a.ds_horarios,
		'N',
		coalesce(a.ie_checar_adep,'N'),
		coalesce(a.ie_intervalo_fixo,'N'),
		coalesce(a.cd_intervalo,cd_intervalo_p)
FROM	proc_int_mat_contraste a,
		proc_interno_contraste c,		
		material m
where	c.nr_sequencia = nr_seq_contraste_p
and		a.nr_seq_contraste	= c.nr_sequencia
and		m.ie_tipo_material = 1
and		m.cd_material = a.cd_material
and 	coalesce(c.ie_itens_associados,'N') = 'S';


BEGIN
ie_mat_insert_p := 'N';
delete from cpoe_material
where coalesce(nr_seq_procedimento, nr_seq_proc_edit) = nr_seq_procedimento_p
and ie_tipo_assoc = 'C'
and coalesce(dt_liberacao::text, '') = '';

commit;

open C01;
loop
fetch C01 into	
	cd_material_w,
	cd_unidade_medida_w,
	qt_dose_w,
	ds_horarios_w,
	ie_duplicar_w,
	ie_checar_adep_w,
	ie_intervalo_fixo_w,
	cd_intervalo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */		

	ie_via_aplicacao_w := cpoe_obter_padrao_param_prescr(nr_atendimento_p, cd_material_w, null, 'N', 'V', null, cd_estabelecimento_p, obter_perfil_ativo, nm_usuario_p, cd_pessoa_fisica_p);

	if (ie_duplicar_w = 'N') then
		
		select	coalesce(max('N'),'S')
		into STRICT	ie_duplicar_w
		from	cpoe_material_proced_v where	cd_material = cd_material_w
		and	nr_atendimento = nr_atendimento_p
		and	nr_seq_proced = nr_seq_procedimento_p LIMIT 1;
		
	end if;
	
	if (ie_duplicar_w = 'S') then		

		select	 max(coalesce(qt_min_intervalo,0))
		into STRICT	 qt_min_intervalo_w
		from	 intervalo_prescricao
		where	 cd_intervalo = cd_intervalo_p;		
	
		nr_ocorrencia_w	:= 0;
		
		if (coalesce(ds_horarios_w::text, '') = '') then					
			SELECT * FROM cpoe_calcular_horario_prescr( nr_atendimento_p, cd_intervalo_p, cd_material_w, dt_inicio_p, 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;
			ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;
		end if;

		if (ie_intervalo_fixo_w = 'N') then
			hr_prim_horario_w	:= to_char(dt_inicio_p,'hh24:mi');
		else
			hr_prim_horario_w	:= to_char(clock_timestamp(),'hh24:mi');
		end if;

		dt_fim_w	   	    := (dt_inicio_p + 1) - (1/86400);

		if (ie_checar_adep_w = 'N' and coalesce(cd_intervalo_p::text, '') = '') then
			dt_inicio_w := null;
			dt_fim_w := null;
			ds_horarios_w := null;
			hr_prim_horario_w := null;
			cd_intervalo_w := null;
			nr_ocorrencia_cpoe_w := null;			
		else
			dt_inicio_w	:= dt_inicio_p;
			dt_fim_w := trunc(dt_inicio_p + 1/24,'hh24') - 1/1440;
			nr_ocorrencia_cpoe_w := obter_ocorrencias_horarios_rep(ds_horarios_w);
		end if;
	
		select	nextval('cpoe_material_seq')
		into STRICT	nr_sequencia_w
		;
	
		insert into cpoe_material(
						nr_sequencia,
						nr_atendimento,
						cd_material,
						qt_dose,
						cd_unidade_medida,
						ie_via_aplicacao,
						cd_intervalo,
						hr_prim_horario,
						ds_horarios,
						dt_inicio,
						ie_urgencia,
						ie_duracao,
						ie_administracao,
						dt_fim,
						ie_material,
						nm_usuario,
						nm_usuario_nrec,
						dt_atualizacao,
						dt_atualizacao_nrec,
						cd_perfil_ativo,
						cd_pessoa_fisica,
						nr_seq_proc_edit,
						cd_funcao_origem,
						qt_unitaria,
						nr_ocorrencia,
						ie_separado_adep,
						ie_tipo_assoc)
					values (
						nr_sequencia_w,
						nr_atendimento_p,
						cd_material_w,
						qt_dose_w,
						cd_unidade_medida_w,
						ie_via_aplicacao_w,
						cd_intervalo_w,
						hr_prim_horario_w,
						ds_horarios_w,
						dt_inicio_w,
						ie_urgencia_p,
						'P',
						'P',
						dt_fim_w,
						'S',
						nm_usuario_p,
						nm_usuario_p,
						clock_timestamp(),
						clock_timestamp(),
						cd_perfil_p,
						cd_pessoa_fisica_p,
						nr_seq_procedimento_p,
						2314,
						obter_conversao_unid_med_cons(cd_material_w, cd_unidade_medida_w, qt_dose_w),
						nr_ocorrencia_cpoe_w,
						ie_checar_adep_w,
						'C');
	
		ie_mat_insert_p := 'S';
	end if;

end loop;
close C01;

commit;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_material_assoc_cont (nr_atendimento_p bigint, nr_seq_proc_interno_p bigint, nr_seq_procedimento_p bigint, nr_seq_contraste_p bigint, cd_intervalo_p text, dt_inicio_p timestamp, ie_urgencia_p text, cd_pessoa_fisica_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_mat_insert_p INOUT text) FROM PUBLIC;
