-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_sincronizar_ccg ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, dt_horario_p timestamp, nr_horario_p integer, ie_exibir_dil_ccg_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_palm_p text) AS $body$
DECLARE
				
	ds_sep_bv_w		varchar(50);				
	nr_seq_procedimento_w	integer;
	nr_seq_horario_w	bigint;
	ie_status_horario_w	varchar(15);
	cd_procedimento_w	bigint;
	ds_procedimento_w	varchar(255);
	nr_seq_proc_interno_w	bigint;
	ie_acm_sn_w		varchar(1);
	cd_intervalo_w		varchar(7);
	qt_procedimento_w	double precision;
	ds_prescricao_w		varchar(240);
	ds_mat_med_assoc_w	varchar(2000);
	ie_suspenso_w		varchar(1);
	dt_suspensao_w		timestamp;
	dt_validade_w		timestamp;
	ds_comando_update_w	varchar(4000);
	nr_seq_prot_glic_w	prescr_procedimento.nr_seq_prot_glic%type;
	current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp	timestamp;
	nr_horario_w	integer;
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();	
	nr_seq_proc_cpoe_w	prescr_procedimento.nr_seq_proc_cpoe%type;
	ie_status_item_w	varchar(5);
	ds_observacao_w		varchar(2000);
	c01 CURSOR FOR	
	SELECT	a.nr_prescricao,
		c.nr_seq_procedimento,
		c.nr_sequencia,
		CASE WHEN coalesce(c.dt_primeira_checagem::text, '') = '' THEN substr(obter_status_hor_proced(c.dt_fim_horario,c.dt_suspensao,c.ie_dose_especial),1,15)  ELSE 'Q' END ,
		c.cd_procedimento,
		z.ds_protocolo,
		c.nr_seq_proc_interno,
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
		x.cd_intervalo,
		x.qt_procedimento,
		CASE WHEN ie_exibir_dil_ccg_p='S' THEN  substr(adep_obter_dados_prescr_proc(a.nr_prescricao,c.nr_seq_procedimento,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100)  ELSE '' END  ds_prescricao,
		substr(CASE WHEN GetIEObsProced='S' THEN  obter_desc_expressao(692668) || x.ds_observacao  ELSE '' END  || '  ' || CASE WHEN ie_exibir_dil_ccg_p='S' THEN  obter_mat_med_assoc_ccg(a.nr_prescricao,c.nr_seq_procedimento,'S')  ELSE '' END  || substr(adep_gerar_horarios_pck.obter_ds_justificativa(obter_justificativa_item(x.nr_prescricao, x.nr_sequencia, 'P')), 1, 1000),1,2000) ds_mat_med_assoc,
		coalesce(x.ie_suspenso,'N') ie_suspenso,
		c.dt_suspensao dt_suspensao,
		x.nr_seq_prot_glic,
		c.dt_horario,
		x.nr_seq_proc_cpoe,
		CASE WHEN obter_se_acm_sn(x.ie_acm, x.ie_se_necessario)='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(x.nr_prescricao,c.nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN x.ie_suspenso='S' THEN  x.ie_suspenso  ELSE null END   ELSE null END   ELSE CASE WHEN x.ie_suspenso='S' THEN  x.ie_suspenso  ELSE null END  END ,
		CASE WHEN GetIEObsProced='S' THEN substr(x.ds_observacao,1,2000)  ELSE null END  ds_observacao
	from	pep_protocolo_glicemia z,
		procedimento y,
		proc_interno w,
		prescr_procedimento x,
		prescr_proc_hor c,
		prescr_medica a
	where	z.nr_sequencia = x.nr_seq_prot_glic
	and	y.cd_procedimento = x.cd_procedimento
	and	y.ie_origem_proced = x.ie_origem_proced
	and	y.cd_procedimento = c.cd_procedimento
	and	y.ie_origem_proced = c.ie_origem_proced		
	and	w.nr_sequencia = x.nr_seq_proc_interno
	and	w.nr_sequencia = c.nr_seq_proc_interno
	and	x.nr_prescricao = c.nr_prescricao
	and	x.nr_sequencia = c.nr_seq_procedimento
	and	x.nr_prescricao = a.nr_prescricao
	and	c.nr_prescricao = a.nr_prescricao
	and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w = 'S'))	
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and	a.nr_atendimento = nr_atendimento_p
	and	coalesce(a.ie_hemodialise, 'N') <> 'R'
	and	a.dt_validade_prescr between dt_validade_limite_p and dt_validade_w
	and	(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_lib_proced_p))::text <> '')
	and ((a.nr_seq_pend_pac_acao IS NOT NULL AND a.nr_seq_pend_pac_acao::text <> '') or
		 ((obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, coalesce(a.dt_liberacao_farmacia, c.dt_lib_horario), ie_data_lib_prescr_p,a.ie_lib_farm) = 'S') or
		 ((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and (not exists (SELECT 1 from prescr_material b where b.nr_prescricao = x.nr_prescricao and b.NR_SEQUENCIA_PROC = x.nr_sequencia and b.ie_agrupador = 5)))))
	and	coalesce(w.ie_tipo,'O') not in ('G','BS')
	and	coalesce(w.ie_ivc,'N') <> 'S'
	and	w.ie_ctrl_glic = 'CCG'
	and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
	and	(x.nr_seq_prot_glic IS NOT NULL AND x.nr_seq_prot_glic::text <> '')
	and	coalesce(x.nr_seq_solic_sangue::text, '') = ''
	and	coalesce(x.nr_seq_derivado::text, '') = ''
	and	coalesce(x.nr_seq_exame_sangue::text, '') = ''
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
	and	((ie_so_proc_setor_usuario_p = 'N') or (adep_obter_se_setor_proc_user(nm_usuario_p, x.cd_setor_atendimento) = 'S'))
	and	coalesce(c.ie_situacao,'A') = 'A'
	and	((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> ''))
	and	((ie_exibir_hor_realizados_p = 'S') or ((ie_palm_p = 'S') and (Obter_se_assoc_glic_pend(x.nr_prescricao, c.dt_horario) = 'S')) or (coalesce(c.dt_fim_horario::text, '') = ''))
	and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
	and	ie_regra_inclusao_p <> 'N'
	and	c.dt_horario between dt_horario_inicio_sinc_w and dt_horario_fim_sinc_w
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
	group by
		c.dt_horario,
		a.nr_prescricao,
		c.nr_seq_procedimento,
		c.nr_sequencia,
		c.dt_fim_horario,
		c.dt_suspensao,
		c.dt_primeira_checagem,
		c.ie_dose_especial,
		c.cd_procedimento,
		z.ds_protocolo,
		c.nr_seq_proc_interno,
		x.ie_acm,
		x.ie_se_necessario,		
		x.cd_intervalo,
		x.qt_procedimento,
		x.ie_suspenso,
		x.nr_seq_prot_glic,
		x.nr_seq_proc_cpoe,
		substr(CASE WHEN GetIEObsProced='S' THEN  obter_desc_expressao(692668) || x.ds_observacao  ELSE '' END  || '  ' || CASE WHEN ie_exibir_dil_ccg_p='S' THEN  obter_mat_med_assoc_ccg(a.nr_prescricao,c.nr_seq_procedimento,'S')  ELSE '' END  || substr(adep_gerar_horarios_pck.obter_ds_justificativa(obter_justificativa_item(x.nr_prescricao, x.nr_sequencia, 'P')), 1, 1000),1,2000),
		CASE WHEN obter_se_acm_sn(x.ie_acm, x.ie_se_necessario)='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(x.nr_prescricao,c.nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN x.ie_suspenso='S' THEN  x.ie_suspenso  ELSE null END   ELSE null END   ELSE CASE WHEN x.ie_suspenso='S' THEN  x.ie_suspenso  ELSE null END  END ,
		CASE WHEN GetIEObsProced='S' THEN substr(x.ds_observacao,1,2000)  ELSE null END  		
	order by
		dt_horario,
		dt_suspensao;
	
BEGIN
	ds_sep_bv_w 	:= obter_separador_bv;	
	dt_validade_w	:= current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp;
	open c01;
	loop
	fetch c01 into	current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_procedimento_w,
			nr_seq_horario_w,
			ie_status_horario_w,
			cd_procedimento_w,
			ds_procedimento_w,
			nr_seq_proc_interno_w,
			ie_acm_sn_w,		
			cd_intervalo_w,
			qt_procedimento_w,
			ds_prescricao_w,
			ds_mat_med_assoc_w,
			ie_suspenso_w,
			dt_suspensao_w,
			nr_seq_prot_glic_w,
			current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp,
			nr_seq_proc_cpoe_w,
			ie_status_item_w,
			ds_observacao_W;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_horario_w := adep_gerar_horarios_pck.get_posicao_horario( current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp );
		if (nr_horario_w IS NOT NULL AND nr_horario_w::text <> '') then
			ds_comando_update_w	:=	' update w_adep_t ' ||
							' set hora' || to_char(nr_horario_w) || ' = :vl_hora, ' ||
							' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
							' ds_diluicao = :ds_mat_med_assoc ' ||					
							' where nm_usuario = :nm_usuario ' ||
							' and ie_tipo_item = :ie_tipo ' ||
							' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
							' and nvl(nr_seq_cpoe,nvl(:nr_seq_cpoe,0)) = nvl(:nr_seq_cpoe,0) ' ||
							' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||					
							' and cd_item = :cd_item ' ||
							' and nvl(nr_seq_proc_interno,nvl(:nr_seq_proc_interno,0)) = nvl(:nr_seq_proc_interno,0) ' ||
							' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' ||
							' and nvl(qt_item,0) = nvl(:qt_item,0) ' ||
							' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) '||
							' and ((ie_status_item is null) or (ie_status_item = :ie_status_w))' ||
							' and ((nr_seq_prot_glic is null) or (nr_seq_prot_glic = :nr_seq_prot_glic))' ||
							' and nvl(ds_observacao,''XPTO'') = nvl(:ds_observacao,''XPTO'') ';
			CALL exec_sql_dinamico_bv('ADEP', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
										'nr_prescricao=' || to_char(current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type) || ds_sep_bv_w ||
										'nr_seq_cpoe=' || to_char(nr_seq_proc_cpoe_w) || ds_sep_bv_w || 
										'ds_mat_med_assoc=' || ds_mat_med_assoc_w || ds_sep_bv_w || 
										'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
										'ie_tipo=G' || ds_sep_bv_w ||
										'nr_seq_item=' || to_char(nr_seq_procedimento_w) || ds_sep_bv_w ||
										'cd_item=' || to_char(cd_procedimento_w) || ds_sep_bv_w ||
										'nr_seq_proc_interno=' || to_char(nr_seq_proc_interno_w) || ds_sep_bv_w ||
										'cd_intervalo=' || cd_intervalo_w  || ds_sep_bv_w ||
										'qt_item=' || to_char(qt_procedimento_w) || ds_sep_bv_w ||
										'ds_prescricao=' || ds_prescricao_w || ds_sep_bv_w ||
										'ie_status_w=' || ie_status_item_w || ds_sep_bv_w ||
										'nr_seq_prot_glic=' || nr_seq_prot_glic_w|| ds_sep_bv_w||
										'ds_observacao=' || ds_observacao_w|| ds_sep_bv_w);
			commit;
		end if;
		end;
	end loop;
	close c01;
	CALL Atualizar_adep_controle(nm_usuario_p, nr_atendimento_p, 'CCG', 'N');
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_sincronizar_ccg ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_data_lib_proced_p text, ie_so_proc_setor_usuario_p text, dt_horario_p timestamp, nr_horario_p integer, ie_exibir_dil_ccg_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_palm_p text) FROM PUBLIC;
