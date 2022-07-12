-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_onc_gerar_horarios_pck.adep_onc_sincronizar_solucao ( nm_usuario_p text, nr_atendimento_p bigint, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_opcao_filtro_p text, dt_filtro_p timestamp, nr_ciclo_p bigint, dt_inicial_horario_p timestamp, dt_final_horario_p timestamp) AS $body$
DECLARE

				
	ds_sep_bv_w		varchar(50);				
	nr_prescricao_w		bigint;
	nr_seq_solucao_w	integer;
	nr_seq_horario_w	bigint;
	ie_status_horario_w	varchar(15);
	ds_comando_update_w	varchar(4000);
	nr_etapa_sol_w		bigint;
	dt_etapa_prev_w		timestamp;
	dt_inicial_w		timestamp;
	dt_final_w		timestamp;
	current_setting('adep_onc_gerar_horarios_pck.dt_horario_w')::timestamp		timestamp;
	nr_horario_w		integer;
	dt_inicio_sol_w		timestamp;
	dt_fim_sol_w		timestamp;
	nr_ciclo_w		smallint;
	ds_dia_ciclo_w		varchar(5);
	nr_seq_onc_w		bigint;
	ie_pre_medicacao_w	varchar(1);
	dt_oncologia_w		timestamp;
	nr_seq_sol_cpoe_w	prescr_material.nr_seq_mat_cpoe%type;
	
	c02 CURSOR FOR
	SELECT	a.nr_prescricao,
		x.nr_seq_solucao,
		CASE WHEN coalesce(c.dt_primeira_checagem::text, '') = '' THEN substr(obter_status_hor_sol_adep(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,a.nr_prescricao,x.nr_seq_solucao),1,15)  ELSE 'Q' END ,
		c.nr_etapa_sol,
		c.dt_horario,
		b.nr_ciclo,
		coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real) ds_dia_ciclo,
		coalesce(coalesce(x.nr_seq_ordem_adep,x.nr_agrupamento),0) nr_seq_ordem_adep,
		coalesce(x.ie_pre_medicacao,'N') ie_pre_medicacao,
		coalesce(b.dt_real, b.dt_prevista) dt_oncologia,
		c.nr_sequencia,
		obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao)
	from	prescr_solucao x,
		prescr_medica a,
		paciente_atendimento b,
		paciente_setor p,
		(SELECT	c.nr_sequencia,
				c.dt_inicio_horario,
				c.dt_fim_horario,
				c.dt_suspensao,
				c.dt_interrupcao,
				c.ie_dose_especial,
				c.nr_seq_processo,
				c.nr_seq_area_prep,
				c.nr_etapa_sol,
				c.dt_prev_fim_horario,
				c.nr_prescricao,
				c.nr_seq_solucao,
				c.dt_horario,
				c.dt_primeira_checagem
		from		prescr_medica a,
				prescr_solucao x,
				prescr_material v,
				prescr_mat_hor c,
				paciente_atendimento b,
				paciente_setor p
		where	a.nr_prescricao	= v.nr_prescricao
		and		v.nr_prescricao = c.nr_prescricao
		and		x.nr_prescricao	= v.nr_prescricao
		and		a.nr_seq_atend	= b.nr_seq_atendimento
		and		b.nr_seq_paciente = p.nr_seq_paciente
		and		x.nr_seq_solucao = v.nr_sequencia_solucao
		and 		v.nr_sequencia = c.nr_seq_material
		and		a.nr_atendimento = nr_atendimento_p
		and		p.cd_pessoa_fisica = a.cd_pessoa_fisica
		and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
		and		obter_se_prescr_lib_adep(coalesce(a.dt_liberacao_medico, x.dt_lib_material), coalesce(a.dt_liberacao, x.dt_lib_material), coalesce(a.dt_liberacao_farmacia, x.dt_lib_farmacia), ie_data_lib_prescr_p) = 'S'
		and		coalesce(c.ie_situacao,'A') = 'A'
		and		coalesce(c.ie_adep,'S') = 'S'
		and		c.ie_agrupador = 4
		and		coalesce(a.ie_recem_nato,'N')	= 'N'
		and		coalesce(x.nr_seq_dialise::text, '') = ''
		and 	((ie_opcao_filtro_p in ('Q','C')) or
				 ((ie_opcao_filtro_p = 'D') and (coalesce(b.dt_real,b.dt_prevista) between trunc(dt_filtro_p) and fim_dia(dt_filtro_p))) or
				 (ie_opcao_filtro_p = 'H' AND c.dt_horario between dt_inicial_horario_p and dt_final_horario_p))
		and		b.nr_ciclo	= coalesce(nr_ciclo_p,b.nr_ciclo)		
		and		((coalesce(c.ie_horario_especial,'N') = 'N') or (x.ie_etapa_especial = 'S'))) c
	where	x.nr_prescricao = c.nr_prescricao
	and		x.nr_seq_solucao = c.nr_seq_solucao
	and		x.nr_prescricao = a.nr_prescricao
	and		c.nr_prescricao = a.nr_prescricao
	and		a.nr_seq_atend	= b.nr_seq_atendimento
	and		b.nr_seq_paciente = p.nr_seq_paciente
	and		a.nr_atendimento = nr_atendimento_p
	and		a.cd_pessoa_fisica = p.cd_pessoa_fisica
	and		obter_se_prescr_lib_adep(coalesce(a.dt_liberacao_medico, x.dt_lib_material), coalesce(a.dt_liberacao, x.dt_lib_material), coalesce(a.dt_liberacao_farmacia, x.dt_lib_farmacia), ie_data_lib_prescr_p) = 'S'
	and		coalesce(x.nr_seq_dialise::text, '') = ''
	and		((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
	and		coalesce(a.ie_recem_nato,'N')	= 'N'
	and 	((ie_opcao_filtro_p in ('Q','C')) or
			 ((ie_opcao_filtro_p = 'D') and (coalesce(b.dt_real,b.dt_prevista) between trunc(dt_filtro_p) and fim_dia(dt_filtro_p))) or
			 (ie_opcao_filtro_p = 'H' AND c.dt_horario between dt_inicial_horario_p and dt_final_horario_p))
	and		b.nr_ciclo	= coalesce(nr_ciclo_p,b.nr_ciclo)	
	group by
			c.dt_horario,
			a.nr_prescricao,
			x.nr_seq_solucao,
			c.nr_sequencia,
			c.dt_inicio_horario,
			c.dt_fim_horario,
			c.dt_interrupcao,
			c.dt_suspensao,
			c.ie_dose_especial,
			c.nr_seq_processo,
			c.dt_primeira_checagem,
			c.nr_seq_area_prep,
			c.nr_etapa_sol,
			b.nr_ciclo,
			coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real),
			coalesce(coalesce(x.nr_seq_ordem_adep,x.nr_agrupamento),0),
			coalesce(x.ie_pre_medicacao,'N'),
			coalesce(b.dt_real, b.dt_prevista),
			obter_nr_seq_cpoe_sol(x.nr_prescricao, x.nr_seq_solucao)
	order by
			c.dt_horario;
	
BEGIN
	ds_sep_bv_w	:= obter_separador_bv;

	open c02;
	loop
	fetch c02 into	nr_prescricao_w,
			nr_seq_solucao_w,
			ie_status_horario_w,
			nr_etapa_sol_w,
			current_setting('adep_onc_gerar_horarios_pck.dt_horario_w')::timestamp,
			nr_ciclo_w,
			ds_dia_ciclo_w,
			nr_seq_onc_w,
			ie_pre_medicacao_w,
			dt_oncologia_w,
			nr_seq_horario_w,
			nr_seq_sol_cpoe_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		nr_horario_w := adep_onc_gerar_horarios_pck.get_posicao_horario( current_setting('adep_onc_gerar_horarios_pck.dt_horario_w')::timestamp );
		if (nr_horario_w IS NOT NULL AND nr_horario_w::text <> '') then
			ds_comando_update_w	:=	' update w_adep_t ' ||
							' set hora' || to_char(nr_horario_w) || ' = :vl_hora, ' ||
							' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao) ' ||
							' where nm_usuario = :nm_usuario ' ||
							' and ie_tipo_item = :ie_tipo ' ||
							' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
							' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||
							' and nr_ciclo = :nr_ciclo ' ||
							' and ds_dia_ciclo = :ds_dia_ciclo ' ||
							' and nr_seq_onc = :nr_seq_onc ' ||
							' and ie_pre_medicacao = :ie_pre_medicacao ' ||
							' and dt_oncologia = :dt_oncologia ' ||
							' and nvl(nr_seq_cpoe,nvl(:nr_seq_cpoe,0)) = nvl(:nr_seq_cpoe,0) ';
							
						
			CALL exec_sql_dinamico_bv('ADEP', ds_comando_update_w,	'vl_hora=S' || to_char(nr_etapa_sol_w)||'H' || ie_status_horario_w || ds_sep_bv_w ||
										'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w || 									
										'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
										'ie_tipo=SOL' || ds_sep_bv_w ||
										'nr_seq_item=' || to_char(nr_seq_solucao_w) || ds_sep_bv_w ||
										'nr_ciclo=' || to_char(nr_ciclo_w) || ds_sep_bv_w ||
										'ds_dia_ciclo=' || ds_dia_ciclo_w || ds_sep_bv_w ||
										'nr_seq_onc=' || to_char(nr_seq_onc_w) || ds_sep_bv_w ||
										'ie_pre_medicacao=' || ie_pre_medicacao_w || ds_sep_bv_w ||
										'dt_oncologia=' || to_char(dt_oncologia_w,'dd/mm/yyyy hh24:mi:ss') || ds_sep_bv_w ||
										'nr_seq_cpoe=' || to_char(nr_seq_sol_cpoe_w) || ds_sep_bv_w);
			commit;
		end if;	
		end;
	end loop;
	close c02;	

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_onc_gerar_horarios_pck.adep_onc_sincronizar_solucao ( nm_usuario_p text, nr_atendimento_p bigint, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_opcao_filtro_p text, dt_filtro_p timestamp, nr_ciclo_p bigint, dt_inicial_horario_p timestamp, dt_final_horario_p timestamp) FROM PUBLIC;