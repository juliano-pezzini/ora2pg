-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_rep_gerar_mat_assoc_proc ( nr_seq_procedimento_p bigint, nr_seq_proc_cpoe_p bigint, nr_prescricao_p bigint, nr_atendimento_p bigint, dt_inicio_prescr_p timestamp, nm_usuario_p text default null, cd_perfil_p bigint default null, cd_pessoa_fisica_p cpoe_procedimento.cd_pessoa_fisica%type default null, dt_liberacao_p timestamp default null, cd_funcao_origem_p bigint default null) AS $body$
DECLARE

	
cd_material_w			prescr_material.cd_material%type;
cd_unidade_medida_w		prescr_material.cd_unidade_medida%type;
qt_dose_w				prescr_material.qt_dose%type;
ie_via_aplicacao_w		prescr_material.ie_via_aplicacao%type;
ds_observacao_w			prescr_material.ds_observacao%type;
cd_intervalo_w			prescr_material.cd_intervalo%type;
ds_horarios_w			prescr_material.ds_horarios%type;
ie_se_necessario_w		prescr_material.ie_se_necessario%type;
ie_acm_w				prescr_material.ie_acm%type;
hr_prim_horario_w		prescr_material.hr_prim_horario%type;
ie_urgencia_w			prescr_material.ie_urgencia%type;
ie_checar_adep_w		prescr_material.ie_checar_adep%type;
qt_unitaria_w			prescr_material.qt_unitaria%type;
nr_ocorrencia_w			prescr_material.nr_ocorrencia%type;

nr_seq_diluicao_w		prescr_material.nr_sequencia%type;
cd_material_dil_w		prescr_material.cd_material%type;
qt_dose_dil_w			prescr_material.qt_dose%type;
cd_un_medida_dil_w		prescr_material.cd_unidade_medida%type;
ie_agrupador_dil_w		prescr_material.ie_agrupador%type;

dt_prim_horario_w		cpoe_procedimento.dt_inicio_proc1%type;
ie_administracao_w		cpoe_procedimento.ie_adm_mat1%type;
ie_urgencia_mat_w		cpoe_procedimento.ie_urgencia%type;

nr_sequencia_w			cpoe_material.nr_sequencia%type;

ds_erro_w						varchar(4000);

i						bigint;

ie_tipo_material_w		varchar(15);

c01 CURSOR FOR
SELECT	a.cd_material,
		a.cd_unidade_medida,
		a.qt_dose,
		a.ie_via_aplicacao,
		a.ds_observacao,
		a.cd_intervalo,
		a.ds_horarios,
		coalesce(a.ie_se_necessario,'N'),
		coalesce(a.ie_acm,'N'),
		a.hr_prim_horario,
		coalesce(a.ie_urgencia,'N'),
		coalesce(a.ie_checar_adep,'N'),
		obter_tipo_material(a.cd_material, 'C') ie_tipo_material,
		qt_unitaria,
		nr_ocorrencia,
		a.nr_sequencia
from 	prescr_material a
where	a.nr_prescricao = nr_prescricao_p
and		a.nr_sequencia_proc = nr_seq_procedimento_p
and		a.ie_agrupador = 5
order by
		ie_tipo_material, a.nr_seq_material;
		
c02 CURSOR FOR
SELECT 	a.cd_material,
		a.qt_dose,
		a.cd_unidade_medida,
		a.ie_agrupador
  from 	prescr_material a
 where 	a.nr_prescricao = nr_prescricao_p 
   and 	a.nr_sequencia_diluicao = nr_seq_diluicao_w
   and 	coalesce(a.dt_suspensao::text, '') = ''
   and 	a.ie_agrupador in (3, 9)
 order  by ie_agrupador;
		

BEGIN		

i := 1;
	
open c01;
loop
fetch c01 into	cd_material_w,
				cd_unidade_medida_w,
				qt_dose_w,
				ie_via_aplicacao_w,
				ds_observacao_w,
				cd_intervalo_w,
				ds_horarios_w,
				ie_se_necessario_w,
				ie_acm_w,
				hr_prim_horario_w,
				ie_urgencia_w,
				ie_checar_adep_w,
				ie_tipo_material_w,
				qt_unitaria_w,
				nr_ocorrencia_w,
				nr_seq_diluicao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	ie_urgencia_mat_w := '';
	ie_administracao_w := 'P';
	
	if (ie_urgencia_w = 'S') then
		ie_urgencia_mat_w := '0';
	elsif (ie_acm_w = 'S') then
		ie_administracao_w := 'C';
		ds_horarios_w := '';
		hr_prim_horario_w := '';
	elsif (ie_se_necessario_w = 'S') then
		ie_administracao_w := 'C';
		ds_horarios_w := '';
		hr_prim_horario_w := '';
	end if;
	
	if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
		dt_prim_horario_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_inicio_prescr_p, hr_prim_horario_w);
		if (dt_prim_horario_w < dt_inicio_prescr_p) then
			dt_prim_horario_w := dt_prim_horario_w + 1;
		end if;
	else
		dt_prim_horario_w := dt_inicio_prescr_p;
	end if;

	if (ie_tipo_material_w <> '1') then
		begin
			execute	immediate	' update	cpoe_procedimento ' ||
								' set		cd_mat_proc'||i||' = :1, ' ||
								' 			ie_via_mat_proc'||i||' = :2, ' ||
								' 			qt_dose_mat'||i||' = :3, ' ||
								' 			cd_unid_medida_dose_mat'||i||' = :4, ' ||
								' 			cd_interv_proc'||i||' = :5, ' ||
								' 			ds_hor_proc'||i||' = :6, ' ||
								' 			dt_inicio_proc'||i||' = :7, ' ||
								' 			hr_prim_hor_proc'||i||' = :8, ' ||
								' 			ds_obser_proc'||i||' = :9, ' ||
								' 			ie_urgencia_mat'||i||' = :10, ' ||
								' 			ie_adm_mat'||i||' = :11, ' ||
								' 			ie_assoc_adep'||i||' = :12 ' ||
								' where		nr_sequencia = :13 '
						using	cd_material_w,
								ie_via_aplicacao_w,
								qt_dose_w,
								cd_unidade_medida_w,
								cd_intervalo_w,
								ds_horarios_w,
								dt_prim_horario_w,
								hr_prim_horario_w,
								ds_observacao_w,
								ie_urgencia_mat_w,
								ie_administracao_w,
								ie_checar_adep_w,
								nr_seq_proc_cpoe_p;
			
			open c02;
				loop
					fetch c02 into	
						cd_material_dil_w,
						qt_dose_dil_w,
						cd_un_medida_dil_w,
						ie_agrupador_dil_w;
					EXIT WHEN NOT FOUND; /* apply on c02 */
					begin
											
						if (ie_agrupador_dil_w = 3) then
							CALL exec_sql_dinamico_bv(	'CPOE',
													' update	cpoe_procedimento ' ||
													' set		cd_mat_dil'||i||' = :cd_material_dil_w, ' ||
													'			qt_dose_dil'||i||' = :qt_dose_dil_w, ' ||
													'			cd_unid_medida_dose_dil'||i||' = :cd_un_medida_dil_w ' ||
													' where		nr_sequencia = :nr_seq_procedimento_p ',
													'cd_material_dil_w='||cd_material_dil_w||
													'#@#@qt_dose_dil_w='||qt_dose_dil_w||
													'#@#@cd_un_medida_dil_w='||cd_un_medida_dil_w||
													'#@#@nr_seq_procedimento_p='||nr_seq_proc_cpoe_p||
													'#@#@');
						elsif (ie_agrupador_dil_w = 9) then
							CALL exec_sql_dinamico_bv(	'CPOE',
													' update	cpoe_procedimento ' ||
													' set		cd_mat_recons'||i||' = :cd_material_dil_w, ' ||
													'			qt_dose_recons'||i||' = :qt_dose_dil_w, ' ||
													'			cd_unid_medida_dose_recons'||i||' = :cd_un_medida_dil_w ' ||
													' where		nr_sequencia = :nr_seq_procedimento_p ',
													'cd_material_dil_w='||cd_material_dil_w||
													'#@#@qt_dose_dil_w='||qt_dose_dil_w||
													'#@#@cd_un_medida_dil_w='||cd_un_medida_dil_w||
													'#@#@nr_seq_procedimento_p='||nr_seq_proc_cpoe_p||
													'#@#@');											
						end if;
					end;
				end loop;
			close c02;
			
		exception when others then
			ds_erro_w	:= to_char(sqlerrm);	
			CALL gravar_log_tasy(10007,' cpoe_rep_gerar_mat_assoc_pro ASCOC - ERRO ' || ds_erro_w, nm_usuario_p);
		end;
		
		i := i +1;
		if (i > 7) then
			exit;
		end if;
		
	else
		begin
			
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
							dt_prox_geracao,
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
							nr_seq_procedimento,
							dt_liberacao,
							qt_unitaria,
							cd_funcao_origem,
							nr_ocorrencia)
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
							dt_prim_horario_w,
							dt_prim_horario_w + 12/24,
							ie_urgencia_mat_w,
							'P',
							ie_administracao_w,
							trunc(dt_prim_horario_w + 1/24,'hh24') - 1/1440,
							'S',
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							clock_timestamp(),
							cd_perfil_p,
							cd_pessoa_fisica_p,
							nr_seq_proc_cpoe_p,
							dt_liberacao_p,
							qt_unitaria_w,
							cd_funcao_origem_p,
							nr_ocorrencia_w);
			
		exception when others then
		ds_erro_w	:= to_char(sqlerrm);	
		CALL gravar_log_tasy(10007,' cpoe_rep_gerar_mat_assoc_pro - ERRO ' || ds_erro_w,
						nm_usuario_p);
		end;	
	end if;
	
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_rep_gerar_mat_assoc_proc ( nr_seq_procedimento_p bigint, nr_seq_proc_cpoe_p bigint, nr_prescricao_p bigint, nr_atendimento_p bigint, dt_inicio_prescr_p timestamp, nm_usuario_p text default null, cd_perfil_p bigint default null, cd_pessoa_fisica_p cpoe_procedimento.cd_pessoa_fisica%type default null, dt_liberacao_p timestamp default null, cd_funcao_origem_p bigint default null) FROM PUBLIC;

