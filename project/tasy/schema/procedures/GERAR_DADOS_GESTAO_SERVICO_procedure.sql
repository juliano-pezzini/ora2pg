-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dados_gestao_servico ( nr_sequencia_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_executor_p text, ie_opcao_p text, nm_usuario_p text, cd_pf_usuario_p text, ds_obs_pausa_p text, nr_seq_motivo_higienizacao_p bigint default null, CD_MOTIVO_PAUSA_P bigint default null, evt_integ_P bigint default null) AS $body$
DECLARE


nm_usuario_w			varchar(15);
ie_servico_aprovador_w		varchar(1);
cd_estabelecimento_w		bigint;
ie_forma_atualiza_atend_w	varchar(1);
nr_seq_unidade_w	bigint;
ie_status_unid_ant_w	varchar(3);
atualizar_leito_status_ant_w	varchar(1);
ie_aprov_ao_lib_checklist_w	varchar(1);
dt_inicio_log_w	timestamp;

BEGIN

select	coalesce(obter_usuario_pf(cd_executor_p),'Tasy')
into STRICT	nm_usuario_w
;

cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

ie_forma_atualiza_atend_w := Obter_param_Usuario(75, 16, obter_perfil_ativo, coalesce(nm_usuario_p,nm_usuario_w), cd_estabelecimento_w, ie_forma_atualiza_atend_w);
atualizar_leito_status_ant_w := Obter_param_Usuario(75, 91, obter_perfil_ativo, coalesce(nm_usuario_p,nm_usuario_w), cd_estabelecimento_w, atualizar_leito_status_ant_w);
ie_aprov_ao_lib_checklist_w := Obter_param_Usuario(75, 95, obter_perfil_ativo, coalesce(nm_usuario_p,nm_usuario_w), cd_estabelecimento_w, ie_aprov_ao_lib_checklist_w);

if (ie_opcao_p = 'A') then
	begin
	update 	sl_unid_atend
	set	dt_inicio		= dt_inicio_p,
		dt_fim		= dt_fim_p,
		ie_status_serv 	= 'E',
		cd_executor	=  cd_executor_p,
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario	= coalesce(nm_usuario_p,nm_usuario_w),		
		cd_evento_eritel = evt_integ_P
	where	nr_sequencia 	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'P') then
	begin
	update 	sl_unid_atend
	set	dt_inicio		 = NULL,	
		dt_fim		 = NULL,
		ie_status_serv 	= 'P',
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario	=  coalesce(nm_usuario_p,nm_usuario_w),
		nr_seq_motivo_higienizacao  = NULL,
		cd_evento_eritel = evt_integ_P
	where	nr_sequencia 	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'I') then
	begin
	
	if (atualizar_leito_status_ant_w = 'S')	then
		select	coalesce(max(nr_seq_unidade),0)				
		into STRICT	nr_seq_unidade_w				
		from	sl_unid_atend
		where	nr_sequencia = nr_sequencia_p;
		
		select	max(ie_status_unidade)
		into STRICT	ie_status_unid_ant_w
		from 	unidade_atendimento
		where	nr_seq_interno = nr_seq_unidade_w;
	end if;		
	
	update 	sl_unid_atend
	set	dt_inicio	= dt_inicio_p,	
		ie_status_serv 	= 'EE',
		cd_executor	=  cd_executor_p,
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario	=  coalesce(nm_usuario_p,nm_usuario_w),
		cd_executor_inic_serv = cd_executor_p,
		cd_pf_usuario_inic_serv = cd_pf_usuario_p,
		nr_seq_motivo_higienizacao = nr_seq_motivo_higienizacao_p,
		cd_evento_eritel = evt_integ_P,
		ie_status_unid_ant = coalesce(ie_status_unid_ant_w,ie_status_unid_ant)
	where	nr_sequencia 	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'F') then
	begin
	select 	max(dt_inicio)
	into STRICT	dt_inicio_log_w
	from 	sl_unid_atend
	where	nr_sequencia 	= nr_sequencia_p;
	
	if (coalesce(dt_inicio_log_w::text, '') = '')then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(213232);
	end if;

	update 	sl_unid_atend
	set	dt_fim		= dt_fim_p,
		ie_status_serv 	= 'E',
		cd_executor	=  cd_executor_p,
		cd_executor_fim_serv =  cd_executor_p,		
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario	=  coalesce(nm_usuario_p,nm_usuario_w),
		cd_pf_usuario_fim_serv = cd_pf_usuario_p,
		cd_evento_eritel = evt_integ_P
	where	nr_sequencia 	= nr_sequencia_p;
	
	
	select	coalesce(max(a.ie_servico_aprovador),'N')
	into STRICT	ie_servico_aprovador_w
	from	sl_servico a
	where	a.nr_sequencia = (SELECT b.nr_seq_servico from sl_unid_atend b where b.nr_sequencia = nr_sequencia_p);
	
	if	(ie_servico_aprovador_w = 'S' AND ie_forma_atualiza_atend_w = 'A') then
		update 	sl_unid_atend
		set	dt_aprovacao	= dt_fim_p,
			ie_status_serv 	= 'A',
			cd_executor	=  cd_executor_p,
			cd_executor_aprov_serv =  cd_executor_p,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	=  coalesce(nm_usuario_p,nm_usuario_w),
			cd_evento_eritel = evt_integ_P
		where	nr_sequencia 	= nr_sequencia_p;
	end if;
	
	if (atualizar_leito_status_ant_w = 'S')	then
		select	coalesce(max(nr_seq_unidade),0)				
		into STRICT	nr_seq_unidade_w				
		from	sl_unid_atend
		where	nr_sequencia = nr_sequencia_p;
		
		select	max(ie_status_unid_ant)
		into STRICT	ie_status_unid_ant_w
		from	sl_unid_atend
		where	nr_sequencia = nr_seq_unidade_w;
		
		if (ie_status_unid_ant_w IS NOT NULL AND ie_status_unid_ant_w::text <> '') and (nr_seq_unidade_w <> 0) then
			update	unidade_atendimento
			set		ie_status_unidade = ie_status_unid_ant_w
			where	nr_seq_interno = nr_seq_unidade_w;
		end if;
	end if;		
	
	end;
elsif (ie_opcao_p = 'V') then
	begin
	update 	sl_unid_atend
	set		dt_aprovacao	= dt_fim_p,
			ie_status_serv 	= 'A',
			cd_executor	=  cd_executor_p,
			cd_executor_aprov_serv = cd_executor_p,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	=  coalesce(nm_usuario_p,nm_usuario_w),
			cd_evento_eritel = evt_integ_P
	where	nr_sequencia 	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'DV') then
	begin
	update 	sl_unid_atend
	set	dt_aprovacao	 = NULL,
		ie_status_serv 	= 'E',
		cd_executor	=  cd_executor_p,
		cd_executor_aprov_serv  = NULL,
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario	=  coalesce(nm_usuario_p,nm_usuario_w),
		cd_evento_eritel = evt_integ_P
	where	nr_sequencia 	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'IP') then
	begin
	update 	sl_unid_atend
	set	dt_pausa_servico	= dt_fim_p,
		ds_obs_pausa_leito	= substr(ds_obs_pausa_p,1,255),
		ie_status_serv 		= 'IP',
		cd_executor		=  cd_executor_p,
		cd_executor_pausa_serv	=  cd_executor_p,
		dt_atualizacao 		= clock_timestamp(),
		nm_usuario		=  coalesce(nm_usuario_p,nm_usuario_w),
		nr_seq_motivo_pausa     = cd_motivo_pausa_p,
		cd_evento_eritel = evt_integ_P
	where	nr_sequencia 		= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'FP') then
	begin
	update 	sl_unid_atend
	set	dt_fim_pausa_servico	= dt_fim_p,
		ie_status_serv 		= 'FP',
		cd_executor		=  cd_executor_p,
		dt_atualizacao 		= clock_timestamp(),
		nm_usuario		=  coalesce(nm_usuario_p,nm_usuario_w),
		cd_evento_eritel = evt_integ_P
	where	nr_sequencia 		= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'DF') then
	begin
	update 	sl_unid_atend
	set	ie_status_serv 		= 'EE',
		ds_obs_fim_serv	= substr(ds_obs_pausa_p,1,255),
		cd_executor_fim_serv 	 = NULL,
		dt_atualizacao 		= clock_timestamp(),
		nm_usuario		=  coalesce(nm_usuario_p,nm_usuario_w),
		dt_fim			 = NULL,
		cd_evento_eritel = evt_integ_P
	where	nr_sequencia 		= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'HU') then
	CALL inserir_historico_serv_leito(nr_sequencia_p, substr(ds_obs_pausa_p,1,255), clock_timestamp(), coalesce(nm_usuario_p,nm_usuario_w));
end if;

if (ie_opcao_p in ('I', 'P', 'F', 'V', 'DV', 'IP', 'FP', 'DF')) then
	CALL inserir_hist_gestao_servico(ie_opcao_p, nr_sequencia_p, coalesce(nm_usuario_p,nm_usuario_w));
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_gestao_servico ( nr_sequencia_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_executor_p text, ie_opcao_p text, nm_usuario_p text, cd_pf_usuario_p text, ds_obs_pausa_p text, nr_seq_motivo_higienizacao_p bigint default null, CD_MOTIVO_PAUSA_P bigint default null, evt_integ_P bigint default null) FROM PUBLIC;
