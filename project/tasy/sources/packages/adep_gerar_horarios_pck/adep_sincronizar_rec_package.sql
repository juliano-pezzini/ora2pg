-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_sincronizar_rec ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_quimio_p text) AS $body$
DECLARE
				
	ds_sep_bv_w		varchar(50);
	nr_seq_recomendacao_w	integer;
	nr_seq_horario_w	bigint;
	ie_status_horario_w	varchar(1);
	ie_status_hora_w	varchar(1);
	cd_recomendacao_w	varchar(255);
	ds_recomendacao_w	varchar(4000);
	ie_acm_sn_w		varchar(1);
	cd_intervalo_w		varchar(7);
	qt_recomendacao_w	double precision;
	ds_intervalo_w		varchar(255);
	ds_comando_update_w	varchar(4000);
	current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp	timestamp;
	nr_horario_w	integer;
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();
	nr_seq_rec_cpoe_w	prescr_recomendacao.nr_seq_rec_cpoe%type;	
	c01 CURSOR FOR	
	SELECT	a.nr_prescricao,
			c.nr_seq_recomendacao,
			c.nr_sequencia,
			substr(coalesce(Obter_status_recomendacao(x.nr_prescricao, x.nr_sequencia, c.nr_sequencia), obter_status_hor_rec(c.dt_fim_horario,c.dt_suspensao)),1,1),			
			CASE WHEN obter_se_acm_sn(x.ie_acm,x.ie_se_necessario)='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_rec(a.nr_prescricao,c.nr_seq_recomendacao,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN x.ie_suspenso='S' THEN  x.ie_suspenso  ELSE null END   ELSE null END   ELSE CASE WHEN x.ie_suspenso='S' THEN  x.ie_suspenso  ELSE null END  END ,
			coalesce(substr(coalesce(to_char(x.cd_recomendacao),x.ds_recomendacao),1,255),' ') cd_recomendacao,
			substr(coalesce(y.ds_tipo_recomendacao,x.ds_recomendacao),1,200) ds_recomendacao,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,
			x.cd_intervalo,
			x.qt_recomendacao,
			obter_desc_acm_sn(x.ie_acm, x.ie_se_necessario) || ' ' || substr(w.ds_prescricao,1,200) ds_prescricao,
			c.dt_horario,
			x.nr_seq_rec_cpoe
	FROM prescr_rec_hor c, prescr_medica a, prescr_recomendacao x
LEFT OUTER JOIN intervalo_prescricao w ON (x.cd_intervalo = w.cd_intervalo)
LEFT OUTER JOIN tipo_recomendacao y ON (x.cd_recomendacao = y.cd_tipo_recomendacao)
WHERE x.nr_prescricao = c.nr_prescricao and x.nr_sequencia = c.nr_seq_recomendacao and x.nr_prescricao = a.nr_prescricao and c.nr_prescricao = a.nr_prescricao and obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S' and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w and ((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w = 'S')) and ((ie_data_lib_prescr_p = 'F') or (obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p, a.ie_lib_farm) = 'S')) and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and coalesce(c.ie_situacao,'A') = 'A' and ((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')) and ((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = '')) and ((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'REC',
																		cd_estabelecimento_p, 
																		cd_setor_usuario_p, 
																		cd_perfil_p, 
																		null, 
																		null, 
																		null, 
																		null,
																		a.cd_Setor_atendimento,
																		null,
																		null,			-- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e nao haviam passado nada
																		null) = 'S')))  -- nr_seq_exame_p
  and c.dt_horario between dt_horario_inicio_sinc_w and dt_horario_fim_sinc_w and ((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p)) and Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' and ((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440)) and ((ie_quimio_p = 'S') or (coalesce(a.nr_seq_atend::text, '') = '')) group by
		c.dt_horario,
		a.nr_prescricao,
		c.nr_seq_recomendacao,
		c.nr_sequencia,
		c.dt_fim_horario,
		c.dt_suspensao,
		substr(coalesce(Obter_status_recomendacao(x.nr_prescricao, x.nr_sequencia, c.nr_sequencia), obter_status_hor_rec(c.dt_fim_horario,c.dt_suspensao)),1,1),
		substr(obter_status_hor_rec(c.dt_fim_horario,c.dt_suspensao),1,1),
		coalesce(substr(coalesce(to_char(x.cd_recomendacao),x.ds_recomendacao),1,200),' '),
		coalesce(to_char(x.cd_recomendacao),x.ds_recomendacao),
		coalesce(y.ds_tipo_recomendacao,x.ds_recomendacao),
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario),
		x.cd_intervalo,
		x.qt_recomendacao,
		x.ie_acm,
		obter_desc_acm_sn(x.ie_acm, x.ie_se_necessario) || ' ' || substr(w.ds_prescricao,1,200),
		CASE WHEN obter_se_acm_sn(x.ie_acm,x.ie_se_necessario)='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_rec(a.nr_prescricao,c.nr_seq_recomendacao,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN x.ie_suspenso='S' THEN  x.ie_suspenso  ELSE null END   ELSE null END   ELSE CASE WHEN x.ie_suspenso='S' THEN  x.ie_suspenso  ELSE null END  END ,
		x.nr_seq_rec_cpoe
	order by
		c.dt_horario,
		c.dt_suspensao;
	
BEGIN
	ds_sep_bv_w 	:= obter_separador_bv;
	open c01;
	loop
	fetch c01 into	current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
			nr_seq_recomendacao_w,
			nr_seq_horario_w,
			ie_status_horario_w,
			ie_status_hora_w,
			cd_recomendacao_w,
			ds_recomendacao_w,
			ie_acm_sn_w,		
			cd_intervalo_w,
			qt_recomendacao_w,
			ds_intervalo_w,
			current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp,
			nr_seq_rec_cpoe_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin		
		nr_horario_w := adep_gerar_horarios_pck.get_posicao_horario( current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp );
		if (nr_horario_w IS NOT NULL AND nr_horario_w::text <> '') then
			ds_comando_update_w	:=	' update w_adep_t ' ||
							' set hora' || to_char(nr_horario_w) || ' = :vl_hora, ' ||
							' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao) ' ||
							' where nm_usuario = :nm_usuario ' ||
							' and ie_tipo_item = :ie_tipo ' ||
							' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
							' and nvl(nr_seq_cpoe,nvl(:nr_seq_cpoe,0)) = nvl(:nr_seq_cpoe,0) ' ||
							' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||					
							' and cd_item = :cd_item ' ||
							' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' ||
							' and nvl(qt_item,0) = nvl(:qt_item,0) ' ||
							' and ((ie_status_item is null) or (ie_status_item = :ie_status_w))' ||
							' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) ';
			CALL exec_sql_dinamico_bv('ADEP', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
										'nr_prescricao=' || to_char(current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type) || ds_sep_bv_w ||
										'nr_seq_cpoe=' || to_char(nr_seq_rec_cpoe_w) || ds_sep_bv_w || 
										'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
										'ie_tipo=R' || ds_sep_bv_w ||
										'nr_seq_item='|| to_char(nr_seq_recomendacao_w) || ds_sep_bv_w ||
										'cd_item=' || to_char(cd_recomendacao_w) || ds_sep_bv_w ||
										'cd_intervalo=' || cd_intervalo_w  || ds_sep_bv_w ||
										'qt_item=' || to_char(qt_recomendacao_w) || ds_sep_bv_w ||
										'ie_status_w=' || ie_status_hora_w|| ds_sep_bv_w ||
										'ds_prescricao=' || ds_intervalo_w || ds_sep_bv_w );
			commit;
		end if;
		end;
	end loop;
	close c01;
	CALL Atualizar_adep_controle(nm_usuario_p, nr_atendimento_p, 'R', 'N');
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_sincronizar_rec ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_quimio_p text) FROM PUBLIC;