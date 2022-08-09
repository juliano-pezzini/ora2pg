-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_shoppingcart_procedure ((nr_sequencia_p bigint, ie_retrogrado_p text, ds_retorno_p out text) is nr_return_value_w bigint) AS $body$
DECLARE

ds_retorno_w	varchar(1)	:= 'N';
ie_tipo_material_w	material.ie_tipo_material%type;

BEGIN
if ((cd_material_p IS NOT NULL AND cd_material_p::text <> '') and coalesce(ie_assoc_adep_p, 'N') = 'S') then
	if (cpoe_shoppingcart_vigencia(cd_intervalo_p, ie_administracao_p, dt_inicio_p, ie_urgencia_p, ie_duracao_proc_p, dt_fim_proc_p, ie_evento_unico_proc_p, ie_retrogrado_p) = 'S') then
		ds_retorno_w := 'S';
	end if;
end if;

return;
end;

function cpoe_exame_lab_proc(nr_seq_proc_interno_p NUMBER)
				return;

begin

  select max(a.nr_seq_exame_lab)
    into STRICT nr_seq_exame_lab_w
    from proc_interno a,
		     procedimento b
   where a.nr_sequencia = nr_seq_proc_interno_p
     and a.cd_procedimento = b.cd_procedimento;

  if (coalesce(nr_seq_exame_lab_w::text, '') = '') then
     nr_seq_exame_lab_w := 0;
  end if;

  return;

end;


begin
ds_retorno_p := 'S';
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	for r_c01_w in C01
	loop
		nr_atendimento_w := r_c01_w.nr_atendimento;

		--CAMPOS OBRIGATORIOS
		if (coalesce(r_c01_w.nr_seq_proc_interno::text, '') = '' or coalesce(r_c01_w.cd_intervalo::text, '') = '' or coalesce(r_c01_w.dt_inicio::text, '') = ''
			or coalesce(r_c01_w.ie_administracao::text, '') = '' or coalesce(r_c01_w.ie_duracao::text, '') = '') then
			
			ds_log_step_w := 'STEP_1'
				|| ' - dt_inicio: ' || r_c01_w.dt_inicio
				|| ' - nr_seq_proc_interno: ' || r_c01_w.nr_seq_proc_interno
				|| ' - cd_intervalo: ' || r_c01_w.cd_intervalo
				|| ' - ie_administracao: ' || r_c01_w.ie_administracao
				|| ' - ie_duracao: ' || r_c01_w.ie_duracao
				|| ' - LINE: ' || $$plsql_line;
			
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		if (r_c01_w.ie_retrogrado = 'S') then
			ie_retrogrado_w	:= r_c01_w.ie_retrogrado;
		else
			ie_retrogrado_w	:= ie_retrogrado_p;
		end if;

		if (cpoe_shoppingcart_vigencia(r_c01_w.cd_intervalo, r_c01_w.ie_administracao, r_c01_w.dt_inicio,
				r_c01_w.ie_urgencia, r_c01_w.ie_duracao,r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_w) = 'S'
			or cpoe_fora_vigencia_proc_assoc(r_c01_w.cd_mat_proc1, r_c01_w.ie_assoc_adep1, r_c01_w.cd_interv_proc1, r_c01_w.ie_adm_mat1, r_c01_w.dt_inicio_proc1,r_c01_w.ie_urgencia_mat1,
				r_c01_w.cd_intervalo, r_c01_w.ie_administracao, r_c01_w.dt_inicio, r_c01_w.ie_urgencia, r_c01_w.ie_duracao, r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_w) = 'S'
			or cpoe_fora_vigencia_proc_assoc(r_c01_w.cd_mat_proc2, r_c01_w.ie_assoc_adep2, r_c01_w.cd_interv_proc2, r_c01_w.ie_adm_mat2, r_c01_w.dt_inicio_proc2,r_c01_w.ie_urgencia_mat2,
				r_c01_w.cd_intervalo, r_c01_w.ie_administracao, r_c01_w.dt_inicio, r_c01_w.ie_urgencia, r_c01_w.ie_duracao, r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_w) = 'S'
			or cpoe_fora_vigencia_proc_assoc(r_c01_w.cd_mat_proc3, r_c01_w.ie_assoc_adep3, r_c01_w.cd_interv_proc3, r_c01_w.ie_adm_mat3, r_c01_w.dt_inicio_proc3,r_c01_w.ie_urgencia_mat3,
				r_c01_w.cd_intervalo, r_c01_w.ie_administracao, r_c01_w.dt_inicio, r_c01_w.ie_urgencia, r_c01_w.ie_duracao, r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_w) = 'S'
			or cpoe_fora_vigencia_proc_assoc(r_c01_w.cd_mat_proc4, r_c01_w.ie_assoc_adep4, r_c01_w.cd_interv_proc4, r_c01_w.ie_adm_mat4, r_c01_w.dt_inicio_proc4,r_c01_w.ie_urgencia_mat4,
				r_c01_w.cd_intervalo, r_c01_w.ie_administracao, r_c01_w.dt_inicio, r_c01_w.ie_urgencia, r_c01_w.ie_duracao, r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_w) = 'S'
			or cpoe_fora_vigencia_proc_assoc(r_c01_w.cd_mat_proc5, r_c01_w.ie_assoc_adep5, r_c01_w.cd_interv_proc5, r_c01_w.ie_adm_mat5, r_c01_w.dt_inicio_proc5,r_c01_w.ie_urgencia_mat5,
				r_c01_w.cd_intervalo, r_c01_w.ie_administracao, r_c01_w.dt_inicio, r_c01_w.ie_urgencia, r_c01_w.ie_duracao, r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_w) = 'S'
			or cpoe_fora_vigencia_proc_assoc(r_c01_w.cd_mat_proc6, r_c01_w.ie_assoc_adep6, r_c01_w.cd_interv_proc6, r_c01_w.ie_adm_mat6, r_c01_w.dt_inicio_proc6,r_c01_w.ie_urgencia_mat6,
				r_c01_w.cd_intervalo, r_c01_w.ie_administracao, r_c01_w.dt_inicio, r_c01_w.ie_urgencia, r_c01_w.ie_duracao, r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_w) = 'S'
			or cpoe_fora_vigencia_proc_assoc(r_c01_w.cd_mat_proc7, r_c01_w.ie_assoc_adep7, r_c01_w.cd_interv_proc7, r_c01_w.ie_adm_mat7, r_c01_w.dt_inicio_proc7,r_c01_w.ie_urgencia_mat7,
				r_c01_w.cd_intervalo, r_c01_w.ie_administracao, r_c01_w.dt_inicio, r_c01_w.ie_urgencia, r_c01_w.ie_duracao, r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_w) = 'S') then

			ds_log_step_w := 'STEP_2 - LINE: ' || $$plsql_line;

			ds_retorno_p := 'N';
			goto return_value;
		end if;

		if (((r_c01_w.cd_mat_proc1 IS NOT NULL AND r_c01_w.cd_mat_proc1::text <> '') and (coalesce(r_c01_w.ie_via_mat_proc1::text, '') = '' or coalesce(r_c01_w.qt_dose_mat1::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_mat1::text, '') = ''))
			or ((r_c01_w.cd_mat_proc2 IS NOT NULL AND r_c01_w.cd_mat_proc2::text <> '') and (coalesce(r_c01_w.ie_via_mat_proc2::text, '') = '' or coalesce(r_c01_w.qt_dose_mat2::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_mat2::text, '') = ''))
			or ((r_c01_w.cd_mat_proc3 IS NOT NULL AND r_c01_w.cd_mat_proc3::text <> '') and (coalesce(r_c01_w.ie_via_mat_proc3::text, '') = '' or coalesce(r_c01_w.qt_dose_mat3::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_mat3::text, '') = ''))
			or ((r_c01_w.cd_mat_proc4 IS NOT NULL AND r_c01_w.cd_mat_proc4::text <> '') and (coalesce(r_c01_w.ie_via_mat_proc4::text, '') = '' or coalesce(r_c01_w.qt_dose_mat4::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_mat4::text, '') = ''))
			or ((r_c01_w.cd_mat_proc5 IS NOT NULL AND r_c01_w.cd_mat_proc5::text <> '') and (coalesce(r_c01_w.ie_via_mat_proc5::text, '') = '' or coalesce(r_c01_w.qt_dose_mat5::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_mat5::text, '') = ''))
			or ((r_c01_w.cd_mat_proc6 IS NOT NULL AND r_c01_w.cd_mat_proc6::text <> '') and (coalesce(r_c01_w.ie_via_mat_proc6::text, '') = '' or coalesce(r_c01_w.qt_dose_mat6::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_mat6::text, '') = ''))
			or ((r_c01_w.cd_mat_proc7 IS NOT NULL AND r_c01_w.cd_mat_proc7::text <> '') and (coalesce(r_c01_w.ie_via_mat_proc7::text, '') = '' or coalesce(r_c01_w.qt_dose_mat7::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_mat7::text, '') = ''))
			or ((r_c01_w.cd_mat_dil1 IS NOT NULL AND r_c01_w.cd_mat_dil1::text <> '') and (coalesce(r_c01_w.qt_dose_dil1::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_dil1::text, '') = ''))
			or ((r_c01_w.cd_mat_dil2 IS NOT NULL AND r_c01_w.cd_mat_dil2::text <> '') and (coalesce(r_c01_w.qt_dose_dil2::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_dil2::text, '') = ''))
			or ((r_c01_w.cd_mat_dil3 IS NOT NULL AND r_c01_w.cd_mat_dil3::text <> '') and (coalesce(r_c01_w.qt_dose_dil3::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_dil3::text, '') = ''))
			or ((r_c01_w.cd_mat_dil4 IS NOT NULL AND r_c01_w.cd_mat_dil4::text <> '') and (coalesce(r_c01_w.qt_dose_dil4::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_dil4::text, '') = ''))
			or ((r_c01_w.cd_mat_dil5 IS NOT NULL AND r_c01_w.cd_mat_dil5::text <> '') and (coalesce(r_c01_w.qt_dose_dil5::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_dil5::text, '') = ''))
			or ((r_c01_w.cd_mat_dil6 IS NOT NULL AND r_c01_w.cd_mat_dil6::text <> '') and (coalesce(r_c01_w.qt_dose_dil6::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_dil6::text, '') = ''))
			or ((r_c01_w.cd_mat_dil7 IS NOT NULL AND r_c01_w.cd_mat_dil7::text <> '') and (coalesce(r_c01_w.qt_dose_dil7::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_dil7::text, '') = ''))
			or ((r_c01_w.cd_mat_recons1 IS NOT NULL AND r_c01_w.cd_mat_recons1::text <> '') and (coalesce(r_c01_w.qt_dose_recons1::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_recons1::text, '') = ''))
			or ((r_c01_w.cd_mat_recons2 IS NOT NULL AND r_c01_w.cd_mat_recons2::text <> '') and (coalesce(r_c01_w.qt_dose_recons2::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_recons2::text, '') = ''))
			or ((r_c01_w.cd_mat_recons3 IS NOT NULL AND r_c01_w.cd_mat_recons3::text <> '') and (coalesce(r_c01_w.qt_dose_recons3::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_recons3::text, '') = ''))
			or ((r_c01_w.cd_mat_recons4 IS NOT NULL AND r_c01_w.cd_mat_recons4::text <> '') and (coalesce(r_c01_w.qt_dose_recons4::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_recons4::text, '') = ''))
			or ((r_c01_w.cd_mat_recons5 IS NOT NULL AND r_c01_w.cd_mat_recons5::text <> '') and (coalesce(r_c01_w.qt_dose_recons5::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_recons5::text, '') = ''))
			or ((r_c01_w.cd_mat_recons6 IS NOT NULL AND r_c01_w.cd_mat_recons6::text <> '') and (coalesce(r_c01_w.qt_dose_recons6::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_recons6::text, '') = ''))
			or ((r_c01_w.cd_mat_recons7 IS NOT NULL AND r_c01_w.cd_mat_recons7::text <> '') and (coalesce(r_c01_w.qt_dose_recons7::text, '') = '' or coalesce(r_c01_w.cd_unid_medida_dose_recons7::text, '') = ''))) then
			
			ds_log_step_w := 'STEP_3 - LINE: ' || $$plsql_line;

			ds_retorno_p := 'N';
			goto return_value;
		end if;
		 --FIM CAMPOS OBRIGATORIOS


		--OPEN DETAIL
		ds_campo_obriga_w := cpoe_regra_obriga_campos_proc(r_c01_w.nr_atendimento, r_c01_w.nr_seq_proc_interno, r_c01_w.cd_intervalo, wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_cd_perfil, ds_campo_obriga_w);

		if ((ds_campo_obriga_w like '%1%' and coalesce(r_c01_w.ds_dado_clinico::text, '') = '')
			or (ds_campo_obriga_w like '%5%' and coalesce(r_c01_w.ds_observacao::text, '') = '')
			or (ds_campo_obriga_w like '%6%' and coalesce(r_c01_w.ds_justificativa::text, '') = '')
			or (ds_campo_obriga_w like '%7%' and coalesce(r_c01_w.nr_seq_contraste::text, '') = '')
			or ((ds_campo_obriga_w like '%M%' and coalesce(r_c01_w.cd_material_exame::text, '') = '')
				and cpoe_exame_lab_proc(r_c01_w.nr_seq_proc_interno) > 0 ))then

			ds_log_step_w := 'STEP_4 - LINE: ' || $$plsql_line;

			ds_retorno_p := 'N';
			goto return_value;
		end if;

		SELECT * FROM cpoe_consist_regra_presc_proce(r_c01_w.nr_atendimento, null, null, null, r_c01_w.nr_seq_proc_interno, wheb_usuario_pck.get_cd_perfil, r_c01_w.cd_setor_atend, r_c01_w.cd_material_exame, wheb_usuario_pck.get_nm_usuario, clock_timestamp(), ds_erro_w, ds_mensagem_w, ie_abortar_w) INTO STRICT ds_erro_w, ds_mensagem_w, ie_abortar_w;

		if (ds_erro_w = 'J' and coalesce(r_c01_w.ds_justificativa::text, '') = '') then
			ds_log_step_w := 'STEP_4A - LINE: ' || $$plsql_line;

			ds_retorno_p := 'N';
			exit;
		end if;

		select	coalesce(max(ie_ctrl_glic),'NC'),
			coalesce(max(ie_topografia),'N'),
			coalesce(max(ie_exige_lado),'N'),
			coalesce(max(ie_exige_condicao),'N')
		into STRICT	ie_ctrl_glic_w,
			ie_topografia_w,
			ie_exige_lado_w,
			ie_exige_condicao_w
		from	proc_interno
		where	nr_sequencia = r_c01_w.nr_seq_proc_interno;

		if (ie_ctrl_glic_w <> 'NC' and coalesce(r_c01_w.nr_seq_prot_glic::text, '') = '') then
		
			ds_log_step_w := 'STEP_5 - LINE: ' || $$plsql_line;

			ds_retorno_p := 'N';
			goto return_value;
		end if;

		if (ie_topografia_w = 'S' and coalesce(r_c01_w.nr_seq_topografia::text, '') = '') then
		
			ds_log_step_w := 'STEP_6 - LINE: ' || $$plsql_line;

			ds_retorno_p := 'N';
			goto return_value;
		end if;

		if ((ie_exige_lado_w = 'S' or ie_exige_lado_w = 'L') and coalesce(r_c01_w.ie_lado::text, '') = '') then
		
			ds_log_step_w := 'STEP_7 - LINE: ' || $$plsql_line;

			ds_retorno_p := 'N';
			goto return_value;
		end if;

		if (ie_exige_condicao_w = 'S' and coalesce(r_c01_w.nr_seq_condicao::text, '') = '') then
			
			ds_log_step_w := 'STEP_8 - LINE: ' || $$plsql_line;
			
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		select	coalesce(max(b.ie_material_especial),'N')
		into STRICT	ie_material_especial_w
		from 	material_exame_lab b,
			exame_lab_material a
		where	a.nr_seq_material  = b.nr_sequencia
		and	a.ie_situacao = 'A' 
		and	b.cd_material_exame = r_c01_w.cd_material_exame
		and	(a.nr_seq_exame = (SELECT max(nr_seq_exame_lab)
						from	proc_interno
						where	nr_sequencia = r_c01_w.nr_seq_proc_interno)
		or	a.nr_seq_exame = (select coalesce(max(a.nr_seq_exame),0) nr_seq_exame
					from	exame_laboratorio a
					where	a.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
					and	a.nr_seq_proc_interno = r_c01_w.nr_seq_proc_interno))
		order by a.ie_prioridade, b.ds_material_exame;

		if (ie_material_especial_w = 'S' and coalesce(r_c01_w.ds_material_especial::text, '') = '') then

			ds_log_step_w := 'STEP_9 - LINE: ' || $$plsql_line;

			ds_retorno_p := 'N';
			goto return_value;
		end if;
		--FIM OPEN DETAIL


		--CUSTOM VALIDATOR
		if (((r_c01_w.cd_mat_proc1 IS NOT NULL AND r_c01_w.cd_mat_proc1::text <> '') and coalesce(r_c01_w.qt_dose_mat1,0) = 0)
			or ((r_c01_w.cd_mat_proc2 IS NOT NULL AND r_c01_w.cd_mat_proc2::text <> '') and coalesce(r_c01_w.qt_dose_mat2,0) = 0)
			or ((r_c01_w.cd_mat_proc3 IS NOT NULL AND r_c01_w.cd_mat_proc3::text <> '') and coalesce(r_c01_w.qt_dose_mat3,0) = 0)
			or ((r_c01_w.cd_mat_proc4 IS NOT NULL AND r_c01_w.cd_mat_proc4::text <> '') and coalesce(r_c01_w.qt_dose_mat4,0) = 0)
			or ((r_c01_w.cd_mat_proc5 IS NOT NULL AND r_c01_w.cd_mat_proc5::text <> '') and coalesce(r_c01_w.qt_dose_mat5,0) = 0)
			or ((r_c01_w.cd_mat_proc6 IS NOT NULL AND r_c01_w.cd_mat_proc6::text <> '') and coalesce(r_c01_w.qt_dose_mat6,0) = 0)
			or ((r_c01_w.cd_mat_proc7 IS NOT NULL AND r_c01_w.cd_mat_proc7::text <> '') and coalesce(r_c01_w.qt_dose_mat7,0) = 0)
			or ((r_c01_w.cd_mat_dil1 IS NOT NULL AND r_c01_w.cd_mat_dil1::text <> '') and coalesce(r_c01_w.qt_dose_dil1,0) = 0)
			or ((r_c01_w.cd_mat_dil2 IS NOT NULL AND r_c01_w.cd_mat_dil2::text <> '') and coalesce(r_c01_w.qt_dose_dil2,0) = 0)
			or ((r_c01_w.cd_mat_dil3 IS NOT NULL AND r_c01_w.cd_mat_dil3::text <> '') and coalesce(r_c01_w.qt_dose_dil3,0) = 0)
			or ((r_c01_w.cd_mat_dil4 IS NOT NULL AND r_c01_w.cd_mat_dil4::text <> '') and coalesce(r_c01_w.qt_dose_dil4,0) = 0)
			or ((r_c01_w.cd_mat_dil5 IS NOT NULL AND r_c01_w.cd_mat_dil5::text <> '') and coalesce(r_c01_w.qt_dose_dil5,0) = 0)
			or ((r_c01_w.cd_mat_dil6 IS NOT NULL AND r_c01_w.cd_mat_dil6::text <> '') and coalesce(r_c01_w.qt_dose_dil6,0) = 0)
			or ((r_c01_w.cd_mat_dil7 IS NOT NULL AND r_c01_w.cd_mat_dil7::text <> '') and coalesce(r_c01_w.qt_dose_dil7,0) = 0)) then
			
			ds_log_step_w := 'STEP_10 - LINE: ' || $$plsql_line;
			
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		--FIM CUSTOM VALIDATOR


		--INCONSISTENCIA DA CPOE (BARRA VERMELHA) 

		
		--DUPLICIDADE PROC
		if (cpoe_shoppingcart_proc_duplic(r_c01_w.nr_sequencia, r_c01_w.nr_atendimento, r_c01_w.cd_setor_atend, r_c01_w.cd_pessoa_fisica, r_c01_w.nr_seq_proc_interno, r_c01_w.dt_inicio, r_c01_w.dt_fim) = 'S') then
			
			ds_log_step_w := 'STEP_11 - LINE: ' || $$plsql_line;

			ds_retorno_p := 'N';
			goto return_value;
		end if;
		--NAO PERMITIDO PARA ESTA ESPECIALIDADE
		select	max(ie_forma_consistencia)
		into STRICT	ie_forma_consistencia_w
		from	regra_consiste_prescr_par 
		where	nr_seq_regra 		= 287
		and	coalesce(cd_perfil,wheb_usuario_pck.get_cd_perfil)	= wheb_usuario_pck.get_cd_perfil;

		if (ie_forma_consistencia_w <> 'X') then

			select a.nr_sequencia,
				b.cd_tipo_procedimento
			into STRICT	nr_seq_proc_interno_espec_w,
				cd_tipo_procedimento_espec_w
			from	proc_interno a,
				procedimento b
			where	b.cd_procedimento = a.cd_procedimento
			and b.ie_origem_proced = a.ie_origem_proced
			and a.nr_sequencia = r_c01_w.nr_seq_proc_interno;
			
			if (nr_seq_proc_interno_espec_w IS NOT NULL AND nr_seq_proc_interno_espec_w::text <> '' AND cd_tipo_procedimento_espec_w IS NOT NULL AND cd_tipo_procedimento_espec_w::text <> '') then
							
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_proc_espec_w
				from	rep_proc_especialidade a
				where	a.nr_seq_proc_interno = nr_seq_proc_interno_espec_w
					or a.cd_tipo_procedimento = cd_tipo_procedimento_espec_w;
			
				if (nr_seq_proc_espec_w IS NOT NULL AND nr_seq_proc_espec_w::text <> '') then
					select	count(*) qtd
					into STRICT	qt_count_w
					from	medico_especialidade a
					where	a.cd_pessoa_fisica	= r_c01_w.cd_pessoa_fisica
					and	exists (SELECT	1
							from	rep_especialidade_proc	x
							where	x.cd_especialidade	= a.cd_especialidade
							and	x.nr_seq_regra		= nr_seq_proc_espec_w);
							
					if (qt_count_w < 1) then
						ds_log_step_w := 'STEP_12 - LINE: ' || $$plsql_line;
						ds_retorno_p := 'N';
						goto return_value;
					end if;
				end if;
			end if;
		end if;
		--NAO PERMITIDO PARA PACIENTES GRAVIDAS
		select	max(ie_forma_consistencia)
		into STRICT	ie_forma_consistencia_w
		from	regra_consiste_prescr_par 
		where	nr_seq_regra 		= 297
		and	coalesce(cd_perfil,wheb_usuario_pck.get_cd_perfil)	= wheb_usuario_pck.get_cd_perfil;
		
		if (coalesce(ie_forma_consistencia_w::text, '') = '') then
			select	max(ie_libera_prescr)
			into STRICT	ie_forma_consistencia_w
			from	regra_consiste_prescr
			where	nr_sequencia = 297;
		end if;

		if (ie_forma_consistencia_w <> 'X') then

			select obter_se_perm_proc_pac_gravida(r_c01_w.cd_pessoa_fisica, r_c01_w.nr_seq_proc_interno)
			into STRICT ie_consiste_proc_gravida_w
			;
		
			if (ie_consiste_proc_gravida_w = 'S') then
				ds_log_step_w := 'STEP_13 - LINE: ' || $$plsql_line;
			
				ds_retorno_p := 'N';
				goto return_value;
			end if;
		end if;
		--NAO PERMITIDO PARA PACIENTES COM MARCAPASSO
		select	max(ie_forma_consistencia)
		into STRICT	ie_forma_consistencia_w
		from	regra_consiste_prescr_par 
		where	nr_seq_regra 		= 298
		and	coalesce(cd_perfil,wheb_usuario_pck.get_cd_perfil)	= wheb_usuario_pck.get_cd_perfil;
		
		if (coalesce(ie_forma_consistencia_w::text, '') = '') then
			select	max(ie_libera_prescr)
			into STRICT	ie_forma_consistencia_w
			from	regra_consiste_prescr
			where	nr_sequencia = 298;
		end if;

		if (ie_forma_consistencia_w <> 'X') then

			select obter_se_permite_acessorio(r_c01_w.cd_pessoa_fisica, r_c01_w.nr_seq_proc_interno)
			into STRICT ie_consiste_marcapasso_w
			;
		
			if (ie_consiste_marcapasso_w = 'S') then
				ds_log_step_w := 'STEP_14 - LINE: ' || $$plsql_line;
			
				ds_retorno_p := 'N';
				goto return_value;
			end if;
		end if;
		--NAO PERMITIDO PARA PACIENTES COM ACESSORIO / ORTESE / PROTESE
		select	max(ie_forma_consistencia)
		into STRICT	ie_forma_consistencia_w
		from	regra_consiste_prescr_par 
		where	nr_seq_regra 		= 115
		and	coalesce(cd_perfil,wheb_usuario_pck.get_cd_perfil)	= wheb_usuario_pck.get_cd_perfil;
		
		if (coalesce(ie_forma_consistencia_w::text, '') = '') then
			select	max(ie_libera_prescr)
			into STRICT	ie_forma_consistencia_w
			from	regra_consiste_prescr
			where	nr_sequencia = 115;
		end if;

		if (ie_forma_consistencia_w <> 'X') then
		
			select	obter_se_paciente_acessorio(r_c01_w.cd_pessoa_fisica, pi.cd_procedimento, pi.ie_origem_proced)
			into STRICT	ie_consiste_acessorio_w
			from	proc_interno pi
			where	pi.nr_sequencia = r_c01_w.nr_seq_proc_interno;

			if (ie_consiste_acessorio_w = 'S') then
				ds_log_step_w := 'STEP_15 - LINE: ' || $$plsql_line;
			
				ds_retorno_p := 'N';
				goto return_value;
			end if;
		end if;
		--DUPLICIDADE MEDICAMENTO ASSOCIADO
		if (cpoe_shoppingcart_medic_duplic(r_c01_w.nr_sequencia, r_c01_w.cd_setor_atend, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc1, coalesce(r_c01_w.dt_inicio_proc1,r_c01_w.dt_inicio), r_c01_w.dt_fim) = 'S'
			or cpoe_shoppingcart_medic_duplic(r_c01_w.nr_sequencia, r_c01_w.cd_setor_atend, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc2, coalesce(r_c01_w.dt_inicio_proc2,r_c01_w.dt_inicio), r_c01_w.dt_fim) = 'S'
			or cpoe_shoppingcart_medic_duplic(r_c01_w.nr_sequencia, r_c01_w.cd_setor_atend, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc3, coalesce(r_c01_w.dt_inicio_proc3,r_c01_w.dt_inicio), r_c01_w.dt_fim) = 'S'
			or cpoe_shoppingcart_medic_duplic(r_c01_w.nr_sequencia, r_c01_w.cd_setor_atend, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc4, coalesce(r_c01_w.dt_inicio_proc4,r_c01_w.dt_inicio), r_c01_w.dt_fim) = 'S'
			or cpoe_shoppingcart_medic_duplic(r_c01_w.nr_sequencia, r_c01_w.cd_setor_atend, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc5, coalesce(r_c01_w.dt_inicio_proc5,r_c01_w.dt_inicio), r_c01_w.dt_fim) = 'S'
			or cpoe_shoppingcart_medic_duplic(r_c01_w.nr_sequencia, r_c01_w.cd_setor_atend, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc6, coalesce(r_c01_w.dt_inicio_proc6,r_c01_w.dt_inicio), r_c01_w.dt_fim) = 'S'
			or cpoe_shoppingcart_medic_duplic(r_c01_w.nr_sequencia, r_c01_w.cd_setor_atend, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc7, coalesce(r_c01_w.dt_inicio_proc7,r_c01_w.dt_inicio), r_c01_w.dt_fim) = 'S') then
			
			ds_log_step_w := 'STEP_16 - LINE: ' || $$plsql_line;
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		--NAO PADRONIZADO MEDICAMENTO ASSOCIADO
		if (cpoe_obter_se_mat_padronizado(wheb_usuario_pck.get_cd_estabelecimento, r_c01_w.cd_mat_proc1, r_c01_w.ie_paciente_mat1) = 'N'
			or cpoe_obter_se_mat_padronizado(wheb_usuario_pck.get_cd_estabelecimento, r_c01_w.cd_mat_proc2, r_c01_w.ie_paciente_mat2) = 'N'
			or cpoe_obter_se_mat_padronizado(wheb_usuario_pck.get_cd_estabelecimento, r_c01_w.cd_mat_proc3, r_c01_w.ie_paciente_mat3) = 'N'
			or cpoe_obter_se_mat_padronizado(wheb_usuario_pck.get_cd_estabelecimento, r_c01_w.cd_mat_proc4, r_c01_w.ie_paciente_mat4) = 'N'
			or cpoe_obter_se_mat_padronizado(wheb_usuario_pck.get_cd_estabelecimento, r_c01_w.cd_mat_proc5, r_c01_w.ie_paciente_mat5) = 'N'
			or cpoe_obter_se_mat_padronizado(wheb_usuario_pck.get_cd_estabelecimento, r_c01_w.cd_mat_proc6, r_c01_w.ie_paciente_mat6) = 'N'
			or cpoe_obter_se_mat_padronizado(wheb_usuario_pck.get_cd_estabelecimento, r_c01_w.cd_mat_proc7, r_c01_w.ie_paciente_mat7) = 'N') then
			
			ds_log_step_w := 'STEP_17 - LINE: ' || $$plsql_line;
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		--ALERGIA MEDICAMENTO ASSOCIADO
		SELECT * FROM cpoe_verifica_se_pac_alergico(r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc1, ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, 'N', nr_seq_ficha_tecnica_w) INTO STRICT ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, nr_seq_ficha_tecnica_w;

		if (ie_return_value_w = 'N') then
			SELECT * FROM cpoe_verifica_se_pac_alergico(r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc2, ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, 'N', nr_seq_ficha_tecnica_w) INTO STRICT ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, nr_seq_ficha_tecnica_w;
		end if;	

		if (ie_return_value_w = 'N') then
			SELECT * FROM cpoe_verifica_se_pac_alergico(r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc3, ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, 'N', nr_seq_ficha_tecnica_w) INTO STRICT ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, nr_seq_ficha_tecnica_w;
		end if;

		if (ie_return_value_w = 'N') then
			SELECT * FROM cpoe_verifica_se_pac_alergico(r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc4, ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, 'N', nr_seq_ficha_tecnica_w) INTO STRICT ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, nr_seq_ficha_tecnica_w;
		end if;

		if (ie_return_value_w = 'N') then
			SELECT * FROM cpoe_verifica_se_pac_alergico(r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc5, ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, 'N', nr_seq_ficha_tecnica_w) INTO STRICT ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, nr_seq_ficha_tecnica_w;
		end if;

		if (ie_return_value_w = 'N') then
			SELECT * FROM cpoe_verifica_se_pac_alergico(r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc6, ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, 'N', nr_seq_ficha_tecnica_w) INTO STRICT ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, nr_seq_ficha_tecnica_w;
		end if;

		if (ie_return_value_w = 'N') then
			SELECT * FROM cpoe_verifica_se_pac_alergico(r_c01_w.cd_pessoa_fisica, r_c01_w.cd_mat_proc7, ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, 'N', nr_seq_ficha_tecnica_w) INTO STRICT ie_return_value_w, ds_alergia_w, ie_severidade_w, nr_seq_reacao_w, nr_seq_ficha_tecnica_w;
		end if;	

		if (ie_return_value_w = 'S') then
			
			ds_log_step_w := 'STEP_18 - LINE: ' || $$plsql_line;
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		--DOSE MIN E MAX
		SELECT * FROM cpoe_shoppingcart_dose_max_min(r_c01_w.nr_atendimento, r_c01_w.nr_sequencia, 'PMAT1', r_c01_w.cd_mat_proc1, r_c01_w.qt_dose_mat1, null, r_c01_w.cd_unid_medida_dose_mat1, r_c01_w.ie_via_mat_proc1, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_interv_proc1, null, null, null, null, null, null, null, null, r_c01_w.dt_inicio_proc1, r_c01_w.dt_fim, r_c01_w.ie_duracao, r_c01_w.ds_hor_proc1, r_c01_w.ie_urgencia_mat1, 'A') INTO STRICT nr_return_value_w, active_ingred_consist_w;

		if ((nr_return_value_w IS NOT NULL AND nr_return_value_w::text <> '') and nr_return_value_w > 0) then
			SELECT * FROM cpoe_shoppingcart_dose_max_min(r_c01_w.nr_atendimento, r_c01_w.nr_sequencia, 'PMAT2', r_c01_w.cd_mat_proc2, r_c01_w.qt_dose_mat2, null, r_c01_w.cd_unid_medida_dose_mat2, r_c01_w.ie_via_mat_proc2, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_interv_proc2, null, null, null, null, null, null, null, null, r_c01_w.dt_inicio_proc2, r_c01_w.dt_fim, r_c01_w.ie_duracao, r_c01_w.ds_hor_proc2, r_c01_w.ie_urgencia_mat2, 'A') INTO STRICT nr_return_value_w, active_ingred_consist_w;
		end if;

		if ((nr_return_value_w IS NOT NULL AND nr_return_value_w::text <> '') and nr_return_value_w > 0) then
			SELECT * FROM cpoe_shoppingcart_dose_max_min(r_c01_w.nr_atendimento, r_c01_w.nr_sequencia, 'PMAT3', r_c01_w.cd_mat_proc3, r_c01_w.qt_dose_mat3, null, r_c01_w.cd_unid_medida_dose_mat3, r_c01_w.ie_via_mat_proc3, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_interv_proc3, null, null, null, null, null, null, null, null, r_c01_w.dt_inicio_proc3, r_c01_w.dt_fim, r_c01_w.ie_duracao, r_c01_w.ds_hor_proc3, r_c01_w.ie_urgencia_mat3, 'A') INTO STRICT nr_return_value_w, active_ingred_consist_w;
		end if;	

		if ((nr_return_value_w IS NOT NULL AND nr_return_value_w::text <> '') and nr_return_value_w > 0) then
			SELECT * FROM cpoe_shoppingcart_dose_max_min(r_c01_w.nr_atendimento, r_c01_w.nr_sequencia, 'PMAT4', r_c01_w.cd_mat_proc4, r_c01_w.qt_dose_mat4, null, r_c01_w.cd_unid_medida_dose_mat4, r_c01_w.ie_via_mat_proc4, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_interv_proc4, null, null, null, null, null, null, null, null, r_c01_w.dt_inicio_proc4, r_c01_w.dt_fim, r_c01_w.ie_duracao, r_c01_w.ds_hor_proc4, r_c01_w.ie_urgencia_mat4, 'A') INTO STRICT ie_return_value_w, active_ingred_consist_w;
		end if;	

		if ((nr_return_value_w IS NOT NULL AND nr_return_value_w::text <> '') and nr_return_value_w > 0) then
			SELECT * FROM cpoe_shoppingcart_dose_max_min(r_c01_w.nr_atendimento, r_c01_w.nr_sequencia, 'PMAT5', r_c01_w.cd_mat_proc5, r_c01_w.qt_dose_mat5, null, r_c01_w.cd_unid_medida_dose_mat5, r_c01_w.ie_via_mat_proc5, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_interv_proc5, null, null, null, null, null, null, null, null, r_c01_w.dt_inicio_proc5, r_c01_w.dt_fim, r_c01_w.ie_duracao, r_c01_w.ds_hor_proc5, r_c01_w.ie_urgencia_mat5, 'A') INTO STRICT ie_return_value_w, active_ingred_consist_w;
		end if;	

		if ((nr_return_value_w IS NOT NULL AND nr_return_value_w::text <> '') and nr_return_value_w > 0) then
			SELECT * FROM cpoe_shoppingcart_dose_max_min(r_c01_w.nr_atendimento, r_c01_w.nr_sequencia, 'PMAT6', r_c01_w.cd_mat_proc6, r_c01_w.qt_dose_mat6, null, r_c01_w.cd_unid_medida_dose_mat6, r_c01_w.ie_via_mat_proc6, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_interv_proc6, null, null, null, null, null, null, null, null, r_c01_w.dt_inicio_proc6, r_c01_w.dt_fim, r_c01_w.ie_duracao, r_c01_w.ds_hor_proc6, r_c01_w.ie_urgencia_mat6, 'A') INTO STRICT nr_return_value_w, active_ingred_consist_w;
		end if;	

		if ((nr_return_value_w IS NOT NULL AND nr_return_value_w::text <> '') and nr_return_value_w > 0) then
			SELECT * FROM cpoe_shoppingcart_dose_max_min(r_c01_w.nr_atendimento, r_c01_w.nr_sequencia, 'PMAT7', r_c01_w.cd_mat_proc7, r_c01_w.qt_dose_mat7, null, r_c01_w.cd_unid_medida_dose_mat7, r_c01_w.ie_via_mat_proc7, r_c01_w.cd_pessoa_fisica, r_c01_w.cd_interv_proc7, null, null, null, null, null, null, null, null, r_c01_w.dt_inicio_proc7, r_c01_w.dt_fim, r_c01_w.ie_duracao, r_c01_w.ds_hor_proc7, r_c01_w.ie_urgencia_mat7, 'A') INTO STRICT nr_return_value_w, active_ingred_consist_w;
		end if;	

		if ((nr_return_value_w IS NOT NULL AND nr_return_value_w::text <> '') and nr_return_value_w > 0) then
			
			ds_log_step_w := 'STEP_19 - LINE: ' || $$plsql_line;
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		--INTERACAO FARMACO X FARMACO MEDICAMENTO ASSOCIADO
		if (cpoe_obter_se_interacao_medic(r_c01_w.cd_mat_proc1, r_c01_w.nr_atendimento, r_c01_w.cd_pessoa_fisica, r_c01_w.nr_sequencia) = 'S'
			or cpoe_obter_se_interacao_medic(r_c01_w.cd_mat_proc2, r_c01_w.nr_atendimento, r_c01_w.cd_pessoa_fisica, r_c01_w.nr_sequencia) = 'S'
			or cpoe_obter_se_interacao_medic(r_c01_w.cd_mat_proc3, r_c01_w.nr_atendimento, r_c01_w.cd_pessoa_fisica, r_c01_w.nr_sequencia) = 'S'
			or cpoe_obter_se_interacao_medic(r_c01_w.cd_mat_proc4, r_c01_w.nr_atendimento, r_c01_w.cd_pessoa_fisica, r_c01_w.nr_sequencia) = 'S'
			or cpoe_obter_se_interacao_medic(r_c01_w.cd_mat_proc5, r_c01_w.nr_atendimento, r_c01_w.cd_pessoa_fisica, r_c01_w.nr_sequencia) = 'S'
			or cpoe_obter_se_interacao_medic(r_c01_w.cd_mat_proc6, r_c01_w.nr_atendimento, r_c01_w.cd_pessoa_fisica, r_c01_w.nr_sequencia) = 'S'
			or cpoe_obter_se_interacao_medic(r_c01_w.cd_mat_proc7, r_c01_w.nr_atendimento, r_c01_w.cd_pessoa_fisica, r_c01_w.nr_sequencia) = 'S') then
			
			ds_log_step_w := 'STEP_20 - LINE: ' || $$plsql_line;
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		--LATEX MEDICAMENTO ASSOCIADO
		if (cpoe_shoppingcart_se_latex(r_c01_w.cd_mat_proc1, r_c01_w.cd_pessoa_fisica) = 'S'
			or cpoe_shoppingcart_se_latex(r_c01_w.cd_mat_proc2, r_c01_w.cd_pessoa_fisica) = 'S'
			or cpoe_shoppingcart_se_latex(r_c01_w.cd_mat_proc3, r_c01_w.cd_pessoa_fisica) = 'S'
			or cpoe_shoppingcart_se_latex(r_c01_w.cd_mat_proc4, r_c01_w.cd_pessoa_fisica) = 'S'
			or cpoe_shoppingcart_se_latex(r_c01_w.cd_mat_proc5, r_c01_w.cd_pessoa_fisica) = 'S'
			or cpoe_shoppingcart_se_latex(r_c01_w.cd_mat_proc6, r_c01_w.cd_pessoa_fisica) = 'S'
			or cpoe_shoppingcart_se_latex(r_c01_w.cd_mat_proc7, r_c01_w.cd_pessoa_fisica) = 'S') then
			
			ds_log_step_w := 'STEP_21 - LINE: ' || $$plsql_line;
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		
		ie_param_rep_353_w := Obter_param_Usuario(924, 353, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_param_rep_353_w);

		if (ie_param_rep_353_w = 'S') then

			SELECT * FROM obter_proc_tab_interno(r_c01_w.nr_seq_proc_interno, 0, r_c01_w.nr_atendimento, 0, cd_procedimento_w, ie_origem_proced_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w;

			if (cpoe_obter_proc_interno_laudo(r_c01_w.nr_atendimento, cd_procedimento_w, ie_origem_proced_w, r_c01_w.nr_sequencia) = 'S') then
				
				ds_log_step_w := 'STEP_22 - LINE: ' || $$plsql_line;
				ds_retorno_p := 'N';
				goto return_value;	
			end if;
		end if;

		ie_param_rep_964_w := Obter_param_Usuario(924, 964, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_param_rep_964_w);

		if (ie_param_rep_964_w = 'R') then

			select 	coalesce(max(nr_seq_avaliacao),0)
			into STRICT 	nr_seq_avaliacao_w
			from 	proc_interno
			where 	nr_sequencia = r_c01_w.nr_seq_proc_interno;

			if (nr_seq_avaliacao_w > 0) then
				
				ds_log_step_w := 'STEP_23 - LINE: ' || $$plsql_line;
				ds_retorno_p := 'N';
				goto return_value;	
			end if;
		end if;
		--NAO PERMITIDO SE A DATA ESTIVER FORA DA DEADLINE
		
		if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then
			select consiste_inicio_prescr(null, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_cd_estabelecimento, r_c01_w.cd_setor_atend, r_c01_w.dt_inicio, r_c01_w.nr_atendimento, null, r_c01_w.nr_seq_cpoe_order_unit, 'S')
			into STRICT ie_consiste_proc_deadline_w
			;

			if (ie_consiste_proc_deadline_w = 'ERROR' OR ie_consiste_proc_deadline_w = 'WARNING') then
				ds_retorno_p := 'N';
				goto return_value;
			end if;
		end if;
		--FIM INCONSISTENCIA DA CPOE (BARRA VERMELHA)
	end loop;
end if;
<<return_value>>

	if (ds_retorno_p = 'N' AND ds_log_step_w IS NOT NULL AND ds_log_step_w::text <> '') then
		ie_info_rastre_prescr_w := obter_se_info_rastre_prescr('O', wheb_usuario_pck.get_nm_usuario, obter_perfil_ativo, wheb_usuario_pck.get_cd_estabelecimento);

		if (ie_info_rastre_prescr_w = 'S') then
			CALL gravar_log_cpoe(
				substr('CPOE_SHOPPINGCART_PROCEDURE:' || ds_log_step_w, 1, 2000),
				nr_atendimento_w,
				'P',
				nr_sequencia_p
			);
			commit;
		end if;
	end if;

exception when others then
	CALL gravar_log_cpoe(substr('CPOE_SHOPPINGCART_PROCEDURE EXCEPTION:'|| substr(to_char(sqlerrm),1,2000) || '//nr_sequencia_p: '|| nr_sequencia_p,1,40000));
	ds_retorno_p := 'N';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_shoppingcart_procedure ((nr_sequencia_p bigint, ie_retrogrado_p text, ds_retorno_p out text) is nr_return_value_w bigint) FROM PUBLIC;
