-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_material_assoc_proc ( nr_atendimento_p bigint, nr_seq_proc_interno_p bigint, nr_seq_procedimento_p bigint, cd_interv_proc_p text, dt_inicio_p timestamp, ie_urgencia_p text, cd_pessoa_fisica_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_mat_insert_p INOUT text ) AS $body$
DECLARE

																				
cd_material_w				material.cd_material%type;
qt_dose_w					prescr_material.qt_dose%type;
ds_observacao_w				prescr_material.ds_observacao%type;
cd_unidade_medida_w			unidade_medida.cd_unidade_medida%type;
cd_intervalo_w				intervalo_prescricao.cd_intervalo%type;
qt_min_intervalo_w			intervalo_prescricao.qt_min_intervalo%type;
ie_via_aplicacao_w			via_aplicacao.ie_via_aplicacao%type;
ie_tipo_atendimento_w		atendimento_Paciente.ie_tipo_atendimento%type;
cd_medico_w					usuario.cd_pessoa_fisica%type;
cd_convenio_w				integer;
nr_ocorrencia_w				double precision;
ie_gerar_associado_w		char(1);
ie_duplicar_w				char(1);
hr_prim_horario_w			char(5);
ds_horarios_w				varchar(4000);
ds_horarios_aux_w			varchar(2000);
nr_sequencia_w				cpoe_material.nr_sequencia%type;
dt_fim_w					timestamp;
qt_peso_w					prescr_medica.qt_peso%type;
ie_separado_adep_w			proc_int_mat_prescr.ie_checar_adep%type;

C01 CURSOR FOR
SELECT	a.cd_material,
	coalesce(a.cd_unidade_medida,b.cd_unidade_medida_consumo),
	coalesce(a.qt_dose,0),
	coalesce(a.cd_intervalo, cd_interv_proc_p),
	a.ds_observacao,
	a.ds_horarios,
	a.ie_via_aplicacao,
	coalesce(a.ie_duplicar,'S'),
	coalesce(a.ie_checar_adep,'N')
FROM	material b,
		proc_int_mat_prescr a
where	b.cd_material = a.cd_material
and	b.ie_tipo_material = 1
and	coalesce(a.ie_situacao,'A')	= 'A'
and	((coalesce(a.cd_convenio_exc::text, '') = '') or (a.cd_convenio_exc <> cd_convenio_w))
and	((coalesce(a.cd_medico::text, '') = '') or (a.cd_medico = cd_medico_w))
and	obter_se_mat_setor(a.nr_sequencia, cd_setor_atendimento_p, cd_convenio_w, ie_tipo_atendimento_w) = 'S'
and	((coalesce(a.ie_tipo_atendimento::text, '') = '') or (a.ie_tipo_atendimento = ie_tipo_atendimento_w))
and	((coalesce(a.cd_convenio::text, '') = '') or (a.cd_convenio = cd_convenio_w))
and	((coalesce(a.cd_setor_atendimento::text, '') = '') or (a.cd_setor_atendimento = cd_setor_atendimento_p))
and	((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = cd_estabelecimento_p))
and	a.nr_seq_proc_interno = nr_seq_proc_interno_p
and coalesce(qt_peso_w,0) between coalesce(a.qt_peso_min,0) and coalesce(a.qt_peso_max,999)
order by coalesce(a.cd_setor_atendimento,999), a.nr_sequencia;
	

BEGIN
	ie_mat_insert_p := 'N';
	ie_tipo_atendimento_w := obter_tipo_atendimento(nr_atendimento_p);
	cd_convenio_w := obter_convenio_atendimento(nr_atendimento_p);
	cd_medico_w := obter_pf_usuario(nm_usuario_p,'C');
	qt_peso_w := obter_sinal_vital(nr_atendimento_p,'PESO');

open C01;
loop
fetch C01 into	
	cd_material_w,
	cd_unidade_medida_w,
	qt_dose_w,
	cd_intervalo_w,
	ds_observacao_w,
	ds_horarios_w,
	ie_via_aplicacao_w,
	ie_duplicar_w,
	ie_separado_adep_w;
EXIT WHEN NOT FOUND; /* apply on C01 */	
	
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
		where	 cd_intervalo = cd_intervalo_w;		
	
		nr_ocorrencia_w	:= 0;	
		
		if (coalesce(ds_horarios_w::text, '') = '') then					
			SELECT * FROM cpoe_calcular_horario_prescr( nr_atendimento_p, cd_intervalo_w, cd_material_w, dt_inicio_p, 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;
			ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;
		end if;

		hr_prim_horario_w	:= to_char(dt_inicio_p,'hh24:mi');
		dt_fim_w		    := (dt_inicio_p + 1) - (1/86400);
		
		
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
						dt_inicio_p,
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
						obter_ocorrencias_horarios_rep(ds_horarios_w),
						ie_separado_adep_w,
						'P');
			
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
-- REVOKE ALL ON PROCEDURE cpoe_gerar_material_assoc_proc ( nr_atendimento_p bigint, nr_seq_proc_interno_p bigint, nr_seq_procedimento_p bigint, cd_interv_proc_p text, dt_inicio_p timestamp, ie_urgencia_p text, cd_pessoa_fisica_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_mat_insert_p INOUT text ) FROM PUBLIC;
