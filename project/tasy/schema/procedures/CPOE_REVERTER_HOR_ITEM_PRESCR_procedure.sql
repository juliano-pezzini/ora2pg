-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_reverter_hor_item_prescr (nr_prescricao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_item_w					prescr_material.cd_material%type;
ie_agrupador_w				prescr_material.ie_agrupador%type;	
 
cd_recomendacao_w			prescr_rec_hor.cd_recomendacao%type;
nr_seq_recomendacao_w		prescr_rec_hor.nr_seq_recomendacao%type;

cd_procedimento_w			prescr_proc_hor.cd_procedimento%type;
nr_seq_proc_interno_w		prescr_proc_hor.nr_seq_proc_interno%type;
dt_inicio_horario_w			prescr_proc_hor.dt_inicio_horario%type;

cd_dieta_w					prescr_dieta.cd_dieta%type;

nr_seq_interno_w			prescr_procedimento.nr_seq_interno%type;
	
ie_tipo_item_w				varchar(3);
ie_jejum_w					varchar(1);
ie_atualizou_w				varchar(1);
ie_regra_lanc_conta_w		varchar(1);
ie_inicia_proced_w			varchar(1):= 'N';
ie_tipo_item_assoc_w		varchar(15);
nm_tabela_w					varchar(30);
dt_horario_w				timestamp;
nr_agrupamento_w			double precision;
nr_seq_alteracao_w			bigint;
nr_seq_lote_w				bigint;
nr_seq_item_w				bigint;
nr_seq_item_sol_w			bigint;
nr_seq_etapa_w				bigint;
nr_etapa_evento_w			bigint;
nr_etapa_sol_w				bigint;


BEGIN 
 
ie_tipo_item_w := null;
 
if (ie_tipo_item_p = 'N') then 
 
	select	coalesce(max(nr_seq_dieta),0) 
	into STRICT		nr_seq_item_w 
	from	prescr_dieta_hor 
	where	nr_sequencia = nr_sequencia_p 
	and		nr_prescricao = nr_prescricao_p;
	 
	if (coalesce(nr_seq_item_w,0) > 0) then 
	 
		ie_tipo_item_w := 'D';
	 
		update	prescr_dieta_hor 
		set	dt_suspensao 		 = NULL, 
			nm_usuario_susp		 = NULL 
		where	nr_sequencia 	= nr_sequencia_p 
		and nr_prescricao = nr_prescricao_p 
		and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '');	
 
		select	coalesce(max('S'),'N') 
		into STRICT 	ie_atualizou_w 
		from 	prescr_dieta_hor where nr_sequencia = nr_sequencia_p 
		and nr_prescricao = nr_prescricao_p 
		and	coalesce(dt_suspensao::text, '') = '' 
		and	coalesce(nm_usuario_susp::text, '') = '' LIMIT 1;		
	 
		if (ie_atualizou_w = 'S') then 
 
			select	max(dt_horario) 
			into STRICT	dt_horario_w 
			from	prescr_dieta_hor 
			where	nr_sequencia = nr_sequencia_p 
			and		nr_prescricao = nr_prescricao_p;
	 
			select cd_dieta 
			into STRICT	cd_dieta_w 
			from prescr_dieta 
			where nr_sequencia = nr_seq_item_w 
			and	 nr_prescricao = nr_prescricao_p;
	 
			select	nextval('prescr_mat_alteracao_seq') 
			into STRICT	nr_seq_alteracao_w 
			;	
	 
			insert	into prescr_mat_alteracao(nr_sequencia, 
												dt_atualizacao, 
												nm_usuario, 
												dt_atualizacao_nrec, 
												nm_usuario_nrec, 
												nr_prescricao, 
												nr_seq_horario_dieta, 
												dt_alteracao, 
												cd_pessoa_fisica, 
												ie_alteracao, 
												ie_tipo_item, 
												dt_horario, 
												nr_atendimento, 
												cd_item, 
												ie_mostra_adep) 
									values (	nr_seq_alteracao_w, 
												clock_timestamp(), 
												nm_usuario_p, 
												clock_timestamp(), 
												nm_usuario_p, 
												nr_prescricao_p, 
												nr_sequencia_p, 
												clock_timestamp(), 
												obter_dados_usuario_opcao(nm_usuario_p,'C'), 
												6, 
												'D', 
												dt_horario_w, 
												nr_atendimento_p, 
												cd_dieta_w, 
												'S');
	 
	 
			update prescr_dieta 
			set	ie_suspenso = 'N', 
				nm_usuario_susp  = NULL, 
				dt_atualizacao = clock_timestamp(), 
				nm_usuario = nm_usuario_p 
			where nr_sequencia = nr_seq_item_w 
			and	 nr_prescricao = nr_prescricao_p;	
 
		end if;
	 
	else 
	 
		select coalesce(max('S'),'N') 
		into STRICT	ie_jejum_w 
		from rep_jejum 
		where nr_sequencia = nr_sequencia_p 
		and	nr_prescricao = nr_prescricao_p 
		and	 coalesce(ie_suspenso,'N') = 'S';
		 
		if (coalesce(ie_jejum_w,'N') = 'S') then			 
			 
			update	rep_jejum 
			set		ie_suspenso = 'N' 
			where	nr_prescricao = nr_prescricao_p 
			and		nr_sequencia = nr_sequencia_p;
	 
			select	nextval('prescr_mat_alteracao_seq') 
			into STRICT	nr_seq_alteracao_w 
			;
			 
			insert into	prescr_mat_alteracao( nr_sequencia, 
												dt_atualizacao, 
												nm_usuario, 
												dt_atualizacao_nrec, 
												nm_usuario_nrec, 
												nr_prescricao, 
												nr_seq_prescricao, 
												nr_seq_horario, 
												dt_alteracao, 
												cd_pessoa_fisica, 
												ie_alteracao, 
												ds_justificativa, 
												ie_tipo_item, 
												dt_horario, 
												nr_atendimento, 
												--cd_item, 
												qt_dose_adm, 
												cd_um_dose_adm, 
												qt_dose_original, 
												nr_agrupamento, 
												ie_acm_sn, 
												cd_medico_solic, 
												ds_observacao, 
												nr_seq_motivo_susp, 
												ie_mostra_adep, 
												nr_seq_assinatura, 
												nr_seq_lote) 
									values (	nr_seq_alteracao_w, 
												clock_timestamp(), 
												nm_usuario_p, 
												clock_timestamp(), 
												nm_usuario_p, 
												nr_prescricao_p, 
												null, 
												null, 
												clock_timestamp(), 
												obter_dados_usuario_opcao(nm_usuario_p,'C'), 
												6, 
												null, 
												'J', 
												clock_timestamp(), 
												nr_atendimento_p, 
												--cd_item_w, 
												null, 
												null, 
												null, 
												null, 
												'N', 
												null, 
												null, 
												null, 
												'S', 
												null, 
												null);			
		else 
		 
			select	coalesce(max(nr_seq_material),0) 
			into STRICT	nr_seq_item_w 
			from	prescr_mat_hor 
			where	nr_sequencia = nr_sequencia_p 
			and		nr_prescricao = nr_prescricao_p;		
			 
			if (coalesce(nr_seq_item_w,0) > 0) then 
				 
				ie_tipo_item_w := 'NM';
				 
				select max(ie_agrupador) 
				into STRICT	ie_agrupador_w 
				from prescr_material 
				where nr_sequencia = nr_seq_item_w 
				and nr_prescricao = nr_prescricao_p;			
		 
				--Enteral, suplemento, Leites 
				update	prescr_mat_hor 
				set	dt_suspensao		 = NULL, 
					nm_usuario_susp		 = NULL, 
					ie_suspenso_adep	 = NULL 
				where	nr_sequencia	= nr_sequencia_p 
				and nr_prescricao = nr_prescricao_p 
				and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '');		
				 
				select	coalesce(max('S'),'N') 
				into STRICT 	ie_atualizou_w 
				from 	prescr_mat_hor where nr_sequencia 	 = nr_sequencia_p 
				and nr_prescricao = nr_prescricao_p 
				and	coalesce(dt_suspensao::text, '') = '' 
				and	coalesce(nm_usuario_susp::text, '') = '' 
				and	coalesce(ie_suspenso_adep::text, '') = '' LIMIT 1;	
 
				if (ie_atualizou_w = 'S') then 
						 
						select	max(dt_horario) 
						into STRICT	dt_horario_w 
						from	prescr_mat_hor 
						where	nr_sequencia = nr_sequencia_p 
						and		nr_prescricao = nr_prescricao_p;					
						 
						select	coalesce(max(nr_seq_lote),0), 
								max(cd_material) 
						into STRICT	nr_seq_lote_w, 
								cd_item_w 
						from	prescr_mat_hor 
						where	nr_sequencia = nr_sequencia_p 
						and nr_prescricao = nr_prescricao_p;			
					 
					if (ie_agrupador_w = 8) then --Deita Enteral 
						 
						select	nextval('prescr_solucao_evento_seq') 
						into STRICT	nr_seq_alteracao_w 
						;
 
						insert into prescr_solucao_evento( nr_sequencia, 
															dt_atualizacao, 
															nm_usuario, 
															dt_atualizacao_nrec, 
															nm_usuario_nrec, 
															nr_prescricao, 
															nr_seq_material, 
															cd_pessoa_fisica, 
															ie_alteracao, 
															dt_alteracao, 
															ie_evento_valido, 
															nr_seq_motivo, 
															ds_observacao, 
															ie_tipo_solucao, 
															nr_seq_lote, 
															nr_seq_solucao, 
															ds_justificativa, 
															cd_funcao) 
												values (nr_seq_alteracao_w, 
															clock_timestamp(), 
															nm_usuario_p, 
															clock_timestamp(), 
															nm_usuario_p, 
															nr_prescricao_p, 
															nr_seq_item_w, 
															obter_dados_usuario_opcao(nm_usuario_p, 'C'), 
															36, 
															clock_timestamp(), 
															'S', 
															null, 
															null, 
															2, 
															nr_seq_lote_w, 
															NULL, 
															null, 
															null);
					else 
				 
						select	nextval('prescr_mat_alteracao_seq') 
						into STRICT	nr_seq_alteracao_w 
						;	
				 
						insert	into prescr_mat_alteracao(nr_sequencia, 
															dt_atualizacao, 
															nm_usuario, 
															dt_atualizacao_nrec, 
															nm_usuario_nrec, 
															nr_prescricao, 
															nr_seq_horario, 
															dt_alteracao, 
															cd_pessoa_fisica, 
															ie_alteracao, 
															ie_tipo_item, 
															dt_horario, 
															nr_atendimento, 
															cd_item, 
															ie_mostra_adep) 
												values (	nr_seq_alteracao_w, 
															clock_timestamp(), 
															nm_usuario_p, 
															clock_timestamp(), 
															nm_usuario_p, 
															nr_prescricao_p, 
															nr_sequencia_p, 
															clock_timestamp(), 
															obter_dados_usuario_opcao(nm_usuario_p,'C'), 
															6, 
															'S', 
															dt_horario_w, 
															nr_atendimento_p, 
															cd_item_w, 
															'S');					
					 
					end if;	
				end if;	
			 
				update 	prescr_material 
				set		ie_suspenso 	= 'N', 
						nm_usuario_susp  = NULL, 
						dt_suspensao 	 = NULL 
				where	nr_prescricao 	= nr_prescricao_p 
				and nr_prescricao = nr_prescricao_p 
				and 	nr_sequencia = nr_seq_item_w;		
			 
			end if;
		end if;
		 
	end if;
	 
-- Medicine and Solution - MAterials 
elsif (ie_tipo_item_p = 'M') or (ie_tipo_item_p = 'MA') or (ie_tipo_item_p = 'S')then 
 
	update	prescr_mat_hor 
	set	dt_suspensao		 = NULL, 
		nm_usuario_susp		 = NULL, 
		ie_suspenso_adep	 = NULL 
	where	nr_sequencia	= nr_sequencia_p 
	and nr_prescricao	= nr_prescricao_p 
	and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '');
	 
	select	coalesce(max('S'),'N') 
	into STRICT 	ie_atualizou_w 
	from 	prescr_mat_hor where nr_sequencia 	 = nr_sequencia_p 
	and nr_prescricao = nr_prescricao_p 
	and	coalesce(dt_suspensao::text, '') = '' 
	and	coalesce(nm_usuario_susp::text, '') = '' 
	and	coalesce(ie_suspenso_adep::text, '') = '' LIMIT 1;	
 
	if (ie_atualizou_w = 'S') then 
 
		select max(nr_seq_material), 
			max(dt_horario), 
			max(cd_material), 
			MAX(nr_etapa_sol), 
			coalesce(max(nr_seq_lote),0) 
		into STRICT  nr_seq_item_w, 
			dt_horario_w, 
			cd_item_w, 
			nr_seq_etapa_w, 
			nr_seq_lote_w 
		from prescr_mat_hor 
		where nr_sequencia = nr_sequencia_p 
		and nr_prescricao = nr_prescricao_p 
		and	obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';
			 
		if (ie_tipo_item_p = 'S') then	 
			 
			select max(nr_sequencia_solucao) 
			into STRICT nr_seq_item_sol_w 
			from prescr_material 
			where nr_sequencia = nr_seq_item_w 
			and nr_prescricao = nr_prescricao_p;
			 
			update	prescr_solucao 
			set		ie_suspenso = 'N', 
					dt_suspensao  = NULL, 
					nm_usuario_susp  = NULL, 
					nm_usuario = nm_usuario_p, 
					dt_atualizacao = clock_timestamp() 
			where nr_seq_solucao = nr_seq_item_sol_w 
			and nr_prescricao = nr_prescricao_p;
 
			update 	prescr_material 
			set		ie_suspenso 	= 'N', 
					nm_usuario_susp  = NULL, 
					dt_suspensao 	 = NULL 
			where	nr_prescricao 	= nr_prescricao_p 
			and 	nr_sequencia_solucao = nr_seq_item_sol_w;			
			 
			ie_tipo_item_w := 'SOL';
			 
			select	nextval('prescr_solucao_evento_seq') 
			into STRICT	nr_seq_alteracao_w 
			;
			 
			insert into prescr_solucao_evento( nr_sequencia, 
												dt_atualizacao, 
												nm_usuario, 
												dt_atualizacao_nrec, 
												nm_usuario_nrec, 
												nr_prescricao, 
												nr_seq_solucao, 
												cd_pessoa_fisica, 
												ie_alteracao, 
												dt_alteracao, 
												ie_evento_valido, 
												ds_observacao, 
												ie_tipo_solucao, 
												nr_seq_lote, 
												nr_etapa_evento) 
										values (nr_seq_alteracao_w, 
												clock_timestamp(), 
												nm_usuario_p, 
												clock_timestamp(), 
												nm_usuario_p, 
												nr_prescricao_p, 
												nr_seq_item_sol_w, 
												obter_dados_usuario_opcao(nm_usuario_p, 'C'), 
												36, 
												clock_timestamp(), 
												'S', 
												NULL, 
												1, 
												nr_seq_lote_w, 
												nr_seq_etapa_w);		
		else 			 
			ie_tipo_item_w := 'M';
			 
			select	nextval('prescr_mat_alteracao_seq') 
			into STRICT	nr_seq_alteracao_w 
			;		
		 
			insert	into prescr_mat_alteracao( nr_sequencia, 
												dt_atualizacao, 
												nm_usuario, 
												dt_atualizacao_nrec, 
												nm_usuario_nrec, 
												nr_prescricao, 
												nr_seq_horario, 
												dt_alteracao, 
												cd_pessoa_fisica, 
												ie_alteracao, 
												nr_atendimento, 
												nr_seq_prescricao, 
												nr_agrupamento, 
												dt_horario, 
												cd_item, 
												ie_mostra_adep, 
												ie_tipo_item, 
												nr_seq_lote) 
										VALUES (nr_seq_alteracao_w, 
												clock_timestamp(), 
												nm_usuario_p, 
												clock_timestamp(), 
												nm_usuario_p, 
												nr_prescricao_p, 
												nr_sequencia_p, 
												clock_timestamp(), 
												obter_dados_usuario_opcao(nm_usuario_p,'C'), 
												6, 
												nr_atendimento_p, 
												nr_seq_item_w, 
												0, 
												dt_horario_w, 
												cd_item_w, 
												'S', 
												CASE WHEN ie_tipo_item_p='MA' THEN 'MAT'  ELSE 'M' END , 
												nr_seq_lote_w);
		end if;
		 
		update 	prescr_material 
		set		ie_suspenso 	= 'N', 
				nm_usuario_susp  = NULL, 
				dt_suspensao 	 = NULL 
		where	nr_prescricao 	= nr_prescricao_p 
		and 	nr_sequencia = nr_seq_item_w;
		 
		ie_regra_lanc_conta_w	:= obter_regra_lanc_conta_adep(coalesce(wheb_usuario_pck.get_cd_estabelecimento,1), Obter_perfil_Ativo, nm_usuario_p, 'CG');
 
		CALL gerar_alter_horario_item_comp(nr_atendimento_p, 'IC', nr_prescricao_p, nr_seq_item_w, nr_agrupamento_w, dt_horario_w, 6, clock_timestamp(), ie_regra_lanc_conta_w, null, nm_usuario_p);
		CALL gerar_alter_horario_item_dil(nr_atendimento_p, 'DIL', nr_prescricao_p, nr_seq_item_w, nr_agrupamento_w, dt_horario_w, 6, clock_timestamp(), ie_regra_lanc_conta_w, nm_usuario_p);
		CALL gerar_alter_horario_item_kit(nr_atendimento_p, 'KIT', nr_prescricao_p, nr_seq_item_w, dt_horario_w, 6, clock_timestamp(), ie_regra_lanc_conta_w, nm_usuario_p);
	 
	 
	end if;
	 
	-- Recommendation 
elsif (ie_tipo_item_p = 'R') then 
 
		update	prescr_rec_hor 
		set	dt_suspensao 		 = NULL, 
			nm_usuario_susp		 = NULL, 
			nr_seq_motivo_susp	 = NULL 
		where	nr_sequencia 	= nr_sequencia_p 
		and nr_prescricao	= nr_prescricao_p 
		and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '');
		 
		select	coalesce(max('S'),'N') 
		into STRICT 	ie_atualizou_w 
		from 	prescr_rec_hor where nr_sequencia 	 = nr_sequencia_p 
		and nr_prescricao = nr_prescricao_p 
		and	coalesce(dt_suspensao::text, '') = '' 
		and	coalesce(nm_usuario_susp::text, '') = '' LIMIT 1;
		 
		if (ie_atualizou_w = 'S') then 
		 
			ie_tipo_item_w := 'R';
		 
			select cd_recomendacao, 
					nr_seq_recomendacao, 
					dt_horario_w 
			into STRICT	cd_recomendacao_w, 
					nr_seq_item_w, 
					dt_horario_w 
			from prescr_rec_hor 
			where nr_sequencia = nr_sequencia_p 
			and nr_prescricao = nr_prescricao_p;
		 
			select	nextval('prescr_mat_alteracao_seq') 
			into STRICT	nr_seq_alteracao_w 
			;				
			 
			insert	into prescr_mat_alteracao( nr_sequencia, 
												dt_atualizacao, 
												nm_usuario, 
												dt_atualizacao_nrec, 
												nm_usuario_nrec, 
												nr_prescricao, 
												nr_seq_horario_rec, 
												dt_alteracao, 
												cd_pessoa_fisica, 
												ie_alteracao, 
												nr_atendimento, 
												nr_seq_recomendacao, 
												nr_agrupamento, 
												dt_horario, 
												cd_item, 
												ie_mostra_adep, 
												ie_tipo_item) 
										VALUES (nr_seq_alteracao_w, 
												clock_timestamp(), 
												nm_usuario_p, 
												clock_timestamp(), 
												nm_usuario_p, 
												nr_prescricao_p, 
												nr_sequencia_p, 
												clock_timestamp(), 
												obter_dados_usuario_opcao(nm_usuario_p,'C'), 
												6, 
												nr_atendimento_p, 
												nr_seq_item_w, 
												0, 
												dt_horario_w, 
												cd_recomendacao_w, 
												'S', 
												ie_tipo_item_p);
			 
			 
			update 	prescr_recomendacao 
			set		ie_suspenso 	= 'N', 
					nm_usuario_susp  = NULL, 
					dt_suspensao 	 = NULL 
			where	nr_prescricao 	= nr_prescricao_p 
			and 	nr_sequencia  = nr_seq_item_w;			
			 
		end if;	
	 
	 
-- Procedure 
elsif (ie_tipo_item_p = 'P') then 
			 
		update	prescr_proc_hor 
		set	dt_suspensao		 = NULL, 
			nm_usuario_susp		 = NULL 
		where	nr_sequencia	= nr_sequencia_p 
		and nr_prescricao	= nr_prescricao_p 
		and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '');	
	 
		select	coalesce(max('S'),'N') 
		into STRICT 	ie_atualizou_w 
		from 	prescr_proc_hor where nr_sequencia 	 = nr_sequencia_p 
		and nr_prescricao = nr_prescricao_p 
		and	coalesce(dt_suspensao::text, '') = '' 
		and	coalesce(nm_usuario_susp::text, '') = '' LIMIT 1;
		 
		if (ie_atualizou_w = 'S') then 
		 
			ie_tipo_item_w := 'P';
		 
			select nr_seq_procedimento, 
					dt_horario, 
					cd_procedimento, 
					nr_seq_proc_interno, 
					dt_inicio_horario 
			into STRICT	nr_seq_item_w, 
					dt_horario_w, 
					cd_procedimento_w, 
					nr_seq_proc_interno_w, 
					dt_inicio_horario_w 
			from prescr_proc_hor 
			where nr_sequencia = nr_sequencia_p 
			and nr_prescricao = nr_prescricao_p;
		 
			select max(nr_seq_interno) 
			into STRICT	nr_seq_interno_w 
			from prescr_procedimento 
			where nr_sequencia = nr_seq_item_w 
			and nr_prescricao = nr_prescricao_p;
		 
			select	nextval('prescr_mat_alteracao_seq') 
			into STRICT	nr_seq_alteracao_w 
			;		
		 
			insert	into	prescr_mat_alteracao(nr_sequencia, 
												dt_atualizacao, 
												nm_usuario, 
												dt_atualizacao_nrec, 
												nm_usuario_nrec, 
												nr_prescricao, 
												nr_seq_procedimento, 
												nr_seq_horario_proc, 
												dt_alteracao, 
												cd_pessoa_fisica, 
												ie_alteracao, 
												ie_tipo_item, 
												dt_horario, 
												nr_atendimento, 
												cd_item, 
												nr_seq_proc_interno, 
												ie_mostra_adep, 
												cd_procedimento) 
									VALUES (nr_seq_alteracao_w, 
												clock_timestamp(), 
												nm_usuario_p, 
												clock_timestamp(), 
												nm_usuario_p, 
												nr_prescricao_p, 
												nr_seq_item_w, 
												nr_sequencia_p, 
												clock_timestamp(), 
												obter_dados_usuario_opcao(nm_usuario_p,'C'), 
												6, 
												ie_tipo_item_p, 
												dt_horario_w, 
												nr_atendimento_p, 
												cd_procedimento_w, 
												nr_seq_proc_interno_w, 
												'S', 
												cd_procedimento_w);			
			 
				 
			update 	prescr_procedimento 
			set		ie_suspenso 	= 'N', 
					nm_usuario_susp  = NULL, 
					dt_suspensao 	 = NULL 
			where	nr_prescricao 	= nr_prescricao_p 
			and 	nr_sequencia  = nr_seq_item_w;
			 
			select	CASE WHEN coalesce(max(ie_ctrl_glic),'NC')='NC' THEN 'AP'  ELSE MAX(ie_ctrl_glic) END  
			into STRICT	ie_tipo_item_assoc_w 
			from	proc_interno 
			where	nr_sequencia	= nr_seq_proc_interno_w;
 
			if (dt_inicio_horario_w IS NOT NULL AND dt_inicio_horario_w::text <> '') then 
				ie_inicia_proced_w := 'S';
			end if;
			 
			if (coalesce(Wheb_assist_pck.obterParametroFuncao(1113,613),'N') = 'S') then 
				CALL gerar_alteracao_proc_assoc( nr_atendimento_p, nr_prescricao_p, nr_seq_interno_w, dt_horario_w, 6, ie_tipo_item_p, nm_usuario_p, 
						Obter_perfil_Ativo, null, null, 0, null, coalesce(ie_inicia_proced_w,'N'), coalesce(wheb_usuario_pck.get_cd_estabelecimento,1), 'N', null);
			end if;
 
			if (Wheb_assist_pck.obterParametroFuncao(88,291) = 'S') then 
				CALL gerar_alter_horario_item_assoc(nr_atendimento_p, ie_tipo_item_assoc_w, nr_prescricao_p, nr_seq_item_w, cd_procedimento_w, dt_horario_w, clock_timestamp(), 6, nm_usuario_p);
			end if;			
			 
		 
		end if;
	 
	 
-- Gastherapy 
elsif (ie_tipo_item_p = 'G') then 
	 
		update	prescr_gasoterapia_hor 
		set	dt_suspensao  = NULL, 
			nm_usuario_susp  = NULL 
		where nr_sequencia	= nr_sequencia_p 
		and nr_prescricao	= nr_prescricao_p 
		and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '');
		 
		select	coalesce(max('S'),'N') 
		into STRICT 	ie_atualizou_w 
		from 	prescr_gasoterapia_hor where nr_sequencia 	 = nr_sequencia_p 
		and nr_prescricao = nr_prescricao_p 
		and	coalesce(dt_suspensao::text, '') = '' 
		and	coalesce(nm_usuario_susp::text, '') = '' LIMIT 1;
	 
		if (ie_atualizou_w = 'S') then 
		 
			ie_tipo_item_w := 'G';
		 
			select	max(nr_seq_gasoterapia), 
					max(nr_etapa) 
			into STRICT	nr_seq_item_w, 
					nr_etapa_evento_w 
			from prescr_gasoterapia_hor 
			where nr_sequencia = nr_sequencia_p 
			and nr_prescricao = nr_prescricao_p;
		 
			select	nextval('prescr_gasoterapia_evento_seq') 
			into STRICT	nr_seq_alteracao_w 
			;		
		 
			insert into prescr_gasoterapia_evento(nr_sequencia, 
												dt_atualizacao, 
												nm_usuario, 
												dt_atualizacao_nrec, 
												nm_usuario_nrec, 
												nr_seq_gasoterapia, 
												ie_evento, 
												dt_evento, 
												ie_evento_valido, 
												nr_seq_assinatura, 
												nr_seq_horario, 
												ds_justificativa, 
												nr_etapa_evento) 
									values (	nr_seq_alteracao_w, 
												clock_timestamp(), 
												nm_usuario_p, 
												clock_timestamp(), 
												nm_usuario_p, 
												nr_seq_item_w, 
												'RV', 
												clock_timestamp(), 
												'S', 
												0, 
												nr_sequencia_p, 
												null, 
												nr_etapa_evento_w); 		
			 
			update 	prescr_gasoterapia 
			set		ie_suspenso 	= 'N', 
					nr_seq_motivo_susp	 = NULL 
			where	nr_prescricao 	= nr_prescricao_p 
			and 	nr_sequencia  = nr_seq_item_w;
 
			select	max(dt_horario) 
			into STRICT	dt_horario_w				 
			from	prescr_gasoterapia_hor		 
			where	nr_sequencia = nr_sequencia_p 
			and nr_prescricao = nr_prescricao_p;
				 
			CALL gerar_alter_horario_item_assoc(nr_atendimento_p, 'IAO', nr_prescricao_p, nr_seq_item_w, nr_seq_item_w, dt_horario_w, clock_timestamp(), 6, nm_usuario_p);			
		 
		 
		end if;
		 
	 
--Hemotherapy 
elsif (ie_tipo_item_p = 'H') THEN 
 
		update	prescr_proc_hor 
		set	dt_suspensao  = NULL, 
			nm_usuario_susp  = NULL, 
			dt_atualizacao = clock_timestamp(), 
			nm_usuario = nm_usuario_p 
		where	nr_prescricao	= nr_prescricao_p 
		and	nr_sequencia = nr_sequencia_p 
		and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '');	
	 
		select	coalesce(max('S'),'N') 
		into STRICT 	ie_atualizou_w 
		from 	prescr_proc_hor where nr_sequencia 	 = nr_sequencia_p 
		and nr_prescricao = nr_prescricao_p 
		and	coalesce(dt_suspensao::text, '') = '' 
		and	coalesce(nm_usuario_susp::text, '') = '' LIMIT 1;
		 
		if (ie_atualizou_w = 'S') then 
		 
			select dt_horario, 
					nr_seq_procedimento 
			into STRICT dt_horario_w, 
				nr_seq_item_w 
			from prescr_proc_hor 
			where nr_sequencia = nr_sequencia_p 
			and nr_prescricao = nr_prescricao_p;
 
			nr_etapa_sol_w	:= Obter_etapa_horario_susp_sol(nr_prescricao_p, nr_seq_item_w, dt_horario_w, 3);								
				 
			select	nextval('prescr_solucao_evento_seq') 
			into STRICT	nr_seq_alteracao_w 
			;
				 
			insert into prescr_solucao_evento(nr_sequencia, 
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
									values (	nr_seq_alteracao_w, 
												clock_timestamp(), 
												nm_usuario_p, 
												clock_timestamp(), 
												nm_usuario_p, 
												nr_prescricao_p, 
												null, 
												null, 
												nr_seq_item_w, 
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
												null, 
												null, 
												3, 
												null, 
												nr_etapa_sol_w);
			 
				 
			update 	prescr_procedimento 
			set		ie_suspenso 	= 'N', 
					nm_usuario_susp  = NULL, 
					dt_suspensao 	 = NULL 
			where	nr_prescricao 	= nr_prescricao_p 
			and 	nr_sequencia  = nr_seq_item_w;			
		 
		end if;
 
-- Diálise 
elsif (ie_tipo_item_p = 'D') then 
		 
		update	prescr_solucao 
		set--		ie_suspenso	= 'N', 
				ie_status  = 'N', 
				nm_usuario	= nm_usuario_p, 
				dt_atualizacao	= clock_timestamp(), 
				dt_suspensao	 = NULL, 
				nm_usuario_susp	 = NULL 
		where	nr_prescricao	= nr_prescricao_p 
		and		nr_seq_solucao	= nr_sequencia_p 
		and		(nr_seq_dialise IS NOT NULL AND nr_seq_dialise::text <> '');			
		 
		update	prescr_material 
		set	ie_suspenso 		= 'N', 
			dt_suspensao		 = NULL, 
			nm_usuario_susp		 = NULL 
		where	nr_sequencia	= nr_sequencia_p 
		and nr_sequencia_solucao= nr_prescricao_p 
		and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '');
 
		select	coalesce(max('S'),'N') 
		into STRICT 	ie_atualizou_w 
		from 	prescr_solucao where nr_seq_solucao 	 = nr_sequencia_p 
		and nr_prescricao = nr_prescricao_p 
		and	(nr_seq_dialise IS NOT NULL AND nr_seq_dialise::text <> '') 
		and	coalesce(dt_suspensao::text, '') = '' 
		and	coalesce(nm_usuario_susp::text, '') = '' LIMIT 1;
 
		if (ie_atualizou_w = 'S') then 
	 
			select max(nr_seq_material) 
			into STRICT	nr_seq_item_w 
			from prescr_mat_hor 
			where nr_sequencia = nr_Sequencia_p 
			and nr_prescricao = nr_prescricao_p;
 
			insert into hd_prescricao_evento(nr_sequencia, 
												dt_atualizacao_nrec, 
												nm_usuario_nrec, 
												dt_atualizacao, 
												nm_usuario, 
												nr_prescricao, 
												nr_seq_solucao, 
												nr_etapa_evento, 
												ie_evento, 
												dt_evento, 
												cd_pessoa_evento, 
												dt_ciclo) 
									values (	nextval('hd_prescricao_evento_seq'), 
												clock_timestamp(), 
												nm_usuario_p, 
												clock_timestamp(), 
												nm_usuario_p, 
												nr_prescricao_p, 
												nr_sequencia_p, 
												null, 
												'RS', 
												clock_timestamp(), 
												substr(obter_dados_usuario_opcao(nm_usuario_p,'C'),1,10), 
												null);		
												 
		end if;
			 
end if;
 
 
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
 
	if (ie_tipo_item_w IS NOT NULL AND ie_tipo_item_w::text <> '') then 
 
		if (ie_tipo_item_w in ('D')) then 
			nm_tabela_w	:= 'PRESCR_DIETA';
			 
		elsif (ie_tipo_item_p in ('M','NM')) then 
			nm_tabela_w	:= 'PRESCR_MATERIAL';
			 
		elsif (ie_tipo_item_p IN ('P','G')) then 
			nm_tabela_w	:= 'PRESCR_PROCEDIMENTO';
			 
		elsif (ie_tipo_item_p in ('R')) then 
			nm_tabela_w	:= 'PRESCR_RECOMENDACAO';
			 
		elsif (ie_tipo_item_p in ('SOL')) then 
			nm_tabela_w	:= 'PRESCR_SOLUCAO';	
		end if;
 
		if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_item_w IS NOT NULL AND nr_seq_item_w::text <> '') then		 
				CALL Atualiza_ie_horario_susp(nr_prescricao_p, nr_seq_item_w, nm_tabela_w);	
		end if;
	 
	end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_reverter_hor_item_prescr (nr_prescricao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

