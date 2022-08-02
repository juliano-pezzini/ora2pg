-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reverter_susp_etapa_hor_sol ( cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_seq_horario_p bigint, nr_etapa_sol_p bigint, ie_tipo_solucao_p text, nr_seq_motivo_p bigint) AS $body$
DECLARE

 
ie_status_item_w	varchar(1);
qt_volume_etapa_w	double precision;
nr_sequencia_w		bigint;
dt_horario_w		timestamp;
nr_etapa_sol_w		bigint;
nr_seq_horario_w	bigint;
qt_atualizados_w	bigint;
ie_consiste_etapa_w	varchar(15);


BEGIN 
 
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (coalesce(coalesce(nr_seq_horario_p,nr_etapa_sol_p),0) > 0) then 
 
 
	if (ie_tipo_solucao_p = 1) then -- Solução 
		select	coalesce(max(ie_suspenso),'N') 
		into STRICT	ie_status_item_w 
		from	prescr_solucao 
		where	nr_prescricao	= nr_prescricao_p 
		and	nr_seq_solucao	= nr_seq_solucao_p;
 
		if (ie_status_item_w = 'S') then 
			-- O item já foi suspenso na prescrição, sendo assim, não será possível reverter a etapa/horário suspenso! 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(196186);
		elsif (ie_status_item_w = 'T') then 
			-- Este item já foi terminado, não será possível reverter a suspensão desta etapa/horário. 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(213227);
		end if;
 
		nr_etapa_sol_w		:= coalesce(nr_etapa_sol_p,0);
		nr_seq_horario_w	:= nr_seq_horario_p;
		 
		if (nr_etapa_sol_w = 0) and (coalesce(nr_seq_horario_w,0) > 0) then 
 
			select	max(dt_horario) 
			into STRICT	dt_horario_w 
			from	prescr_mat_hor 
			where	nr_seq_solucao = nr_seq_solucao_p 
			and		nr_prescricao = nr_prescricao_p 
			and		nr_sequencia = nr_seq_horario_w;
			 
			nr_etapa_sol_w	:= Obter_etapa_horario_susp_sol(nr_prescricao_p, nr_seq_solucao_p, dt_horario_w);
		else 
			select	max(dt_horario) 
			into STRICT	dt_horario_w 
			from	prescr_mat_hor 
			where	nr_etapa_sol = nr_etapa_sol_w 
			and		Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S' 
			and		(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '') 
			and		ie_agrupador in (4) 
			and		nr_seq_solucao = nr_seq_solucao_p 
			and		nr_prescricao = nr_prescricao_p;
		end if;
		 
		select	coalesce(max('S'),'N') 
		into STRICT	ie_consiste_etapa_w 
		from	prescr_mat_hor 
		where	coalesce(nr_seq_horario_w,0) <> nr_sequencia 
		and		dt_horario > dt_horario_w 
		and		coalesce(nr_etapa_sol,nr_etapa_sol_w+1) > nr_etapa_sol_w 
		and		(dt_inicio_horario IS NOT NULL AND dt_inicio_horario::text <> '') 
		and		Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S' 
		and		coalesce(dt_suspensao::text, '') = '' 
		and		ie_agrupador in (4) 
		and		nr_seq_solucao = nr_seq_solucao_p 
		and		nr_prescricao = nr_prescricao_p;
 
		if (ie_consiste_etapa_w = 'S') then 
			--Existem etapas/horários superiores já iniciados ou terminados. Sendo assim, não será possível realizar esta reversão. 
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(210178);
		end if;
		 
		update	prescr_mat_hor 
		set		dt_suspensao  = NULL, 
				nm_usuario_susp  = NULL, 
				ds_motivo_susp  = NULL, 
				nr_seq_assinatura_susp  = NULL, 
				dt_atualizacao = clock_timestamp(), 
				nm_usuario = nm_usuario_p 
		where	coalesce(nr_seq_horario_w,nr_sequencia) = nr_sequencia 
		and		coalesce(nr_etapa_sol,nr_etapa_sol_w) = nr_etapa_sol_w 
		and		Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S' 
		and		(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '') 
		and		ie_agrupador in (4) 
		and		nr_seq_solucao = nr_seq_solucao_p 
		and		nr_prescricao = nr_prescricao_p;
 
		GET DIAGNOSTICS qt_atualizados_w = ROW_COUNT;
		 
		commit;
 
		if (qt_atualizados_w > 0) then 
 
			select	coalesce(max(qt_volume),0) 
			into STRICT	qt_volume_etapa_w 
			from	prescr_solucao 
			where	nr_seq_solucao = nr_seq_solucao_p 
			and		nr_prescricao = nr_prescricao_p;
			 
			select	nextval('prescr_solucao_evento_seq') 
			into STRICT	nr_sequencia_w 
			;
 
			insert into prescr_solucao_evento( 
				nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_prescricao, 
				nr_seq_solucao, 
				nr_seq_material, 
				nr_seq_procedimento, 
				nr_seq_nut, 
				nr_seq_nut_neo, 
				ie_forma_infusao, 
				ie_tipo_dosagem, 
				qt_dosagem, 
				qt_vol_infundido, 
				qt_vol_desprezado, 
				cd_pessoa_fisica, 
				ie_alteracao, 
				dt_alteracao, 
				ie_evento_valido, 
				nr_seq_motivo, 
				ds_observacao, 
				ie_tipo_solucao, 
				nr_seq_esquema, 
				nr_etapa_evento) 
			values ( 
				nr_sequencia_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_prescricao_p, 
				nr_seq_solucao_p, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				obter_dados_usuario_opcao(nm_usuario_p, 'C'), 
				36, 
				clock_timestamp(), 
				'S', 
				nr_seq_motivo_p, 
				null, 
				ie_tipo_solucao_p, 
				null, 
				nr_etapa_sol_w);
				 
			update	prescr_solucao_evento 
			set		ie_evento_valido = 'N' 
			where	coalesce(ie_evento_valido,'S') = 'S' 
			and		ie_alteracao = 12 
			and		nr_etapa_evento = nr_etapa_sol_w 
			and		nr_seq_solucao = nr_seq_solucao_p 
			and		nr_prescricao = nr_prescricao_p;
 
			if (qt_volume_etapa_w > 0) then 
			 
				CALL atualizar_valor_susp_solucao(ie_tipo_solucao_p, nr_prescricao_p, nr_seq_solucao_p, qt_volume_etapa_w, 'N', nm_usuario_p);
			end if;	
		end if;
	elsif (ie_tipo_solucao_p = 2) then -- Suporte Nutricional Enteral SNE 
 
		select	coalesce(max(ie_suspenso),'N') 
		into STRICT	ie_status_item_w 
		from	prescr_material 
		where	nr_prescricao	= nr_prescricao_p 
		and	ie_agrupador	= 8 
		and	nr_sequencia	= nr_seq_solucao_p;
 
		if (ie_status_item_w = 'S') then 
			-- O item já foi suspenso na prescrição, sendo assim, não será possível reverter a etapa/horário suspenso! 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(196186);
		end if;
 
		nr_etapa_sol_w		:= coalesce(nr_etapa_sol_p,0);
		nr_seq_horario_w	:= nr_seq_horario_p;
 
		 
		if (nr_etapa_sol_w = 0) and (coalesce(nr_seq_horario_w,0) > 0) then 
			 
			select	max(dt_horario) 
			into STRICT	dt_horario_w 
			from	prescr_mat_hor 
			where	nr_prescricao = nr_prescricao_p 
			and		nr_seq_material = nr_seq_solucao_p 
			and		nr_sequencia = nr_seq_horario_w;
			 
			nr_etapa_sol_w	:= Obter_etapa_horario_susp_sol(nr_prescricao_p, nr_seq_solucao_p, dt_horario_w, 2);
		end if;
		 
		update	prescr_mat_hor 
		set		dt_suspensao  = NULL, 
				nm_usuario_susp  = NULL, 
				ds_motivo_susp  = NULL, 
				nr_seq_assinatura_susp  = NULL, 
				dt_atualizacao = clock_timestamp(), 
				nm_usuario = nm_usuario_p 
		where	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S' 
		and		(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '') 
		and		ie_agrupador 	= 8 
		and		nr_seq_material = nr_seq_solucao_p 
		and		nr_prescricao	= nr_prescricao_p 
		and		nr_seq_horario_w = nr_sequencia;
		 
		GET DIAGNOSTICS qt_atualizados_w = ROW_COUNT;
		 
		commit;
		 
		if (qt_atualizados_w > 0) then 
 
			select	nextval('prescr_solucao_evento_seq') 
			into STRICT	nr_sequencia_w 
			;
 
			insert into prescr_solucao_evento( 
				nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_prescricao, 
				nr_seq_solucao, 
				nr_seq_material, 
				nr_seq_procedimento, 
				nr_seq_nut, 
				nr_seq_nut_neo, 
				ie_forma_infusao, 
				ie_tipo_dosagem, 
				qt_dosagem, 
				qt_vol_infundido, 
				qt_vol_desprezado, 
				cd_pessoa_fisica, 
				ie_alteracao, 
				dt_alteracao, 
				ie_evento_valido, 
				nr_seq_motivo, 
				ds_observacao, 
				ie_tipo_solucao, 
				nr_seq_esquema, 
				nr_etapa_evento) 
			values ( 
				nr_sequencia_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_prescricao_p, 
				null, 
				nr_seq_solucao_p, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				obter_dados_usuario_opcao(nm_usuario_p, 'C'), 
				36, 
				clock_timestamp(), 
				'S', 
				nr_seq_motivo_p, 
				null, 
				ie_tipo_solucao_p, 
				null, 
				nr_etapa_sol_w);
				 
			update	prescr_solucao_evento 
			set		ie_evento_valido = 'N' 
			where	coalesce(ie_evento_valido,'S') = 'S' 
			and		ie_alteracao = 12 
			and		nr_etapa_evento = nr_etapa_sol_w 
			and		nr_seq_solucao = nr_seq_solucao_p 
			and		nr_prescricao = nr_prescricao_p;
 
/*			select	nvl(max(qt_volume),0) 
			into	qt_volume_etapa_w 
			from	prescr_material 
			where	nr_prescricao = nr_prescricao_p 
			and	nr_sequencia = nr_seq_solucao_p 
			and	ie_agrupador = 8; 
			 
			if	(qt_volume_etapa_w > 0) then 
				--atualizar_valor_susp_solucao(ie_tipo_solucao_p, nr_prescricao_p, nr_seq_solucao_p, qt_volume_etapa_w, 'N', nm_usuario_p); 
			end if;	*/
 
		end if;
 
	elsif (ie_tipo_solucao_p = 3) then -- Hemoterapia 
 
		select	coalesce(max(ie_suspenso),'N') 
		into STRICT	ie_status_item_w 
		from	prescr_procedimento 
		where	nr_prescricao	= nr_prescricao_p 
		and	nr_sequencia	= nr_seq_solucao_p;
 
		if (ie_status_item_w = 'S') then 
			-- O item já foi suspenso na prescrição, sendo assim, não será possível reverter a etapa/horário suspenso! 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(196186);
		end if;
 
		nr_etapa_sol_w		:= coalesce(nr_etapa_sol_p,0);
		nr_seq_horario_w	:= nr_seq_horario_p;
 
		if (nr_etapa_sol_w = 0) and (coalesce(nr_seq_horario_w,0) > 0) then 
 
			select	max(dt_horario) 
			into STRICT	dt_horario_w 
			from	prescr_proc_hor 
			where	nr_prescricao = nr_prescricao_p 
			and	nr_seq_procedimento = nr_seq_solucao_p 
			and	nr_sequencia = nr_seq_horario_p;
 
			nr_etapa_sol_w	:= Obter_etapa_horario_susp_sol(nr_prescricao_p, nr_seq_solucao_p, dt_horario_w, 3);
		end if;
		 
		update	prescr_proc_hor 
		set	dt_suspensao  = NULL, 
			nm_usuario_susp  = NULL, 
			dt_atualizacao = clock_timestamp(), 
			nm_usuario = nm_usuario_p 
		where	nr_prescricao	= nr_prescricao_p 
		and	nr_seq_procedimento = nr_seq_solucao_p 
		and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '') 
		and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';
		 
		GET DIAGNOSTICS qt_atualizados_w = ROW_COUNT;
		 
		commit;
		 
		if (qt_atualizados_w > 0) then 
 
			select	nextval('prescr_solucao_evento_seq') 
			into STRICT	nr_sequencia_w 
			;
 
			insert into prescr_solucao_evento( 
				nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_prescricao, 
				nr_seq_solucao, 
				nr_seq_material, 
				nr_seq_procedimento, 
				nr_seq_nut, 
				nr_seq_nut_neo, 
				ie_forma_infusao, 
				ie_tipo_dosagem, 
				qt_dosagem, 
				qt_vol_infundido, 
				qt_vol_desprezado, 
				cd_pessoa_fisica, 
				ie_alteracao, 
				dt_alteracao, 
				ie_evento_valido, 
				nr_seq_motivo, 
				ds_observacao, 
				ie_tipo_solucao, 
				nr_seq_esquema, 
				nr_etapa_evento) 
			values ( 
				nr_sequencia_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_prescricao_p, 
				null, 
				null, 
				nr_seq_solucao_p, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				obter_dados_usuario_opcao(nm_usuario_p, 'C'), 
				36, 
				clock_timestamp(), 
				'S', 
				nr_seq_motivo_p, 
				null, 
				ie_tipo_solucao_p, 
				null, 
				nr_etapa_sol_w);
 
			update	prescr_solucao_evento 
			set		ie_evento_valido = 'N' 
			where	coalesce(ie_evento_valido,'S') = 'S' 
			and		ie_alteracao = 12 
			and		nr_etapa_evento = nr_etapa_sol_w 
			and		nr_seq_solucao = nr_seq_solucao_p 
			and		nr_prescricao = nr_prescricao_p;
				 
/*			select	nvl(max(qt_volume_suspenso),0) 
			into	qt_volume_etapa_w 
			from	prescr_procedimento 
			where	nr_prescricao = nr_prescricao_p 
			and	nr_sequencia = nr_seq_solucao_p; 
				 
			if	(qt_volume_etapa_w > 0) then 
				--atualizar_valor_susp_solucao(ie_tipo_solucao_p, nr_prescricao_p, nr_seq_solucao_p, qt_volume_etapa_w, 'N', nm_usuario_p); 
			end if;*/
 
		end if;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reverter_susp_etapa_hor_sol ( cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_seq_horario_p bigint, nr_etapa_sol_p bigint, ie_tipo_solucao_p text, nr_seq_motivo_p bigint) FROM PUBLIC;

