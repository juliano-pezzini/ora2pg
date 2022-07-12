-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE plt_gerar_horarios_pck.plt_obter_jejum ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_prescr_usuario_p text, nr_seq_regra_p bigint, ie_edicao_p text, ie_estendidos_p bigint, dt_referencia_p timestamp, ie_exibir_hor_suspensos_p text, dt_plano_p text) AS $body$
DECLARE


	nr_seq_wadep_w		bigint;		
	nr_prescricao_w		bigint;
	cd_jejum_w		varchar(255);
	ds_jejum_w		varchar(255);
	ds_vigencia_w		varchar(255);
	nr_seq_jejum_w		bigint;
	ie_suspenso_w		varchar(1);
	current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15)	varchar(1);
	ie_liberado_w		varchar(1);
	ie_copiar_w		varchar(1);
	dt_fim_w		timestamp;
	dt_extensao_w		timestamp;
	ie_plano_atual_w	varchar(1);
	ie_retrogrado_w		varchar(1);
	ie_pend_assinatura_w 	varchar(1);
	ie_estendido_w		varchar(1);
	dt_validade_prescr_w	timestamp;
	ds_cor_titulo_w			varchar(20);
	ie_curta_duracao_w		varchar(1);
	cd_funcao_origem_w		bigint;
	cd_classif_setor_w		integer;
	ie_interv_farm_w		varchar(1);
	ie_recem_nato_w	  		varchar(1);
	
	
	c01 REFCURSOR;
		
	
BEGIN
	dt_fim_w	:= dt_validade_limite_p + 5;
	ie_copiar_w 	:= plt_obter_se_item_marcado('J', nr_seq_regra_p);
	ds_cor_titulo_w	:= plt_obter_cor_titulo('J',nr_seq_regra_p);

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
		open	c01 for
		SELECT	to_char(c.dt_inicio,'dd/mm/yyyy hh24:mi:ss') || '-' || to_char(CASE WHEN to_char(c.dt_fim, 'mi')='00' THEN  c.dt_fim - 1/86400  ELSE c.dt_fim END ,'dd/mm/yyyy hh24:mi:ss') cd_jejum,
				x.ds_tipo ds_jejum,
				wheb_mensagem_pck.get_texto(1111248, 'DT_INICIO=' || to_char(c.dt_inicio,'dd/mm/yyyy hh24:mi:ss') || ';DT_FIM=' || to_char(c.dt_fim,'dd/mm/yyyy hh24:mi:ss')) ds_vigencia,
				c.nr_sequencia,
				CASE WHEN c.ie_suspenso='N' THEN ''  ELSE c.ie_suspenso END  ie_suspenso,
				substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1) ie_lib_pend_rep,
				plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia) ie_liberado,
				plt_obter_dt_extensao(c.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade) dt_extensao,
				c.nr_prescricao,
				substr(PLT_obter_se_plano_atual(c.nr_prescricao),1,1) ie_plano_atual,
				coalesce(a.ie_prescr_emergencia,'N') ie_retrogrado,
				substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1) ie_pend_assinatura,
				substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(c.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1) ie_estendido,
				a.dt_validade_prescr,
				obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type) ie_curta_duracao,
				a.cd_funcao_origem,
				coalesce(a.ie_prescr_farm, 'N') ie_prescr_farm,
				coalesce(a.ie_recem_nato, 'N') ie_recem_nato
		from	rep_tipo_jejum x,
				rep_jejum c,
				prescr_medica a
		where	x.nr_sequencia = c.nr_seq_tipo
		and		c.nr_prescricao = a.nr_prescricao
		and		a.nr_atendimento = nr_atendimento_p
		and		plt_gerar_horarios_pck.OBTER_SE_MOSTRA_REP_INTER(a.ie_motivo_prescricao) = 'S'
		and		a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint	and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint
		and		((c.dt_inicio between dt_inicial_horarios_p and dt_final_horarios_p) or (c.dt_fim between dt_inicial_horarios_p and dt_final_horarios_p))
		and		((((coalesce(a.dt_liberacao_medico, a.dt_liberacao) IS NOT NULL AND (coalesce(a.dt_liberacao_medico, a.dt_liberacao))::text <> '')) and (ie_prescr_usuario_p = 'N')) or (a.nm_usuario_original = nm_usuario_p))
		and		(((ie_estendidos_p = 0) and (PLT_obter_se_estendido(c.dt_extensao,dt_referencia_p) = 'S')) or
				 ((ie_estendidos_p = 1) and (PLT_obter_se_estendido(c.dt_extensao,dt_referencia_p) = 'N')) or (ie_estendidos_p = 2))
		and		(((ie_edicao_p = 'S') and (plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia) = 'N')) or (ie_edicao_p = 'N'))	
		and		((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.ie_suspenso,'N') <> 'S'))
		group by
			c.dt_inicio,
			c.dt_fim,
			to_char(c.dt_inicio,'dd/mm/yyyy hh24:mi:ss') || '-' || to_char(c.dt_fim,'dd/mm/yyyy hh24:mi:ss'),
			x.ds_tipo,
			c.nr_sequencia,
			substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),
			c.nr_prescricao,
			c.ie_suspenso,
			a.dt_liberacao_medico,
			a.dt_liberacao,
			a.dt_liberacao_farmacia,
			PLT_obter_dt_extensao(c.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),
			a.ie_prescr_emergencia,
			substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1),
			substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(c.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1),
			a.dt_validade_prescr,
			obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type),
			a.cd_funcao_origem,
			a.ie_prescr_farm,
			coalesce(a.ie_recem_nato, 'N');	
	else
		open	c01 for
		SELECT	to_char(c.dt_inicio,'dd/mm/yyyy hh24:mi:ss') || '-' || to_char(c.dt_fim,'dd/mm/yyyy hh24:mi:ss') cd_jejum,
				x.ds_tipo ds_jejum,
				wheb_mensagem_pck.get_texto(1111248, 'DT_INICIO=' || to_char(c.dt_inicio,'dd/mm/yyyy hh24:mi:ss') || ';DT_FIM=' || to_char(c.dt_fim,'dd/mm/yyyy hh24:mi:ss')) ds_vigencia,
				c.nr_sequencia,
				CASE WHEN c.ie_suspenso='N' THEN ''  ELSE c.ie_suspenso END ,
				substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1) ie_lib_pend_rep,
				plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia) ie_liberado,
				PLT_obter_dt_extensao(c.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade) dt_extensao,
				c.nr_prescricao,
				substr(PLT_obter_se_plano_atual(c.nr_prescricao),1,1) ie_plano_atual,
				coalesce(a.ie_prescr_emergencia,'N') ie_retrogrado,
				substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1) ie_pend_assinatura,
				substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(c.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1) ie_estendido,
				a.dt_validade_prescr,
				obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type) ie_curta_duracao,
				a.cd_funcao_origem,
				coalesce(a.ie_prescr_farm, 'N') ie_prescr_farm,
				coalesce(a.ie_recem_nato, 'N') ie_recem_nato
		from	rep_tipo_jejum x,
				rep_jejum c,
				prescr_medica a
		where	x.nr_sequencia = c.nr_seq_tipo
		and		c.nr_prescricao = a.nr_prescricao
		and		a.cd_pessoa_fisica = current_setting('plt_gerar_horarios_pck.cd_pessoa_fisica_w')::varchar(10)
		and		a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint	and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint
		and		PLT_Gerar_Horarios_PCK.OBTER_SE_MOSTRA_REP_INTER(a.ie_motivo_prescricao) = 'S'
		and		((c.dt_inicio between dt_inicial_horarios_p and dt_final_horarios_p) or (c.dt_fim between dt_inicial_horarios_p and dt_final_horarios_p))
		and		((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
		and		(((ie_estendidos_p = 0) and (PLT_obter_se_estendido(c.dt_extensao,dt_referencia_p) = 'S')) or
				 ((ie_estendidos_p = 1) and (PLT_obter_se_estendido(c.dt_extensao,dt_referencia_p) = 'N')) or (ie_estendidos_p = 2))
		and		(((ie_edicao_p = 'S') and (plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia) = 'N')) or (ie_edicao_p = 'N'))	
		and		((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.ie_suspenso,'N') <> 'S'))
		group by
				c.dt_inicio,
				c.dt_fim,
				to_char(c.dt_inicio,'dd/mm/yyyy hh24:mi:ss') || '-' || to_char(c.dt_fim,'dd/mm/yyyy hh24:mi:ss'),
				x.ds_tipo,
				c.nr_sequencia,
				substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),
				c.nr_prescricao,
				c.ie_suspenso,
				a.dt_liberacao_medico,
				a.dt_liberacao,
				a.dt_liberacao_farmacia,
				PLT_obter_dt_extensao(c.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),
				a.ie_prescr_emergencia,
				substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1),
				substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(c.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1),
				a.dt_validade_prescr,
				obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type),
				a.cd_funcao_origem,
				a.ie_prescr_farm,
				coalesce(a.ie_recem_nato, 'N');		
	end if;
	
	loop
	fetch c01 into	cd_jejum_w,
			ds_jejum_w,
			ds_vigencia_w,
			nr_seq_jejum_w,
			ie_suspenso_w,
			current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
			ie_liberado_w,
			dt_extensao_w,
			nr_prescricao_w,
			ie_plano_atual_w,
			ie_retrogrado_w,
			ie_pend_assinatura_w,
			ie_estendido_w,
			dt_validade_prescr_w,
			ie_curta_duracao_w,
			cd_funcao_origem_w,
			ie_interv_farm_w,
			ie_recem_nato_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		select	coalesce(Obter_classif_setor_atend(nr_atendimento_p),0)
		into STRICT	cd_classif_setor_w
		;
			
		if (ie_estendido_w	= 'P') and (coalesce(dt_extensao_w::text, '') = '') then
			dt_extensao_w	:= dt_validade_prescr_w;
		end if;	
		
		if (((ie_estendido_w = 'P') and
			 ((coalesce(cd_funcao_origem_w,924) <> 950) or (ie_curta_duracao_w = 'N'))) or (cd_classif_setor_w = 1)) then
			ie_estendido_w	:= 'N';
		end if;
		
		select	nextval('w_rep_t_seq')
		into STRICT	nr_seq_wadep_w
		;
		
		insert into w_rep_t(
			nr_sequencia,
			nm_usuario,
			ie_tipo_item,
			nr_seq_item,
			cd_item,
			ds_item,
			ds_prescricao,
			nr_agrupamento,
			nr_seq_proc_interno,
			ie_acm_sn,
			ie_status_item,
			ie_pendente_liberacao,
			ie_liberado,
			ie_copiar,
			dt_extensao,
			nr_prescricoes,
			ie_plano_atual,
			ds_hint,
			ie_retrogrado,
			ie_pend_assinatura,
			dt_atualizacao,
			ie_estendido,
			ds_cor_titulo,
			ie_curta_duracao,
			ie_interv_farm,
			ie_item_rn)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'J',
			nr_seq_jejum_w,
			cd_jejum_w,
			ds_jejum_w,
			ds_vigencia_w,
			0,
			0,
			'N',
			ie_suspenso_w,
			current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
			ie_liberado_w,
			CASE WHEN ie_suspenso_w='S' THEN 'N'  ELSE ie_copiar_w END ,
			dt_extensao_w,
			nr_prescricao_w,
			ie_plano_atual_w,
			ds_vigencia_w,
			ie_retrogrado_w,
			ie_pend_assinatura_w,
			clock_timestamp(),
			ie_estendido_w,
			ds_cor_titulo_w,
			ie_curta_duracao_w,
			ie_interv_farm_w,
			ie_recem_nato_w);
		end;
		
	end loop;
	close c01;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_gerar_horarios_pck.plt_obter_jejum ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_prescr_usuario_p text, nr_seq_regra_p bigint, ie_edicao_p text, ie_estendidos_p bigint, dt_referencia_p timestamp, ie_exibir_hor_suspensos_p text, dt_plano_p text) FROM PUBLIC;
