-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_obter_dieta_oral ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_horarios_dietas_orais_p text, ie_exibe_sem_lib_farm_p text, ie_exibe_dietas_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_palm_p text) AS $body$
DECLARE

	cd_refeicao_w		varchar(15);
	ds_refeicao_w		varchar(255);
	current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15)	varchar(1);
	nr_seq_wadep_w		bigint;
	qt_parametro_w		double precision;
	ie_status_item_w	varchar(1);
	ie_horario_w		varchar(1);
	cd_intervalo_w		varchar(255);
	ie_oncologia_w		varchar(1);
	nr_seq_dieta_cpoe_w	prescr_dieta.nr_seq_dieta_cpoe%type;
	ie_nome_dieta_w		varchar(1);
	nm_dieta_w			dieta.nm_dieta%type;
	dt_suspensao_cpoe_w	timestamp;
	ds_bind_cCursor_w	sql_pck.t_dado_bind;
	ds_bind_cCursorAux_w	sql_pck.t_dado_bind;
	
	cCursor REFCURSOR;
	cCursorAux REFCURSOR;
	c03 CURSOR FOR
	SELECT	CASE WHEN coalesce(d.nr_seq_dieta_cpoe::text, '') = '' THEN  a.nr_prescricao  ELSE null END ,
			to_char(d.cd_dieta),
			x.nm_dieta,
			substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
			CASE WHEN coalesce(d.ds_horarios::text, '') = '' THEN  'N'  ELSE 'S' END  ie_horario,
			d.cd_intervalo,
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END  ie_oncologia,
			d.nr_seq_dieta_cpoe
	from	dieta x,
			prescr_dieta d,
			prescr_medica a
	where	x.cd_dieta = d.cd_dieta
	and		d.nr_prescricao	= a.nr_prescricao
	and		obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and		a.nr_atendimento = nr_atendimento_p
	and		a.dt_validade_prescr between dt_validade_limite_p and current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp
	and		(a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')
	and		coalesce(a.dt_liberacao::text, '') = ''
	and 	coalesce(d.dt_suspensao::text, '') = ''
	and 	coalesce(a.dt_suspensao::text, '') = ''
	and		obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'
	and		((ie_exibir_suspensos_p = 'S') or (coalesce(d.dt_suspensao::text, '') = ''))
	and		((ie_exibir_hor_suspensos_p = 'S') or (coalesce(d.dt_suspensao::text, '') = ''))	
	and		((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
	and		((coalesce(a.ie_recem_nato,'N')	= 'N') or (get_ie_recem_nato = 'S'))	
	and	not exists (
			SELECT	1
			from	prescr_dieta_hor c
			where	c.nr_prescricao = d.nr_prescricao
			and	c.nr_prescricao = a.nr_prescricao
			and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')
	and	((ie_exibe_dietas_p = 'N') or ((ie_exibe_dietas_p = 'S') and ((coalesce(a.dt_liberacao_medico::text, '') = '') or (coalesce(dt_liberacao::text, '') = ''))))		
	and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
	group by
			CASE WHEN coalesce(d.nr_seq_dieta_cpoe::text, '') = '' THEN  a.nr_prescricao  ELSE null END ,
			d.cd_dieta,
			x.nm_dieta,
			d.cd_intervalo,
			a.dt_liberacao_medico,
			a.dt_liberacao,
			a.dt_liberacao_farmacia,
			d.ds_horarios,
			CASE WHEN ie_palm_p='S' THEN obter_se_setor_oncologia(a.cd_setor_atendimento)  ELSE null END ,
			d.nr_seq_dieta_cpoe;
	
BEGIN
	CALL adep_gerar_horarios_pck.limparvariaveiscursor();
	ie_nome_dieta_w := adep_gerar_horarios_pck.get_ie_apres_inf_dieta();
	-- CURSOR PRINCIPAL
	if (ie_horarios_dietas_orais_p <> 'N') then	
		-- SELECT GENERICO : Atributos que sao utilizados em todas as consultas deste metodo e/ou podem depender de alguma informacao externa
		PERFORM set_config('adep_gerar_horarios_pck.ds_sql_select_generico_w', ' 			d.cd_intervalo, ' ||
			' 			d.qt_parametro, ' ||
			' 			' || adep_gerar_horarios_pck.iflinha(ie_palm_p='S','obter_se_setor_oncologia(a.cd_setor_atendimento)','null') || ' ie_oncologia, ' ||
			' 			decode(d.dt_suspensao, null, null, ''S''), ' ||
			' 			d.nr_seq_dieta_cpoe, ' ||
			adep_gerar_horarios_pck.iflinha(ie_nome_dieta_w='X',	' decode(c.cd_refeicao, null, null, y.nm_dieta) ',	'null'), false);
		-- WHERE GENERICO : Restricoes que sao utilizadas em todas as consultas deste metodo e/ou podem depender de alguma informacao externa
		PERFORM set_config('adep_gerar_horarios_pck.ds_sql_where_generico_w', ' and		nvl(c.ie_situacao,''A'') = ''A'' ' ||
			' and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = ''S'' ' ||
			' and		a.nr_atendimento = :nr_atendimento_p ' ||
			' and		obter_se_mostra_dieta(d.cd_dieta) = ''S'' ' ||
			' and		obter_se_exibir_rep_adep_setor(:cd_setor_paciente_p ,a.cd_setor_atendimento,nvl(a.ie_adep,''S'')) = ''S'' ' ||
			' and		a.dt_validade_prescr between :dt_validade_limite_p and :dt_fim_w ' ||
			' and		c.dt_horario between :dt_inicial_horarios_p and :dt_final_horarios_p ' ||
			adep_gerar_horarios_pck.iflinha(get_ie_recem_nato='S',			'', ' and		nvl(a.ie_recem_nato,''N'') = ''N'' ') ||
			adep_gerar_horarios_pck.iflinha(ie_exibir_suspensos_p='S',		'', ' and		d.dt_suspensao is null ') ||
			adep_gerar_horarios_pck.iflinha(ie_exibir_hor_realizados_p='S',	'', ' and		c.dt_fim_horario is null ') ||
			adep_gerar_horarios_pck.iflinha(ie_exibir_hor_suspensos_p='S',	'', ' and		nvl(c.dt_suspensao,d.dt_suspensao) is null ') ||
			adep_gerar_horarios_pck.iflinha(ie_prescr_setor_p='N',			'', ' and		a.cd_setor_atendimento = :cd_setor_paciente_p  ') ||
			adep_gerar_horarios_pck.iflinha(get_ie_vigente='N',				'', ' and		sysdate between a.dt_inicio_prescr and a.dt_validade_prescr + :get_minutos_vigente /1440 ') ||
			' and		((obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, :ie_data_lib_prescr_p , a.ie_lib_farm) = ''S'')' || adep_gerar_horarios_pck.iflinha(ie_exibe_sem_lib_farm_p = 'S',' or (nvl(a.ie_prescr_nutricao, ''N'') = ''S'')','') || ') ' ||
			'', false);
		-- SELECT DO CURSOR
		PERFORM set_config('adep_gerar_horarios_pck.ds_sql_cursor_w', current_setting('adep_gerar_horarios_pck.ds_sql_cursor_w')::varchar(30000) ||
							' select	' ||
							' 			c.cd_refeicao, ' ||
							'		  	obter_valor_dominio_idioma(99, c.cd_refeicao, wheb_usuario_pck.get_nr_seq_idioma), ' ||										
							current_setting('adep_gerar_horarios_pck.ds_sql_select_generico_w')::varchar(10000) ||
							' from	prescr_dieta d, ' ||
							' 			prescr_dieta_hor c, ' ||
							' 			prescr_medica a, ' ||
							' 			dieta y ' ||
							' where		d.nr_prescricao = c.nr_prescricao ' ||
							' and		d.nr_prescricao = a.nr_prescricao ' ||
							' and		c.nr_prescricao = a.nr_prescricao ' ||
							' and		c.nr_seq_dieta	= d.nr_sequencia ' ||
							' and		y.cd_dieta	= d.cd_dieta ' ||
							' and		obter_se_mostra_dieta(d.cd_dieta) = ''S'' ' ||
							' and		c.cd_refeicao is not null	 ' ||
							current_setting('adep_gerar_horarios_pck.ds_sql_where_generico_w')::varchar(10000) ||
							' group by	' ||
							' 			c.cd_refeicao, ' ||
							' 			d.cd_intervalo, ' ||
              '       obter_valor_dominio_idioma(99, c.cd_refeicao, wheb_usuario_pck.get_nr_seq_idioma), ' ||
							adep_gerar_horarios_pck.iflinha(ie_nome_dieta_w='X',	' decode(c.cd_refeicao, null, null, y.nm_dieta) ',	' null ') || ', ' ||
							'			d.dt_suspensao, ' ||
							' 			d.nr_seq_dieta_cpoe, ' ||
							' 			' || adep_gerar_horarios_pck.iflinha(ie_palm_p='S',	'obter_se_setor_oncologia(a.cd_setor_atendimento)',	'null') || ', ' ||
							' 			d.qt_parametro ' ||
							' union ' ||
							' select	' ||
							' 			to_char(d.cd_dieta), ' ||
							' 			y.nm_dieta, ' ||																
							current_setting('adep_gerar_horarios_pck.ds_sql_select_generico_w')::varchar(10000) ||
							' from		dieta y, ' ||
							' 			prescr_dieta d, ' ||
							' 			prescr_dieta_hor c, ' ||
							' 			prescr_medica a ' ||
							' where		y.cd_dieta	= d.cd_dieta ' ||
							' and		d.nr_prescricao = c.nr_prescricao ' ||
							' and		d.nr_prescricao = a.nr_prescricao ' ||
							' and		c.nr_prescricao = a.nr_prescricao ' ||
							' and		c.nr_seq_dieta	= d.nr_sequencia ' ||
							' and		obter_se_mostra_dieta(d.cd_dieta) = ''S'' ' ||
							' and		c.cd_refeicao is null	 ' ||
							current_setting('adep_gerar_horarios_pck.ds_sql_where_generico_w')::varchar(10000) ||
							' group by	' ||
							' 			d.cd_dieta, ' ||
							' 			d.cd_intervalo, ' ||
							' 			d.dt_suspensao, ' ||
							' 			d.nr_seq_dieta_cpoe, ' ||
							' 			y.nm_dieta, ' ||		
							adep_gerar_horarios_pck.iflinha(ie_nome_dieta_w='X',	' decode(c.cd_refeicao, null, null, y.nm_dieta) ',	' null ') || ', ' ||							
							' 			' || adep_gerar_horarios_pck.iflinha(ie_palm_p='S',	'obter_se_setor_oncologia(a.cd_setor_atendimento)',	'null') || ', ' ||
							' 			d.qt_parametro ', false);
	else
		-- SELECT GENERICO : Atributos que sao utilizados em todas as consultas deste metodo e/ou podem depender de alguma informacao externa
		PERFORM set_config('adep_gerar_horarios_pck.ds_sql_select_generico_w', '			to_char(d.cd_dieta), ' ||
			'			x.nm_dieta, ' ||
			'			d.cd_intervalo, ' ||
			'			d.qt_parametro, ' ||
			' 			' || adep_gerar_horarios_pck.iflinha(ie_palm_p='S','obter_se_setor_oncologia(a.cd_setor_atendimento)','null') || ' ie_oncologia, ', false);
		-- WHERE GENERICO : Restricoes que sao utilizadas em todas as consultas deste metodo e/ou podem depender de alguma informacao externa
		PERFORM set_config('adep_gerar_horarios_pck.ds_sql_where_generico_w', ' and		a.nr_atendimento = :nr_atendimento_p ' ||
			' and		obter_se_exibir_rep_adep_setor(:cd_setor_paciente_p ,a.cd_setor_atendimento,nvl(a.ie_adep,''S'')) = ''S'' ' ||
			' and		a.dt_validade_prescr between :dt_validade_limite_p and :dt_fim_w ' ||
			adep_gerar_horarios_pck.iflinha(get_ie_recem_nato='S',			'', ' and		nvl(a.ie_recem_nato,''N'') = ''N'' ') ||
			adep_gerar_horarios_pck.iflinha(ie_exibir_suspensos_p='S',		'', ' and		d.dt_suspensao is null ') ||
			adep_gerar_horarios_pck.iflinha(ie_prescr_setor_p='N',			'', ' and		a.cd_setor_atendimento = :cd_setor_paciente_p  ') ||
			adep_gerar_horarios_pck.iflinha(get_ie_vigente='N',				'', ' and		sysdate between a.dt_inicio_prescr and a.dt_validade_prescr + :get_minutos_vigente /1440 ') ||
			' and		((obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, :ie_data_lib_prescr_p , a.ie_lib_farm) = ''S'')' || adep_gerar_horarios_pck.iflinha(ie_exibe_sem_lib_farm_p = 'S',' or (nvl(a.ie_prescr_nutricao, ''N'') = ''S'')','') || ') ' ||
			'', false);
		-- SELECT DO CURSOR
		PERFORM set_config('adep_gerar_horarios_pck.ds_sql_cursor_w', current_setting('adep_gerar_horarios_pck.ds_sql_cursor_w')::varchar(30000) ||
							' select	' ||
							current_setting('adep_gerar_horarios_pck.ds_sql_select_generico_w')::varchar(10000) ||							
							' 			substr(obter_status_hor_dieta_oral(c.dt_fim_horario,c.dt_suspensao),1,1), ' ||							
							' 			d.nr_seq_dieta_cpoe, ' ||
							'			null '||
							' from		dieta x, ' ||
							'			prescr_dieta d, ' ||
							'			prescr_dieta_hor c, ' ||
							'			prescr_medica a ' ||
							' where		x.cd_dieta = d.cd_dieta ' ||
							' and		d.nr_prescricao = c.nr_prescricao ' ||
							' and		d.nr_prescricao	= a.nr_prescricao ' ||
							' and		c.nr_prescricao = a.nr_prescricao ' ||
							' and		c.nr_seq_dieta	= d.nr_sequencia	 ' ||
							' and		obter_Se_mostra_dieta(d.cd_dieta) = ''S'' ' ||
							' and		obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, :ie_data_lib_prescr_p , a.ie_lib_farm) = ''S'' ' ||
							' and		nvl(c.ie_situacao,''A'') = ''A'' ' ||
							' and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = ''S'' ' ||
							' and		c.dt_horario between :dt_inicial_horarios_p and :dt_final_horarios_p ' ||
							adep_gerar_horarios_pck.iflinha(ie_exibir_hor_realizados_p='S',	'',	' and		c.dt_fim_horario is null ') ||
							adep_gerar_horarios_pck.iflinha(ie_exibir_hor_suspensos_p='S',	'',	' and		nvl(c.dt_suspensao,d.dt_suspensao) is null ') ||
							current_setting('adep_gerar_horarios_pck.ds_sql_where_generico_w')::varchar(10000) ||
							' group by	' ||
							'			d.cd_dieta, ' ||
							'			d.cd_intervalo, ' ||
							'			x.nm_dieta, ' ||
							'			c.dt_fim_horario, ' ||
							' 			d.nr_seq_dieta_cpoe, ' ||
							'			c.dt_suspensao, ' ||
							' 			' || adep_gerar_horarios_pck.iflinha(ie_palm_p='S',	'obter_se_setor_oncologia(a.cd_setor_atendimento)',	'null') || ', ' ||
							'			null, ' ||
							'			d.qt_parametro ', false);
						if (ie_exibe_dietas_p = 'S') then
							PERFORM set_config('adep_gerar_horarios_pck.ds_sql_cursor_w', current_setting('adep_gerar_horarios_pck.ds_sql_cursor_w')::varchar(30000) ||
								' union ' ||
								' select	' ||
								current_setting('adep_gerar_horarios_pck.ds_sql_select_generico_w')::varchar(10000) ||								
								'			substr(obter_status_hor_dieta_oral(null,d.dt_suspensao),1,1), ' ||								
								' 			d.nr_seq_dieta_cpoe, ' ||
								'			null' ||
								' from		dieta x, ' ||
								'			prescr_dieta d,	 ' ||
								'			prescr_medica a ' ||
								' where		x.cd_dieta = d.cd_dieta ' ||
								' and		d.nr_prescricao	= a.nr_prescricao ' ||
								' and		nvl(a.dt_liberacao_medico,a.dt_liberacao) is not null ' ||
								' and		obter_Se_mostra_dieta(d.cd_dieta) = ''S'' ' ||
								' and		not exists(	select	1 ' ||
								'						from	prescr_dieta_hor c ' ||
								'						where	c.nr_prescricao = d.nr_prescricao ' ||
								'						and		c.nr_prescricao = a.nr_prescricao ' ||
								'						and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = ''S'') ' ||
								adep_gerar_horarios_pck.iflinha(ie_exibir_hor_suspensos_p='S',	'',	' and		d.dt_suspensao is null ') ||
								current_setting('adep_gerar_horarios_pck.ds_sql_where_generico_w')::varchar(10000) ||
								' group by	' ||
								'			d.cd_dieta, ' ||
								'			d.cd_intervalo, ' ||
								'			x.nm_dieta,	 ' ||
								'			d.dt_suspensao, ' ||
								' 			d.nr_seq_dieta_cpoe, ' ||
								' 			' || adep_gerar_horarios_pck.iflinha(ie_palm_p='S',	'obter_se_setor_oncologia(a.cd_setor_atendimento)',	'null') || ', ' ||
								'			null, ' ||
								'			d.qt_parametro ', false);
		end if;
	end if;
	if (ie_lib_pend_rep_p = 'S') then
		-- CURSOR SECUNDaRIO
		PERFORM set_config('adep_gerar_horarios_pck.ds_sql_cursor_aux_w', current_setting('adep_gerar_horarios_pck.ds_sql_cursor_aux_w')::varchar(30000) ||
							' select	a.nr_prescricao, ' ||
							'			to_char(d.cd_dieta), ' ||
							'			x.nm_dieta, ' ||
							'			substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep, ' ||
							'			decode(d.ds_horarios, null, ''N'', ''S'') ie_horario, ' ||
							'			d.cd_intervalo, ' ||							
							'			' || adep_gerar_horarios_pck.iflinha(ie_palm_p='S','obter_se_setor_oncologia(a.cd_setor_atendimento)','null') || ' ie_oncologia, ' ||
							' 			d.nr_seq_dieta_cpoe ' ||
							' from		dieta x, ' ||
							'			prescr_dieta d, ' ||
							'			prescr_medica a ' ||
							' where		x.cd_dieta = d.cd_dieta ' ||
							' and		d.nr_prescricao		= a.nr_prescricao ' ||
							' and		a.dt_liberacao_medico is not null ' ||
							' and		coalesce(a.dt_liberacao,d.dt_suspensao,a.dt_suspensao) is null ' ||
							' and		obter_se_mostra_dieta(d.cd_dieta) = ''S'' ' ||
							' and		not exists(	' ||
												'	select	1 ' ||
												'	from	prescr_dieta_hor c ' ||
												'	where	c.nr_prescricao = d.nr_prescricao ' ||
												'	and		c.nr_prescricao = a.nr_prescricao ' ||
												'	and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = ''S'') ' ||
							' and		a.nr_atendimento = :nr_atendimento_p ' ||
							' and		obter_se_exibir_rep_adep_setor(:cd_setor_paciente_p ,a.cd_setor_atendimento,nvl(a.ie_adep,''S'')) = ''S'' ' ||
							' and		a.dt_validade_prescr between :dt_validade_limite_p and :dt_fim_w ' ||
							' and		obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,:dt_inicial_horarios_p,:dt_final_horarios_p) = ''S'' ' ||
							adep_gerar_horarios_pck.iflinha(ie_exibir_suspensos_p='S',		'',	' and		d.dt_suspensao is null ') ||
							adep_gerar_horarios_pck.iflinha(ie_exibir_hor_suspensos_p='S',	'',	' and		d.dt_suspensao is null ') ||
							adep_gerar_horarios_pck.iflinha(ie_prescr_setor_p='N',			'',	' and		a.cd_setor_atendimento = :cd_setor_paciente_p  ') ||
							adep_gerar_horarios_pck.iflinha(get_ie_recem_nato='S',			'',	' and		nvl(a.ie_recem_nato,''N'') = ''N'' ') ||
							adep_gerar_horarios_pck.iflinha(ie_exibe_dietas_p='N',			'',	' and		coalesce(a.dt_liberacao_medico,dt_liberacao) is null ') ||
							adep_gerar_horarios_pck.iflinha(get_ie_vigente='N',				'',	' and		sysdate between a.dt_inicio_prescr and a.dt_validade_prescr + :get_minutos_vigente /1440 ') ||
							' group by ' ||
							'			a.nr_prescricao, ' ||
							'			d.cd_dieta, ' ||
							'			x.nm_dieta, ' ||
							'			d.cd_intervalo, ' ||
							' 			d.nr_seq_dieta_cpoe, ' ||
							'			a.dt_liberacao_medico, ' ||
							'			a.dt_liberacao, ' ||
							'			a.dt_liberacao_farmacia, ' ||
							'			d.ds_horarios, ' ||
							'			' || adep_gerar_horarios_pck.iflinha(ie_palm_p='S','obter_se_setor_oncologia(a.cd_setor_atendimento)','null') || ' ', false);
	end if;
	-- Sempre que adicionar um novo atributo, inserir na outra consulta contida no select
	ds_bind_cCursor_w := sql_pck.bind_variable(':nr_atendimento_p', nr_atendimento_p, ds_bind_cCursor_w);
	ds_bind_cCursor_w := sql_pck.bind_variable(':cd_setor_paciente_p', cd_setor_paciente_p, ds_bind_cCursor_w);
	ds_bind_cCursor_w := sql_pck.bind_variable(':dt_validade_limite_p', dt_validade_limite_p, ds_bind_cCursor_w, 'DATAHORA');
	ds_bind_cCursor_w := sql_pck.bind_variable(':dt_fim_w', current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp, ds_bind_cCursor_w, 'DATAHORA');
	ds_bind_cCursor_w := sql_pck.bind_variable(':dt_inicial_horarios_p', dt_inicial_horarios_p, ds_bind_cCursor_w, 'DATAHORA');
	ds_bind_cCursor_w := sql_pck.bind_variable(':dt_final_horarios_p', dt_final_horarios_p, ds_bind_cCursor_w, 'DATAHORA');
	ds_bind_cCursor_w := sql_pck.bind_variable(':ie_data_lib_prescr_p', ie_data_lib_prescr_p, ds_bind_cCursor_w);
	ds_bind_cCursor_w := sql_pck.bind_variable(':get_minutos_vigente', get_minutos_vigente, ds_bind_cCursor_w);
	ds_bind_cCursor_w := sql_pck.executa_sql_cursor(current_setting('adep_gerar_horarios_pck.ds_sql_cursor_w')::varchar(30000), ds_bind_cCursor_w);
	--open cCursor for ds_sql_cursor_w;
	loop
	fetch cCursor into	
		cd_refeicao_w,
		ds_refeicao_w,
		cd_intervalo_w,
		qt_parametro_w,
		ie_oncologia_w,
		ie_status_item_w,
		nr_seq_dieta_cpoe_w,
		nm_dieta_w;
	EXIT WHEN NOT FOUND; /* apply on cCursor */
		begin
		--Dieta
		dt_suspensao_cpoe_w := cpoe_obter_dt_suspensao(nr_seq_dieta_cpoe_w, 'N');
		if	dt_suspensao_cpoe_w <= clock_timestamp() then
			ds_refeicao_w := wheb_mensagem_pck.get_texto(820376) || ' ' || substr(ds_refeicao_w,1,240);
		elsif (dt_suspensao_cpoe_w > clock_timestamp()) then
			ds_refeicao_w := '(' || wheb_mensagem_pck.get_texto(1061446, 'DT_SUSPENSAO=' || TO_CHAR(dt_suspensao_cpoe_w, pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)))) || ') ' || substr(ds_refeicao_w,1,240);
		end if;
		if	(nm_dieta_w IS NOT NULL AND nm_dieta_w::text <> '' AND ie_nome_dieta_w = 'X') then
			ds_refeicao_w	:= ds_refeicao_w || ' - ' || nm_dieta_w;	
		end if;
		select	nextval('w_adep_t_seq')
		into STRICT	nr_seq_wadep_w
		;
		insert into w_adep_t(
			nr_sequencia,
			nm_usuario,
			ie_tipo_item,
			cd_item,
			ds_item,
			ie_acm_sn,
			ie_diferenciado,
			nr_seq_proc_interno,
			nr_agrupamento,
			ie_status_item,
			cd_intervalo,
			ie_oncologia,
			qt_item,
			nr_seq_cpoe)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'D',
			cd_refeicao_w,
			substr(ds_refeicao_w,1,240),
			'N',
			'N',
			0,
			0,
			ie_status_item_w,
			cd_intervalo_w,
			ie_oncologia_w,
			qt_parametro_w,
			nr_seq_dieta_cpoe_w);
		if (ie_lib_pend_rep_p = 'S') then
			begin
			ds_bind_cCursorAux_w := sql_pck.bind_variable(':nr_atendimento_p', nr_atendimento_p, ds_bind_cCursorAux_w);
			ds_bind_cCursorAux_w := sql_pck.bind_variable(':cd_setor_paciente_p', cd_setor_paciente_p, ds_bind_cCursorAux_w);
			ds_bind_cCursorAux_w := sql_pck.bind_variable(':dt_validade_limite_p', dt_validade_limite_p, ds_bind_cCursorAux_w, 'DATAHORA');
			ds_bind_cCursorAux_w := sql_pck.bind_variable(':dt_fim_w', current_setting('adep_gerar_horarios_pck.dt_fim_w')::timestamp, ds_bind_cCursorAux_w, 'DATAHORA');
			ds_bind_cCursorAux_w := sql_pck.bind_variable(':dt_inicial_horarios_p', dt_inicial_horarios_p, ds_bind_cCursorAux_w, 'DATAHORA');
			ds_bind_cCursorAux_w := sql_pck.bind_variable(':dt_final_horarios_p', dt_final_horarios_p, ds_bind_cCursorAux_w, 'DATAHORA');
			ds_bind_cCursorAux_w := sql_pck.bind_variable(':ie_data_lib_prescr_p', ie_data_lib_prescr_p, ds_bind_cCursorAux_w);
			ds_bind_cCursorAux_w := sql_pck.bind_variable(':get_minutos_vigente', get_minutos_vigente, ds_bind_cCursorAux_w);
			ds_bind_cCursorAux_w := sql_pck.executa_sql_cursor(current_setting('adep_gerar_horarios_pck.ds_sql_cursor_aux_w')::varchar(30000), ds_bind_cCursorAux_w);
			loop
			fetch cCursorAux into	
				current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
				cd_refeicao_w,
				ds_refeicao_w,
				current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
				ie_horario_w,
				cd_intervalo_w,				
				ie_oncologia_w,
				nr_seq_dieta_cpoe_w;
			EXIT WHEN NOT FOUND; /* apply on cCursorAux */
				begin
				--Dieta
				dt_suspensao_cpoe_w := cpoe_obter_dt_suspensao(nr_seq_dieta_cpoe_w, 'N');
				if	dt_suspensao_cpoe_w <= clock_timestamp() then
					ds_refeicao_w := wheb_mensagem_pck.get_texto(820376) || ' ' || substr(ds_refeicao_w,1,240);
				elsif (dt_suspensao_cpoe_w > clock_timestamp()) then
					ds_refeicao_w := '(' || wheb_mensagem_pck.get_texto(1061446, 'DT_SUSPENSAO=' || TO_CHAR(dt_suspensao_cpoe_w, pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)))) || ') ' || substr(ds_refeicao_w,1,240);
				end if;
				select	nextval('w_adep_t_seq')
				into STRICT	nr_seq_wadep_w
				;
				insert into w_adep_t(
					nr_sequencia,
					nm_usuario,
					ie_tipo_item,
					cd_item,
					ds_item,
					ie_acm_sn,
					ie_diferenciado,
					nr_seq_proc_interno,
					nr_agrupamento,
					ie_pendente_liberacao,
					nr_prescricao,
					ie_horario,
					cd_intervalo,
					ie_oncologia,
					nr_seq_cpoe)
				values (
					nr_seq_wadep_w,
					nm_usuario_p,
					'D',
					cd_refeicao_w,
					substr(ds_refeicao_w,1,240),
					'N',
					'N',
					0,
					0,
					current_setting('adep_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
					current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
					ie_horario_w,
					cd_intervalo_w,
					ie_oncologia_w,
					nr_seq_dieta_cpoe_w);
				end;
			end loop;
			close cCursorAux;
			end;
		end if;
		end;
	end loop;
	close cCursor;
	commit;
	CALL adep_gerar_horarios_pck.limparvariaveiscursor();
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_obter_dieta_oral ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_horarios_dietas_orais_p text, ie_exibe_sem_lib_farm_p text, ie_exibe_dietas_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_palm_p text) FROM PUBLIC;